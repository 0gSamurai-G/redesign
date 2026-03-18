import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/shared_preferences/maps_preferences.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class MapsController extends GetxController {
  // ─── API Key ────────────────────────────────────────────────
  String get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  // ─── Reactive State ─────────────────────────────────────────
  final Rx<LocationData?> currentLocation = Rx<LocationData?>(null);

  final displayCity = ''.obs;
  final displayLocality = ''.obs;
  final displayLandmark = ''.obs;
  final displayAddress = ''.obs;

  final isLoading = false.obs;
  final isDragging = false.obs;
  final isLocationResolved = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final recentLocations = <LocationData>[].obs;
  final labeledLocations = <LocationData>[].obs;
  final nearbyPlaces = <NearbyPlace>[].obs;
  final searchResults = <PlaceSearchResult>[].obs;

  // ─── Internal ───────────────────────────────────────────────
  GoogleMapController? mapController;
  Timer? _debounce;

  // ─── Lifecycle ──────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadSavedData();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    mapController?.dispose();
    super.onClose();
  }

  // ─── Load Persisted Data ────────────────────────────────────
  Future<void> _loadSavedData() async {
    final saved = await MapsPreferences.getCurrentLocation();
    if (saved != null) {
      currentLocation.value = saved;
      _updateDisplayFields(saved);
    } else {
      // Fallback to fetch from Firebase if nothing is cached
      await fetchLocationFromFirebase();
    }
    recentLocations.value = await MapsPreferences.getRecentLocations();
    labeledLocations.value = await MapsPreferences.getLabeledLocations();
  }

  // ─── Detect Current Location (with full permission handling) ─
  Future<void> detectCurrentLocation() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // 1. Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        hasError.value = true;
        errorMessage.value = 'Location services are disabled. Please enable GPS.';
        isLoading.value = false;
        return;
      }

      // 2. Check & request permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          hasError.value = true;
          errorMessage.value = 'Location permission denied.';
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        hasError.value = true;
        errorMessage.value =
            'Location permission permanently denied. Please enable in Settings.';
        isLoading.value = false;
        return;
      }

      // 3. Get position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      // 4. Reverse geocode
      await reverseGeocode(position.latitude, position.longitude,
          isCurrentLocation: true);

      // 5. Animate map
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            16,
          ),
        );
      }

      // 6. Fetch nearby places
      fetchNearbyPlaces(position.latitude, position.longitude);
    } catch (e) {
      hasError.value = true;
      if (e is TimeoutException) {
        errorMessage.value = 'Location request timed out. Please try again.';
      } else {
        errorMessage.value = 'Failed to detect location. Check your connection.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Reverse Geocode (Smart Context) ────────────────────────
  Future<void> reverseGeocode(double lat, double lng,
      {bool isCurrentLocation = false}) async {
    try {
      isLocationResolved.value = false;
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) return;

      final place = placemarks.first;

      final city = place.locality ?? place.administrativeArea ?? '';
      final subLocality = place.subLocality ?? '';
      final street = place.street ?? place.thoroughfare ?? '';
      final landmark = place.name ?? '';
      final fullAddress = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((s) => s != null && s.isNotEmpty).join(', ');

      final locationData = LocationData(
        lat: lat,
        lng: lng,
        city: city,
        subLocality: subLocality,
        street: street,
        landmark: landmark,
        fullAddress: fullAddress,
        isCurrentLocation: isCurrentLocation,
      );

      currentLocation.value = locationData;
      _updateDisplayFields(locationData);

      await MapsPreferences.saveCurrentLocation(locationData);
      isLocationResolved.value = true;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to get address. Check your connection.';
    }
  }

  void _updateDisplayFields(LocationData data) {
    displayCity.value = data.city;
    displayLocality.value = data.subLocality;
    displayLandmark.value = data.landmark;
    displayAddress.value = data.fullAddress;
  }

  // ─── Map Camera Events ─────────────────────────────────────
  void onCameraMoveStarted() {
    isDragging.value = true;
    isLocationResolved.value = false;
    HapticFeedback.selectionClick();
  }

  void onCameraIdle(LatLng position) {
    isDragging.value = false;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      reverseGeocode(position.latitude, position.longitude);
    });
  }

  // ─── Search Places (Autocomplete via REST) ──────────────────
  void searchPlaces(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(query)}'
          '&key=$_apiKey',
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final predictions = data['predictions'] as List<dynamic>? ?? [];
          searchResults.value = predictions
              .map((p) => PlaceSearchResult.fromMap(p as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {
        // Silently fail — search is non-critical
      }
    });
  }

  /// Get LatLng for a place ID and move map there
  Future<void> selectSearchResult(PlaceSearchResult result) async {
    searchResults.clear();
    isLoading.value = true;
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=${result.placeId}'
        '&fields=geometry'
        '&key=$_apiKey',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loc = data['result']?['geometry']?['location'];
        if (loc != null) {
          final lat = (loc['lat'] as num).toDouble();
          final lng = (loc['lng'] as num).toDouble();
          await mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16),
          );
          await reverseGeocode(lat, lng);
        }
      }
    } catch (_) {
      // Silently fail
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Nearby Places (REST API) ───────────────────────────────
  Future<void> fetchNearbyPlaces(double lat, double lng) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=2000'
        '&type=establishment'
        '&key=$_apiKey',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>? ?? [];
        nearbyPlaces.value = results
            .take(10)
            .map((r) => NearbyPlace.fromMap(r as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Non-critical — fail silently
    }
  }

  // ─── Firebase Location Sync ─────────────────────────────────
  Future<void> saveLocationToFirebase(LocationData location) async {
    try {
      final docId = await UserPreferences.getDocId();
      if (docId == null || docId.isEmpty) return;

      final labeled = await MapsPreferences.getLabeledLocations();
      final labeledMaps = labeled.map((e) => e.toMap()).toList();

      final recents = await MapsPreferences.getRecentLocations();
      final recentsMaps = recents.map((e) => e.toMap()).toList();

      await FirebaseFirestore.instance
          .collection('User')
          .doc(docId)
          .set({
        'current_location': location.toMap(),
        'saved_locations': labeledMaps,
        'recent_locations': recentsMaps,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving location arrays to Firebase: $e');
    }
  }

  Future<void> fetchLocationFromFirebase() async {
    try {
      final docId = await UserPreferences.getDocId();
      if (docId == null || docId.isEmpty) return;

      final doc = await FirebaseFirestore.instance
          .collection('User')
          .doc(docId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        
        // 1. Restore Current Location
        if (data.containsKey('current_location')) {
          final locData = LocationData.fromMap(data['current_location'] as Map<String, dynamic>);
          currentLocation.value = locData;
          _updateDisplayFields(locData);
          await MapsPreferences.saveCurrentLocation(locData);
        } else if (data.containsKey('location')) {
          // Fallback reading old location object
          final locData = LocationData.fromMap(data['location'] as Map<String, dynamic>);
          currentLocation.value = locData;
          _updateDisplayFields(locData);
          await MapsPreferences.saveCurrentLocation(locData);
        }

        // 2. Restore Saved (Labeled) Locations
        if (data.containsKey('saved_locations')) {
          final list = data['saved_locations'] as List<dynamic>;
          final parsedList = list.map((e) => LocationData.fromMap(e as Map<String, dynamic>)).toList();
          labeledLocations.value = parsedList;
          await MapsPreferences.saveLabeledLocations(parsedList);
        }

        // 3. Restore Recent Locations
        if (data.containsKey('recent_locations')) {
          final list = data['recent_locations'] as List<dynamic>;
          final parsedList = list.map((e) => LocationData.fromMap(e as Map<String, dynamic>)).toList();
          recentLocations.value = parsedList;
          await MapsPreferences.saveRecentLocations(parsedList);
        }
      }
    } catch (e) {
      print('Error fetching location arrays from Firebase: $e');
    }
  }

  // ─── Remove Saved/Recent Location ───────────────────────────
  Future<void> removeSavedLocation(LocationData location, {bool isRecent = false}) async {
    if (isRecent) {
      await MapsPreferences.removeRecentLocation(location);
      recentLocations.value = await MapsPreferences.getRecentLocations();
    } else {
      await MapsPreferences.removeLabeledLocation(location);
      labeledLocations.value = await MapsPreferences.getLabeledLocations();
    }
    
    // Automatically sync over to Firebase so the deletion is reflected
    LocationData? fallbackLocation = currentLocation.value ?? 
        (labeledLocations.isNotEmpty ? labeledLocations.first : null);
        
    if (fallbackLocation != null) {
      await saveLocationToFirebase(fallbackLocation);
    } else {
      // If we have no locations left, save an empty dummy to force Firebase lists to clear
      await saveLocationToFirebase(location);
    }
  }

  // ─── Confirm Location ───────────────────────────────────────
  Future<void> confirmLocation({String? label}) async {
    if (currentLocation.value == null) return;

    HapticFeedback.mediumImpact();

    final location = LocationData(
      lat: currentLocation.value!.lat,
      lng: currentLocation.value!.lng,
      city: currentLocation.value!.city,
      subLocality: currentLocation.value!.subLocality,
      street: currentLocation.value!.street,
      landmark: currentLocation.value!.landmark,
      fullAddress: currentLocation.value!.fullAddress,
      label: label,
      isCurrentLocation: currentLocation.value!.isCurrentLocation,
    );

    await MapsPreferences.saveCurrentLocation(location);
    await MapsPreferences.addRecentLocation(location);

    if (label != null) {
      await MapsPreferences.addLabeledLocation(location);
      labeledLocations.value = await MapsPreferences.getLabeledLocations();
    }

    recentLocations.value = await MapsPreferences.getRecentLocations();
    currentLocation.value = location;
    _updateDisplayFields(location);

    // Automatically sync over to Firebase
    await saveLocationToFirebase(location);
  }

  // ─── Use Current Location Button ────────────────────────────
  Future<void> useCurrentLocation() async {
    HapticFeedback.lightImpact();
    await detectCurrentLocation();
  }

  // ─── Open App Settings ──────────────────────────────────────
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
