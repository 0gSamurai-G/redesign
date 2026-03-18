import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'package:redesign/view/USER/Book/book.dart';
import 'package:redesign/view/USER/Home/Bookings/bookings.dart';
import 'package:redesign/view/USER/Home/Friends/friends.dart';
import 'package:redesign/view/USER/Home/Groups/groups.dart';
import 'package:redesign/view/USER/Home/Ranking/ranking.dart';
import 'package:redesign/view/USER/Home/Scoreboard/scoreboards.dart';
import 'package:redesign/togglemode.dart';
import 'package:redesign/trainer_navigation.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:redesign/view/maps_setup.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/controller/maps_controller.dart';
// enum AppMode { player, trainer }

/* ============================================================
   USER HOME PAGE
   ============================================================ */
class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  // Spotify-style palette
  static const Color bg = Color(0xFF000000);
  static const Color surface = Color(0xFF181818);
  static const Color accent = Color(0xFF1DB954);
  static const Color muted = Color(0xFF9CA3AF);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final _controller = Get.find<UserProfileController>();
  AppMode _mode = AppMode.player;
  bool _isTrainer = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final isTrainer = await UserPreferences.getIsTrainer();
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      _controller.fetchUserProfile(docId);
    }
    if (mounted) {
      setState(() {
        _isTrainer = isTrainer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: UserHomePage.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 00, 80),
          children: [
            _TopAppBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _HomeHeader(
                isTrainer: _isTrainer,
                mode: _mode,
                onChanged: (m) {
                  setState(() => _mode = m);
                  if (_mode == AppMode.trainer) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => TrainerAppNavShell()),
                      (route) => false,
                    );
                  }
                },
              ),
            ),

            SizedBox(height: 20),
            _HeroCTA(),
            SizedBox(height: 28),
            _QuickAccessTiles(),
            SizedBox(height: 28),
            _PopularVenues(),
            SizedBox(height: 28),
            _ExploreBySport(),
            SizedBox(height: 28),
            _FeaturedEvents(),
            SizedBox(height: 20),
            _OfficialAppInfo(),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   HOME HEADER (GREETING + TOGGLE)
   ============================================================ */
class _HomeHeader extends StatelessWidget {
  final bool isTrainer;
  final AppMode mode;
  final ValueChanged<AppMode> onChanged;
  final _controller = Get.find<UserProfileController>();

