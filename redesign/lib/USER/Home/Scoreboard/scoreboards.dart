import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redesign/USER/Home/Scoreboard/select_sports.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);

const kGreen = Color(0xFF1DB954);
const kRed = Color(0xFFE53935);
const kGold = Color(0xFFFFC107);
const kPurple = Color(0xFF7C4DFF);
const kMuted = Color(0xFFA7A7A7);


class ScoreboardHubScreen extends StatefulWidget {
  const ScoreboardHubScreen({super.key});

  @override
  State<ScoreboardHubScreen> createState() => _ScoreboardHubScreenState();
}

class _ScoreboardHubScreenState extends State<ScoreboardHubScreen> {
  /// Example state hooks (ready for APIs / streams)
  bool isLoading = false;
  bool hasLiveMatches = true;

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

            /// QUICK ACTIONS
            SliverToBoxAdapter(
              child: QuickActions(),
            ),

            /// CREATE SCOREBOARD
            SliverToBoxAdapter(
              child: _CreateScoreboardHero(),
            ),

            /// LIVE SCOREBOARDS
            const _SectionHeader(
              title: 'Live Scoreboards',
              action: 'View All',
              liveDot: true,
            ),

            SliverToBoxAdapter(
              child: hasLiveMatches
                  ? const LiveScoreboardCard()
                  : _EmptyLiveState(
                      onCreate: _onCreateMatch,
                    ),
            ),

            /// LIVE TOURNAMENT WATCH
            SliverToBoxAdapter(
              child: LiveTournamentWatch(),
            ),

            /// CLAN BATTLES
            const _SectionHeader(title: 'Clan Battles'),
            SliverToBoxAdapter(
              child: _ClanBattleCard(),
            ),

            /// TOURNAMENTS
            const _SectionHeader(title: 'Tournaments'),
            const SliverToBoxAdapter(
              child: _TournamentCard(
                name: 'Mumbai Premier League',
                sport: 'Cricket',
                teams: 12,
                stage: 'Semi-Finals',
                prize: '₹1,50,000',
                season: '4',
              ),
            ),

            /// HISTORY
            const _SectionHeader(title: 'History'),
            SliverToBoxAdapter(
              child: _HistoryList(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }

  /* ───────────── ACTIONS / STATE ───────────── */

  void _onCreateMatch() {
    // Navigate to match setup
  }

  void refreshLiveData() {
    setState(() {
      isLoading = true;
    });

    // Hook API / WebSocket refresh here
  }
}


class _EmptyLiveState extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyLiveState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text(
              'No live matches right now',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Start a match to see live action here',
              style: TextStyle(color: kMuted, fontSize: 12),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onCreate,
              child: const Text('Start New Match'),
            ),
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


class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  int liveMatches = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: QuickActionCard(
              icon: Icons.add_circle_outline,
              title: 'New Match',
              subtitle: 'Start Tracking',
              onTap: _onNewMatch,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: QuickActionCard(
              icon: Icons.podcasts,
              title: 'Live View',
              subtitle: '$liveMatches Happening',
              live: liveMatches > 0,
              onTap: _onLiveView,
            ),
          ),
        ],
      ),
    );
  }

  /* ───────── ACTIONS ───────── */

  void _onNewMatch() {
    // Hook into match setup flow
  }

  void _onLiveView() {
    // Navigate to live matches list
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SelectSportScreen()));
              },
              child: const Text('Create Now →'),
            ),
          ],
        ),
      ),
    );
  }
}


