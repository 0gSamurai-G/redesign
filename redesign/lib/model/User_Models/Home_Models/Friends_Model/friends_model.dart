import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an accepted friend stored in User/{email}.friends[]
class FriendModel {
  final String email;
  final String fullName;
  final String profileImageUrl;
  final bool isOnline;

  FriendModel({
    required this.email,
    this.fullName = '',
    this.profileImageUrl = '',
    this.isOnline = false,
  });

  // ── Firestore ──
  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      isOnline: map['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'fullName': fullName,
        'profileImageUrl': profileImageUrl,
      };

  // ── SQFlite ──
  Map<String, dynamic> toSqfliteMap() => {
        'email': email,
        'fullName': fullName,
        'profileImageUrl': profileImageUrl,
        'isOnline': isOnline ? 1 : 0,
      };

  factory FriendModel.fromSqfliteMap(Map<String, dynamic> map) {
    return FriendModel(
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      isOnline: (map['isOnline'] ?? 0) == 1,
    );
  }
}

/// Represents a pending friend request stored in User/{email}.friendRequests[]
class FriendRequestModel {
  final String fromEmail;
  final String toEmail;
  final String fromName;
  final String fromProfilePic;
  final String status; // pending | approved | declined
  final DateTime timestamp;

  FriendRequestModel({
    required this.fromEmail,
    required this.toEmail,
    this.fromName = '',
    this.fromProfilePic = '',
    this.status = 'pending',
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // ── Firestore ──
  factory FriendRequestModel.fromMap(Map<String, dynamic> map) {
    return FriendRequestModel(
      fromEmail: map['fromEmail'] ?? '',
      toEmail: map['toEmail'] ?? '',
      fromName: map['fromName'] ?? '',
      fromProfilePic: map['fromProfilePic'] ?? '',
      status: map['status'] ?? 'pending',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'fromEmail': fromEmail,
        'toEmail': toEmail,
        'fromName': fromName,
        'fromProfilePic': fromProfilePic,
        'status': status,
        'timestamp': Timestamp.fromDate(timestamp),
      };

  // ── SQFlite ──
  Map<String, dynamic> toSqfliteMap() => {
        'fromEmail': fromEmail,
        'toEmail': toEmail,
        'fromName': fromName,
        'fromProfilePic': fromProfilePic,
        'status': status,
        'timestamp': timestamp.toIso8601String(),
      };

  factory FriendRequestModel.fromSqfliteMap(Map<String, dynamic> map) {
    return FriendRequestModel(
      fromEmail: map['fromEmail'] ?? '',
      toEmail: map['toEmail'] ?? '',
      fromName: map['fromName'] ?? '',
      fromProfilePic: map['fromProfilePic'] ?? '',
      status: map['status'] ?? 'pending',
      timestamp:
          DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

/// Represents a single chat message in Direct_Message/{dmDocId}/Chats/{id}
class ChatMessageModel {
  final String id;
  final String senderEmail;
  final String type; // text | image | video | audio | location
  final String content; // text body, download URL, or "lat,lng"
  final DateTime timestamp;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.senderEmail,
    required this.type,
    required this.content,
    DateTime? timestamp,
    this.isRead = false,
  }) : timestamp = timestamp ?? DateTime.now();

  // ── Firestore ──
  factory ChatMessageModel.fromMap(String docId, Map<String, dynamic> map) {
    return ChatMessageModel(
      id: docId,
      senderEmail: map['senderEmail'] ?? '',
      type: map['type'] ?? 'text',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
              DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'senderEmail': senderEmail,
        'type': type,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': isRead,
      };

  // ── SQFlite ──
  Map<String, dynamic> toSqfliteMap(String dmDocId) => {
        'id': id,
        'dmDocId': dmDocId,
        'senderEmail': senderEmail,
        'type': type,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead ? 1 : 0,
      };

  factory ChatMessageModel.fromSqfliteMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      type: map['type'] ?? 'text',
      content: map['content'] ?? '',
      timestamp:
          DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
      isRead: (map['isRead'] ?? 0) == 1,
    );
  }
}
