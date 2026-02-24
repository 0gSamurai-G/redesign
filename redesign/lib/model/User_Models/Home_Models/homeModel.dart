/// ============================================================
/// SHARED DATE PARSER (FIREBASE + SQLITE SAFE)
/// ============================================================

DateTime _parseDate(dynamic value) {
  if (value == null) return DateTime.now();

  if (value is DateTime) return value;

  // Firestore Timestamp without importing cloud_firestore
  if (value.runtimeType.toString() == 'Timestamp') {
    return (value as dynamic).toDate();
  }

  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }

  return DateTime.now();
}

/// ============================================================
/// USER MODEL
/// ============================================================

class UserModel {
  final String id;
  final String name;
  final String location;
  final String avatarUrl;
  final int xp;
  final String role; // player / trainer
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.location,
    required this.avatarUrl,
    required this.xp,
    required this.role,
    required this.createdAt,
  });

  /* ---------------- FIREBASE ---------------- */

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    return UserModel(
      id: docId,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      xp: (json['xp'] ?? 0) is int ? json['xp'] : (json['xp'] ?? 0).toInt(),
      role: json['role'] ?? 'player',
      createdAt: _parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'avatarUrl': avatarUrl,
      'xp': xp,
      'role': role,
      'createdAt': createdAt,
    };
  }

  /* ---------------- SQLITE ---------------- */

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      xp: (map['xp'] ?? 0) as int,
      role: map['role'] ?? 'player',
      createdAt: _parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'avatarUrl': avatarUrl,
      'xp': xp,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /* ---------------- COPY WITH ---------------- */

  UserModel copyWith({
    String? name,
    String? location,
    String? avatarUrl,
    int? xp,
    String? role,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }

  /* ---------------- EQUALITY ---------------- */

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// ============================================================
/// EVENT MODEL
/// ============================================================

class EventModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final DateTime startTime;
  final double entryFee;

  const EventModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
    required this.startTime,
    required this.entryFee,
  });

  /* ---------------- FIREBASE ---------------- */

  factory EventModel.fromJson(Map<String, dynamic> json, String docId) {
    return EventModel(
      id: docId,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      tag: json['tag'] ?? '',
      startTime: _parseDate(json['startTime']),
      entryFee: (json['entryFee'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'tag': tag,
      'startTime': startTime,
      'entryFee': entryFee,
    };
  }

  /* ---------------- SQLITE ---------------- */

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      tag: map['tag'] ?? '',
      startTime: _parseDate(map['startTime']),
      entryFee: (map['entryFee'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'tag': tag,
      'startTime': startTime.toIso8601String(),
      'entryFee': entryFee,
    };
  }

  EventModel copyWith({String? title, String? subtitle, double? entryFee}) {
    return EventModel(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl,
      tag: tag,
      startTime: startTime,
      entryFee: entryFee ?? this.entryFee,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// ============================================================
/// SPORT MODEL
/// ============================================================

class SportModel {
  final String id;
  final String name;
  final String imageUrl;

  const SportModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SportModel.fromJson(Map<String, dynamic> json, String docId) {
    return SportModel(
      id: docId,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'imageUrl': imageUrl};
  }

  factory SportModel.fromMap(Map<String, dynamic> map) {
    return SportModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
  }

  SportModel copyWith({String? name, String? imageUrl}) {
    return SportModel(
      id: id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