class LiveScoreboardCard extends StatelessWidget {
  const LiveScoreboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// HEADER
            Row(
              children: const [
                Text(
                  'FUTSAL • FRIENDLY MATCH',
                  style: TextStyle(
                    color: kMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Spacer(),
                _LiveBadge(),
              ],
            ),

            const SizedBox(height: 16),

            /// SCORE ROW
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: _TeamBlock(
                        code: 'RD',
                        percent: '58%',
                        name: 'Red Dragons',
                        alignStart: true,
                      ),
                    ),
                    _CenterScore(score: '4 - 2'),
                    Expanded(
                      child: _TeamBlock(
                        code: 'BH',
                        percent: '42%',
                        name: 'Blue Hawks',
                        alignStart: false,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

            /// MATCH CONTEXT
            const Center(
              child: Text(
                "38′  2nd Half",
                style: TextStyle(
                  color: kGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// POSSESSION
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'POSS.',
                  style: TextStyle(
                    color: kMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 58,
                        child: Container(height: 6, color: kGreen),
                      ),
                      Expanded(
                        flex: 42,
                        child: Container(height: 6, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// HIGHLIGHT
            Row(
              children: const [
                Icon(Icons.flash_on, size: 16, color: kGreen),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Goal! Rahul S. scored (37′)',
                    style: TextStyle(
                      color: kMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: kMuted, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamBlock extends StatelessWidget {
  final String code;
  final String percent;
  final String name;
  final bool alignStart;

  const _TeamBlock({
    required this.code,
    required this.percent,
    required this.name,
    required this.alignStart,
  });

  @override
  Widget build(BuildContext context) {
    final alignment =
        alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.end;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white.withOpacity(0.12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(code,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(
                percent,
                style: const TextStyle(
                  color: kMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignStart ? TextAlign.left : TextAlign.right,
        ),
      ],
    );
  }
}

class _CenterScore extends StatelessWidget {
  final String score;

  const _CenterScore({required this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        score,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w900,
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
        color: kRed.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.wifi_tethering, size: 12, color: kRed),
          SizedBox(width: 4),
          Text(
            'LIVE',
            style: TextStyle(
              color: kRed,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}


class LiveTournamentWatch extends StatefulWidget {
  const LiveTournamentWatch({super.key});

  @override
  State<LiveTournamentWatch> createState() => _LiveTournamentWatchState();
}

class _LiveTournamentWatchState extends State<LiveTournamentWatch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: InkWell(
            onTap: _onWatchLive,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            child: AspectRatio(
              /// 👈 THIS IS THE CRITICAL FIX
              /// Stadium cards are usually 16:9 or slightly taller
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  /// BACKGROUND IMAGE
                  Image.network(
                    'https://i.pinimg.com/736x/46/69/a8/4669a847112174fc10421987679b46ab.jpg',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(color: kSurface);
                    },
                    errorBuilder: (_, __, ___) =>
                        Container(color: kSurface),
                  ),

                  /// DARK GRADIENT OVERLAY
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),

                  /// CONTENT
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WatchLivePill(),

                        const Spacer(),

                        const Text(
                          'Pune City Championship',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          children: [
                            Icon(Icons.remove_red_eye,
                                size: 14, color: kMuted),
                            SizedBox(width: 6),
                            Text(
                              '1.2k watching',
                              style: TextStyle(
                                color: kMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '• Final Match',
                              style: TextStyle(
                                color: kMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
          ),
        ),
      ),
    );
  }

  void _onWatchLive() {
    // Navigate to spectator / stream
  }
}


class _WatchLivePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: kRed,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam, size: 16, color: Colors.white),
          SizedBox(width: 6),
          Text(
            'WATCH LIVE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
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


// class _LiveBadge extends StatelessWidget {
//   const _LiveBadge();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: kRed,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Text('LIVE',
//           style: TextStyle(color: Colors.white, fontSize: 11)),
//     );
//   }
// }

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


class QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool live;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.live = false,
    this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.live ? kRed : kGreen,
                  size: 22,
                ),
                const SizedBox(width: 12),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                /// LIVE BADGE (SPACE ALWAYS RESERVED)
                Visibility(
                  visible: widget.live,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: _LiveBadge(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ───────── LIVE BADGE ───────── */

// class _LiveBadge extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: kRed.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Text(
//         'LIVE',
//         style: TextStyle(
//           color: kRed,
//           fontSize: 10,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.6,
//         ),
//       ),
//     );
//   }
// }



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
