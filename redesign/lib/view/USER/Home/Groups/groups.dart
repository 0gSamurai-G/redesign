import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/* ============================================================
   THEME CONSTANTS
   ============================================================ */
const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF1DB954);
const kMuted = Colors.white70;
const kGold = Color(0xFFF5C542);
const kRed = Color(0xFFE53935);

/* ============================================================
   GROUPS SCREEN
   ============================================================ */
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const _GroupsAppBar(),
            SliverToBoxAdapter(child: _SearchAndFilters()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _MySquadsList()),
            SliverToBoxAdapter(child: _RecommendedForYouSection()),
            SliverToBoxAdapter(child: _ExtraSquadsList()),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
        
      ),
    );
  }
}

/* ============================================================
   APP BAR
   ============================================================ */
class _GroupsAppBar extends StatelessWidget {
  const _GroupsAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              border: const Border(
                bottom: BorderSide(color: Colors.white12),
              ),
            ),
            child: SafeArea(
              bottom: false, // ✅ only top inset
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// TEXT
                    const Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // 🔥 critical
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Groups',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Play together. Compete harder.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// ACTION ICONS
                    _HeaderIcon(Icons.group_add),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: kSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

/* ============================================================
   SEARCH + FILTERS
   ============================================================ */
class _SearchAndFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: kMuted),
                hintText: 'Search groups, clans or tournaments',
                hintStyle: TextStyle(color: kMuted),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   SECTION HEADER (REUSABLE)
   ============================================================ */
class _MySquadsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'MY SQUADS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const _SquadListTile(
          name: 'Shivajinagar Strikers',
          subtitle: 'Rahul: See you guys at 7pm sharp!',
          subtitleHighlight: 'Rahul:',
          time: '7:42 PM',
          timeColor: kGreen,
          unreadCount: 3,
          imageUrl: 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
        ),
        const Divider(height: 1, color: Colors.white12, indent: 80, endIndent: 16),
        const _SquadListTile(
          name: 'IPL Fanatics',
          subtitle: 'Match today! Lineups announced at 6.',
          subtitleHighlight: '',
          time: 'YESTERDAY',
          timeColor: kMuted,
          unreadCount: 0,
          imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        ),
        const Divider(height: 1, color: Colors.white12, indent: 80, endIndent: 16),
      ],
    );
  }
}

class _SquadListTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String subtitleHighlight;
  final String time;
  final Color timeColor;
  final int unreadCount;
  final String imageUrl;
  final bool isBasketball;

  const _SquadListTile({
    required this.name,
    required this.subtitle,
    this.subtitleHighlight = '',
    required this.time,
    required this.timeColor,
    this.unreadCount = 0,
    required this.imageUrl,
    this.isBasketball = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (isBasketball) ...[
                            const SizedBox(width: 4),
                            const Text('🏀', style: TextStyle(fontSize: 16)),
                          ],
                        ],
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: timeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(
                              color: kMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              if (subtitleHighlight.isNotEmpty)
                                TextSpan(
                                  text: '$subtitleHighlight ',
                                  style: const TextStyle(color: kGreen),
                                ),
                              TextSpan(
                                text: subtitle.replaceFirst('$subtitleHighlight ', ''),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: kGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: kBg,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedForYouSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C0C0C),
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RECOMMENDED FOR YOU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'SEE ALL',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _RecommendedCard(
            name: 'Pune Runners Club',
            members: '1.2K MEMBERS',
            status: 'ACTIVE NOW',
            imageUrl: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5',
          ),
          const SizedBox(height: 12),
          const _RecommendedCard(
            name: 'Badminton Smashers',
            members: '840 MEMBERS',
            status: '12 ACTIVE',
            imageUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea',
          ),
        ],
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final String name;
  final String members;
  final String status;
  final String imageUrl;

  const _RecommendedCard({
    required this.name,
    required this.members,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(32), 
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$members • $status',
                    style: const TextStyle(
                      color: kMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.black,
                elevation: 0,
                minimumSize: const Size(64, 32),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'JOIN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExtraSquadsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SquadListTile(
          name: 'Weekend Hoops',
          subtitle: 'Sam: Who\'s carrying the ball today?',
          subtitleHighlight: 'Sam:',
          time: '2 DAYS AGO',
          timeColor: kMuted,
          imageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
          isBasketball: true,
        ),
      ],
    );
  }
}
