import 'dart:convert';

/// Core location data model
class LocationData {
  final double lat;
  final double lng;
  final String city;
  final String subLocality;
  final String street;
  final String landmark;
  final String fullAddress;
  final String? label;
  final bool isCurrentLocation;
  final DateTime savedAt;

  LocationData({
    required this.lat,
    required this.lng,
    required this.city,
    required this.subLocality,
    required this.street,
    required this.landmark,
    required this.fullAddress,
    this.label,
    this.isCurrentLocation = false,
    DateTime? savedAt,
  }) : savedAt = savedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'city': city,
      'subLocality': subLocality,
      'street': street,
      'landmark': landmark,
      'fullAddress': fullAddress,
      'label': label,
      'isCurrentLocation': isCurrentLocation,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      lat: (map['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0.0,
      city: map['city'] ?? '',
      subLocality: map['subLocality'] ?? '',
      street: map['street'] ?? '',
      landmark: map['landmark'] ?? '',
      fullAddress: map['fullAddress'] ?? '',
      label: map['label'],
      isCurrentLocation: map['isCurrentLocation'] ?? false,
      savedAt: map['savedAt'] != null
          ? DateTime.tryParse(map['savedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationData.fromJson(String source) =>
      LocationData.fromMap(json.decode(source));
}

/// Google Places REST API nearby result
class NearbyPlace {
  final String name;
  final String address;
  final String placeId;
  final double lat;
  final double lng;
  final String? iconUrl;
  final String? type;

  NearbyPlace({
    required this.name,
    required this.address,
    required this.placeId,
    required this.lat,
    required this.lng,
    this.iconUrl,
    this.type,
  });

  factory NearbyPlace.fromMap(Map<String, dynamic> map) {
    final location = map['geometry']?['location'] as Map<String, dynamic>?;
    final types = map['types'] as List<dynamic>?;
    return NearbyPlace(
      name: map['name'] ?? '',
      address: map['vicinity'] ?? map['formatted_address'] ?? '',
      placeId: map['place_id'] ?? '',
      lat: (location?['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (location?['lng'] as num?)?.toDouble() ?? 0.0,
      iconUrl: map['icon'] as String?,
      type: types != null && types.isNotEmpty ? types.first as String? : null,
    );
  }
}

/// Strongly-typed search autocomplete result
class PlaceSearchResult {
  final String description;
  final String placeId;

  PlaceSearchResult({
    required this.description,
    required this.placeId,
  });

  factory PlaceSearchResult.fromMap(Map<String, dynamic> map) {
    return PlaceSearchResult(
      description: map['description'] ?? '',
      placeId: map['place_id'] ?? '',
    );
  }
}