  _HomeHeader({
    required this.isTrainer,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (isTrainer) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _greeting(width)),
          const SizedBox(width: 20),
          _toggle(),
        ],
      );
    } else {
      return _greeting(width);
    }
  }

  Widget _greeting(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ FIX: Align to left
      children: [
        const SizedBox(height: 10),
        Obx(() {
          final fullName = _controller.rxUser.value?.fullName ?? 'User';
          final firstName = fullName.split(' ').first;
          return RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Hey $firstName! 👋\n",
                  style: TextStyle(
                    fontSize: width < 360 ? 16 : 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                TextSpan(
                  text: "Ready for some competition?",
                  style: TextStyle(
                    fontSize: width < 360 ? 8 : 13,
                    fontWeight: FontWeight.w500,
                    color: UserHomePage.muted,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _toggle() {
    return Flexible(
      child: Column(
        children: [
          const SizedBox(height: 15),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150, minWidth: 110),
            child: TrainerModePillToggle(
              mode: mode,
              onChanged: onChanged,
              compact: true,
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   TOP APP BAR
   ============================================================ */
class _TopAppBar extends StatelessWidget {
  _TopAppBar();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          /// LOCATION TEXT + DROPDOWN ICON together
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LocationSelectSliverScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: BookTurfScreen.accent,
                    size: width < 360 ? 18 : 22,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Obx(() {
                      final mapsCtrl = Get.find<MapsController>();
                      final city = mapsCtrl.displayCity.value;
                      final locality = mapsCtrl.displayLocality.value;
                      final displayText = locality.isNotEmpty
                          ? locality
                          : city.isNotEmpty
                              ? city
                              : 'Select Location';
                      return Text(
                        displayText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: width < 360 ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70,
                    size: width < 360 ? 20 : 24,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// NOTIFICATIONS BELL
          Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: width < 360 ? 20 : 24,
          ),
          const SizedBox(width: 16),

          /// AVATAR
          Obx(() {
            final profileImageUrl = _controller.profileImageUrl;
            return ClipOval(
              child: profileImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: profileImageUrl,
                      width: width < 360 ? 32 : 36,
                      height: width < 360 ? 32 : 36,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: CircleAvatar(radius: width < 360 ? 16 : 18),
                      ),
                      errorWidget: (_, __, ___) => CircleAvatar(
                        radius: width < 360 ? 16 : 18,
                        backgroundColor: const Color(0xFF1A1A1A),
                        child: const Icon(Icons.person, color: Colors.white38),
                      ),
                    )
                  : CircleAvatar(
                      radius: width < 360 ? 16 : 18,
                      backgroundColor: const Color(0xFF1A1A1A),
                      child: const Icon(Icons.person, color: Colors.white38),
                    ),
            );
          }),
        ],
      ),
    );
  }

  final _controller = Get.find<UserProfileController>();
}

/* ============================================================
   HERO CTA CARD
   ============================================================ */
/* ============================================================
   HERO CTA CARD (AUTO SLIDING PAGE VIEW)
   ============================================================ */
class _HeroCTA extends StatefulWidget {
  const _HeroCTA();

  @override
  State<_HeroCTA> createState() => _HeroCTAState();
}

class _HeroCTAState extends State<_HeroCTA> {
  late final PageController _pageController;
  int _currentIndex = 0;

  static const List<Map<String, String>> _slides = [
    {
      'image': 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      'badge': 'TRENDING NOW',
      'title': 'Game On with\nPlayZ',
    },
    {
      'image': 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
      'badge': 'NEAR YOU',
      'title': 'Book Grounds\nInstantly',
    },
    {
      'image': 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2',
      'badge': 'COMMUNITY',
      'title': 'Find Your\nSquad',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      _currentIndex = (_currentIndex + 1) % _slides.length;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return true;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;

          final cardHeight = (w * 0.55).clamp(160.0, 220.0);
          final radius = (w * 0.06).clamp(14.0, 22.0);
          final padding = (w * 0.05).clamp(12.0, 20.0);

          return SizedBox(
            height: cardHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      /// ✅ CACHED IMAGE + SHIMMER
                      CachedNetworkImage(
                        imageUrl: slide['image']!,
                        cacheKey: slide['image'],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const _HeroShimmer(),
                        errorWidget: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 32,
                          ),
                        ),
                      ),

                      /// OVERLAY
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.65),
                              Colors.black.withOpacity(0.35),
                            ],
                          ),
                        ),
                      ),

                      /// CONTENT
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// BADGE
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: (w * 0.035).clamp(10.0, 16.0),
                                vertical: (w * 0.014).clamp(4.0, 8.0),
                              ),
                              decoration: BoxDecoration(
                                color: UserHomePage.muted.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                slide['badge']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: (w * 0.028).clamp(10.0, 13.0),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const Spacer(),

                            /// TITLE
                            Text(
                              slide['title']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: (w * 0.065).clamp(18.0, 26.0),
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                                color: Colors.white,
                              ),
                            ),

                            const Spacer(),

                            /// CTA
                            SizedBox(
                              height: (w * 0.11).clamp(40.0, 46.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1DB954),
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: (w * 0.06).clamp(16.0, 24.0),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Explore Games Near You',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroShimmer extends StatelessWidget {
  const _HeroShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(color: Colors.grey.shade800),
    );
  }
}

/* ============================================================
   QUICK ACCESS TILES
   ============================================================ */
class _QuickAccessTiles extends StatelessWidget {
  const _QuickAccessTiles();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 2 columns for a dashboard feel
        const crossAxisCount = 2;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              // Wide ratio for horizontal layout
              childAspectRatio: 2.1,
            ),
            itemCount: _tiles.length,
            itemBuilder: (_, i) => _tiles[i],
          ),
        );
      },
    );
  }
}

