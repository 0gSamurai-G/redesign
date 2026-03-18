import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redesign/controller/maps_controller.dart';

/// COLORS
const Color kSpotifyGreen = Color(0xFF1DB954);
const Color kBg = Color(0xFF000000);
const Color kSurface = Color(0xFF0E0E0E);
const Color kCard = Color(0xFF1A1A1A);
const Color kMuted = Color(0xFFA7A7A7);

/// Dark Map Style JSON
const String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#212121"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},
  {"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},
  {"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},
  {"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},
  {"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},
  {"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},
  {"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},
  {"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},
  {"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},
  {"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}
]
''';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen>
    with TickerProviderStateMixin {
  final _mapsCtrl = Get.find<MapsController>();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  LatLng _lastCameraPos = const LatLng(18.5204, 73.8567); // Default: Pune

  @override
  void initState() {
    super.initState();
    // Auto detect on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loc = _mapsCtrl.currentLocation.value;
      if (loc != null) {
        _lastCameraPos = LatLng(loc.lat, loc.lng);
      }
      _mapsCtrl.detectCurrentLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ─── GOOGLE MAP ─────────────────────────────────────
          Obx(() {
            final loc = _mapsCtrl.currentLocation.value;
            final initialPos = loc != null
                ? LatLng(loc.lat, loc.lng)
                : _lastCameraPos;
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPos,
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              style: _darkMapStyle,
              onMapCreated: (controller) {
                _mapsCtrl.mapController = controller;
              },
              onCameraMoveStarted: () {
                _mapsCtrl.onCameraMoveStarted();
              },
              onCameraMove: (pos) {
                _lastCameraPos = pos.target;
              },
              onCameraIdle: () {
                _mapsCtrl.onCameraIdle(_lastCameraPos);
              },
            );
          }),

          // ─── CENTER PIN + LABEL ─────────────────────────────
          Center(child: _AnimatedCenterPin()),

          // ─── TOP BAR + SEARCH ───────────────────────────────
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTopBar(),
                const SizedBox(height: 12),
                _buildSearchBar(),
                // Inline search results overlay
                _buildSearchResults(),
              ],
            ),
          ),

          // ─── GPS BUTTON ─────────────────────────────────────
          Positioned(right: 16, bottom: 220, child: _buildGpsButton()),

          // ─── BOTTOM SHEET ───────────────────────────────────
          Align(alignment: Alignment.bottomCenter, child: _buildBottomCard()),

          // ─── ERROR OVERLAY ──────────────────────────────────
          _buildErrorOverlay(),
        ],
      ),
    );
  }

  // ─── TOP BAR ────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          const Text(
            "Select Location",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── SEARCH BAR ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: kSurface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: kMuted),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                cursorColor: kSpotifyGreen,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Search turfs, areas, or streets...",
                  hintStyle: TextStyle(color: kMuted, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                ),
                onChanged: (query) {
                  HapticFeedback.selectionClick();
                  _mapsCtrl.searchPlaces(query);
                },
              ),
            ),
            Obx(() {
              if (_mapsCtrl.searchResults.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _mapsCtrl.searchResults.clear();
                    _searchFocus.unfocus();
                  },
                  child: const Icon(Icons.close, color: kMuted, size: 20),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // ─── SEARCH RESULTS OVERLAY ─────────────────────────────────
  Widget _buildSearchResults() {
    return Obx(() {
      if (_mapsCtrl.searchResults.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        constraints: const BoxConstraints(maxHeight: 250),
        decoration: BoxDecoration(
          color: kCard.withOpacity(0.97),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _mapsCtrl.searchResults.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.white.withOpacity(0.05)),
            itemBuilder: (_, i) {
              final result = _mapsCtrl.searchResults[i];
              return ListTile(
                dense: true,
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: kSpotifyGreen,
                  size: 20,
                ),
                title: Text(
                  result.description,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  HapticFeedback.selectionClick();
                  _searchController.clear();
                  _searchFocus.unfocus();
                  _mapsCtrl.selectSearchResult(result);
                },
              );
            },
          ),
        ),
      );
    });
  }

  // ─── GPS BUTTON ─────────────────────────────────────────────
  Widget _buildGpsButton() {
    return GestureDetector(
      onTap: () {
        _mapsCtrl.useCurrentLocation();
      },
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Obx(() {
          if (_mapsCtrl.isLoading.value) {
            return const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: kSpotifyGreen,
              ),
            );
          }
          return const Icon(Icons.my_location, color: Colors.white);
        }),
      ),
    );
  }

  // ─── BOTTOM CARD ────────────────────────────────────────────
  Widget _buildBottomCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Location info with AnimatedSwitcher
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kSpotifyGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on, color: kSpotifyGreen),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildAddressPreview()),
            ],
          ),

          const SizedBox(height: 20),

          // Confirm button with state logic
          _buildConfirmButton(),
        ],
      ),
    );
  }

  // ─── LIVE ADDRESS PREVIEW ───────────────────────────────────
  Widget _buildAddressPreview() {
    return Obx(() {
      final isDrag = _mapsCtrl.isDragging.value;
      final loading = _mapsCtrl.isLoading.value;
      final resolved = _mapsCtrl.isLocationResolved.value;

      String title;
      String subtitle;

      if (isDrag || (loading && !resolved)) {
        title = 'Fetching location...';
        subtitle = 'Move map to adjust';
      } else {
        final city = _mapsCtrl.displayCity.value;
        final locality = _mapsCtrl.displayLocality.value;
        final landmark = _mapsCtrl.displayLandmark.value;
        final address = _mapsCtrl.displayAddress.value;

        title = locality.isNotEmpty
            ? locality
            : (city.isNotEmpty ? city : 'Unknown');
        subtitle = landmark.isNotEmpty && landmark != locality
            ? 'Near $landmark · $address'
            : address.isNotEmpty
            ? address
            : 'Tap GPS to detect location';
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey('$title-${subtitle.hashCode}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: kMuted, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }

  // ─── CONFIRM BUTTON ─────────────────────────────────────────
  Widget _buildConfirmButton() {
    return Obx(() {
      final canConfirm =
          _mapsCtrl.isLocationResolved.value &&
          !_mapsCtrl.isLoading.value &&
          !_mapsCtrl.isDragging.value;

      return GestureDetector(
        onTap: canConfirm
            ? () async {
                await _showLabelDialog();
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            color: canConfirm ? kSpotifyGreen : kSpotifyGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
            boxShadow: canConfirm
                ? [
                    BoxShadow(
                      color: kSpotifyGreen.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: _mapsCtrl.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    "Confirm Location",
                    style: TextStyle(
                      color: canConfirm ? Colors.black : Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      );
    });
  }

  // ─── LABEL DIALOG ───────────────────────────────────────────
  Future<void> _showLabelDialog() async {
    final labels = ['Home', 'Work', 'Gym', 'Other'];
    String? selected;

    await showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                'Save Location As',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: labels.map((label) {
                  final icons = {
                    'Home': Icons.home_outlined,
                    'Work': Icons.work_outline,
                    'Gym': Icons.fitness_center,
                    'Other': Icons.location_on_outlined,
                  };
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      selected = label;
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: kSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          Icon(icons[label], color: kSpotifyGreen, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  selected = null;
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: kMuted, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Confirm regardless of label choice
    await _mapsCtrl.confirmLocation(label: selected);
    if (mounted) Navigator.pop(context);
  }

  // ─── ERROR OVERLAY ──────────────────────────────────────────
  Widget _buildErrorOverlay() {
    return Obx(() {
      if (!_mapsCtrl.hasError.value) return const SizedBox.shrink();
      return Positioned(
        left: 16,
        right: 16,
        bottom: 200,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C1010),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orangeAccent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _mapsCtrl.errorMessage.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (_mapsCtrl.errorMessage.value.contains('Settings')) {
                          _mapsCtrl.openAppSettings();
                        } else {
                          _mapsCtrl.hasError.value = false;
                          _mapsCtrl.detectCurrentLocation();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kSpotifyGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _mapsCtrl.errorMessage.value.contains('Settings')
                              ? 'Open Settings'
                              : 'Retry',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _mapsCtrl.hasError.value = false,
                child: const Icon(Icons.close, color: Colors.white38, size: 20),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── ANIMATED CENTER PIN ──────────────────────────────────────
class _AnimatedCenterPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapsController>();
    return Obx(() {
      final dragging = ctrl.isDragging.value;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: dragging ? 0.0 : 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "MOVE MAP TO ADJUST LOCATION",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: kBg,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Animated pin
          AnimatedScale(
            scale: dragging ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kSpotifyGreen.withOpacity(dragging ? 0.8 : 0.5),
                    blurRadius: dragging ? 40 : 25,
                    spreadRadius: dragging ? 8 : 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on,
                color: kSpotifyGreen,
                size: 50,
              ),
            ),
          ),
          // Shadow dot (below pin)
          AnimatedScale(
            scale: dragging ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 12,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      );
    });
  }
}
