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
    return Scaffold(  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // TODO: Add Availability / Create Action
    },
    backgroundColor: kGreen,
    shape: CircleBorder(),
    elevation: 6,
    child: const Icon(
      Icons.add,
      size: 28,
      color: kBg,
    ),
  ),

  /// ✅ SAFE POSITION (ANDROID + IOS)
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: kBg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const _GroupsAppBar(),
            SliverToBoxAdapter(child: _SearchAndFilters()),
            const _SectionHeader(
              title: 'My Groups',
              subtitle: 'Your active squads',
              action: 'View all',
            ),
            SliverToBoxAdapter(child: _MyGroupsRow()),
            const _SectionHeader(
              title: 'Discover Groups',
              subtitle: 'Top rated squads nearby',
              action: 'Explore',
            ),
            SliverToBoxAdapter(child: _DiscoverGroupsRow()),
            const _SectionHeader(
              title: 'Clan Battles',
              subtitle: 'Live & upcoming matchups',
              action: 'Brackets',
            ),
            SliverToBoxAdapter(child: _ClanBattles()),
            const _SectionHeader(
              title: 'Upcoming Tournaments',
              subtitle: 'Compete for glory & prizes',
            ),
            SliverToBoxAdapter(child: _TournamentsRow()),
            const _SectionHeader(
              title: 'Recent Activity',
              subtitle: 'Updates from your circles',
            ),
            SliverToBoxAdapter(child: _RecentActivityCard()),
            const _SectionHeader(title: 'Weekly Challenge'),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: _WeeklyChallengeCard(),
              ),
            ),
            
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
                    _HeaderIcon(Icons.notifications_none),
                    const SizedBox(width: 10),
                    _HeaderIcon(Icons.person_add_alt_1),
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
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _FilterChip('All Groups', selected: true),
                _FilterChip('My Squads'),
                _FilterChip('Nearby'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: kGreen,
        backgroundColor: kSurface,
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) {},
      ),
    );
  }
}

/* ============================================================
   SECTION HEADER (REUSABLE)
   ============================================================ */
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? action;

  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(subtitle!,
                          style: const TextStyle(
                              color: kMuted, fontSize: 12)),
                    ),
                ],
              ),
            ),
            if (action != null)
              Text(action!,
                  style: const TextStyle(
                      color: kGreen, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   MY GROUPS
   ============================================================ */
class _MyGroupsRow extends StatelessWidget {
  const _MyGroupsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230, // safe height for image + content
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          return _MyGroupCard(
            role: i == 0 ? 'ADMIN' : 'CAPTAIN',
            roleColor: i == 0 ? kGreen : const Color(0xFFF5C542),
            name: i == 0 ? 'Shivajinagar Strikers' : 'Midnight Futsal',
            meta: i == 0
                ? 'Cricket · 11 members'
                : 'Football · 8 members',
            activity: i == 0 ? 'Match Today 7PM' : '2 new msgs',
            imageUrl:
                'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
          );
        },
      ),
    );
  }
}

class _MyGroupCard extends StatelessWidget {
  final String role;
  final Color roleColor;
  final String name;
  final String meta;
  final String activity;
  final String imageUrl;

