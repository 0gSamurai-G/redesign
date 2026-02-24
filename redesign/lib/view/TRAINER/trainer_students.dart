import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);

const kGreen = Color(0xFF1DB954);
const kAmber = Color(0xFFF5C542);
const kMuted = Color(0xFFA7A7A7);
const kCompleted = Colors.white38;

class TrainerStudentsScreen extends StatefulWidget {
  const TrainerStudentsScreen({super.key});

  @override
  State<TrainerStudentsScreen> createState() =>
      _TrainerStudentsScreenState();
}

class _TrainerStudentsScreenState
    extends State<TrainerStudentsScreen> {
  int _filterIndex = 0;

  final filters = const ['All Students', 'Active', 'Payment Due'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const _StudentsAppBar(),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SearchBar(),
                const SizedBox(height: 12),
                _FilterChips(
                  filters: filters,
                  selected: _filterIndex,
                  onChanged: (i) {
                    setState(() => _filterIndex = i);
                  },
                ),
                const SizedBox(height: 24),

                _SectionHeader(
                  title: 'ACTIVE TODAY',
                  action: 'VIEW CALENDAR',
                ),
                const SizedBox(height: 12),
                const _ActiveTodayCard(),
                const SizedBox(height: 28),

                const Text(
                  'ALL STUDENTS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),

                const _StudentCard.active(
                  name: 'Rohan Mehta',
                  subtitle: '16 yrs  ·  All-Rounder',
                  package: 'Quarterly Camp',
                  progress: '23 / 24',
                  attendance: '92% Attendance',
                  endText: 'Ends Tomorrow',
                  avatar:
                      'https://randomuser.me/api/portraits/men/12.jpg',
                ),
                const SizedBox(height: 12),

                const _StudentCard.active(
                  name: 'Neha Sharma',
                  subtitle: '22 yrs  ·  Fitness & Strength',
                  package: 'Monthly Strength',
                  progress: '4 / 12',
                  attendance: '100% Attendance',
                  endText: 'Ends 28 Oct 2023',
                  avatar:
                      'https://randomuser.me/api/portraits/women/44.jpg',
                ),
                const SizedBox(height: 12),

                const _StudentCard.completed(
                  name: 'Vikram Singh',
                  subtitle: '26 yrs  ·  Fast Bowler',
                  package: '1-on-1 Session',
                  attendance: '100% Attendance',
                  endText: 'Ended 10 Sep 2023',
                  avatar:
                      'https://randomuser.me/api/portraits/men/66.jpg',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── APP BAR ───────────────── */

class _StudentsAppBar extends StatelessWidget {
  const _StudentsAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Students',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Manage 24 active athletes',
                            style: TextStyle(color: kMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_add_outlined,
                          color: Colors.white),
                      onPressed: () {},
                    ),
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

/* ───────────────── SEARCH ───────────────── */

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: kMuted),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText:
                    'Search by name, role or package',
                hintStyle: TextStyle(color: kMuted),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune,
                color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

/* ───────────────── FILTER CHIPS ───────────────── */

class _FilterChips extends StatelessWidget {
  final List<String> filters;
  final int selected;
  final ValueChanged<int> onChanged;

  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = i == selected;
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? kGreen : kCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filters[i],
                style: TextStyle(
                  color:
                      active ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ───────────────── ACTIVE TODAY CARD ───────────────── */

class _ActiveTodayCard extends StatelessWidget {
  const _ActiveTodayCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: kGreen.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: const [
          _StudentHeader(
            name: 'Aryan Patel',
            subtitle: '19 yrs  ·  Top Order Batsman',
            avatar:
                'https://randomuser.me/api/portraits/men/32.jpg',
            badge: 'Active',
            badgeColor: kGreen,
          ),
          SizedBox(height: 12),
          _ProgressRow(
            label: 'Pro Batting Module',
            progress: 0.6,
            right: '12 / 20',
            footer:
                'Ends 15 Oct 2023   ·   85% Attendance',
          ),
          SizedBox(height: 12),
          _ActionRow(
            primary: 'Mark Present',
            secondary: 'Chat',
          ),
        ],
      ),
    );
  }
}

/* ───────────────── STUDENT CARD ───────────────── */

class _StudentCard extends StatelessWidget {
  final bool completed;
  final String name;
  final String subtitle;
  final String package;
  final String attendance;
  final String endText;
  final String avatar;
  final String? progress;

  const _StudentCard.active({
    required this.name,
    required this.subtitle,
    required this.package,
    required this.attendance,
    required this.endText,
    required this.avatar,
    this.progress,
  }) : completed = false;

  const _StudentCard.completed({
    required this.name,
    required this.subtitle,
    required this.package,
    required this.attendance,
    required this.endText,
    required this.avatar,
  })  : completed = true,
        progress = null;

  @override
  Widget build(BuildContext context) {
    final color = completed ? kCompleted : kGreen;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: completed
            ? null
            : Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _StudentHeader(
            name: name,
            subtitle: subtitle,
            avatar: avatar,
            badge: completed ? 'Completed' : 'Active',
            badgeColor: color,
            grayscale: completed,
          ),
          const SizedBox(height: 12),
          _ProgressRow(
            label: package,
            progress: completed ? null : 0.9,
            right: progress,
            footer:
                '$endText   ·   $attendance',
            muted: completed,
          ),
          const SizedBox(height: 12),
          _ActionRow(
            primary:
                completed ? 'Re-Enroll' : 'Schedule',
            secondary: completed ? 'Notes' : 'Chat',
            muted: completed,
          ),
        ],
      ),
    );
  }
}