final List<_QuickTile> _tiles = [
  _QuickTile(
    Icons.groups,
    'Groups',
    'Find your crew',
    destination: GroupsScreen(),
  ),
  _QuickTile(
    Icons.calendar_month,
    'Bookings',
    'Reserve slots',
    destination: MyBookingsScreen(),
  ),
  _QuickTile(
    Icons.people_outline,
    'Friends',
    'Build squad',
    destination: FriendsHubScreen(),
  ),
  _QuickTile(
    Icons.emoji_events,
    'Rankings',
    'Track stats',
    destination: RankingsScreen(),
  ),
  _QuickTile(
    Icons.scoreboard_outlined,
    'Scoreboard',
    'Live scores',
    destination: ScoreboardHubScreen(),
  ),
  _QuickTile(
    Icons.smart_toy_outlined,
    'AI Trainer',
    'Train smarter',
    highlight: true,
    // destination: AiTrainerScreen(),
  ),
];

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final bool highlight;
  final Widget? destination;

  const _QuickTile(
    this.icon,
    this.title,
    this.subtitle, {
    this.badge,
    this.highlight = false,
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: destination == null
            ? null
            : () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => destination!));
              },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: UserHomePage.surface, // #181818
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight
                  ? UserHomePage.accent.withOpacity(0.5)
                  : Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Badge (BETA/NEW/Active)
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badge == 'Beta' || badge == 'New'
                          ? UserHomePage.accent
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge!.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: badge == 'Beta' || badge == 'New'
                            ? Colors.black
                            : Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

              Row(
                children: [
                  // Icon Container
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: highlight ? UserHomePage.accent : Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Text Info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: UserHomePage.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   POPULAR VENUES
   ============================================================ */
class _PopularVenues extends StatelessWidget {
  const _PopularVenues();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        children: const [
          _SectionHeader('Popular Venues'),
          SizedBox(height: 14),
          _VenueTile(
            title: 'Urban Kick Turf',
            location: 'Indiranagar • 2.5km',
            price: '₹1200/hr',
            rating: '4.8',
            status: 'Open till 11 PM',
          ),
          SizedBox(height: 12),
          _VenueTile(
            title: 'Skyline Arena',
            location: 'Koramangala • 4.1km',
            price: '₹900/hr',
            rating: '4.6',
            status: 'Filling Fast',
          ),
        ],
      ),
    );
  }
}

class _VenueTile extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String rating;
  final String status;

  const _VenueTile({
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: UserHomePage.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Row(
        children: [
          /// ✅ IMAGE WITH CACHE + SHIMMER
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              cacheKey:
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  const _ImageShimmer(width: 70, height: 70),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: Colors.white54),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: UserHomePage.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    color: UserHomePage.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: UserHomePage.muted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   EXPLORE BY SPORT
   ============================================================ */

class _ExploreBySport extends StatelessWidget {
  const _ExploreBySport();

  @override
  Widget build(BuildContext context) {
    final sports = ['Cricket', 'Football', 'Badminton', 'Tennis'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const _SectionHeader('Explore by Sport'),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final cardWidth = (w * 0.32).clamp(100.0, 140.0);
            final cardHeight = (cardWidth * 1.15).clamp(120.0, 150.0);
            final textSize = (w * 0.04).clamp(12.0, 14.0);
            final padding = (w * 0.035).clamp(10.0, 14.0);

            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 14),
                itemCount: sports.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: cardWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          /// ✅ IMAGE WITH CACHE + SHIMMER
                          CachedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                            cacheKey:
                                'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const _ImageShimmer(),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),

                          Container(color: Colors.black.withOpacity(0.25)),

                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                sports[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: textSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

/* ============================================================
   SHIMMER PLACEHOLDER (REUSABLE)
   ============================================================ */

class _ImageShimmer extends StatelessWidget {
  final double? width;
  final double? height;

  const _ImageShimmer({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade800,
      ),
    );
  }
}

/* ============================================================
   FEATURED EVENTS
   ============================================================ */
class _FeaturedEvents extends StatefulWidget {
  const _FeaturedEvents();

  @override
  State<_FeaturedEvents> createState() => _FeaturedEventsState();
}

class _FeaturedEventsState extends State<_FeaturedEvents> {
  late final PageController _controller;
  int _index = 0;

  static const _events = [
    {
      'image': 'https://images.unsplash.com/photo-1547347298-4074fc3086f0',
      'title': 'Prime Energy Cup 2024',
      'subtitle': 'Starts Aug 12 • Entry ₹500',
      'tag': 'SPONSORED',
    },
    {
      'image': 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
      'title': 'Weekend Football Bash',
      'subtitle': 'Open slots available',
      'tag': 'HOT',
    },
    {
      'image': 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2',
      'title': 'Community Badminton',
      'subtitle': 'Free entry • All levels',
      'tag': 'COMMUNITY',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;

      _index = (_index + 1) % _events.length;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const _SectionHeader('Featured Events'),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;

            final cardHeight = (w * 0.42).clamp(140.0, 170.0);
            final padding = (w * 0.045).clamp(12.0, 16.0);
            final titleSize = (w * 0.045).clamp(14.0, 16.0);
            final subtitleSize = (w * 0.035).clamp(11.0, 12.0);
            final tagSize = (w * 0.032).clamp(10.0, 11.0);

            return SizedBox(
              height: cardHeight,
              child: PageView.builder(
                controller: _controller,
                padEnds: false,
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 20 : 0,
                      right: index == _events.length - 1 ? 20 : 16,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          /// ✅ CACHED IMAGE WITH SHIMMER
                          CachedNetworkImage(
                            imageUrl: event['image']!,
                            fit: BoxFit.cover,
                            cacheKey: event['image'],
                            placeholder: (context, _) => _ShimmerPlaceholder(),
                            errorWidget: (context, _, __) => const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 28,
                              ),
                            ),
                          ),

                          /// OVERLAY
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.55),
                                  Colors.black.withOpacity(0.25),
                                ],
                              ),
                            ),
                          ),

                          /// CONTENT
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TAG
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: (w * 0.03).clamp(8.0, 12.0),
                                    vertical: (w * 0.012).clamp(4.0, 6.0),
                                  ),
                                  decoration: BoxDecoration(
                                    color: UserHomePage.accent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    event['tag']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: tagSize,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                /// TITLE
                                Text(
                                  event['title']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                /// SUBTITLE
                                Text(
                                  event['subtitle']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: UserHomePage.muted,
                                    fontSize: subtitleSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 🔥 SHIMMER WIDGET
class _ShimmerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(color: Colors.grey.shade800),
    );
  }
}

/* ============================================================
   SECTION HEADER
   ============================================================ */
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        const Text(
          'See All',
          style: TextStyle(color: UserHomePage.accent, fontSize: 13),
        ),
      ],
    );
  }
}

