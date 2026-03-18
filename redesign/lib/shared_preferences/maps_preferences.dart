import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redesign/model/maps_model.dart';

class MapsPreferences {
  static const String _keyLat = 'maps_lat';
  static const String _keyLng = 'maps_lng';
  static const String _keyCity = 'maps_city';
  static const String _keySubLocality = 'maps_subLocality';
  static const String _keyStreet = 'maps_street';
  static const String _keyLandmark = 'maps_landmark';
  static const String _keyFullAddress = 'maps_fullAddress';
  static const String _keyRecentLocations = 'maps_recentLocations';
  static const String _keyLabeledLocations = 'maps_labeledLocations';

  // ─── Current Location ───────────────────────────────────────

  static Future<void> saveCurrentLocation(LocationData location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLat, location.lat);
    await prefs.setDouble(_keyLng, location.lng);
    await prefs.setString(_keyCity, location.city);
    await prefs.setString(_keySubLocality, location.subLocality);
    await prefs.setString(_keyStreet, location.street);
    await prefs.setString(_keyLandmark, location.landmark);
    await prefs.setString(_keyFullAddress, location.fullAddress);
  }

  static Future<LocationData?> getCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_keyLat);
    final lng = prefs.getDouble(_keyLng);
    if (lat == null || lng == null) return null;
    return LocationData(
      lat: lat,
      lng: lng,
      city: prefs.getString(_keyCity) ?? '',
      subLocality: prefs.getString(_keySubLocality) ?? '',
      street: prefs.getString(_keyStreet) ?? '',
      landmark: prefs.getString(_keyLandmark) ?? '',
      fullAddress: prefs.getString(_keyFullAddress) ?? '',
      isCurrentLocation: true,
    );
  }

  // ─── Recent Locations ───────────────────────────────────────

  static Future<void> addRecentLocation(LocationData location) async {
    final list = await getRecentLocations();
    // Remove duplicate (same lat/lng)
    list.removeWhere(
      (l) => l.lat == location.lat && l.lng == location.lng,
    );
    list.insert(0, location);
    // Cap at 10
    if (list.length > 10) list.removeRange(10, list.length);
    await _saveRecentLocations(list);
  }

  static Future<List<LocationData>> getRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyRecentLocations);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> decoded = json.decode(raw);
    return decoded.map((e) => LocationData.fromMap(e)).toList();
  }

  static Future<void> _saveRecentLocations(List<LocationData> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(locations.map((l) => l.toMap()).toList());
    await prefs.setString(_keyRecentLocations, encoded);
  }

  // ─── Labeled Locations (Home / Work / Other) ────────────────

  static Future<void> saveLabeledLocations(List<LocationData> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(locations.map((l) => l.toMap()).toList());
    await prefs.setString(_keyLabeledLocations, encoded);
  }

  static Future<List<LocationData>> getLabeledLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyLabeledLocations);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> decoded = json.decode(raw);
    return decoded.map((e) => LocationData.fromMap(e)).toList();
  }

  static Future<void> addLabeledLocation(LocationData location) async {
    final list = await getLabeledLocations();
    // Replace if same label exists
    if (location.label != null) {
      list.removeWhere((l) => l.label == location.label);
    }
    list.add(location);
    await saveLabeledLocations(list);
  }

  // ─── Clear ──────────────────────────────────────────────────

  static Future<void> clearLocationData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLat);
    await prefs.remove(_keyLng);
    await prefs.remove(_keyCity);
    await prefs.remove(_keySubLocality);
    await prefs.remove(_keyStreet);
    await prefs.remove(_keyLandmark);
    await prefs.remove(_keyFullAddress);
    await prefs.remove(_keyRecentLocations);
    await prefs.remove(_keyLabeledLocations);
  }
}