/* ───────────────── REUSABLE ROWS ───────────────── */

class _StudentHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String avatar;
  final String badge;
  final Color badgeColor;
  final bool grayscale;

  const _StudentHeader({
    required this.name,
    required this.subtitle,
    required this.avatar,
    required this.badge,
    required this.badgeColor,
    this.grayscale = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage:
              CachedNetworkImageProvider(avatar),
          foregroundColor:
              grayscale ? Colors.grey : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: kMuted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badge,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double? progress;
  final String? right;
  final String footer;
  final bool muted;

  const _ProgressRow({
    required this.label,
    required this.footer,
    this.progress,
    this.right,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white)),
            ),
            if (right != null)
              Text(right!,
                  style: const TextStyle(
                      color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 6),
        if (progress != null)
          LinearProgressIndicator(
            value: progress,
            color: kGreen,
            backgroundColor:
                Colors.white12,
            minHeight: 6,
          ),
        const SizedBox(height: 6),
        Text(
          footer,
          style: const TextStyle(color: kMuted),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String primary;
  final String secondary;
  final bool muted;

  const _ActionRow({
    required this.primary,
    required this.secondary,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _ActionButton(
          label: secondary,
          outlined: true,
          muted: muted,
        ),
        _ActionButton(
          label: primary,
          primary: true,
          muted: muted,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool primary;
  final bool outlined;
  final bool muted;

  const _ActionButton({
    required this.label,
    this.primary = false,
    this.outlined = false,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        muted ? kCompleted : kGreen;

    return Material(
      color: outlined
          ? Colors.transparent
          : color,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 18, vertical: 10),
          decoration: outlined
              ? BoxDecoration(
                  border: Border.all(
                      color: color.withOpacity(0.4)),
                  borderRadius:
                      BorderRadius.circular(24),
                )
              : null,
          child: Text(
            label,
            style: TextStyle(
              color: outlined
                  ? color
                  : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onActionTap;

  const _SectionHeader({
    required this.title,
    this.action,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),

        if (action != null)
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onActionTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                action!,
                style: const TextStyle(
                  color: Color(0xFF1DB954), // Spotify Green
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
