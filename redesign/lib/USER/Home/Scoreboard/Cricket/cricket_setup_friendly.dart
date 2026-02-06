import 'package:flutter/material.dart';
import 'package:redesign/USER/Home/Scoreboard/Cricket/cricket_scoreboard.dart';

/* ───────────────── THEME ───────────────── */

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFF9E9E9E);
const kAmber = Color(0xFFFFC107);
const kRed = Color(0xFFE53935);

/* ───────────────── ENUMS ───────────────── */

enum MatchMode { friendly, tournament }

enum TournamentType { knockout, league, hybrid }

// League-specific enums
enum RoundRobinType { single, double }

enum PlayoffFormat { top2Final, top4IPL, custom }

/* ───────────────── SCREEN ───────────────── */

class FriendlySetupScreen extends StatefulWidget {
  const FriendlySetupScreen({super.key});

  @override
  State<FriendlySetupScreen> createState() => _FriendlySetupScreenState();
}

class _FriendlySetupScreenState extends State<FriendlySetupScreen> {
  // ───────── Friendly State ─────────
  MatchMode mode = MatchMode.friendly;

  int maxPlayers = 11;
  int innings = 1;
  int overs = 10;

  final teamA = <String>['Rahul', 'Amit', 'Dev'];
  final teamB = <String>['Vikram', 'Sameer'];

  bool wideBall = true;
  bool noBall = true;
  bool proMode = false;

  bool get valid =>
      teamA.length >= 5 &&
      teamB.length >= 5 &&
      teamA.length <= maxPlayers &&
      teamB.length <= maxPlayers;

