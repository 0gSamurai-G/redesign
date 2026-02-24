import 'dart:ui';

import 'package:flutter/material.dart';


/// CORE BACKGROUND
const Color kBg = Color(0xFF000000);
const Color kSurface = Color(0xFF0E0E0E);

/// PRIMARY ACCENT
const Color kGreen = Color(0xFF1DB954);

/// TEXT
const Color kMuted = Color(0xFFA7A7A7);

/// STATUS COLORS
const Color kGold = Color(0xFFFFC107);
const Color kSilver = Color(0xFFB0BEC5);
const Color kBronze = Color(0xFFCD7F32);

const Color kRed = Color(0xFFE53935);

/// DIVIDERS / BORDERS
const Color kBorder = Color(0x1FFFFFFF);
class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  int scopeIndex = 0;
  int sportIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            const _RankingsAppBar(),
            SliverToBoxAdapter(child: _UserRankCard()),
            SliverToBoxAdapter(
              child: _ScopeTabs(
                selected: scopeIndex,
                onChanged: (i) => setState(() => scopeIndex = i),
              ),
            ),
            SliverToBoxAdapter(
              child: _SportFilterRow(
                selected: sportIndex,
                onChanged: (i) => setState(() => sportIndex = i),
              ),
            ),
            const SliverToBoxAdapter(child: _SeasonPrizeCard()),
            const SliverToBoxAdapter(child: _QuickStatsRow()),
            const SliverToBoxAdapter(child: _GoldLeagueSection()),
            const SliverToBoxAdapter(child: _SilverLeagueSection()),
            const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
          ],
        ),
      ),
    );
  }
}


class _RankingsAppBar extends StatelessWidget {
  const _RankingsAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Rankings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                _HeaderIcon(Icons.share),
                const SizedBox(width: 10),
                _HeaderIcon(Icons.info_outline),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Season 12 · 14 days left',
                style: TextStyle(
                  color: kGreen,
                  fontSize: 12,
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


class _UserRankCard extends StatelessWidget {
  const _UserRankCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/32.jpg',
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      _LeaguePill('SILVER'),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('#42',
                        style: TextStyle(
                            color: kGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    Text('Global Rank',
                        style: TextStyle(color: kMuted, fontSize: 12)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 14),
            _ProgressBar(
              current: 1240,
              target: 1500,
              label: 'Target: Gold (1,500)',
            ),
            const SizedBox(height: 10),
            const _TrendRow(),
          ],
        ),
      ),
    );
  }
}


class _ScopeTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _ScopeTabs({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Friends', 'Local', 'Global', 'Groups'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
                decoration: BoxDecoration(
                  color: active ? kSurface : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? Colors.white : kMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}


class _SportFilterRow extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _SportFilterRow({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sports = ['All Sports', 'Cricket', 'Football', 'Badminton', 'Tennis'];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = selected == i;
          return ChoiceChip(
            selected: active,
            label: Text(sports[i]),
            selectedColor: kGreen.withOpacity(0.2),
            backgroundColor: kSurface,
            labelStyle: TextStyle(
              color: active ? kGreen : Colors.white,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onChanged(i),
          );
        },
      ),
    );
  }
}


class _GoldLeagueSection extends StatelessWidget {
  const _GoldLeagueSection();

  @override
  Widget build(BuildContext context) {
    return _LeagueSection(
      title: 'GOLD LEAGUE',
      icon: Icons.emoji_events,
      info: 'Top 10 players promote to Platinum League next week.',
      rows: const [
        _RankRow(rank: 1, name: 'Rohan K.', pts: 2100, up: true),
        _RankRow(rank: 2, name: 'Priya S.', pts: 1950),
        _RankRow(rank: 3, name: 'Amit V.', pts: 1820, down: true),
      ],
    );
  }
}


class _SilverLeagueSection extends StatelessWidget {
  const _SilverLeagueSection();

  @override
  Widget build(BuildContext context) {
    return _LeagueSection(
      title: 'SILVER LEAGUE',
      icon: Icons.shield,
      rows: const [
        _RankRow(rank: 41, name: 'Vikram S.', pts: 1255),
        _RankRow(
          rank: 42,
          name: 'You',
          pts: 1240,
          highlight: true,
          up: true,
        ),
        _RankRow(rank: 43, name: 'Neha M.', pts: 1230, down: true),
      ],
    );
  }
}


class _RankRow extends StatelessWidget {
  final int rank;
  final String name;
  final int pts;
  final bool up;
  final bool down;
  final bool highlight;

  const _RankRow({
    required this.rank,
    required this.name,
    required this.pts,
    this.up = false,
    this.down = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? kGreen.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text('$rank',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          Text('$pts',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          if (up)
            const Icon(Icons.arrow_upward, size: 16, color: kGreen),
          if (down)
            const Icon(Icons.arrow_downward, size: 16, color: kRed),
        ],
      ),
    );
  }
}


class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kSurface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}


// class _HeaderIcon extends StatelessWidget {
//   final IconData icon;
//   const _HeaderIcon(this.icon);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(999),
//         onTap: () {},
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: kSurface,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: Colors.white, size: 18),
//         ),
//       ),
//     );
//   }
// }


class _TrendRow extends StatelessWidget {
  const _TrendRow();

  @override
  Widget build(BuildContext context) {
    final trends = [true, true, false, true, false]; // mock

    return Row(
      children: [
        const Text(
          'Top 15% (Rising)',
          style: TextStyle(
            color: kGreen,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Row(
          children: trends.map((up) {
            return Container(
              margin: const EdgeInsets.only(left: 6),
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                color: up ? kGreen : kMuted.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


class _LeaguePill extends StatelessWidget {
  final String label;
  const _LeaguePill(this.label);

  Color get color {
    switch (label) {
      case 'GOLD':
        return kGold;
      case 'SILVER':
        return kSilver;
      case 'BRONZE':
        return kBronze;
      default:
        return kMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}


class _LeagueSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? info;
  final List<Widget> rows;

  const _LeagueSection({
    required this.title,
    required this.icon,
    this.info,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Icon(icon, color: kGold, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              if (info != null)
                Text(
                  'View Rules',
                  style: TextStyle(
                    color: kMuted,
                    fontSize: 12,
                  ),
                ),
            ],
          ),

          if (info != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                info!,
                style: const TextStyle(color: kMuted, fontSize: 12),
              ),
            ),
          ],

          const SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }
}


class _SeasonPrizeCard extends StatelessWidget {
  const _SeasonPrizeCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.card_giftcard, color: kGold),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Season 12 Prize Pool: ₹1 Lakh',
                    style: TextStyle(
                        color: kGold, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Top 10 players win cash & exclusive merch',
                    style: TextStyle(color: kMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: kMuted),
          ],
        ),
      ),
    );
  }
}


class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: const [
          _StatTile('24', 'Matches', Icons.sports),
          SizedBox(width: 10),
          _StatTile('68%', 'Win Rate', Icons.percent),
          SizedBox(width: 10),
          _StatTile('3', 'Streak', Icons.local_fire_department),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatTile(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: kGreen, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(color: kMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
class _ProgressBar extends StatelessWidget {
  final int current;
  final int target;
  final String label;

  const _ProgressBar({
    required this.current,
    required this.target,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$current pts',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(label,
                style: const TextStyle(color: kMuted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: const AlwaysStoppedAnimation(kGreen),
          ),
        ),
      ],
    );
  }
}
