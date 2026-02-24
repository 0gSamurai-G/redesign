

import 'dart:ui';

import 'package:flutter/material.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF1DB954);
const kMuted = Colors.white70;
const kBlue = Color(0xFF4DA3FF);
const kAmber = Color(0xFFFFC107);

class FriendsHubScreen extends StatelessWidget {
  const FriendsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const _FriendsAppBar(),
            SliverToBoxAdapter(child: _SearchAndFilters()),
            SliverToBoxAdapter(child: _OnlineNowSection()),
            SliverToBoxAdapter(child: _FriendsListSection()), // 👈 ADD THIS
            SliverToBoxAdapter(child: _RequestsSection()),
            SliverToBoxAdapter(child: _BuildSquadCTA()),
            SliverToBoxAdapter(child: _SuggestedPlayersSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}


class _FriendsAppBar extends StatelessWidget {
  const _FriendsAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Friends Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Play together. Stay connected.',
                    style: TextStyle(color: kMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
              onPressed: () {},
            ),
            const CircleAvatar(
              radius: 18,
              backgroundImage:
                  NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}


class _SearchAndFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: kMuted),
                hintText: 'Find friends, squads, or nearby players...',
                hintStyle: TextStyle(color: kMuted),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                _FilterChip('All', active: true),
                _FilterChip('Online'),
                _FilterChip('Nearby'),
                _FilterChip('Requests (2)'),
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
  final bool active;

  const _FilterChip(this.label, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        selectedColor: kGreen,
        backgroundColor: kSurface,
        labelStyle: TextStyle(
          color: active ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) {},
      ),
    );
  }
}


class _OnlineNowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader('Online Now', action: 'See All (8)'),
        SizedBox(
          height: 110,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (_, i) => const _OnlineAvatar(),
          ),
        ),
      ],
    );
  }
}

class _OnlineAvatar extends StatelessWidget {
  const _OnlineAvatar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage:
                    NetworkImage('https://randomuser.me/api/portraits/men/12.jpg'),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: kGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Rohan',
              style: TextStyle(color: Colors.white, fontSize: 12)),
          const Text('Looking',
              style: TextStyle(color: kAmber, fontSize: 11)),
        ],
      ),
    );
  }
}


class _RequestsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SectionHeader('Requests', count: '2'),
        _RequestCard(
          name: 'Karan Mehra',
          meta: 'Football · 3 Mutual Friends',
        ),
        _RequestCard(
          name: 'Sara Ali',
          meta: 'Badminton · 1 Mutual Friend',
        ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String name;
  final String meta;

  const _RequestCard({required this.name, required this.meta});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage:
                  NetworkImage('https://randomuser.me/api/portraits/men/40.jpg'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                  Text(meta,
                      style:
                          const TextStyle(color: kMuted, fontSize: 12)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Confirm'),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: kMuted),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}


class _BuildSquadCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build a New Squad',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Book turfs faster with your team.',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Start Now'),
            ),
          ],
        ),
      ),
    );
  }
}


class _SuggestedPlayersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SectionHeader('Suggested Players', action: 'View Map'),
        _SuggestedPlayerCard(
          name: 'Rahul S.',
          level: 'Intermediate',
          meta: '500m · Football',
        ),
        _SuggestedPlayerCard(
          name: 'Sneha K.',
          level: 'Pro',
          meta: '1.2km · Badminton',
        ),
      ],
    );
  }
}

class _SuggestedPlayerCard extends StatelessWidget {
  final String name;
  final String level;
  final String meta;

  const _SuggestedPlayerCard({
    required this.name,
    required this.level,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage:
                  NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      _LevelBadge(level),
                    ],
                  ),
                  Text(meta,
                      style:
                          const TextStyle(color: kMuted, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add_alt, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String label;
  const _LevelBadge(this.label);

  @override
  Widget build(BuildContext context) {
    final color = label == 'Pro' ? kGreen : kMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 11)),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final String? count;

  const _SectionHeader(this.title, {this.action, this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800),
          ),
          if (count != null)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                count!,
                style: const TextStyle(color: kGreen),
              ),
            ),
          const Spacer(),
          if (action != null)
            Text(
              action!,
              style: const TextStyle(
                  color: kGreen, fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }
}


class _FriendsListSection extends StatelessWidget {
  const _FriendsListSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('Friends'),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          itemCount: 6,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: Colors.white12,
          ),
          itemBuilder: (_, i) {
            return _FriendListTile(
              name: _names[i],
              subtitle: _statuses[i],
              statusColor: _statusColors[i],
              unreadCount: 2,
            );
          },
        ),
      ],
    );
  }
}


class _FriendListTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final Color statusColor;
  final int unreadCount;

  const _FriendListTile({
    required this.name,
    required this.subtitle,
    required this.statusColor,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        // TODO: Open chat thread
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            /// AVATAR + STATUS DOT
            Stack(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/45.jpg',
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: kBg, width: 2),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            /// NAME + STATUS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            /// UNREAD COUNT
            _UnreadCountBadge(unreadCount),
          ],
        ),
      ),
    );
  }
}



final _names = [
  'Rohan',
  'Priya',
  'Amit',
  'Neha',
  'Vikram',
  'Sneha',
];

final _statuses = [
  'Looking for a game',
  'In match · Football',
  'Available nearby',
  'Offline',
  'In game',
  'Online',
];

final _statusColors = [
  kAmber, // Looking
  kBlue,  // In game
  kGreen, // Online
  Colors.grey, // Offline
  kBlue,
  kGreen,
];


class _UnreadCountBadge extends StatelessWidget {
  final int count;

  const _UnreadCountBadge(this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final display = count > 99 ? '99+' : '$count';

    return Container(
      height: 26,
      constraints: const BoxConstraints(minWidth: 26),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: kGreen, // Spotify dark surface
        shape: BoxShape.circle,
        border: Border.all(
          color: kGreen.withOpacity(0.35),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        display,
        style: const TextStyle(
          color: kBg,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