  // ───────── Tournament State ─────────
  TournamentType tournamentType = TournamentType.knockout;
  int totalTeams = 8;
  int playersPerTeam = 11;
  int matchesPerDay = 2;
  DateTime startDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);

  // Tournament teams storage
  late List<List<String>> tournamentTeams;

  // Bracket matchups (pairs of team indices for round 1)
  late List<List<int>> bracketMatchups;

  // ───────── League State ─────────
  RoundRobinType leagueFormat = RoundRobinType.single;
  int winPoints = 2;
  int tiePoints = 1;
  int lossPoints = 0;
  List<String> rankingPriority = [
    'Total Points',
    'Net Run Rate (NRR)',
    'Head-to-Head',
  ];
  bool playoffsEnabled = true;
  PlayoffFormat playoffFormat = PlayoffFormat.top4IPL;
  int customQualifyTeams = 4;
  bool allowWeekendDoubleHeaders = true;
  int leagueMatchesPerDay = 1;

  // League fixtures storage
  late List<Map<String, dynamic>> leagueFixtures;

  @override
  void initState() {
    super.initState();
    _initTournamentTeams();
    _initBracketMatchups();
    _initLeagueFixtures();
  }

  void _initTournamentTeams() {
    tournamentTeams = List.generate(
      totalTeams,
      (i) => <String>['Player 1', 'Player 2'],
    );
  }

  void _initBracketMatchups() {
    // Create initial matchups: [0,1], [2,3], [4,5], etc.
    bracketMatchups = [];
    for (int i = 0; i < totalTeams; i += 2) {
      if (i + 1 < totalTeams) {
        bracketMatchups.add([i, i + 1]);
      } else {
        bracketMatchups.add([i, -1]); // Bye
      }
    }
  }

  void _initLeagueFixtures() {
    leagueFixtures = _generateLeagueFixtures();
  }

  List<Map<String, dynamic>> _generateLeagueFixtures() {
    final fixtures = <Map<String, dynamic>>[];
    final multiplier = leagueFormat == RoundRobinType.double ? 2 : 1;

    // Round robin fixture generation
    for (int round = 0; round < multiplier; round++) {
      for (int i = 0; i < totalTeams; i++) {
        for (int j = i + 1; j < totalTeams; j++) {
          final isHomeAway = round == 1;
          fixtures.add({
            'matchNum': fixtures.length + 1,
            'team1': isHomeAway ? j : i,
            'team2': isHomeAway ? i : j,
            'isHome': !isHomeAway,
            'round': 'League',
          });
        }
      }
    }

    return fixtures;
  }

  void _shuffleLeagueFixtures() {
    leagueFixtures.shuffle();
    // Re-number matches
    for (int i = 0; i < leagueFixtures.length; i++) {
      leagueFixtures[i]['matchNum'] = i + 1;
    }
    setState(() {});
  }

  void _shuffleMatchups() {
    final teams = List.generate(totalTeams, (i) => i);
    teams.shuffle();
    bracketMatchups = [];
    for (int i = 0; i < teams.length; i += 2) {
      if (i + 1 < teams.length) {
        bracketMatchups.add([teams[i], teams[i + 1]]);
      } else {
        bracketMatchups.add([teams[i], -1]); // Bye
      }
    }
    setState(() {});
  }

  // Tournament computed values
  int get totalMatches => totalTeams - 1; // Knockout format
  int get estimatedDays => (totalMatches / matchesPerDay).ceil();
  int get estimatedHours => totalMatches * overs ~/ 3; // rough estimate
  String get startDateLabel =>
      '${startDate.day}/${startDate.month}/${startDate.year}';
  String get startTimeLabel => startTime.format(context);

  bool isPowerOfTwo(int n) => n > 0 && (n & (n - 1)) == 0;

  // League computed values
  int get leagueTotalMatches {
    final baseMatches = (totalTeams * (totalTeams - 1)) ~/ 2;
    return leagueFormat == RoundRobinType.double
        ? baseMatches * 2
        : baseMatches;
  }

  int get matchesPerTeam {
    return leagueFormat == RoundRobinType.double
        ? (totalTeams - 1) * 2
        : totalTeams - 1;
  }

  int get playoffMatches {
    if (!playoffsEnabled) return 0;
    switch (playoffFormat) {
      case PlayoffFormat.top2Final:
        return 1;
      case PlayoffFormat.top4IPL:
        return 4; // Q1, Eliminator, Q2, Final
      case PlayoffFormat.custom:
        return customQualifyTeams - 1;
    }
  }

  int get totalLeagueAndPlayoffMatches => leagueTotalMatches + playoffMatches;

  int get leagueEstimatedDays {
    final effectiveMatchesPerDay = allowWeekendDoubleHeaders
        ? leagueMatchesPerDay + 1
        : leagueMatchesPerDay;
    return (totalLeagueAndPlayoffMatches / effectiveMatchesPerDay).ceil();
  }

  DateTime get leagueEndDate =>
      startDate.add(Duration(days: leagueEstimatedDays));

  String get leagueEndDateLabel =>
      '${leagueEndDate.day}/${leagueEndDate.month}/${leagueEndDate.year}';

  double get fixtureDensity =>
      totalLeagueAndPlayoffMatches / leagueEstimatedDays;

  String get fixtureDensityLabel {
    if (fixtureDensity < 1.5) return 'Light';
    if (fixtureDensity < 2.5) return 'Moderate';
    if (fixtureDensity < 3.5) return 'Dense';
    return 'Very Dense';
  }

  Color get fixtureDensityColor {
    if (fixtureDensity < 1.5) return kGreen;
    if (fixtureDensity < 2.5) return kAmber;
    return kRed;
  }

  List<Map<String, dynamic>> get leagueSchedule {
    final schedule = <Map<String, dynamic>>[];
    int dayOffset = 0;
    int matchesOnDay = 0;
    final effectiveMatchesPerDay = leagueMatchesPerDay;

    for (final fixture in leagueFixtures) {
      final matchDate = startDate.add(Duration(days: dayOffset));
      final isWeekend = matchDate.weekday == 6 || matchDate.weekday == 7;
      final todayLimit = (isWeekend && allowWeekendDoubleHeaders)
          ? effectiveMatchesPerDay + 1
          : effectiveMatchesPerDay;

      final matchTime = TimeOfDay(
        hour: startTime.hour + (matchesOnDay * 3),
        minute: startTime.minute,
      );

      schedule.add({...fixture, 'date': matchDate, 'time': matchTime});

      matchesOnDay++;
      if (matchesOnDay >= todayLimit) {
        matchesOnDay = 0;
        dayOffset++;
      }
    }

    // Add playoff matches if enabled
    if (playoffsEnabled) {
      dayOffset += 2; // Gap before playoffs
      final playoffNames = _getPlayoffMatchNames();
      for (int i = 0; i < playoffMatches; i++) {
        final matchDate = startDate.add(Duration(days: dayOffset));
        schedule.add({
          'matchNum': leagueTotalMatches + i + 1,
          'team1': -1,
          'team2': -1,
          'round': playoffNames[i],
          'date': matchDate,
          'time': startTime,
        });
        dayOffset++;
      }
    }

    return schedule;
  }

  List<String> _getPlayoffMatchNames() {
    switch (playoffFormat) {
      case PlayoffFormat.top2Final:
        return ['Final'];
      case PlayoffFormat.top4IPL:
        return ['Qualifier 1', 'Eliminator', 'Qualifier 2', 'Final'];
      case PlayoffFormat.custom:
        final names = <String>[];
        for (int i = 0; i < customQualifyTeams - 1; i++) {
          if (i == customQualifyTeams - 2) {
            names.add('Final');
          } else {
            names.add('Playoff ${i + 1}');
          }
        }
        return names;
    }
  }

  bool get leagueValid {
    if (totalTeams < 3) return false;
    for (final team in tournamentTeams) {
      if (team.length < 5) return false;
    }
    if (winPoints <= tiePoints) return false;
    return true;
  }

  // Generate full match schedule
  List<Map<String, dynamic>> get matchSchedule {
    final schedule = <Map<String, dynamic>>[];
    int matchNum = 0;
    int dayOffset = 0;
    int matchesOnDay = 0;

    // Round 1 matches
    for (int i = 0; i < bracketMatchups.length; i++) {
      final match = bracketMatchups[i];
      if (match[1] == -1) continue; // Skip byes

      final matchDate = startDate.add(Duration(days: dayOffset));
      final matchTime = TimeOfDay(
        hour: startTime.hour + (matchesOnDay * 2), // 2 hours per match
        minute: startTime.minute,
      );

      schedule.add({
        'matchNum': matchNum + 1,
        'round': 'Round 1',
        'team1': match[0],
        'team2': match[1],
        'date': matchDate,
        'time': matchTime,
      });

      matchNum++;
      matchesOnDay++;
      if (matchesOnDay >= matchesPerDay) {
        matchesOnDay = 0;
        dayOffset++;
      }
    }

    // Later rounds (placeholders)
    int teamsInRound = bracketMatchups.length;
    int roundNum = 2;
    while (teamsInRound > 1) {
      teamsInRound = (teamsInRound / 2).ceil();
      for (int i = 0; i < teamsInRound; i++) {
        final matchDate = startDate.add(Duration(days: dayOffset));
        final matchTime = TimeOfDay(
          hour: startTime.hour + (matchesOnDay * 2),
          minute: startTime.minute,
        );

        String roundName = teamsInRound == 1
            ? 'Final'
            : teamsInRound == 2
            ? 'Semi-Final'
            : 'Round $roundNum';

        schedule.add({
          'matchNum': matchNum + 1,
          'round': roundName,
          'team1': -1, // TBD
          'team2': -1,
          'date': matchDate,
          'time': matchTime,
        });

        matchNum++;
        matchesOnDay++;
        if (matchesOnDay >= matchesPerDay) {
          matchesOnDay = 0;
          dayOffset++;
        }
      }
      roundNum++;
    }

    return schedule;
  }

  bool get tournamentValid {
    if (totalTeams < 2) return false;
    for (final team in tournamentTeams) {
      if (team.length < 5) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _modeTabs(),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),

            // ─── Animated Section Switch ───
            SliverToBoxAdapter(
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: mode == MatchMode.friendly
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _buildFriendlySection(),
                secondChild: _buildTournamentSection(),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: _cta(context),
    );
  }

  /* ───────── FRIENDLY SECTION ───────── */

  Widget _buildFriendlySection() {
    return Column(
      children: [
        _friendlyBanner(),
        _playersPerTeam(),
        _teamsSetup(),
        _matchFormat(),
        _aiPredictor(),
        _rules(),
        _summary(),
      ],
    );
  }

  /* ───────── TOURNAMENT SECTION ───────── */

  Widget _buildTournamentSection() {
    return Column(
      children: [
        _tournamentBanner(),
        _tournamentTypeSelector(),
        if (tournamentType == TournamentType.knockout) ...[
          _structureCard(),
          _tournamentTeamsCard(),
          _bracketCard(),
          _matchFormat(), // reused
          _aiPredictor(), // reused
          _scheduleCard(),
          _matchScheduleCard(),
          _tournamentSummary(),
        ],
        if (tournamentType == TournamentType.league) ...[
          _leagueBanner(),
          _leagueStructureCard(),
          _tournamentTeamsCard(), // reused
          _leagueFormatCard(),
          _pointsSystemCard(),
          _playoffConfigCard(),
          _matchFormat(), // reused
          _leagueScheduleCard(),
          _leagueMatchScheduleCard(),
          _seasonSimulationCard(),
          _leagueSummaryCard(),
        ],
      ],
    );
  }

  /* ───────── MODE TABS ───────── */

  Widget _modeTabs() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: MatchMode.values.map((m) {
              final selected = mode == m;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => mode = m),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white10 : Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      m.name[0].toUpperCase() + m.name.substring(1),
                      style: TextStyle(
                        color: selected ? kGreen : kMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /* ───────── FRIENDLY BANNER ───────── */

  Widget _friendlyBanner() {
    return _card(
      gradient: LinearGradient(
        colors: [kGreen.withOpacity(.25), Colors.transparent],
      ),
      child: Row(
        children: const [
          CircleAvatar(
            backgroundColor: kGreen,
            child: Icon(Icons.sentiment_satisfied, color: Colors.black),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Friendly Match\nCasual rules enabled. Stats tracked but rankings unaffected.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /* ───────── TOURNAMENT BANNER ───────── */

  Widget _tournamentBanner() {
    return _card(
      gradient: const LinearGradient(
        colors: [Color(0x33FFD54F), Colors.transparent],
      ),
      child: Row(
        children: const [
          CircleAvatar(
            backgroundColor: Color(0x33FFD54F),
            child: Icon(Icons.emoji_events, color: Colors.amber),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tournament Match\nOrganize multi-match competitions with eliminations, leagues, or hybrid formats.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /* ───────── TOURNAMENT TYPE SELECTOR ───────── */

  Widget _tournamentTypeSelector() {
    return _card(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: TournamentType.values.map((t) {
          final active = t != TournamentType.hybrid;
          final selected = tournamentType == t;

          return GestureDetector(
            onTap: active ? () => setState(() => tournamentType = t) : null,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? (t == TournamentType.league
                              ? kRoyalBlue.withOpacity(0.2)
                              : kGreen.withOpacity(0.2))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? (t == TournamentType.league ? kRoyalBlue : kGreen)
                          : Colors.white12,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    t.name.toUpperCase(),
                    style: TextStyle(
                      color: active ? Colors.white : kMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!active)
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        'COMING SOON',
                        style: TextStyle(color: kMuted, fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /* ───────── STRUCTURE CARD ───────── */

  Widget _structureCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Structure',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _stepperRow(
            'Total Teams',
            'Power of 2 recommended',
            totalTeams,
            min: 2,
            max: 32,
            onChanged: (v) {
              setState(() {
                totalTeams = v;
                // Adjust tournament teams list
                if (v > tournamentTeams.length) {
                  tournamentTeams.addAll(
                    List.generate(
                      v - tournamentTeams.length,
                      (i) => <String>['Player 1', 'Player 2'],
                    ),
                  );
                } else if (v < tournamentTeams.length) {
                  tournamentTeams = tournamentTeams.sublist(0, v);
                }
                // Reinitialize bracket matchups
                _initBracketMatchups();
              });
            },
          ),
          const SizedBox(height: 12),
          _stepperRow(
            'Players Per Team',
            'Playing XI + Subs',
            playersPerTeam,
            min: 5,
            max: 15,
            onChanged: (v) => setState(() => playersPerTeam = v),
          ),
          if (!isPowerOfTwo(totalTeams))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: kAmber, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Not a power of 2 — byes will be required',
                      style: TextStyle(color: kAmber, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _stepperRow(
    String title,
    String subtitle,
    int value, {
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white)),
              Text(
                subtitle,
                style: const TextStyle(color: kMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        _stepper(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  /* ───────── TOURNAMENT TEAMS ───────── */

  Widget _tournamentTeamsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Teams',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '$totalTeams teams',
                style: const TextStyle(color: kMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(totalTeams, (i) => _tournamentTeamRow(i)),
        ],
      ),
    );
  }

  Widget _tournamentTeamRow(int index) {
    final teamColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
    ];
    final color = teamColors[index % teamColors.length];
    final players = tournamentTeams[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 5, backgroundColor: color),
              const SizedBox(width: 8),
              Text(
                'Team ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${players.length}/$playersPerTeam',
                style: TextStyle(
                  color: players.length >= 5 ? kMuted : kAmber,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              ...players.map(
                (p) => Chip(
                  label: Text(p, style: const TextStyle(fontSize: 12)),
                  visualDensity: VisualDensity.compact,
                  onDeleted: players.length > 2
                      ? () => setState(() => players.remove(p))
                      : null,
                ),
              ),
              if (players.length < playersPerTeam)
                ActionChip(
                  label: const Text('+ Add', style: TextStyle(fontSize: 12)),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(
                    () => players.add('Player ${players.length + 1}'),
                  ),
                ),
            ],
          ),
          if (players.length < 5)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Need ${5 - players.length} more player(s)',
                style: const TextStyle(color: kAmber, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  /* ───────── BRACKET CARD ───────── */

  Widget _bracketCard() {
    final teamColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
    ];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Bracket',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _shuffleMatchups,
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text('Shuffle'),
                style: TextButton.styleFrom(
                  foregroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Round 1 Matchups',
            style: TextStyle(color: kMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ...bracketMatchups.asMap().entries.map((entry) {
            final idx = entry.key;
            final match = entry.value;
            final team1Idx = match[0];
            final team2Idx = match[1];
            final isBye = team2Idx == -1;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Text(
                    'M${idx + 1}',
                    style: const TextStyle(
                      color: kMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor:
                              teamColors[team1Idx % teamColors.length],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Team ${team1Idx + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'VS',
                      style: TextStyle(
                        color: kGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isBye)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: kAmber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'BYE',
                              style: TextStyle(
                                color: kAmber,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          )
                        else ...[
                          Expanded(
                            child: Text(
                              'Team ${team2Idx + 1}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          CircleAvatar(
                            radius: 4,
                            backgroundColor:
                                teamColors[team2Idx % teamColors.length],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (!isPowerOfTwo(totalTeams))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: kAmber, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Some teams will receive byes to the next round',
                      style: TextStyle(color: kAmber, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /* ───────── SCHEDULE CARD ───────── */

  Widget _scheduleCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today, color: kMuted),
            title: const Text(
              'Start Date',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              startDateLabel,
              style: const TextStyle(color: kMuted),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => startDate = picked);
              }
            },
          ),
          const Divider(color: Colors.white12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.access_time, color: kMuted),
            title: const Text(
              'Start Time',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              startTimeLabel,
              style: const TextStyle(color: kMuted),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: startTime,
              );
              if (picked != null) {
                setState(() => startTime = picked);
              }
            },
          ),
          const Divider(color: Colors.white12),
          _stepperRow(
            'Matches Per Day',
            'Est. $estimatedDays days total',
            matchesPerDay,
            min: 1,
            max: 6,
            onChanged: (v) => setState(() => matchesPerDay = v),
          ),
        ],
      ),
    );
  }

  /* ───────── MATCH SCHEDULE CARD ───────── */

  Widget _matchScheduleCard() {
    final schedule = matchSchedule;

    // Group matches by date
    final Map<String, List<Map<String, dynamic>>> groupedByDate = {};
    for (final match in schedule) {
      final date = match['date'] as DateTime;
      final dateKey = '${date.day}/${date.month}/${date.year}';
      groupedByDate.putIfAbsent(dateKey, () => []);
      groupedByDate[dateKey]!.add(match);
    }

    final teamColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
    ];

    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Match Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${schedule.length} matches',
                style: const TextStyle(color: kMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...groupedByDate.entries.map((dateEntry) {
            final dateStr = dateEntry.key;
            final matches = dateEntry.value;
            final date = matches.first['date'] as DateTime;
            final dayName = dayNames[date.weekday - 1];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: kGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: kGreen, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '$dayName, $dateStr',
                        style: const TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${matches.length} match${matches.length > 1 ? 'es' : ''}',
                        style: TextStyle(
                          color: kGreen.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...matches.map((match) {
                  final time = match['time'] as TimeOfDay;
                  final team1 = match['team1'] as int;
                  final team2 = match['team2'] as int;
                  final round = match['round'] as String;
                  final isTBD = team1 == -1 || team2 == -1;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            time.format(context),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: isTBD
                              ? Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kMuted.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'TBD',
                                        style: TextStyle(
                                          color: kMuted,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'vs',
                                      style: TextStyle(color: kMuted),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kMuted.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'TBD',
                                        style: TextStyle(
                                          color: kMuted,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 4,
                                      backgroundColor:
                                          teamColors[team1 % teamColors.length],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Team ${team1 + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'vs',
                                      style: TextStyle(color: kMuted),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Team ${team2 + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    CircleAvatar(
                                      radius: 4,
                                      backgroundColor:
                                          teamColors[team2 % teamColors.length],
                                    ),
                                  ],
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: round == 'Final'
                                ? kAmber.withOpacity(0.2)
                                : round == 'Semi-Final'
                                ? kGreen.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            round,
                            style: TextStyle(
                              color: round == 'Final'
                                  ? kAmber
                                  : round == 'Semi-Final'
                                  ? kGreen
                                  : kMuted,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  /* ───────── TOURNAMENT SUMMARY ───────── */

  Widget _tournamentSummary() {
    return _card(
      child: Column(
        children: [
          _summaryRow('Teams', '$totalTeams'),
          _summaryRow('Players / Team', '$playersPerTeam'),
          _summaryRow('Matches', '$totalMatches'),
          _summaryRow('Duration', '~$estimatedHours hrs'),
          _summaryRow(
            'Byes',
            isPowerOfTwo(totalTeams) ? 'None' : 'Yes',
            color: isPowerOfTwo(totalTeams) ? kGreen : kAmber,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kMuted)),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /* ═══════════════════════════════════════════════════════════════════════════
   *                            LEAGUE SECTION WIDGETS
   * ═══════════════════════════════════════════════════════════════════════════ */

  // League accent colors
  static const kRoyalBlue = Color(0xFF4169E1);
  static const kGold = Color(0xFFFFD700);

  Widget _leagueBanner() {
    return _card(
      gradient: LinearGradient(
        colors: [kRoyalBlue.withOpacity(0.25), kGold.withOpacity(0.1)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kRoyalBlue.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: kGold, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'League Season\nRound robin format with points table and playoffs.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leagueStructureCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'League Structure',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _stepperRow(
            'Total Teams',
            'Min 3 for league format',
            totalTeams,
            min: 3,
            max: 16,
            onChanged: (v) {
              setState(() {
                totalTeams = v;
                if (v > tournamentTeams.length) {
                  tournamentTeams.addAll(
                    List.generate(
                      v - tournamentTeams.length,
                      (i) => <String>['Player 1', 'Player 2'],
                    ),
                  );
                } else if (v < tournamentTeams.length) {
                  tournamentTeams = tournamentTeams.sublist(0, v);
                }
                _initLeagueFixtures();
              });
            },
          ),
          const SizedBox(height: 12),
          _stepperRow(
            'Players Per Team',
            'Playing XI + Subs',
            playersPerTeam,
            min: 5,
            max: 15,
            onChanged: (v) => setState(() => playersPerTeam = v),
          ),
        ],
      ),
    );
  }

  Widget _leagueFormatCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'League Format',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kRoyalBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$leagueTotalMatches matches',
                  style: const TextStyle(
                    color: kRoyalBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _formatToggle(
                  'Single Round Robin',
                  'Each team plays once',
                  leagueFormat == RoundRobinType.single,
                  () {
                    setState(() {
                      leagueFormat = RoundRobinType.single;
                      _initLeagueFixtures();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _formatToggle(
                  'Double Round Robin',
                  'Home & Away matches',
                  leagueFormat == RoundRobinType.double,
                  () {
                    setState(() {
                      leagueFormat = RoundRobinType.double;
                      _initLeagueFixtures();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Matches',
                        style: TextStyle(color: kMuted, fontSize: 12),
                      ),
                      Text(
                        '$leagueTotalMatches',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Each Team Plays',
                        style: TextStyle(color: kMuted, fontSize: 12),
                      ),
                      Text(
                        '$matchesPerTeam',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formatToggle(
    String title,
    String subtitle,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? kRoyalBlue.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? kRoyalBlue : Colors.white12,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : kMuted,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: selected ? kRoyalBlue : kMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pointsSystemCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Points System',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _pointsTile(
                  'Win',
                  winPoints,
                  kGreen,
                  (v) => setState(() => winPoints = v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _pointsTile(
                  'Tie/NR',
                  tiePoints,
                  kAmber,
                  (v) => setState(() => tiePoints = v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _pointsTile(
                  'Loss',
                  lossPoints,
                  kRed,
                  (v) => setState(() => lossPoints = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Ranking Priority',
            style: TextStyle(color: kMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ...rankingPriority.asMap().entries.map(
            (e) => _rankingItem(e.key, e.value),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kRoyalBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: kRoyalBlue, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'NRR = (Runs Scored ÷ Overs Faced) - (Runs Conceded ÷ Overs Bowled)',
                    style: TextStyle(color: kMuted, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointsTile(
    String label,
    int value,
    Color color,
    ValueChanged<int> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: value > 0 ? () => onChanged(value - 1) : null,
                child: Icon(
                  Icons.remove_circle_outline,
                  color: value > 0 ? color : kMuted,
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$value',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: value < 5 ? () => onChanged(value + 1) : null,
                child: Icon(
                  Icons.add_circle_outline,
                  color: value < 5 ? color : kMuted,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rankingItem(int index, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Text(
            '${index + 1}.',
            style: const TextStyle(color: kMuted, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
          const Icon(Icons.drag_handle, color: kMuted, size: 18),
        ],
      ),
    );
  }

  Widget _playoffConfigCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Playoffs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Switch(
                value: playoffsEnabled,
                onChanged: (v) => setState(() => playoffsEnabled = v),
                activeColor: kGreen,
              ),
            ],
          ),
          if (playoffsEnabled) ...[
            const SizedBox(height: 12),
            Text(
              'Format: ${_getPlayoffFormatLabel()}',
              style: const TextStyle(color: kMuted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _playoffChip('Top 2 Final', PlayoffFormat.top2Final),
                _playoffChip('Top 4 (IPL Style)', PlayoffFormat.top4IPL),
                _playoffChip('Custom', PlayoffFormat.custom),
              ],
            ),
            if (playoffFormat == PlayoffFormat.top4IPL) ...[
              const SizedBox(height: 16),
              _iplPlayoffPreview(),
            ],
            if (playoffFormat == PlayoffFormat.custom) ...[
              const SizedBox(height: 12),
              _stepperRow(
                'Qualifying Teams',
                'Teams advancing to playoffs',
                customQualifyTeams,
                min: 2,
                max: totalTeams ~/ 2,
                onChanged: (v) => setState(() => customQualifyTeams = v),
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _getPlayoffFormatLabel() {
    switch (playoffFormat) {
      case PlayoffFormat.top2Final:
        return 'Top 2 Final';
      case PlayoffFormat.top4IPL:
        return 'Top 4 (IPL Style)';
      case PlayoffFormat.custom:
        return 'Custom ($customQualifyTeams teams)';
    }
  }

  Widget _playoffChip(String label, PlayoffFormat format) {
    final selected = playoffFormat == format;
    return GestureDetector(
      onTap: () => setState(() => playoffFormat = format),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kGold.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? kGold : Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kGold : kMuted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _iplPlayoffPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _playoffStage(
            Icons.emoji_events,
            'Final',
            'Winner Q1 vs Winner Q2',
            kGold,
          ),
          const SizedBox(height: 8),
          _playoffStage(
            Icons.arrow_upward,
            'Qualifier 2',
            'Loser Q1 vs Winner Eliminator',
            kRoyalBlue,
          ),
          const SizedBox(height: 8),
          _playoffStage(Icons.groups, 'Eliminator', 'Team 3 vs Team 4', kMuted),
          const SizedBox(height: 8),
          _playoffStage(Icons.star, 'Qualifier 1', 'Team 1 vs Team 2', kGreen),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.leaderboard, color: kMuted, size: 16),
              SizedBox(width: 8),
              Text(
                'Top 4 Teams Qualify',
                style: TextStyle(color: kMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _playoffStage(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: kMuted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _leagueScheduleCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today, color: kMuted),
            title: const Text(
              'Start Date',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              startDateLabel,
              style: const TextStyle(color: kMuted),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => startDate = picked);
            },
          ),
          const Divider(color: Colors.white12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.access_time, color: kMuted),
            title: const Text(
              'Start Time',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              startTimeLabel,
              style: const TextStyle(color: kMuted),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: startTime,
              );
              if (picked != null) setState(() => startTime = picked);
            },
          ),
          const Divider(color: Colors.white12),
          _stepperRow(
            'Matches Per Day',
            'Est. $leagueEstimatedDays days for season',
            leagueMatchesPerDay,
            min: 1,
            max: 4,
            onChanged: (v) => setState(() => leagueMatchesPerDay = v),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Weekend Double Headers',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Extra match on Sat/Sun',
              style: TextStyle(color: kMuted, fontSize: 12),
            ),
            value: allowWeekendDoubleHeaders,
            onChanged: (v) => setState(() => allowWeekendDoubleHeaders = v),
            activeColor: kGreen,
          ),
        ],
      ),
    );
  }

  Widget _leagueMatchScheduleCard() {
    final schedule = leagueSchedule;

    final Map<String, List<Map<String, dynamic>>> groupedByDate = {};
    for (final match in schedule.take(15)) {
      // Show first 15 matches
      final date = match['date'] as DateTime;
      final dateKey = '${date.day}/${date.month}/${date.year}';
      groupedByDate.putIfAbsent(dateKey, () => []);
      groupedByDate[dateKey]!.add(match);
    }

    final teamColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
    ];
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Match Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _shuffleLeagueFixtures,
                icon: const Icon(Icons.shuffle, size: 16),
                label: const Text('Shuffle'),
                style: TextButton.styleFrom(
                  foregroundColor: kRoyalBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
          Text(
            '${schedule.length} matches total (showing first 15)',
            style: const TextStyle(color: kMuted, fontSize: 11),
          ),
          const SizedBox(height: 12),
          ...groupedByDate.entries.map((entry) {
            final dateStr = entry.key;
            final matches = entry.value;
            final date = matches.first['date'] as DateTime;
            final dayName = dayNames[date.weekday - 1];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kRoyalBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$dayName, $dateStr',
                    style: const TextStyle(
                      color: kRoyalBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                ...matches.map((match) {
                  final team1 = match['team1'] as int;
                  final team2 = match['team2'] as int;
                  final round = match['round'] as String;
                  final isPlayoff = round != 'League';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isPlayoff
                          ? kGold.withOpacity(0.1)
                          : Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isPlayoff
                            ? kGold.withOpacity(0.3)
                            : Colors.white10,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (team1 >= 0 && team2 >= 0) ...[
                          CircleAvatar(
                            radius: 4,
                            backgroundColor:
                                teamColors[team1 % teamColors.length],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Team ${team1 + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'vs',
                              style: TextStyle(color: kMuted, fontSize: 11),
                            ),
                          ),
                          Text(
                            'Team ${team2 + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          CircleAvatar(
                            radius: 4,
                            backgroundColor:
                                teamColors[team2 % teamColors.length],
                          ),
                        ] else ...[
                          const Text(
                            'TBD vs TBD',
                            style: TextStyle(color: kMuted, fontSize: 12),
                          ),
                        ],
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isPlayoff
                                ? kGold.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            round,
                            style: TextStyle(
                              color: isPlayoff ? kGold : kMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _seasonSimulationCard() {
    return _card(
      gradient: LinearGradient(
        colors: [kRoyalBlue.withOpacity(0.15), Colors.transparent],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.analytics, color: kRoyalBlue, size: 20),
              SizedBox(width: 8),
              Text(
                'Season Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _simStat(
                  'Duration',
                  '$leagueEstimatedDays days',
                  Icons.calendar_month,
                ),
              ),
              Expanded(
                child: _simStat(
                  'End Date',
                  leagueEndDateLabel,
                  Icons.event_available,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _simStat(
                  'Density',
                  fixtureDensityLabel,
                  Icons.speed,
                  color: fixtureDensityColor,
                ),
              ),
              Expanded(
                child: _simStat(
                  'Playoff',
                  playoffsEnabled ? '$playoffMatches matches' : 'Disabled',
                  Icons.emoji_events,
                ),
              ),
            ],
          ),
          if (fixtureDensity > 2.5) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kAmber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: kAmber, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'High fixture density may cause player fatigue',
                      style: TextStyle(color: kAmber, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _simStat(String label, String value, IconData icon, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color ?? kMuted, size: 14),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: kMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _leagueSummaryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'League Summary',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _summaryRow('Teams', '$totalTeams'),
          _summaryRow(
            'Format',
            leagueFormat == RoundRobinType.single
                ? 'Single Round Robin'
                : 'Double Round Robin',
          ),
          _summaryRow('League Matches', '$leagueTotalMatches'),
          _summaryRow(
            'Points (W/T/L)',
            '$winPoints / $tiePoints / $lossPoints',
          ),
          _summaryRow(
            'Playoffs',
            playoffsEnabled ? _getPlayoffFormatLabel() : 'Disabled',
          ),
          _summaryRow('Total Matches', '$totalLeagueAndPlayoffMatches'),
          _summaryRow(
            'Season Duration',
            '$leagueEstimatedDays days',
            color: fixtureDensityColor,
          ),
        ],
      ),
    );
  }

  /* ───────── PLAYERS PER TEAM ───────── */

  Widget _playersPerTeam() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Players Per Team',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text('Maximum Allowed')),
              _stepper(
                value: maxPlayers,
                min: 5,
                max: 15,
                onChanged: (v) => setState(() => maxPlayers = v),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Recommended: 7–11 players. Min 5 required.',
            style: TextStyle(color: kMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /* ───────── TEAMS ───────── */

  Widget _teamsSetup() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _teamCard('Red Strikers', Colors.red, teamA),
          const SizedBox(height: 12),
          _teamCard('Blue Titans', Colors.blue, teamB),
        ],
      ),
    );
  }

  Widget _teamCard(String name, Color color, List<String> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 5, backgroundColor: color),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${players.length}/$maxPlayers',
              style: const TextStyle(color: kMuted),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ...players.map(
              (p) => Chip(
                label: Text(p),
                onDeleted: () => setState(() => players.remove(p)),
              ),
            ),
            ActionChip(
              label: const Text('+ Add'),
              onPressed: () =>
                  setState(() => players.add('Guest ${players.length + 1}')),
            ),
          ],
        ),
        if (players.length < 5)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Need ${5 - players.length} more player(s)',
              style: const TextStyle(color: kAmber, fontSize: 12),
            ),
          ),
      ],
    );
  }

  /* ───────── MATCH FORMAT ───────── */

  Widget _matchFormat() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Match Format',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _seg('1 Inning', innings == 1, () => setState(() => innings = 1)),
              const SizedBox(width: 8),
              _seg(
                '2 Innings',
                innings == 2,
                () => setState(() => innings = 2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [2, 5, 10, 20]
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
        ],
      ),
    );
  }

  /* ───────── AI PREDICTOR ───────── */

  Widget _aiPredictor() {
    return _card(
      gradient: const LinearGradient(
        colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'AI Predictor',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text('Estimated Duration: ~1h 15m'),
          Text('Match Rating: Fairly Balanced'),
          SizedBox(height: 8),
          Text('Light Rain • 20% chance at kickoff'),
          Text('Sunset at 6:30 PM • Visibility may drop'),
        ],
      ),
    );
  }

  /* ───────── RULES ───────── */

  Widget _rules() {
    return _card(
      child: Column(
        children: [
          SwitchListTile(
            value: wideBall,
            onChanged: (v) => setState(() => wideBall = v),
            title: const Text('Wide Ball'),
            subtitle: const Text('1 Run + Extra Ball'),
            activeColor: kGreen,
          ),
          SwitchListTile(
            value: noBall,
            onChanged: (v) => setState(() => noBall = v),
            title: const Text('No Ball'),
            subtitle: const Text('1 Run + Free Hit'),
            activeColor: kGreen,
          ),
          SwitchListTile(
            value: proMode,
            onChanged: (v) => setState(() => proMode = v),
            title: const Text('Pro Mode'),
            subtitle: const Text(
              'Powerplay, DRS, Strict Fielding (Expandable)',
            ),
            activeColor: kGreen,
          ),
        ],
      ),
    );
  }

  /* ───────── SUMMARY ───────── */

  Widget _summary() {
    return _card(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.5,
        children: const [
          _SummaryTile('Teams', 'Red vs Blue'),
          _SummaryTile('Format', '10 Overs'),
          _SummaryTile('Squads', 'Max 11 Players'),
          _SummaryTile('Est. End', '06:45 PM'),
        ],
      ),
    );
  }

  /* ───────── CTA ───────── */

  Widget _cta(BuildContext context) {
    final isTournament = mode == MatchMode.tournament;
    final isValid = isTournament ? tournamentValid : valid;

    final label = isTournament
        ? 'Create Tournament →'
        : 'Create Friendly Scoreboard →';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: isValid
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CricketScoreboardScreen(
                      // mode: mode,
                      // // optional but recommended
                      // tournamentBlueprint:
                      //     isTournament ? tournamentBlueprint : null,
                      // friendlyConfig:
                      //     !isTournament ? friendlyConfig : null,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }

  /* ───────── HELPERS ───────── */

  Widget _card({required Widget child, Gradient? gradient}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          gradient: gradient,
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      ),
    );
  }

  Widget _seg(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? kGreen : Colors.white12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: selected ? kGreen : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _stepper({
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        Text('$value'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

/* ───────────────── SUMMARY TILE ───────────────── */

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryTile(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: kMuted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
