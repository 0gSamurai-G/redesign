import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFF9E9E9E);
const kRed = Color(0xFFE53935);
const kAmber = Color(0xFFFFC107);
const Color kGold = Color(0xFFFFD54F);
enum TieBreaker {
  superOver,
  bowlOut,
  boundaryCount,
  suddenDeath,
}
enum LeagueMatchFormat { t20, t10 }
enum RankingRule { points, nrr, headToHead }

enum MatchType { friendly, league, knockout, tournament }

class CricketMatchSetupScreen extends StatefulWidget {
  const CricketMatchSetupScreen({super.key});

  @override
  State<CricketMatchSetupScreen> createState() =>
      _CricketMatchSetupScreenState();
}

class _CricketMatchSetupScreenState extends State<CricketMatchSetupScreen> {
  final ScrollController _scrollController = ScrollController();

  MatchType? _matchType;

  /// Example shared state (would expand per mode)
  int overs = 10;
  int innings = 1;
  int teamCount = 2;

  /* ───────────────── RESET ───────────────── */

  void _reset() {
    setState(() {
      _matchType = null;
      overs = 10;
      innings = 1;
      teamCount = 2;
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /* ───────────────── SELECT ───────────────── */

  void _selectMatchType(MatchType type) {
    if (_matchType == type) return;

    setState(() {
      _matchType = type;

      /// Clear incompatible state
      switch (type) {
        case MatchType.friendly:
          teamCount = 2;
          innings = 1;
          break;
        case MatchType.league:
          teamCount = 4;
          innings = 1;
          break;
        case MatchType.knockout:
          teamCount = 4;
          innings = 1;
          break;
        case MatchType.tournament:
          teamCount = 8;
          innings = 1;
          break;
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  /* ───────────────── UI ───────────────── */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _AppBar(onReset: _reset),
            _MatchTypeGrid(
              selected: _matchType,
              onSelect: _selectMatchType,
            ),

            /// DYNAMIC SECTION
            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                child: _buildDynamicSection(),
              ),
            ),

            /// LIVE SUMMARY (ALWAYS VISIBLE)
            SliverToBoxAdapter(
              child: _LiveSummary(
                matchType: _matchType,
                teamCount: teamCount,
                overs: overs,
                innings: innings,
              ),
            ),

            /// CTA
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _matchType == null ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    _ctaText(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  /* ───────────────── CTA TEXT ───────────────── */

  String _ctaText() {
    switch (_matchType) {
      case MatchType.friendly:
        return 'Create Friendly Match';
      case MatchType.league:
        return 'Create League';
      case MatchType.knockout:
        return 'Generate Bracket';
      case MatchType.tournament:
        return 'Create Tournament';
      default:
        return 'Select Match Type';
    }
  }

  /* ───────────────── DYNAMIC SECTIONS ───────────────── */

  Widget _buildDynamicSection() {
    switch (_matchType) {
      case MatchType.friendly:
        return FriendlyMatchSection(onCreate: () {  },
          // overs: overs,
          // innings: innings,
          // onOversChanged: (v) => setState(() => overs = v),
          // onInningsChanged: (v) => setState(() => innings = v),
        );
      case MatchType.league:
        return LeagueSetupSection(onCreateLeague: (LeagueBlueprint value) {  },);
      case MatchType.knockout:
        return KnockoutSetupSection(onCreate: () {  },);
      case MatchType.tournament:
        return _TournamentSection(teamCount: teamCount);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _AppBar extends StatelessWidget {
  final VoidCallback onReset;

  const _AppBar({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: kBg,
      elevation: 0,
      leading: const BackButton(),
      title: const Text(
        'Cricket Match Setup',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      actions: [
        TextButton(
          onPressed: onReset,
          child: const Text('Reset'),
        ),
      ],
    );
  }
}


class _MatchTypeGrid extends StatelessWidget {
  final MatchType? selected;
  final ValueChanged<MatchType> onSelect;

  const _MatchTypeGrid({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        delegate: SliverChildListDelegate([
          _MatchTypeCard(
            icon: Icons.group,
            label: 'Friendly',
            selected: selected == MatchType.friendly,
            onTap: () => onSelect(MatchType.friendly),
          ),
          _MatchTypeCard(
            icon: Icons.emoji_events,
            label: 'League',
            selected: selected == MatchType.league,
            onTap: () => onSelect(MatchType.league),
          ),
          _MatchTypeCard(
            icon: Icons.close,
            label: 'Knockout',
            selected: selected == MatchType.knockout,
            onTap: () => onSelect(MatchType.knockout),
          ),
          _MatchTypeCard(
            icon: Symbols.crown,
            label: 'Tournament',
            selected: selected == MatchType.tournament,
            onTap: () => onSelect(MatchType.tournament),
          ),
        ]),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
      ),
    );
  }
}

class _MatchTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MatchTypeCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kSurface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? kGreen : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 28, color: selected ? kGreen : kMuted),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? kGreen : kMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FriendlyMatchSection extends StatefulWidget {
  final VoidCallback onCreate;

  const FriendlyMatchSection({super.key, required this.onCreate});

  @override
  State<FriendlyMatchSection> createState() => _FriendlyMatchSectionState();
}

class _FriendlyMatchSectionState extends State<FriendlyMatchSection> {
  /* ───────── STATE ───────── */

  final List<String> teamA = ['Rahul K.', 'Amit S.'];
  final List<String> teamB = ['Vikram R.', 'Sameer'];

  int innings = 1;
  int overs = 10;

  bool wideBall = true;
  bool noBall = true;
  bool powerplay = false;
  bool legByes = true;

  /* ───────── HELPERS ───────── */

  int get estMinutes {
    final base = overs * 6;
    return innings == 2 ? base * 2 : base;
  }

  bool get teamsValid =>
      teamA.length >= 5 &&
      teamB.length >= 5 &&
      (teamA.length - teamB.length).abs() <= 2;

  Color get teamStatusColor {
    if (teamA.length < 5 || teamB.length < 5) return kRed;
    if ((teamA.length - teamB.length).abs() > 2) return kAmber;
    return kGreen;
  }

  /* ───────── UI ───────── */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _friendlyInfo(),
          const SizedBox(height: 16),
          _teamsSection(),
          const SizedBox(height: 16),
          _formatSection(),
          const SizedBox(height: 16),
          _rulesSection(),
          const SizedBox(height: 16),
          _summaryCard(),
          const SizedBox(height: 24),
          _ctaButton(),
        ],
      ),
    );
  }

  /* ───────── SECTIONS ───────── */

  Widget _friendlyInfo() {
    return _card(
      child: Row(
        children: const [
          CircleAvatar(
            radius: 18,
            backgroundColor: kGreen,
            child: Icon(Icons.sentiment_satisfied,
                color: Colors.black),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Friendly Match',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text(
                  'Casual rules. Stats tracked but rankings unaffected.',
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TEAMS',
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _teamCard('Red Strikers', Colors.red, teamA),
        const SizedBox(height: 12),
        _teamCard('Blue Thunders', Colors.blue, teamB),
      ],
    );
  }

  Widget _teamCard(String name, Color color, List<String> players) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 6, backgroundColor: color),
              const SizedBox(width: 8),
              Text(name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...players.take(2).map(
                    (p) => _playerChip(p, () {
                      setState(() => players.remove(p));
                    }),
                  ),
              if (players.length > 2)
                Chip(
                  label: Text('+${players.length - 2} Others'),
                  backgroundColor: Colors.white10,
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              setState(() => players.add('Guest'));
            },
            icon: const Icon(Icons.add, color: kGreen),
            label: const Text('Add Players',
                style: TextStyle(color: kGreen)),
          ),
        ],
      ),
    );
  }

  Widget _formatSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Match Format',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              _segButton('1 Inning', innings == 1, () {
                setState(() => innings = 1);
              }),
              const SizedBox(width: 8),
              _segButton('2 Innings', innings == 2, () {
                setState(() => innings = 2);
              }),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [2, 5, 10, 20]
                .map(
                  (o) => ChoiceChip(
                    label: Text('$o'),
                    selected: overs == o,
                    onSelected: (_) => setState(() => overs = o),
                    selectedColor: kGreen,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          _durationInfo(),
        ],
      ),
    );
  }

  Widget _rulesSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rules & Variations',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          _ruleToggle(
              'Wide Ball', '1 Run + Extra Ball', wideBall,
              (v) => setState(() => wideBall = v)),
          _ruleToggle(
              'No Ball', '1 Run + Free Hit', noBall,
              (v) => setState(() => noBall = v)),
          _ruleToggle(
            'Powerplay',
            'Overs 1–3',
            powerplay && overs >= 5,
            overs < 5
                ? null
                : (v) => setState(() => powerplay = v),
          ),
          _ruleToggle(
              'Leg Byes / Byes',
              'Runs counted as extras',
              legByes,
              (v) => setState(() => legByes = v)),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Match Summary',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _summaryRow('Format', '$overs Overs / $innings Inn'),
          _summaryRow(
            'Players',
            '${teamA.length} vs ${teamB.length}${teamsValid ? '' : ' (Invalid)'}',
            color: teamStatusColor,
          ),
          _summaryRow('Tie Breaker', 'Super Over'),
          _summaryRow('Est. Time', '~$estMinutes mins'),
        ],
      ),
    );
  }

  Widget _ctaButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: teamsValid ? widget.onCreate : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        child: const Text(
          'Create Friendly Scoreboard →',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  /* ───────── SMALL UI HELPERS ───────── */

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: child,
    );
  }

  Widget _playerChip(String name, VoidCallback onRemove) {
    return Chip(
      avatar: const CircleAvatar(child: Icon(Icons.person, size: 14)),
      label: Text(name),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
    );
  }

  Widget _segButton(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white10 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: selected ? kGreen : Colors.white12),
          ),
          alignment: Alignment.center,
          child: Text(text,
              style: TextStyle(
                  color: selected ? kGreen : Colors.white)),
        ),
      ),
    );
  }

  Widget _ruleToggle(String title, String subtitle, bool value,
      ValueChanged<bool>? onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(subtitle, style: const TextStyle(color: kMuted)),
      activeColor: kGreen,
    );
  }

  Widget _summaryRow(String k, String v, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(k, style: const TextStyle(color: kMuted))),
          Text(v,
              style: TextStyle(
                  color: color ?? Colors.white,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _durationInfo() {
    final warn = estMinutes > 90;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: warn ? kAmber : kGreen),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time,
              color: warn ? kAmber : kGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Estimated duration: ~$estMinutes mins\nEnsure your turf booking slot is long enough.',
              style: TextStyle(
                  color: warn ? kAmber : kGreen, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}


class LeagueSetupSection extends StatefulWidget {
  final ValueChanged<LeagueBlueprint> onCreateLeague;

  const LeagueSetupSection({super.key, required this.onCreateLeague});

  @override
  State<LeagueSetupSection> createState() => _LeagueSetupSectionState();
}

class _LeagueSetupSectionState extends State<LeagueSetupSection> {
  /* ───────── CORE STATE ───────── */

  int totalTeams = 8;
  static const int minTeams = 4;

  bool doubleRoundRobin = true;
  bool transferWindow = false;
  int overseasLimit = 4;

  LeagueMatchFormat format = LeagueMatchFormat.t20;
  bool powerplay = true;
  bool strategicTimeout = false;

  bool iplPlayoffs = true;

  List<RankingRule> rankingPriority = [
    RankingRule.points,
    RankingRule.nrr,
    RankingRule.headToHead,
  ];

  /* ───────── DERIVED ───────── */

  int get totalMatches {
    final base = (totalTeams * (totalTeams - 1)) ~/ 2;
    return doubleRoundRobin ? base * 2 : base;
  }

  bool get valid => totalTeams >= minTeams;

  LeagueBlueprint get blueprint => LeagueBlueprint(
        teams: totalTeams,
        doubleRoundRobin: doubleRoundRobin,
        overseasLimit: overseasLimit,
        format: format,
        powerplay: powerplay,
        strategicTimeout: strategicTimeout,
        rankingPriority: rankingPriority,
        playoffsEnabled: iplPlayoffs,
        totalMatches: totalMatches,
      );

  /* ───────── UI ───────── */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 16),
          _teamsSection(),
          const SizedBox(height: 16),
          _formatSection(),
          const SizedBox(height: 16),
          _rulesSection(),
          const SizedBox(height: 16),
          _pointsSection(),
          const SizedBox(height: 16),
          _playoffsSection(),
          const SizedBox(height: 16),
          _summary(),
          const SizedBox(height: 24),
          _cta(),
        ],
      ),
    );
  }

  /* ───────── SECTIONS ───────── */

  Widget _header() {
    return _card(
      child: Row(
        children: const [
          CircleAvatar(
            backgroundColor: Color(0x33FFD54F),
            child: Icon(Icons.emoji_events, color: kGold),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premier League Setup',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  'Configure teams, format, points, and rules for a full professional season.',
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamsSection() {
    return _section(
      title: '1. Teams & Squads',
      badge: 'Min: $minTeams',
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Total Teams',
                    style: TextStyle(color: Colors.white)),
              ),
              _stepper(
                value: totalTeams,
                min: minTeams,
                max: 12,
                onChanged: (v) => setState(() => totalTeams = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(
            totalTeams.clamp(0, 4),
            (i) => _teamRow('Team ${i + 1}'),
          ),
          if (totalTeams > 4)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Configure remaining ${totalTeams - 4} teams',
                style: const TextStyle(color: kMuted),
              ),
            ),
        ],
      ),
    );
  }

  Widget _teamRow(
  String teamName, {
  Color color = kMuted,
  int players = 0,
  int squadSize = 15,
  VoidCallback? onConfigure,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.white12),
      ),
    ),
    child: Row(
      children: [
        /// Shield icon
        const Icon(
          Icons.shield_outlined,
          color: kMuted,
          size: 22,
        ),

        const SizedBox(width: 10),

        /// Team color dot
        CircleAvatar(
          radius: 5,
          backgroundColor: color,
        ),

        const SizedBox(width: 10),

        /// Team name
        Expanded(
          child: Text(
            teamName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        /// Squad count
        Text(
          '$players / $squadSize Players',
          style: const TextStyle(
            color: kMuted,
            fontSize: 12,
          ),
        ),

        const SizedBox(width: 8),

        /// Configure icon
        IconButton(
          icon: const Icon(
            Icons.tune,
            color: kMuted,
            size: 18,
          ),
          onPressed: onConfigure,
        ),
      ],
    ),
  );
}


  Widget _formatSection() {
    return _section(
      title: '2. Format & Schedule',
      child: Column(
        children: [
          _toggle(
            'Double Round Robin',
            'Home & Away matches against every team',
            doubleRoundRobin,
            (v) => setState(() => doubleRoundRobin = v),
          ),
          _toggle(
            'Mid-Season Transfer Window',
            'Allow squad changes between Match 7 & 8',
            transferWindow,
            (v) => setState(() => transferWindow = v),
          ),
          Row(
            children: [
              const Expanded(
                child: Text('Overseas Player Limit',
                    style: TextStyle(color: Colors.white)),
              ),
              _stepper(
                value: overseasLimit,
                min: 0,
                max: 6,
                onChanged: (v) => setState(() => overseasLimit = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rulesSection() {
    return _section(
      title: '3. Match Rules',
      child: Column(
        children: [
          Row(
            children: [
              _choice('20 Overs', 'T20 Standard',
                  format == LeagueMatchFormat.t20, () {
                setState(() => format = LeagueMatchFormat.t20);
              }),
              const SizedBox(width: 8),
              _choice('10 Overs', 'T10 Express',
                  format == LeagueMatchFormat.t10, () {
                setState(() => format = LeagueMatchFormat.t10);
              }),
            ],
          ),
          _toggle(
            'Powerplay & Fielding',
            'Standard restrictions apply',
            powerplay,
            (v) => setState(() => powerplay = v),
          ),
          _toggle(
            'Strategic Timeout',
            '2.5 min break per innings',
            strategicTimeout,
            (v) => setState(() => strategicTimeout = v),
          ),
        ],
      ),
    );
  }

  Widget _pointsSection() {
    return _section(
      title: '4. Standings & Points',
      child: ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onReorder: (o, n) {
          setState(() {
            if (n > o) n--;
            final r = rankingPriority.removeAt(o);
            rankingPriority.insert(n, r);
          });
        },
        children: rankingPriority
            .map(
              (r) => ListTile(
                key: ValueKey(r),
                title: Text(
                  r.name.replaceAll('headToHead', 'Head-to-Head'),
                  style: const TextStyle(color: Colors.white),
                ),
                trailing:
                    const Icon(Icons.drag_handle, color: kMuted),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _playoffsSection() {
    return _section(
      title: '5. Playoffs Structure',
      child: _toggle(
        'IPL Style Qualification',
        'Top 4 qualify. Qualifier 1, Eliminator, Qualifier 2, Final.',
        iplPlayoffs,
        totalTeams < 4 ? null : (v) => setState(() => iplPlayoffs = v),
      ),
    );
  }

  Widget _summary() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Season Summary',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _row('Total Teams', '$totalTeams'),
          _row('Matches', '$totalMatches'),
          _row(
            'Format',
            format == LeagueMatchFormat.t20 ? '20 Overs' : '10 Overs',
          ),
          _row('Qualification', iplPlayoffs ? 'Top 4' : 'None'),
        ],
      ),
    );
  }

  Widget _cta() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: valid
            ? () => widget.onCreateLeague(blueprint)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22)),
        ),
        child: const Text(
          'Create League & Generate Fixtures →',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  /* ───────── UI HELPERS ───────── */

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      );

  Widget _section(
      {required String title,
      String? badge,
      required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(badge,
                    style:
                        const TextStyle(color: kGreen, fontSize: 12)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        _card(child: child),
      ],
    );
  }

  Widget _stepper(
      {required int value,
      int min = 0,
      int max = 20,
      required ValueChanged<int> onChanged}) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove, color: Colors.white),
          onPressed:
              value > min ? () => onChanged(value - 1) : null,
        ),
        Text('$value',
            style: const TextStyle(color: Colors.white)),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed:
              value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }

  Widget _toggle(String title, String subtitle, bool value,
      ValueChanged<bool>? onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: kGreen,
      title:
          Text(title, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(subtitle, style: const TextStyle(color: kMuted)),
    );
  }

  Widget _choice(String title, String subtitle, bool selected,
      VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: selected ? kGreen : Colors.white12),
          ),
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(
                      color:
                          selected ? kGreen : Colors.white)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style:
                      const TextStyle(color: kMuted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child:
                  Text(k, style: const TextStyle(color: kMuted))),
          Text(v,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/* ───────── BLUEPRINT MODEL ───────── */

class LeagueBlueprint {
  final int teams;
  final bool doubleRoundRobin;
  final int overseasLimit;
  final LeagueMatchFormat format;
  final bool powerplay;
  final bool strategicTimeout;
  final List<RankingRule> rankingPriority;
  final bool playoffsEnabled;
  final int totalMatches;

  const LeagueBlueprint({
    required this.teams,
    required this.doubleRoundRobin,
    required this.overseasLimit,
    required this.format,
    required this.powerplay,
    required this.strategicTimeout,
    required this.rankingPriority,
    required this.playoffsEnabled,
    required this.totalMatches,
  });
}

class KnockoutSetupSection extends StatefulWidget {
  final VoidCallback onCreate;

  const KnockoutSetupSection({super.key, required this.onCreate});

  @override
  State<KnockoutSetupSection> createState() => _KnockoutSetupSectionState();
}

class _KnockoutSetupSectionState extends State<KnockoutSetupSection> {
  int totalTeams = 8;
  static const int minTeams = 2;

  bool randomSeeding = true;

  int overs = 10;
  bool powerplay = true;

  bool wideBall = true;
  bool noBall = true;
  bool extras = true;

  bool lbw = false;
  bool mankading = false;

  bool strictMode = true;
  bool manualUmpire = false;

  TieBreaker? tieBreaker;

  /* ───────── DERIVED ───────── */

  int get totalMatches => totalTeams - 1;

  bool get valid =>
      totalTeams >= minTeams &&
      tieBreaker != null;

  int get estDurationMinutes => totalMatches * overs * 6;

  /* ───────── UI ───────── */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 16),
          _structure(),
          const SizedBox(height: 16),
          _teams(),
          const SizedBox(height: 16),
          _matchFormat(),
          const SizedBox(height: 16),
          _scoringRules(),
          const SizedBox(height: 16),
          _dismissalRules(),
          const SizedBox(height: 16),
          _tieBreaker(),
          const SizedBox(height: 16),
          _advanced(),
          const SizedBox(height: 16),
          _summary(),
          const SizedBox(height: 24),
          _cta(),
        ],
      ),
    );
  }

  /* ───────── SECTIONS ───────── */

  Widget _header() {
    return _card(
      gradient: const LinearGradient(
        colors: [Color(0x33E53935), Color(0x11FFD54F)],
      ),
      child: Row(
        children: const [
          CircleAvatar(
            backgroundColor: Color(0x33E53935),
            child: Icon(Icons.emoji_events, color: kRed),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Knockout Tournament',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  'Single elimination. Lose once and you’re out. Winners advance automatically.',
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Chip(
            label: Text('HIGH STAKES MODE',
                style: TextStyle(color: kRed, fontSize: 11)),
            backgroundColor: Color(0x22E53935),
          ),
        ],
      ),
    );
  }

  Widget _structure() {
    return _section(
      title: '1. Structure',
      badge: 'Min $minTeams teams',
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Total Teams',
                    style: TextStyle(color: Colors.white)),
              ),
              _stepper(
                value: totalTeams,
                min: minTeams,
                max: 16,
                onChanged: (v) => setState(() => totalTeams = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bracketPreview(),
          const SizedBox(height: 12),
          SwitchListTile(
            value: randomSeeding,
            onChanged: (v) => setState(() => randomSeeding = v),
            title: const Text('Random Seeding',
                style: TextStyle(color: Colors.white)),
            activeColor: kGreen,
          ),
        ],
      ),
    );
  }

