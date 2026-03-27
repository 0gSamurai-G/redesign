import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Friends_SQF/friendsSqflite.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class FriendsController extends GetxController {
  final _firestore = FirebaseFirestore.instance;

  // ── Reactive state ──
  final friends = <FriendModel>[].obs;
  final pendingRequests = <FriendRequestModel>[].obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSearching = false.obs;

  // Cache all users for client-side search
  List<Map<String, dynamic>> _allUsersCache = [];

  String _myEmail = '';

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    _myEmail = await UserPreferences.getDocId() ?? '';
    if (_myEmail.isEmpty) return;

    // 1️⃣ Load local data instantly
    await _loadFromSqflite();

    // 2️⃣ Fetch live data and sync
    await fetchLiveData();
  }

  // ═══════════════════════════════════
  //  LOCAL → SQFLITE
  // ═══════════════════════════════════

  Future<void> _loadFromSqflite() async {
    try {
      final localFriends = await FriendsSqflite.getAllFriends();
      final localRequests = await FriendsSqflite.getAllRequests();
      friends.assignAll(localFriends);
      pendingRequests
          .assignAll(localRequests.where((r) => r.status == 'pending'));
    } catch (e) {
      debugPrint('🔴 [FriendsController] SQFlite load error: $e');
    }
  }

  // ═══════════════════════════════════
  //  LIVE → FIRESTORE
  // ═══════════════════════════════════

  Future<void> fetchLiveData() async {
    if (_myEmail.isEmpty) return;
    isLoading.value = true;
    try {
      await Future.wait([
        _fetchFriendsFromFirestore(),
        _fetchRequestsFromFirestore(),
      ]);
    } catch (e) {
      debugPrint('🔴 [FriendsController] Firestore fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchFriendsFromFirestore() async {
    final doc = await _firestore.collection('User').doc(_myEmail).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final rawList = data['friends'] as List<dynamic>? ?? [];
    final liveFriends =
        rawList.map((m) => FriendModel.fromMap(Map<String, dynamic>.from(m))).toList();

    friends.assignAll(liveFriends);
    await FriendsSqflite.clearAndInsertFriends(liveFriends);
  }

  Future<void> _fetchRequestsFromFirestore() async {
    final doc = await _firestore.collection('User').doc(_myEmail).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final rawList = data['friendRequests'] as List<dynamic>? ?? [];
    final liveRequests = rawList
        .map((m) => FriendRequestModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();

    pendingRequests
        .assignAll(liveRequests.where((r) => r.status == 'pending'));
    await FriendsSqflite.clearAndInsertRequests(liveRequests);
  }

  // ═══════════════════════════════════
  //  SEARCH USERS
  // ═══════════════════════════════════

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;

    // Lazy-load the full user list on first search
    if (_allUsersCache.isEmpty) {
      try {
        final snapshot = await _firestore.collection('User').get();
        _allUsersCache = snapshot.docs
            .where((doc) => doc.id != _myEmail)
            .map((doc) => {'docId': doc.id, ...doc.data()})
            .toList();
      } catch (e) {
        debugPrint('🔴 [FriendsController] User fetch error: $e');
        isSearching.value = false;
        return;
      }
    }

    final lowerQuery = query.toLowerCase();
    final friendEmails = friends.map((f) => f.email).toSet();
    final requestedEmails = pendingRequests.map((r) => r.fromEmail).toSet();

    searchResults.assignAll(
      _allUsersCache.where((user) {
        final name = (user['fullName'] ?? '').toString().toLowerCase();
        final email = (user['primaryEmail'] ?? '').toString().toLowerCase();
        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }).map((user) {
        final userEmail = user['primaryEmail'] ?? user['docId'] ?? '';
        return {
          ...user,
          'alreadyFriend': friendEmails.contains(userEmail),
          'alreadyRequested': requestedEmails.contains(userEmail),
        };
      }).toList(),
    );
  }

  // ═══════════════════════════════════
  //  SEND FRIEND REQUEST / DIRECT ADD
  // ═══════════════════════════════════

  Future<void> sendFriendRequest(Map<String, dynamic> targetUser) async {
    final targetEmail =
        targetUser['primaryEmail'] ?? targetUser['docId'] ?? '';
    final isPublic = targetUser['isPublicProfile'] ?? true;

    if (targetEmail.isEmpty || targetEmail == _myEmail) return;

    // Get my profile data
    final myDoc = await _firestore.collection('User').doc(_myEmail).get();
    final myData = myDoc.data() ?? {};
    final myName = myData['fullName'] ?? '';
    final myPic = myData['profileImageUrl'] ?? '';

    final targetName = targetUser['fullName'] ?? '';
    final targetPic = targetUser['profileImageUrl'] ?? '';
    final isOnline = targetUser['isOnline'] ?? false;

    if (isPublic) {
      // ── Direct add (public profile) ──
      await _addFriendBothSides(
        targetEmail: targetEmail,
        targetName: targetName,
        targetPic: targetPic,
        isOnline: isOnline,
        myName: myName,
        myPic: myPic,
      );
      await _createDMDoc(_myEmail, targetEmail);
    } else {
      // ── Send request (private profile) ──
      final request = FriendRequestModel(
        fromEmail: _myEmail,
        toEmail: targetEmail,
        fromName: myName,
        fromProfilePic: myPic,
        status: 'pending',
      );

      // Add to target user's friendRequests field
      await _firestore.collection('User').doc(targetEmail).update({
        'friendRequests': FieldValue.arrayUnion([request.toMap()]),
      });
    }

    // Refresh live data
    await fetchLiveData();
    // Invalidate search cache to update statuses
    _allUsersCache.clear();
  }

  // ═══════════════════════════════════
  //  APPROVE REQUEST
  // ═══════════════════════════════════

  Future<void> approveFriendRequest(FriendRequestModel request) async {
    // 1. Get requester's profile for friend data
    final requesterDoc =
        await _firestore.collection('User').doc(request.fromEmail).get();
    final requesterData = requesterDoc.data() ?? {};

    final myDoc = await _firestore.collection('User').doc(_myEmail).get();
    final myData = myDoc.data() ?? {};

    // 2. Add each other as friends
    await _addFriendBothSides(
      targetEmail: request.fromEmail,
      targetName: requesterData['fullName'] ?? request.fromName,
      targetPic: requesterData['profileImageUrl'] ?? request.fromProfilePic,
      isOnline: requesterData['isOnline'] ?? false,
      myName: myData['fullName'] ?? '',
      myPic: myData['profileImageUrl'] ?? '',
    );

    // 3. Remove the request from my friendRequests field
    await _firestore.collection('User').doc(_myEmail).update({
      'friendRequests': FieldValue.arrayRemove([request.toMap()]),
    });

    // 4. Create DM document
    await _createDMDoc(_myEmail, request.fromEmail);

    // 5. Refresh
    await fetchLiveData();
    _allUsersCache.clear();
  }

  // ═══════════════════════════════════
  //  REMOVE FRIEND
  // ═══════════════════════════════════

  Future<void> removeFriend(String targetEmail) async {
    if (_myEmail.isEmpty || targetEmail.isEmpty) return;

    try {
      // 1. Find the friend entries to remove
      final myDoc = await _firestore.collection('User').doc(_myEmail).get();
      final targetDoc = await _firestore.collection('User').doc(targetEmail).get();

      final myFriends = List<Map<String, dynamic>>.from(myDoc.data()?['friends'] ?? []);
      final targetFriends = List<Map<String, dynamic>>.from(targetDoc.data()?['friends'] ?? []);

      final myEntryToRemove = myFriends.firstWhereOrNull((f) => f['email'] == targetEmail);
      final targetEntryToRemove = targetFriends.firstWhereOrNull((f) => f['email'] == _myEmail);

      // 2. Remove from both users' friends arrays
      if (myEntryToRemove != null) {
        await _firestore.collection('User').doc(_myEmail).update({
          'friends': FieldValue.arrayRemove([myEntryToRemove])
        });
      }
      if (targetEntryToRemove != null) {
        await _firestore.collection('User').doc(targetEmail).update({
          'friends': FieldValue.arrayRemove([targetEntryToRemove])
        });
      }

      // 3. Delete DM document and subcollections
      final sorted = [_myEmail, targetEmail]..sort();
      final dmDocId = sorted.join('_');
      final dmRef = _firestore.collection('Direct_Message').doc(dmDocId);

      // Delete all Chats subcollection documents
      final chatsSnapshot = await dmRef.collection('Chats').get();
      final batch = _firestore.batch();
      for (final doc in chatsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(dmRef);
      await batch.commit();

      // 4. Update local state and DB
      friends.removeWhere((f) => f.email == targetEmail);
      await FriendsSqflite.deleteFriend(targetEmail);
      await FriendsSqflite.deleteMessagesByDmId(dmDocId);

      _allUsersCache.clear();
      await fetchLiveData();

    } catch (e) {
      debugPrint('🔴 [FriendsController] Remove friend error: $e');
    }
  }

  // ═══════════════════════════════════
  //  DECLINE REQUEST
  // ═══════════════════════════════════

  Future<void> declineRequest(FriendRequestModel request) async {
    await _firestore.collection('User').doc(_myEmail).update({
      'friendRequests': FieldValue.arrayRemove([request.toMap()]),
    });
    await fetchLiveData();
  }

  // ═══════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════

  Future<void> _addFriendBothSides({
    required String targetEmail,
    required String targetName,
    required String targetPic,
    required bool isOnline,
    required String myName,
    required String myPic,
  }) async {
    final myFriendEntry = FriendModel(
      email: targetEmail,
      fullName: targetName,
      profileImageUrl: targetPic,
      isOnline: isOnline,
    );

    final theirFriendEntry = FriendModel(
      email: _myEmail,
      fullName: myName,
      profileImageUrl: myPic,
      isOnline: true, // I am assumed online if I'm doing this
    );

    // Update both users' friends field
    await _firestore.collection('User').doc(_myEmail).update({
      'friends': FieldValue.arrayUnion([myFriendEntry.toMap()]),
    });
    await _firestore.collection('User').doc(targetEmail).update({
      'friends': FieldValue.arrayUnion([theirFriendEntry.toMap()]),
    });
  }

  /// Creates DM doc with alphabetical email concat as ID
  Future<void> _createDMDoc(String email1, String email2) async {
    final sorted = [email1, email2]..sort();
    final dmDocId = sorted.join('_');

    final dmRef = _firestore.collection('Direct_Message').doc(dmDocId);
    final existing = await dmRef.get();

    if (!existing.exists) {
      await dmRef.set({
        'participants': sorted,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