/* ============================================================
   OFFICIAL APP INFO / FOOTER
   ============================================================ */
class _OfficialAppInfo extends StatelessWidget {
  const _OfficialAppInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'PlayZ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Play • Book • Compete',
            style: TextStyle(color: UserHomePage.muted, fontSize: 13),
          ),
          SizedBox(height: 10),
          Text(
            'Built for local sports, teams, and communities.',
            textAlign: TextAlign.center,
            style: TextStyle(color: UserHomePage.muted, fontSize: 12),
          ),
          SizedBox(height: 12),
          Text(
            '© 2026 PlayZ Technologies. All rights reserved.',
            style: TextStyle(color: UserHomePage.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   BOTTOM NAVIGATION
   ============================================================ */
// class _BottomNav extends StatefulWidget {
//   const _BottomNav();

//   @override
//   State<_BottomNav> createState() => _BottomNavState();
// }

// class _BottomNavState extends State<_BottomNav> {
//   int _currentIndex = 0;
//   int _pressedIndex = -1;

//   static const Color surface = Color(0xFF121212);
//   static const Color accent = Color(0xFF1DB954);

//   final List<_NavItem> _items = const [
//     _NavItem(
//       filled: Icons.home,
//       outlined: Icons.home_outlined,
//       label: 'Home',
//     ),
//     _NavItem(
//       filled: Icons.calendar_month_rounded,
//       outlined: Icons.calendar_month_outlined,
//       label: 'Book',
//     ),
//     _NavItem(
//       filled: Icons.play_circle_fill,
//       outlined: Icons.play_circle_outline,
//       label: 'Play',
//     ),
//     _NavItem(
//       filled: Icons.people,
//       outlined: Icons.people_outline,
//       label: 'Friends',
//     ),
//     _NavItem(
//       filled: Icons.menu,
//       outlined: Icons.menu_outlined,
//       label: 'More',
//     ),
//   ];

//   void _onTap(int index) {
//     setState(() => _pressedIndex = index);

//     Future.delayed(const Duration(milliseconds: 120), () {
//       if (!mounted) return;
//       setState(() {
//         _currentIndex = index;
//         _pressedIndex = -1;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 74,
//       color: Color.fromRGBO(18, 18, 18, 0.8), // semi-transparent, no glass
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(_items.length, (index) {
//           final item = _items[index];
//           final bool selected = _currentIndex == index;
//           final bool pressed = _pressedIndex == index;

//           return GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () => _onTap(index),
//             child: AnimatedScale(
//               scale: pressed ? 0.9 : 1.0,
//               duration: const Duration(milliseconds: 140),
//               curve: Curves.easeOut,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     selected ? item.filled : item.outlined,
//                     size: 26,
//                     color: selected ? accent : Colors.white70,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     item.label,
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight:
//                           selected ? FontWeight.w600 : FontWeight.w400,
//                       color: selected ? accent : Colors.white60,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// /* ============================================================
//    NAV ITEM MODEL
//    ============================================================ */
// class _NavItem {
//   final IconData filled;
//   final IconData outlined;
//   final String label;

//   const _NavItem({
//     required this.filled,
//     required this.outlined,
//     required this.label,
//   });
// }