Widget _teams() {
  final visibleTeams = totalTeams.clamp(0, 2);

  return _section(
    title: '2. Participating Teams',
    badge: 'Auto-fill',
    child: Column(
      children: [
        for (int i = 0; i < visibleTeams; i++)
          _teamRow('Team ${i + 1}'),

        if (totalTeams > visibleTeams)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Configure remaining ${totalTeams - visibleTeams} teams',
              style: const TextStyle(color: kMuted),
            ),
          ),
      ],
    ),
  );
}


  Widget _matchFormat() {
    return _section(
      title: '3. Match Format',
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            children: [5, 10, 20]
                .map(
                  (o) => ChoiceChip(
                    label: Text('$o'),
                    selected: overs == o,
                    selectedColor: kGreen,
                    onSelected: (_) => setState(() => overs = o),
                  ),
                )
                .toList(),
          ),
          SwitchListTile(
            value: powerplay && overs >= 5,
            onChanged:
                overs < 5 ? null : (v) => setState(() => powerplay = v),
            title: const Text('Powerplay',
                style: TextStyle(color: Colors.white)),
            subtitle:
                const Text('Fielding restrictions active',
                    style: TextStyle(color: kMuted)),
            activeColor: kGreen,
          ),
        ],
      ),
    );
  }

  Widget _scoringRules() {
    return _section(
      title: '4. Scoring Rules',
      child: Column(
        children: [
          _toggle('Wide Ball', '1 Run + Extra Ball', wideBall,
              (v) => setState(() => wideBall = v)),
          _toggle('No Ball', '1 Run + Free Hit', noBall,
              (v) => setState(() => noBall = v)),
          _toggle('Extras', 'Allow Byes & Leg Byes', extras,
              (v) => setState(() => extras = v)),
        ],
      ),
    );
  }

  Widget _dismissalRules() {
    return _section(
      title: '5. Dismissal Rules',
      child: Column(
        children: [
          _toggle('LBW', 'Leg Before Wicket', lbw,
              (v) => setState(() => lbw = v)),
          _toggle(
            'Mankading',
            'Run out non-striker',
            mankading,
            (v) => setState(() => mankading = v),
            danger: true,
          ),
        ],
      ),
    );
  }

  Widget _tieBreaker() {
    return _section(
      title: '6. Tie Breaker Logic',
      badge: 'Mandatory',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'In a knockout format, a match cannot end in a tie.',
            style: TextStyle(color: kMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TieBreaker.values
                .map(
                  (t) => ChoiceChip(
                    label: Text(_tieLabel(t)),
                    selected: tieBreaker == t,
                    selectedColor: kRed,
                    onSelected: (_) => setState(() => tieBreaker = t),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _advanced() {
    return _section(
      title: '7. Advanced Settings',
      child: Column(
        children: [
          _toggle('Strict Mode',
              'Lock squads & rules once started',
              strictMode,
              (v) => setState(() => strictMode = v)),
          _toggle('Manual Umpire',
              'Require approval for wickets',
              manualUmpire,
              (v) => setState(() => manualUmpire = v)),
        ],
      ),
    );
  }

  Widget _summary() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tournament Summary',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _row('Teams', '$totalTeams'),
          _row('Total Matches', '$totalMatches'),
          _row('Est. Duration', '~${(estDurationMinutes / 60).ceil()} hrs'),
          _row('Tie Breaker', _tieLabel(tieBreaker)),
        ],
      ),
    );
  }

  Widget _cta() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: valid ? widget.onCreate : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        child: const Text(
          'Create Knockout Tournament →',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  /* ───────── SMALL HELPERS ───────── */

  Widget _card({required Widget child, Gradient? gradient}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: child,
    );
  }

  Widget _section(
      {required String title, String? badge, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Text(badge,
                  style: const TextStyle(color: kGreen, fontSize: 12)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        _card(child: child),
      ],
    );
  }

  Widget _toggle(String t, String s, bool v,
      ValueChanged<bool>? onChanged,
      {bool danger = false}) {
    return SwitchListTile(
      value: v,
      onChanged: onChanged,
      activeColor: danger ? kRed : kGreen,
      title:
          Text(t, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(s, style: TextStyle(color: danger ? kRed : kMuted)),
    );
  }

  Widget _stepper(
      {required int value,
      required int min,
      required int max,
      required ValueChanged<int> onChanged}) {
    return Row(
      children: [
        IconButton(
            onPressed: value > min
                ? () => onChanged(value - 1)
                : null,
            icon: const Icon(Icons.remove)),
        Text('$value', style: const TextStyle(color: Colors.white)),
        IconButton(
            onPressed: value < max
                ? () => onChanged(value + 1)
                : null,
            icon: const Icon(Icons.add)),
      ],
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(k, style: const TextStyle(color: kMuted))),
          Text(v,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _bracketPreview() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.account_tree,
          color: kMuted, size: 48),
    );
  }

  String _tieLabel(TieBreaker? t) {
    switch (t) {
      case TieBreaker.superOver:
        return 'Super Over';
      case TieBreaker.bowlOut:
        return 'Bowl Out';
      case TieBreaker.boundaryCount:
        return 'Boundary Count';
      case TieBreaker.suddenDeath:
        return 'Sudden Death';
      default:
        return 'Select';
    }
  }
}


