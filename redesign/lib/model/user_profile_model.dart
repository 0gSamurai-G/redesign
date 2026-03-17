import 'package:cloud_firestore/cloud_firestore.dart';

//create user profile model

class UserProfileModel {
  final String docId;
  final String fullName;
  final String primaryEmail;
  final String secondaryEmail;
  final String primaryPhone;
  final String secondaryPhone;
  final String bio;
  final String dob;
  final String profileImageUrl;
  final List<String> favoriteSports;
  final bool isPublicProfile;
  final bool isTrainer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel({
    required this.docId,
    this.fullName = '',
    this.primaryEmail = '',
    this.secondaryEmail = '',
    this.primaryPhone = '',
    this.secondaryPhone = '',
    this.bio = '',
    this.dob = '',
    this.profileImageUrl = '',
    this.favoriteSports = const [],
    this.isPublicProfile = true,
    this.isTrainer = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromMap(String id, Map<String, dynamic> map) {
    return UserProfileModel(
      docId: id,
      fullName: map['fullName'] ?? '',
      primaryEmail: map['primaryEmail'] ?? '',
      secondaryEmail: map['secondaryEmail'] ?? '',
      primaryPhone: map['primaryPhone'] ?? '',
      secondaryPhone: map['secondaryPhone'] ?? '',
      bio: map['bio'] ?? '',
      dob: map['dob'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      favoriteSports: List<String>.from(map['favoriteSports'] ?? []),
      isPublicProfile: map['isPublicProfile'] ?? true,
      isTrainer: map['isTrainer'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'primaryEmail': primaryEmail,
      'secondaryEmail': secondaryEmail,
      'primaryPhone': primaryPhone,
      'secondaryPhone': secondaryPhone,
      'bio': bio,
      'dob': dob,
      'profileImageUrl': profileImageUrl,
      'favoriteSports': favoriteSports,
      'isPublicProfile': isPublicProfile,
      'isTrainer': isTrainer,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserProfileModel copyWith({
    String? fullName,
    String? primaryEmail,
    String? secondaryEmail,
    String? primaryPhone,
    String? secondaryPhone,
    String? bio,
    String? dob,
    String? profileImageUrl,
    List<String>? favoriteSports,
    bool? isPublicProfile,
    bool? isTrainer,
  }) {
    return UserProfileModel(
      docId: docId,
      fullName: fullName ?? this.fullName,
      primaryEmail: primaryEmail ?? this.primaryEmail,
      secondaryEmail: secondaryEmail ?? this.secondaryEmail,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      bio: bio ?? this.bio,
      dob: dob ?? this.dob,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      favoriteSports: favoriteSports ?? this.favoriteSports,
      isPublicProfile: isPublicProfile ?? this.isPublicProfile,
      isTrainer: isTrainer ?? this.isTrainer,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
