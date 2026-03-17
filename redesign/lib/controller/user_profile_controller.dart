import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:redesign/model/user_profile_model.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class UserProfileController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final rxUser = Rxn<UserProfileModel>();
  final isLoading = false.obs;

  // Getters for easy access in UI
  String get userName => rxUser.value?.fullName ?? '';
  String get userEmail => rxUser.value?.primaryEmail ?? '';
  String get profileImageUrl => rxUser.value?.profileImageUrl ?? '';
  bool get isPublicProfile => rxUser.value?.isPublicProfile ?? true;

  Future<void> fetchUserProfile(String docId) async {
    if (docId.isEmpty) return;
    
    isLoading.value = true;
    try {
      final doc = await _firestore.collection('User').doc(docId).get();
      if (doc.exists && doc.data() != null) {
        rxUser.value = UserProfileModel.fromMap(doc.id, doc.data()!);
        
        // Sync local preferences
        await UserPreferences.saveUserProfile(
          rxUser.value!.fullName,
          rxUser.value!.secondaryPhone, // Or primary if appropriate
          rxUser.value!.primaryEmail,
          rxUser.value!.dob,
          rxUser.value!.bio,
          rxUser.value!.profileImageUrl,
        );
        await UserPreferences.setPublicProfile(rxUser.value!.isPublicProfile);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateUserProfile({
    required UserProfileModel updatedUser,
    File? imageFile,
  }) async {
    isLoading.value = true;
    try {
      String finalImageUrl = updatedUser.profileImageUrl;

      // Handle Image Upload if new file provided
      if (imageFile != null) {
        String fileName = imageFile.path.split(Platform.isWindows ? '\\' : '/').last;
        final storageRef = _storage.ref().child(
          'User/${updatedUser.docId}/Profile/$fileName',
        );
        await storageRef.putFile(imageFile);
        finalImageUrl = await storageRef.getDownloadURL();
      }

      // Prepare final model with updated image URL
      final userToSave = updatedUser.copyWith(profileImageUrl: finalImageUrl);

      // Save to Firestore
      await _firestore
          .collection('User')
          .doc(userToSave.docId)
          .set(userToSave.toMap(), SetOptions(merge: true));

      // Update local state
      rxUser.value = userToSave;

      // Update local preferences
      await UserPreferences.saveUserProfile(
        userToSave.fullName,
        userToSave.secondaryPhone,
        userToSave.primaryEmail,
        userToSave.dob,
        userToSave.bio,
        userToSave.profileImageUrl,
      );
      await UserPreferences.setPublicProfile(userToSave.isPublicProfile);
      await UserPreferences.saveDocId(userToSave.docId);

      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void setUser(UserProfileModel user) {
    rxUser.value = user;
  }
}
