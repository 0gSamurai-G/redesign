import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Home/Friends/friends_chat.dart';

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
            SliverToBoxAdapter(child: _MessagesListSection()),
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
        ],
      ),
    );
  }
}

class _OnlineNowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> onlineUsers = [
      {
        'name': 'Marcus',
        'img': 'https://randomuser.me/api/portraits/men/32.jpg',
      },
      {
        'name': 'Sarah',
        'img': 'https://randomuser.me/api/portraits/women/44.jpg',
      },
      {
        'name': 'Alex P.',
        'img': 'https://randomuser.me/api/portraits/men/45.jpg',
      },
      {
        'name': 'Emma',
        'img': 'https://randomuser.me/api/portraits/women/68.jpg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            'Online Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: onlineUsers.length,
            itemBuilder: (_, i) => _OnlineAvatar(
              name: onlineUsers[i]['name']!,
              imageUrl: onlineUsers[i]['img']!,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnlineAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _OnlineAvatar({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: kGreen.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: kGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBg, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
                      fontWeight: FontWeight.w800,
                    ),
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
                  borderRadius: BorderRadius.circular(18),
                ),
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
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/44.jpg',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _LevelBadge(level),
                    ],
                  ),
                  Text(
                    meta,
                    style: const TextStyle(color: kMuted, fontSize: 12),
                  ),
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
      child: Text(label, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;

  const _SectionHeader(this.title, {this.action});

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
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          if (action != null)
            Text(
              action!,
              style: const TextStyle(
                color: kGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _MessagesListSection extends StatelessWidget {
  const _MessagesListSection();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {
        'name': 'David Miller',
        'subtitle': '3 new messages',
        'isNew': true,
        'hasDot': true,
        'img': 'https://randomuser.me/api/portraits/men/33.jpg',
      },
      {
        'name': 'Lia Chen',
        'subtitle': 'Active 5m ago',
        'isNew': false,
        'hasDot': false,
        'img': 'https://randomuser.me/api/portraits/women/40.jpg',
      },
      {
        'name': 'Tom Wilson',
        'subtitle': 'Sent 2h ago',
        'isNew': false,
        'hasDot': false,
        'img': 'https://randomuser.me/api/portraits/men/22.jpg',
      },
      {
        'name': 'Rachel G.',
        'subtitle': '1 new message',
        'isNew': true,
        'hasDot': true,
        'img': 'https://randomuser.me/api/portraits/women/65.jpg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MESSAGES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    '2 Requests',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: messages.length,
          itemBuilder: (_, i) {
            final msg = messages[i];
            return _MessageListTile(
              name: msg['name'] as String,
              subtitle: msg['subtitle'] as String,
              isNew: msg['isNew'] as bool,
              hasDot: msg['hasDot'] as bool,
              imageUrl: msg['img'] as String,
            );
          },
        ),
      ],
    );
  }
}

class _MessageListTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isNew;
  final bool hasDot;
  final String imageUrl;

  const _MessageListTile({
    required this.name,
    required this.subtitle,
    required this.isNew,
    required this.hasDot,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const ChatScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(radius: 26, backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(width: 16),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isNew ? kGreen : kMuted,
                      fontSize: 14,
                      fontWeight: isNew ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (hasDot)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: kGreen,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