class _TournamentSection extends StatelessWidget {
  final int teamCount;
  const _TournamentSection({required this.teamCount});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Tournament Setup',
      child: Text(
        '$teamCount teams • Groups + Playoffs',
        style: const TextStyle(color: kMuted),
      ),
    );
  }
}


class _LiveSummary extends StatelessWidget {
  final MatchType? matchType;
  final int teamCount;
  final int overs;
  final int innings;

  const _LiveSummary({
    required this.matchType,
    required this.teamCount,
    required this.overs,
    required this.innings,
  });

  @override
  Widget build(BuildContext context) {
    if (matchType == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Match Summary',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Type: ${matchType!.name}'),
            Text('Teams: $teamCount'),
            Text('Overs: $overs • Innings: $innings'),
          ],
        ),
      ),
    );
  }
}


class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _StepperRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        Text('$value'),
        IconButton(
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}


Widget _teamRow(
  String teamName, {
  Color color = kMuted,
  int players = 0,
  int squadSize = 11,
  String? status,
  VoidCallback? onTap,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.white12),
      ),
    ),
    child: Row(
      children: [
        /// Shield icon
        const Icon(
          Icons.shield_outlined,
          color: kMuted,
          size: 22,
        ),

        const SizedBox(width: 10),

        /// Team color dot
        CircleAvatar(
          radius: 5,
          backgroundColor: color,
        ),

        const SizedBox(width: 10),

        /// Team name + status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teamName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (status != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: kRed,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
        ),

        /// Squad count
        Text(
          '$players / $squadSize',
          style: const TextStyle(
            color: kMuted,
            fontSize: 12,
          ),
        ),

        const SizedBox(width: 8),

        /// Configure chevron
        IconButton(
          icon: const Icon(
            Icons.chevron_right,
            color: kMuted,
            size: 20,
          ),
          onPressed: onTap,
        ),
      ],
    ),
  );
}
