import 'dart:ui';

import 'package:flutter/material.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);

const kGreen = Color(0xFF1DB954);
const kRed = Color(0xFFE53935);
const kGold = Color(0xFFFFC107);
const kPurple = Color(0xFF7C4DFF);
const kMuted = Color(0xFFA7A7A7);


class ScoreboardHubScreen extends StatelessWidget {
  const ScoreboardHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const _ScoreboardAppBar(),

            SliverToBoxAdapter(child: _QuickActions()),
            SliverToBoxAdapter(child: _CreateScoreboardHero()),

            const _SectionHeader(
              title: 'Live Scoreboards',
              action: 'View All',
              liveDot: true,
            ),
            SliverToBoxAdapter(child: _LiveScoreboardCard()),

            SliverToBoxAdapter(child: _LiveTournamentWatch()),

            const _SectionHeader(title: 'Clan Battles'),
            SliverToBoxAdapter(child: _ClanBattleCard()),

            const _SectionHeader(title: 'Tournaments'),
            SliverToBoxAdapter(child: _TournamentCard(
  name: 'Mumbai Premier League',
  sport: 'Cricket',
  teams: 12,
  stage: 'Semi-Finals',
  prize: '₹1,50,000',
  season: '4',
),
),

            const _SectionHeader(title: 'History'),
            SliverToBoxAdapter(child: _HistoryList()),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}


class _ScoreboardAppBar extends StatelessWidget {
  const _ScoreboardAppBar();

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
                    'Scoreboards',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Live scores & real competition',
                    style: TextStyle(color: kMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            _CircleIcon(Icons.search),
            const SizedBox(width: 10),
            _CircleIcon(Icons.add, fill: kGreen),
          ],
        ),
      ),
    );
  }
}


class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Row(
        children: const [
          Expanded(
            child: _QuickActionCard(
              icon: Icons.add_circle_outline,
              title: 'New Match',
              subtitle: 'Start Tracking',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _QuickActionCard(
              icon: Icons.podcasts,
              title: 'Live View',
              subtitle: '3 Happening',
              live: true,
            ),
          ),
        ],
      ),
    );
  }
}


class _CreateScoreboardHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              kGreen.withOpacity(0.18),
              kSurface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a Scoreboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Track scores for friendly matches, practice games, or local tournaments.',
              style: TextStyle(color: kMuted),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {},
              child: const Text('Create Now →'),
            ),
          ],
        ),
      ),
    );
  }
}


class _LiveScoreboardCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: const [
                Text('FUTSAL · FRIENDLY MATCH',
                    style: TextStyle(color: kMuted, fontSize: 12)),
                Spacer(),
                _LiveBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: _TeamScore('RD', 'Red Dragons', '4')),
                Text('–',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800)),
                Expanded(child: _TeamScore('BH', 'Blue Hawks', '2')),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '38′ 2nd Half',
              style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: 0.58,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: const AlwaysStoppedAnimation(kGreen),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '⚡ Goal! Rahul S. scored (37′)',
              style: TextStyle(color: kMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}


class _LiveTournamentWatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black.withOpacity(0.4)],
          ),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pune City Championship',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('1.2k watching · Final Match',
                      style: TextStyle(color: kMuted, fontSize: 12)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('WATCH LIVE'),
            ),
          ],
        ),
      ),
    );
  }
}


class _HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: const [
          _HistoryTile(
            title: 'Rahul vs Amit',
            subtitle: 'Yesterday · Badminton',
            score: '21 – 18',
            highlight: 'MVP: Rahul',
          ),
          SizedBox(height: 10),
          _HistoryTile(
            title: 'Sunday Smashers',
            subtitle: 'Oct 24 · Cricket Box',
            score: '142 – 145',
            highlight: 'Man of Match: Arjun',
          ),
        ],
      ),
    );
  }
}


class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text('LIVE',
          style: TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color? fill;
  const _CircleIcon(this.icon, {this.fill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: fill ?? kSurface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: fill != null ? Colors.black : Colors.white),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final bool liveDot;

  const _SectionHeader({
    required this.title,
    this.action,
    this.liveDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
        child: Row(
          children: [
            if (liveDot)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: kRed,
                  shape: BoxShape.circle,
                ),
              ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (action != null)
              GestureDetector(
                onTap: () {},
                child: Text(
                  action!,
                  style: const TextStyle(
                    color: kGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool live;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.live = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: live ? kRed : kGreen, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style:
                        const TextStyle(color: kMuted, fontSize: 12)),
              ],
            ),
          ),
          if (live)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: kRed,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class _TeamScore extends StatelessWidget {
  final String short;
  final String name;
  final String score;

  const _TeamScore(this.short, this.name, this.score);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white.withOpacity(0.08),
          child: Text(
            short,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: kMuted, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          score,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}


class _HistoryTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String score;
  final String highlight;

  const _HistoryTile({
    required this.title,
    required this.subtitle,
    required this.score,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style:
                        const TextStyle(color: kMuted, fontSize: 12)),
                const SizedBox(height: 4),
                Text(highlight,
                    style:
                        const TextStyle(color: kMuted, fontSize: 12)),
              ],
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              color: kGreen,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}


class _ClanBattleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Text('REGIONAL RIVALRY',
                    style: TextStyle(color: kMuted, fontSize: 12)),
                Spacer(),
                Text('Q4 Live',
                    style: TextStyle(color: kRed, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(child: _ClanScore('TI', 'Titans', 88)),
                Text('VS',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                Expanded(child: _ClanScore('SP', 'Spartans', 82)),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap for full stats & MVP',
              style: TextStyle(color: kMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClanScore extends StatelessWidget {
  final String tag;
  final String name;
  final int score;

  const _ClanScore(this.tag, this.name, this.score);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white.withOpacity(0.08),
          child: Text(tag,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 6),
        Text(name,
            style:
                const TextStyle(color: kMuted, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          '$score',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}


class _TournamentCard extends StatelessWidget {
  final String name;
  final String sport;
  final int teams;
  final String stage;
  final String prize;
  final String season;

  const _TournamentCard({
    super.key,
    required this.name,
    required this.sport,
    required this.teams,
    required this.stage,
    required this.prize,
    required this.season,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.amber.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER ROW
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'SEASON $season',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// META
            Text(
              '$sport · $teams Teams',
              style: const TextStyle(
                color: kMuted,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            /// PRIZE
            Row(
              children: [
                const Icon(Icons.monetization_on,
                    size: 16, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  'Prize Pool: $prize',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// FOOTER
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Current Stage\n$stage',
                    style: const TextStyle(
                      color: kMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
                _ActionChip(
                  Icons.account_tree_outlined,
                  'View Bracket',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool outlined;
  final Color? color;

  const _ActionChip(
    this.icon,
    this.label, {
    super.key,
    this.onTap,
    this.outlined = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = color ?? kGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : accent,
            borderRadius: BorderRadius.circular(999),
            border: outlined
                ? Border.all(
                    color: accent.withOpacity(0.6),
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: outlined ? accent : Colors.black,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: outlined ? accent : Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