  const _MyGroupCard({
    required this.role,
    required this.roleColor,
    required this.name,
    required this.meta,
    required this.activity,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE + ROLE
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: roleColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// NAME
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          /// META
          Text(
            meta,
            style: const TextStyle(
              color: kMuted,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          /// AVATARS
          Row(
            children: List.generate(
              3,
              (i) => Container(
                margin: const EdgeInsets.only(right: 6),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/${i + 10}.jpg',
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          /// ACTIVITY
          Row(
            children: [
              Icon(
                activity.contains('Match')
                    ? Icons.circle
                    : Icons.chat_bubble_outline,
                size: 12,
                color: kGreen,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  activity,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/* ============================================================
   DISCOVER GROUPS
   ============================================================ */
class _DiscoverGroupsRow extends StatelessWidget {
  const _DiscoverGroupsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 297,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemCount: 2,
        itemBuilder: (_, i) {
          return _DiscoverGroupCard(
            title: i == 0 ? 'CrossFit Spartans' : 'Sunday League',
            meta: i == 0
                ? 'Fitness · 2.1km · Pro'
                : 'Football · 4.5km',
            primaryCta: i == 0 ? 'Join' : 'Request',
            imageUrl:
                'https://images.unsplash.com/photo-1517836357463-d25dfeac3438',
            logoUrl:
                'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
          );
        },
      ),
    );
  }
}


class _DiscoverGroupCard extends StatelessWidget {
  final String title;
  final String meta;
  final String primaryCta;
  final String imageUrl;
  final String logoUrl;

  const _DiscoverGroupCard({
    required this.title,
    required this.meta,
    required this.primaryCta,
    required this.imageUrl,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: kSurface,
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE SECTION
          SizedBox(
            height: 140,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.black),
                  ),
                ),

                /// LOGO OVERLAY
                Positioned(
                  bottom: -22,
                  left: 14,
                  child: Container(
                    height: 44,
                    width: 44,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: logoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                /// META
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kMuted,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 14),

                /// CTA ROW
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreen,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            primaryCta,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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
    );
  }
}


/* ============================================================
   CLAN BATTLES
   ============================================================ */
class _ClanBattles extends StatelessWidget {
  const _ClanBattles();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: const [
          _LiveBattleCard(),
          SizedBox(height: 12),
          _UpcomingBattleCard(),
        ],
      ),
    );
  }
}


class _LiveBattleCard extends StatelessWidget {
  const _LiveBattleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            children: const [
              Text(
                'Ranked Match · Cricket',
                style: TextStyle(color: kMuted, fontSize: 12),
              ),
              Spacer(),
              _LiveBadge(),
            ],
          ),

          const SizedBox(height: 14),

          /// SCORE + TEAMS
          Row(
            children: [
              _TeamColumn(
                imageUrl:
                    'https://randomuser.me/api/portraits/men/32.jpg',
                name: 'Shivajinagar\nStrikers',
              ),

              Expanded(
                child: Column(
                  children: const [
                    Text(
                      '142/4',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'OVERS · 16.2',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 11,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),

              _TeamColumn(
                imageUrl:
                    'https://randomuser.me/api/portraits/men/45.jpg',
                name: 'Camp Kings',
                alignEnd: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ACTIONS
          Row(
            children: const [
              Expanded(child: _BattleButton('Spectate')),
              SizedBox(width: 12),
              Expanded(child: _BattleButton('Stats', primary: true)),
            ],
          ),
        ],
      ),
    );
  }
}


class _UpcomingBattleCard extends StatelessWidget {
  const _UpcomingBattleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            children: const [
              Text(
                'Friendly · 5-a-side',
                style: TextStyle(color: kMuted, fontSize: 12),
              ),
              Spacer(),
              Text(
                'Tomorrow 9:30 PM',
                style: TextStyle(
                  color: kGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// VS ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _VsTeam(
                imageUrl:
                    'https://randomuser.me/api/portraits/men/11.jpg',
                name: 'Midnight Crew',
              ),
              Text(
                'VS',
                style: TextStyle(
                  color: kMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _VsTeam(
                imageUrl:
                    'https://randomuser.me/api/portraits/men/22.jpg',
                name: 'Weekend FC',
                alignEnd: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _TeamColumn extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool alignEnd;

  const _TeamColumn({
    required this.imageUrl,
    required this.name,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: kMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


class _VsTeam extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool alignEnd;

  const _VsTeam({
    required this.imageUrl,
    required this.name,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(
            color: kMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


class _BattleButton extends StatelessWidget {
  final String label;
  final bool primary;

  const _BattleButton(this.label, {this.primary = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? kGreen : Colors.black,
          foregroundColor: primary ? Colors.black : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}


class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'LIVE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}


/* ============================================================
   TOURNAMENTS
   ============================================================ */
class _TournamentsRow extends StatelessWidget {
  const _TournamentsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260, // only for horizontal scrolling container
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          return _TournamentCard(
            title: i == 0
                ? 'Pune City Championship'
                : 'Winter Football Cup',
            sport: i == 0 ? 'Cricket' : 'Football',
            startDate: i == 0 ? 'Starts 15th Dec' : 'Starts 22nd Dec',
            prize: i == 0 ? '₹50,000' : '₹25,000',
            badge: i == 0 ? 'REGISTRATION OPEN' : 'COMING SOON',
            badgeColor: i == 0 ? const Color(0xFFF5C542) : Colors.blue,
            imageUrl: i == 0
                ? 'https://images.unsplash.com/photo-1521412644187-c49fa049e84d'
                : 'https://images.unsplash.com/photo-1509027572446-af8401acfdc3',
          );
        },
      ),
    );
  }
}


class _TournamentCard extends StatelessWidget {
  final String title;
  final String sport;
  final String startDate;
  final String prize;
  final String badge;
  final Color badgeColor;
  final String imageUrl;

  const _TournamentCard({
    required this.title,
    required this.sport,
    required this.startDate,
    required this.prize,
    required this.badge,
    required this.badgeColor,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.78, // keeps card proportional on all devices
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE HEADER
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: Colors.black,
                      ),
                    ),
                  ),

                  /// STATUS BADGE
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// CONTENT
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$sport · $startDate',
                      style: const TextStyle(
                        color: kMuted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 16,
                          color: Color(0xFFF5C542),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Prize Pool: $prize',
                          style: const TextStyle(
                            color: Color(0xFFF5C542),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   RECENT ACTIVITY
   ============================================================ */
class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Column(
          children: [
            _ActivityRow(
              icon: Icons.emoji_events,
              iconColor: kGreen,
              title:
                  'Kothrud Knights won the Inter-city Cricket League finals!',
              time: '2 hours ago',
            ),
            SizedBox(height: 14),
            _ActivityRow(
              icon: Icons.star_border_rounded,
              iconColor: Color(0xFFF5C542),
              title:
                  "Rahul Sharma just reached 'Pro' rank in Football.",
              time: '5 hours ago',
            ),
            SizedBox(height: 14),
            _ActivityRow(
              icon: Icons.group_outlined,
              iconColor: Colors.blueAccent,
              title:
                  '3 friends joined Narhe United group.',
              time: 'Yesterday',
            ),
          ],
        ),
      ),
    );
  }
}


class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;

  const _ActivityRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ICON
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),

        /// TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  color: kMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


/* ============================================================
   WEEKLY CHALLENGE
   ============================================================ */
class _WeeklyChallengeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('WEEKLY CHALLENGE',
                  style: TextStyle(
                      color: kGreen, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Turf Dominator',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text(
                'Play 5 matches at any turf with your squad this week.',
                style: TextStyle(color: kMuted),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: 0.6,
                color: kGreen,
                backgroundColor: Colors.white12,
              ),
              const SizedBox(height: 6),
              const Text('3/5 completed · 2 days left',
                  style: TextStyle(color: kMuted)),
            ],
          ),
        ),
        // Positioned(
        //   right: 12,
        //   bottom: 12,
        //   child: FloatingActionButton(
        //     mini: true,
        //     backgroundColor: kGreen,
        //     onPressed: () {},
        //     child: const Icon(Icons.add, color: Colors.black),
        //   ),
        // )
      ],
    );
  }
}
