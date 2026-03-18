import 'dart:ui';
import 'package:flutter/material.dart';
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
  double _smallTitleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      body: CustomScrollView(
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
          SliverPersistentHeader(pinned: true, delegate: _SearchBarDelegate()),

          /// 🔥 CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// CURRENT LOCATION
                  const _TapBounceContainer(child: CurrentLocationCard()),

                  const SizedBox(height: 24),

                  /// SUBTLE DIVIDER
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.white.withOpacity(0.05),
                  ),

                  const SizedBox(height: 24),

                  /// LABEL
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        "SAVED LOCATIONS",
                        style: TextStyle(
                          color: kMuted.withOpacity(0.5),
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          /// 🔥 SAVED LOCATIONS LIST
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _TapBounceContainer(
                  child: LocationTile(
                    icon: Icons.home_outlined,
                    title: "Home",
                    subtitle: "24 Green Valley Road, Suburbia Heights",
                    tag: "RECENT",
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _TapBounceContainer(
                  child: LocationTile(
                    icon: Icons.work_outline,
                    title: "Work",
                    subtitle: "99 Innovation Hub, Tech District, Downtown",
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _TapBounceContainer(
                  child: LocationTile(
                    icon: Icons.sports_soccer,
                    title: "PowerFit Arena",
                    subtitle: "Westside Sports Complex, Sector 4",
                    tag: "NEARBY",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _TapBounceContainer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapPickerScreen(),
                      ),
                    );
                  },
                  child: const MapTile(),
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }
}

/// 🔥 SEARCH BAR DELEGATE
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 74;

  @override
  double get maxExtent => 74;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: maxExtent,
      color: kBg,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: const _InteractiveSearchBar(),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _InteractiveSearchBar extends StatefulWidget {
  const _InteractiveSearchBar({super.key});

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
        focusNode: _focusNode,
        cursorColor: kSpotifyGreen,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
          hintText: "Search turfs, areas, or streets...",
          hintStyle: TextStyle(color: kMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: kMuted, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }
}

class CurrentLocationCard extends StatelessWidget {
  const CurrentLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(Icons.my_location, color: kSpotifyGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Use Current Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Detect your location automatically",
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
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
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
