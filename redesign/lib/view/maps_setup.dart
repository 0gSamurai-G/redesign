import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/shared_preferences/maps_preferences.dart';
import 'package:redesign/view/maps_picker.dart';

/// COLORS
const Color kSpotifyGreen = Color(0xFF1DB954);
const Color kBg = Color(0xFF000000);
const Color kSurface = Color(0xFF0E0E0E);
const Color kCard = Color(0xFF1A1A1A);
const Color kMuted = Color(0xFFA7A7A7);

class LocationSelectSliverScreen extends StatefulWidget {
  const LocationSelectSliverScreen({super.key});

  @override
  State<LocationSelectSliverScreen> createState() =>
      _LocationSelectSliverScreenState();
}

class _LocationSelectSliverScreenState
    extends State<LocationSelectSliverScreen> {
  final ScrollController _scrollController = ScrollController();
  final _mapsCtrl = Get.find<MapsController>();
  final _searchController = TextEditingController();
  double _smallTitleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load data
    _mapsCtrl.recentLocations.refresh();
    _mapsCtrl.labeledLocations.refresh();
    final loc = _mapsCtrl.currentLocation.value;
    if (loc != null) {
      _mapsCtrl.fetchNearbyPlaces(loc.lat, loc.lng);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    const expandedHeight = 130.0;
    const threshold = expandedHeight - kToolbarHeight;
    final offset = _scrollController.offset;
    final opacity = (offset / threshold).clamp(0.0, 1.0);
    if (opacity != _smallTitleOpacity) {
      setState(() => _smallTitleOpacity = opacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              /// 🔥 PREMIUM COLLAPSING APP BAR
              SliverAppBar(
                backgroundColor: kBg,
                expandedHeight: 130,
                pinned: true,
                floating: false,
                elevation: 0,
                leadingWidth: 40,
                titleSpacing: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Opacity(
                  opacity: _smallTitleOpacity,
                  child: const Text(
                    "Select Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    padding: const EdgeInsets.only(left: 16, bottom: 20),
                    alignment: Alignment.bottomLeft,
                    child: Opacity(
                      opacity: (1.0 - _smallTitleOpacity).clamp(0.0, 1.0),
                      child: const Text(
                        "Select Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// 🔥 INTERACTIVE SEARCH BAR
              SliverPersistentHeader(
                  pinned: true, delegate: _SearchBarDelegate(_searchController, _mapsCtrl)),

              /// 🔥 CONTENT
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// CURRENT LOCATION
                      _TapBounceContainer(
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          await _mapsCtrl.useCurrentLocation();
                          if (mounted && _mapsCtrl.isLocationResolved.value) {
                            Navigator.pop(context);
                          }
                        },
                        child: _CurrentLocationCard(),
                      ),

                      const SizedBox(height: 24),

                      /// SUBTLE DIVIDER
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        color: Colors.white.withOpacity(0.05),
                      ),

                      const SizedBox(height: 24),

                      /// LABELED LOCATIONS HEADER
                      _buildSectionHeader("SAVED LOCATIONS"),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              /// 🔥 LABELED LOCATIONS
              Obx(() {
                final labeled = _mapsCtrl.labeledLocations;
                if (labeled.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final loc = labeled[i];
                      final icons = {
                        'Home': Icons.home_outlined,
                        'Work': Icons.work_outline,
                        'Gym': Icons.fitness_center,
                      };
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _TapBounceContainer(
                          onTap: () => _selectSavedLocation(loc),
                          child: LocationTile(
                            icon: icons[loc.label] ?? Icons.location_on_outlined,
                            title: loc.label ?? 'Saved',
                            subtitle: loc.fullAddress,
                          ),
                        ),
                      );
                    },
                    childCount: labeled.length,
                  ),
                );
              }),

              /// RECENT LOCATIONS HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: _buildSectionHeader("RECENT"),
                ),
              ),

              /// 🔥 RECENT LOCATIONS LIST
              Obx(() {
                final recents = _mapsCtrl.recentLocations;
                if (recents.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "No recent locations yet",
                        style: TextStyle(
                          color: kMuted.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final loc = recents[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _TapBounceContainer(
                          onTap: () => _selectSavedLocation(loc),
                          child: LocationTile(
                            icon: Icons.history,
                            title: loc.subLocality.isNotEmpty
                                ? loc.subLocality
                                : loc.city,
                            subtitle: loc.fullAddress,
                            tag: "RECENT",
                          ),
                        ),
                      );
                    },
                    childCount: recents.length.clamp(0, 5),
                  ),
                );
              }),

              /// NEARBY HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: _buildSectionHeader("NEARBY"),
                ),
              ),

              /// 🔥 NEARBY PLACES
              Obx(() {
                final nearby = _mapsCtrl.nearbyPlaces;
                if (nearby.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "No nearby places found",
                        style: TextStyle(
                          color: kMuted.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final place = nearby[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _TapBounceContainer(
                          onTap: () => _selectNearbyPlace(place),
                          child: LocationTile(
                            icon: Icons.place_outlined,
                            title: place.name,
                            subtitle: place.address,
                            tag: "NEARBY",
                          ),
                        ),
                      );
                    },
                    childCount: nearby.length.clamp(0, 5),
                  ),
                );
              }),

              /// MAP TILE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                  child: _TapBounceContainer(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPickerScreen(),
                        ),
                      );
                      // Refresh after returning from picker
                      _mapsCtrl.recentLocations.refresh();
                      _mapsCtrl.labeledLocations.refresh();
                    },
                    child: const MapTile(),
                  ),
                ),
              ),
            ],
          ),

          // ─── SEARCH RESULTS OVERLAY ────────────────────────
          Obx(() {
            if (_mapsCtrl.searchResults.isEmpty) {
              return const SizedBox.shrink();
            }
            return Positioned(
              top: 130 + MediaQuery.of(context).padding.top,
              left: 16,
              right: 16,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
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
                        leading: const Icon(Icons.location_on_outlined,
                            color: kSpotifyGreen, size: 20),
                        title: Text(
                          result.description,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          _searchController.clear();
                          _mapsCtrl.searchResults.clear();
                          // Navigate to map picker with selected place
                          _mapsCtrl.selectSearchResult(result).then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MapPickerScreen(),
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: TextStyle(
            color: kMuted.withOpacity(0.5),
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  void _selectSavedLocation(LocationData loc) {
    HapticFeedback.lightImpact();
    _mapsCtrl.currentLocation.value = loc;
    _mapsCtrl.displayCity.value = loc.city;
    _mapsCtrl.displayLocality.value = loc.subLocality;
    _mapsCtrl.displayLandmark.value = loc.landmark;
    _mapsCtrl.displayAddress.value = loc.fullAddress;
    _mapsCtrl.isLocationResolved.value = true;
    MapsPreferences.saveCurrentLocation(loc);
    Navigator.pop(context);
  }

  void _selectNearbyPlace(NearbyPlace place) {
    HapticFeedback.lightImpact();
    final loc = LocationData(
      lat: place.lat,
      lng: place.lng,
      city: '',
      subLocality: place.name,
      street: place.address,
      landmark: place.name,
      fullAddress: place.address,
    );
    _mapsCtrl.currentLocation.value = loc;
    _mapsCtrl.displayCity.value = '';
    _mapsCtrl.displayLocality.value = place.name;
    _mapsCtrl.displayAddress.value = place.address;
    _mapsCtrl.isLocationResolved.value = true;
    MapsPreferences.saveCurrentLocation(loc);
    Navigator.pop(context);
  }
}

/// 🔥 SEARCH BAR DELEGATE
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final MapsController mapsCtrl;

  _SearchBarDelegate(this.searchController, this.mapsCtrl);

  @override
  double get minExtent => 74;

  @override
  double get maxExtent => 74;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      color: kBg,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: _InteractiveSearchBar(
        controller: searchController,
        mapsCtrl: mapsCtrl,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _InteractiveSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final MapsController mapsCtrl;

  const _InteractiveSearchBar({
    required this.controller,
    required this.mapsCtrl,
  });

  @override
  State<_InteractiveSearchBar> createState() => _InteractiveSearchBarState();
}

class _InteractiveSearchBarState extends State<_InteractiveSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _isFocused ? kSpotifyGreen : Colors.white12,
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: kSpotifyGreen.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        cursorColor: kSpotifyGreen,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search turfs, areas, or streets...",
          hintStyle: const TextStyle(color: kMuted, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: kMuted, size: 20),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: kMuted, size: 18),
                  onPressed: () {
                    widget.controller.clear();
                    widget.mapsCtrl.searchResults.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
        onChanged: (query) {
          setState(() {});
          widget.mapsCtrl.searchPlaces(query);
        },
      ),
    );
  }
}

/// Current Location Card
class _CurrentLocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MapsController>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kSpotifyGreen, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kSpotifyGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: kSpotifyGreen,
                  ),
                );
              }
              return const Icon(Icons.my_location, color: kSpotifyGreen, size: 22);
            }),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Use Current Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() {
                  final loc = ctrl.displayLocality.value;
                  return Text(
                    loc.isNotEmpty
                        ? loc
                        : "Detect your location automatically",
                    style: const TextStyle(color: kMuted, fontSize: 12),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? tag;

  const LocationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (tag != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: kSpotifyGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag!,
                          style: const TextStyle(
                            color: kSpotifyGreen,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
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
          ),
        ],
      ),
    );
  }
}

class MapTile extends StatelessWidget {
  const MapTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kCard, kSurface.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on_outlined, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose location on map",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Move pin to set precise location",
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }
}

class _TapBounceContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _TapBounceContainer({required this.child, this.onTap});

  @override
  State<_TapBounceContainer> createState() => _TapBounceContainerState();
}

class _TapBounceContainerState extends State<_TapBounceContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
