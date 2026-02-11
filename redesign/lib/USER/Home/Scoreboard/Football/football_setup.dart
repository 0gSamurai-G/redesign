import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'football_scoreboard.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 🎨 THEME & CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF121212);
const kSurfaceHighlight = Color(0xFF1E1E1E);
const kAccent = Color(0xFF1DB954);
const kAccentDim = Color(0x331DB954);
const kTextPrimary = Color(0xFFFFFFFF);
const kTextSecondary = Color(0xFFB3B3B3);
const kTextMuted = Color(0xFF777777);
const kSuccess = Color(0xFF1DB954);
const kWarning = Color(0xFFFFC107);
const kError = Color(0xFFEF4444);
const kDivider = Color(0xFF2A2A2A);

// ─────────────────────────────────────────────────────────────────────────────
// 🧩 ENUMS & MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum MatchMode { friendly, tournament }

enum TournamentType { knockout, league, hybrid }

enum TieBreaker { goalDifference, goalsScored, headToHead }

enum TimerType { countUp, countDown }

class Player {
  final String id;
  final String name;
  Player({required this.name})
    : id = DateTime.now().microsecondsSinceEpoch.toString();
}

class Team {
  String id;
  String name;
  String shortName;
  Color color;
  List<Player> players;
  bool isReady;

  Team({
    required this.name,
    this.shortName = '',
    this.color = Colors.grey,
    List<Player>? players,
    this.isReady = false,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString(),
       players = players ?? [];

  bool get hasMinPlayers => players.length >= 7;
}

class MatchFixture {
  final String id;
  Team? home;
  Team? away;
  DateTime date;
  String? roundName;
  String? groupName;

  MatchFixture({
    this.home,
    this.away,
    required this.date,
    this.roundName,
    this.groupName,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString();
}

// ─────────────────────────────────────────────────────────────────────────────
// 🧠 LOGIC ENGINES
// ─────────────────────────────────────────────────────────────────────────────

class ValidationEngine {
  static bool validateFriendly(List<Team> teams, int playersPerSide) {
    if (teams.length != 2) return false;
    return teams.every(
      (t) => t.players.length >= playersPerSide,
    ); // Strict check
  }

  static bool validateTournament(List<Team> teams, int expectedCount) {
    return teams.length == expectedCount && teams.isNotEmpty;
  }
}

class BracketEngine {
  static List<MatchFixture> generateKnockout(
    List<Team> teams,
    bool activeThirdPlace,
  ) {
    if (teams.isEmpty) return [];
    List<MatchFixture> fixtures = [];

    // Generate First Round (Quarter/Round of 16 etc)
    int matchCount = teams.length ~/ 2;
    for (int i = 0; i < matchCount; i++) {
      fixtures.add(
        MatchFixture(
          home: teams[i * 2],
          away: teams[(i * 2) + 1],
          date: DateTime.now().add(Duration(days: 1)),
          roundName: _getRoundName(matchCount, 0),
        ),
      );
    }

    // Simulate future rounds placeholders
    int nextRoundMatches = matchCount ~/ 2;
    int roundIndex = 1;
    while (nextRoundMatches >= 1) {
      for (int i = 0; i < nextRoundMatches; i++) {
        fixtures.add(
          MatchFixture(
            date: DateTime.now().add(Duration(days: (roundIndex + 1) * 2)),
            roundName: _getRoundName(nextRoundMatches, roundIndex),
          ),
        );
      }
      nextRoundMatches = nextRoundMatches ~/ 2;
      roundIndex++;
    }

    if (activeThirdPlace) {
      fixtures.add(
        MatchFixture(
          date: DateTime.now().add(Duration(days: roundIndex * 2 + 1)),
          roundName: "Third Place Playoff",
        ),
      );
    }

    return fixtures;
  }

  static String _getRoundName(int matchCount, int depth) {
    if (matchCount == 1) return "Final";
    if (matchCount == 2) return "Semi Final";
    if (matchCount == 4) return "Quarter Final";
    return "Round of ${matchCount * 2}";
  }
}

class LeagueEngine {
  static List<MatchFixture> generateRoundRobin(
    List<Team> teams,
    bool doubleRound,
  ) {
    if (teams.length < 2) return [];
    List<MatchFixture> fixtures = [];
    List<Team> roundTeams = List.from(teams);

    if (roundTeams.length % 2 != 0) {
      roundTeams.add(Team(name: "BYE")); // Dummy team
    }

    int numRounds = roundTeams.length - 1;
    int halfSize = roundTeams.length ~/ 2;

    for (int round = 0; round < numRounds; round++) {
      for (int i = 0; i < halfSize; i++) {
        Team home = roundTeams[i];
        Team away = roundTeams[roundTeams.length - 1 - i];
        if (home.name != "BYE" && away.name != "BYE") {
          fixtures.add(
            MatchFixture(
              home: home,
              away: away,
              date: DateTime.now().add(Duration(days: round * 3)),
              roundName: "Week ${round + 1}",
            ),
          );
        }
      }
      // Rotate teams
      roundTeams.insert(1, roundTeams.removeLast());
    }

    if (doubleRound) {
      // Add logic for return legs
      int currentCount = fixtures.length;
      for (int i = 0; i < currentCount; i++) {
        fixtures.add(
          MatchFixture(
            home: fixtures[i].away,
            away: fixtures[i].home,
            date: fixtures[i].date.add(const Duration(days: 90)),
            roundName: "Week ${numRounds + (i ~/ halfSize) + 1}",
          ),
        );
      }
    }

    return fixtures;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 📱 MAIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class MatchSetupScreen extends StatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen>
    with TickerProviderStateMixin {
  // ─── MASTER STATE ───
  MatchMode _mode = MatchMode.friendly;
  TournamentType _tournamentType = TournamentType.knockout;

  // ─── FRIENDLY STATE ───
  int _fPlayersPerSide = 7;
  int _fDuration = 20;
  bool _fRollingSubs = true;
  bool _fStats = true;
  bool _fCards = true;
  bool _fTimeline = true;

  // Result & Control
  bool _fAllowDraw = true;
  bool _fExtraTime = false;
  bool _fPenalties = false;
  TimerType _fTimerType = TimerType.countUp;
  bool _fManualControl = false;

  // Schedule
  DateTime _fDate = DateTime.now();
  TimeOfDay _fTime = const TimeOfDay(hour: 20, minute: 00);

  List<Team> _fTeams = [
    Team(name: 'Home FC', color: Colors.blueAccent, players: []),
    Team(name: 'Away United', color: Colors.redAccent, players: []),
  ];

  // ─── TOURNAMENT STATE ───
  String _tName = "Champions Cup 2026";
  String _tRegion = "International";
  String _tSeason = "2026/27";
  int _tTeamCount = 8;
  List<Team> _tTeams = [];

  // Knockout Settings
  bool _kThirdPlace = false;
  bool _kSeeded = false;
  bool _kTwoLegged = false;

  // Tournament Match Settings
  int _tPlayersPerSide = 11;
  int _tDuration = 45;
  bool _tExtraTime = true;
  bool _tPenalties = true;
  bool _tAwayGoals = false;

  // League Settings
  bool _lRelegation = true;
  int _lRelegationSpots = 3;
  int _lSquadSize = 25;
  String _lFormation = "4-3-3 Holding";
  bool _lDoubleRound = true;

  // Hybrid Settings
  int _hGroupCount = 2;
  int _hQualifyPerGroup = 2;

  // Engines Data
  List<MatchFixture> _knockoutBracket = [];
  List<MatchFixture> _leagueFixtures = [];
  Map<String, List<Team>> _hybridGroups = {};

  // UI STATE
  bool _isGenerating = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _initTeams();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _initTeams() {
    _tTeams = List.generate(
      _tTeamCount,
      (i) => Team(
        name: "Team ${i + 1}",
        color: Colors.primaries[i % Colors.primaries.length],
        isReady: true,
      ),
    );
    _regenerateEngine();
  }

  void _regenerateEngine() {
    setState(() => _isGenerating = true);
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        if (_tournamentType == TournamentType.knockout) {
          _knockoutBracket = BracketEngine.generateKnockout(
            _tTeams,
            _kThirdPlace,
          );
        }
        if (_tournamentType == TournamentType.league) {
          _leagueFixtures = LeagueEngine.generateRoundRobin(
            _tTeams,
            _lDoubleRound,
          );
        }
        if (_tournamentType == TournamentType.hybrid) {
          _generateHybridDraw();
        }
        _isGenerating = false;
      });
    });
  }

  void _generateHybridDraw() {
    _hybridGroups.clear();
    List<Team> shuffled = List.from(_tTeams)..shuffle();
    int perGroup = _tTeamCount ~/ _hGroupCount;
    for (int i = 0; i < _hGroupCount; i++) {
      String groupName = "Group ${String.fromCharCode(65 + i)}";
      _hybridGroups[groupName] = shuffled
          .skip(i * perGroup)
          .take(perGroup)
          .toList();
    }
  }

  void _applyFriendlyPreset() {
    setState(() {
      _fPlayersPerSide = 7;
      _fDuration = 20;
      _fRollingSubs = true;
      _fAllowDraw = true;
      _fStats = true;
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Standard Friendly Rules Applied"),
        backgroundColor: kSuccess,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  // ─── UI BUILDER ───

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildProgressIndicator()),
                  SliverToBoxAdapter(child: _buildModeToggle()),
                  SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.02, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _mode == MatchMode.friendly
                          ? _buildFriendlySection()
                          : _buildTournamentSection(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
            _buildStickyCTA(),
          ],
        ),
      ),
    );
  }

  // ─── HEADER & NAV ───

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: kBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BackButton(color: kTextPrimary),
          Text(
            _mode == MatchMode.friendly ? 'FRIENDLY MATCH' : 'TOURNAMENT SETUP',
            style: const TextStyle(
              color: kTextPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 14,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: kTextSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    double progress = 0.0;
    if (_mode == MatchMode.friendly) {
      if (_fTeams.every((t) => t.hasMinPlayers)) progress += 0.5;
      if (_fDuration > 0) progress += 0.2;
      progress += 0.3; // Base setup
    } else {
      if (_tTeams.isNotEmpty) progress += 0.4;
      if (!_isGenerating &&
          (_knockoutBracket.isNotEmpty ||
              _leagueFixtures.isNotEmpty ||
              _hybridGroups.isNotEmpty))
        progress += 0.6;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Setup Quality",
                style: TextStyle(
                  color: kTextSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  if (progress >= 1.0)
                    const Icon(Icons.verified, color: kAccent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      color: progress >= 1.0 ? kAccent : kWarning,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: kSurfaceHighlight,
              valueColor: AlwaysStoppedAnimation(
                progress >= 1.0 ? kAccent : kWarning,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: kSurfaceHighlight,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              alignment: _mode == MatchMode.friendly
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: (MediaQuery.of(context).size.width - 48) / 2,
                decoration: BoxDecoration(
                  color: kAccent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: kAccent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _buildToggleItem("Friendly", MatchMode.friendly),
                _buildToggleItem("Tournament", MatchMode.tournament),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String label, MatchMode mode) {
    bool isSelected = _mode == mode;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _mode = mode);
        },
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isSelected ? Colors.black : kTextSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  // ─── FRIENDLY SECTION ───

  Widget _buildFriendlySection() {
    return Column(
      key: const ValueKey('Friendly'),
      children: [
        _buildSmartPresets(),
        _buildSectionCard(
          title: "TEAMS",
          icon: Icons.people_outline,
          isExpanded: true,
          child: Column(
            children: _fTeams.map((team) => _buildTeamRow(team)).toList(),
          ),
        ),
        _buildSectionCard(
          title: "FORMAT",
          icon: Icons.tune,
          isExpanded: true,
          child: Column(
            children: [
              _buildStepperRow(
                "Players per Side",
                _fPlayersPerSide,
                (v) => setState(() => _fPlayersPerSide = v),
                min: 3,
                max: 11,
              ),
              const SizedBox(height: 16),
              _buildStepperRow(
                "Half Duration (mins)",
                _fDuration,
                (v) => setState(() => _fDuration = v),
                step: 5,
              ),
            ],
          ),
        ),
        _buildSectionCard(
          title: "RULES & CONTROL",
          icon: Icons.gavel,
          isExpanded: false,
          child: Column(
            children: [
              _buildSwitch(
                "Rolling Substitutions",
                _fRollingSubs,
                (v) => setState(() => _fRollingSubs = v),
              ),
              _buildSwitch(
                "Allow Draw",
                _fAllowDraw,
                (v) => setState(() => _fAllowDraw = v),
              ),
              if (!_fAllowDraw) ...[
                _buildSwitch(
                  "Extra Time",
                  _fExtraTime,
                  (v) => setState(() => _fExtraTime = v),
                ),
                _buildSwitch(
                  "Penalties",
                  _fPenalties,
                  (v) => setState(() => _fPenalties = v),
                ),
              ],
              const Divider(color: kDivider, height: 24),
              _buildSwitch(
                "Manual Match Control",
                _fManualControl,
                (v) => setState(() => _fManualControl = v),
              ),
              const SizedBox(height: 16),
              _buildSegmentedControl(
                ["Count Up", "Countdown"],
                _fTimerType == TimerType.countUp ? 0 : 1,
                (i) => setState(
                  () => _fTimerType = i == 0
                      ? TimerType.countUp
                      : TimerType.countDown,
                ),
              ),
            ],
          ),
        ),
        _buildSectionCard(
          title: "TRACKING",
          icon: Icons.bar_chart,
          isExpanded: false,
          child: Column(
            children: [
              _buildSwitch(
                "Track Player Stats",
                _fStats,
                (v) => setState(() => _fStats = v),
              ),
              _buildSwitch(
                "Match Timeline",
                _fTimeline,
                (v) => setState(() => _fTimeline = v),
              ),
              _buildSwitch(
                "Cards (Yellow/Red)",
                _fCards,
                (v) => setState(() => _fCards = v),
              ),
            ],
          ),
        ),
        _buildSectionCard(
          title: "SCHEDULE",
          icon: Icons.calendar_today,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Starts in ~${_fTime.hour - TimeOfDay.now().hour} hours",
                  style: const TextStyle(
                    color: kAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "${_fDate.day}/${_fDate.month} • ${_fTime.format(context)}",
                style: const TextStyle(color: kTextPrimary),
              ),
            ],
          ),
        ),
        _buildFriendlyPreview(),
      ],
    );
  }

  Widget _buildSmartPresets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurfaceHighlight,
          border: Border.all(color: kAccentDim),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kAccentDim,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: kAccent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Setup",
                    style: TextStyle(
                      color: kTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Used in 72% of friendly games",
                    style: TextStyle(color: kTextSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: _applyFriendlyPreset,
              child: const Text(
                "Apply Standard",
                style: TextStyle(color: kAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendlyPreview() {
    bool valid = ValidationEngine.validateFriendly(_fTeams, _fPlayersPerSide);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: valid ? kAccentDim.withOpacity(0.1) : kSurfaceHighlight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: valid ? kSuccess : kWarning.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            _buildCheckItem(
              "Teams have min 7 players",
              _fTeams.every((t) => t.hasMinPlayers),
            ),
            _buildCheckItem(
              "Format configured (${_fPlayersPerSide}v${_fPlayersPerSide})",
              true,
            ),
            _buildCheckItem("Rules set", true),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String label, bool checked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.circle_outlined,
            color: checked ? kSuccess : kTextMuted,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: checked ? kTextPrimary : kTextMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ─── TOURNAMENT SECTION ───

  Widget _buildTournamentSection() {
    return Column(
      key: const ValueKey('Tournament'),
      children: [
        _buildTournamentTypeSelector(),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _buildTournamentEngineUI(),
        ),
      ],
    );
  }

  Widget _buildTournamentTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: TournamentType.values
            .map((type) => _buildTypeCard(type))
            .toList(),
      ),
    );
  }

  Widget _buildTypeCard(TournamentType type) {
    bool isSelected = _tournamentType == type;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _tournamentType = type;
          _regenerateEngine();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? kAccentDim : kSurfaceHighlight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? kAccent : Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(
              type == TournamentType.knockout
                  ? Icons.emoji_events
                  : type == TournamentType.league
                  ? Icons.grid_view
                  : Icons.schema,
              color: isSelected ? kAccent : kTextMuted,
            ),
            const SizedBox(height: 8),
            Text(
              type.name.toUpperCase(),
              style: TextStyle(
                color: isSelected ? kAccent : kTextMuted,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentEngineUI() {
    return Column(
      key: ValueKey(_tournamentType),
      children: [
        _buildSectionCard(
          title: "IDENTITY",
          icon: Icons.badge,
          child: Column(
            children: [
              _buildTextField("Tournament Name", _tName),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTextField("Season", _tSeason)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField("Region", _tRegion)),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField("Host Name", "Official Organizer"),
            ],
          ),
        ),
        _buildSectionCard(
          title: "MATCH FORMAT",
          icon: Icons.tune,
          child: Column(
            children: [
              _buildStepperRow(
                "Players per Team",
                _tPlayersPerSide,
                (v) => setState(() => _tPlayersPerSide = v),
                min: 3,
                max: 11,
              ),
              const SizedBox(height: 16),
              _buildStepperRow(
                "Half Duration (mins)",
                _tDuration,
                (v) => setState(() => _tDuration = v),
                step: 5,
              ),
            ],
          ),
        ),
        _buildSectionCard(
          title: "STRUCTURE",
          icon: Icons.settings_suggest,
          child: Column(
            children: [
              _buildStepperRow(
                "Total Teams",
                _tTeamCount,
                (v) {
                  setState(() => _tTeamCount = v);
                  _initTeams();
                },
                min: 2,
                max: 64,
              ),
              if (_tournamentType == TournamentType.league) ...[
                const SizedBox(height: 16),
                _buildStepperRow(
                  "Relegation Spots",
                  _lRelegationSpots,
                  (v) => setState(() => _lRelegationSpots = v),
                ),
                const SizedBox(height: 16),
                _buildSwitch("Double Round Robin", _lDoubleRound, (v) {
                  setState(() => _lDoubleRound = v);
                  _regenerateEngine();
                }),
              ],
              if (_tournamentType == TournamentType.hybrid) ...[
                const SizedBox(height: 16),
                _buildStepperRow(
                  "Number of Groups",
                  _hGroupCount,
                  (v) {
                    setState(() => _hGroupCount = v);
                    _regenerateEngine();
                  },
                  min: 2,
                  max: 8,
                ),
                const SizedBox(height: 16),
                _buildStepperRow(
                  "Qualify per Group",
                  _hQualifyPerGroup,
                  (v) => setState(() => _hQualifyPerGroup = v),
                  min: 1,
                  max: 4,
                ),
              ],
            ],
          ),
        ),

        _buildSectionCard(
          title: "TOURNAMENT RULES",
          icon: Icons.gavel,
          isExpanded: false,
          child: Column(
            children: [
              _buildSwitch(
                "Extra Time",
                _tExtraTime,
                (v) => setState(() => _tExtraTime = v),
              ),
              _buildSwitch(
                "Penalties",
                _tPenalties,
                (v) => setState(() => _tPenalties = v),
              ),
              if (_tournamentType == TournamentType.knockout) ...[
                const Divider(color: kDivider, height: 24),
                _buildSwitch("Third Place Playoff", _kThirdPlace, (v) {
                  setState(() => _kThirdPlace = v);
                  _regenerateEngine();
                }),
                _buildSwitch(
                  "Seeded Draw",
                  _kSeeded,
                  (v) => setState(() => _kSeeded = v),
                ),
                _buildSwitch(
                  "Two-Legged Ties",
                  _kTwoLegged,
                  (v) => setState(() => _kTwoLegged = v),
                ),
                if (_kTwoLegged)
                  _buildSwitch(
                    "Away Goals Rule",
                    _tAwayGoals,
                    (v) => setState(() => _tAwayGoals = v),
                  ),
              ],
            ],
          ),
        ),

        if (_tournamentType == TournamentType.league)
          _buildSectionCard(
            title: "LEAGUE SETTINGS",
            icon: Icons.table_chart,
            isExpanded: false,
            child: Column(
              children: [
                _buildSwitch(
                  "Relegation System",
                  _lRelegation,
                  (v) => setState(() => _lRelegation = v),
                ),
                if (_lRelegation) ...[
                  const SizedBox(height: 12),
                  _buildStepperRow(
                    "Relegation Spots",
                    _lRelegationSpots,
                    (v) => setState(() => _lRelegationSpots = v),
                    min: 1,
                    max: 4,
                  ),
                ],
                const SizedBox(height: 16),
                _buildStepperRow(
                  "Squad Size",
                  _lSquadSize,
                  (v) => setState(() => _lSquadSize = v),
                  min: 11,
                  max: 40,
                ),
                const SizedBox(height: 16),
                _buildTextField("Teams Formation", _lFormation),
                const SizedBox(height: 16),
                _buildSwitch("Double Round Robin", _lDoubleRound, (v) {
                  setState(() => _lDoubleRound = v);
                  _regenerateEngine();
                }),
              ],
            ),
          ),

        _buildSectionCard(
          title: "ENGINE PREVIEW",
          icon: Icons.visibility,
          child: _isGenerating
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(color: kAccent),
                  ),
                )
              : _buildEnginePreviewContent(),
        ),
        _buildSystemCheck(),
      ],
    );
  }

  Widget _buildSystemCheck() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurfaceHighlight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildCheckItem("Format Validated", true),
            _buildCheckItem("Schedule Optimized", !_isGenerating),
            _buildCheckItem("Teams Ready", _tTeams.isNotEmpty),
          ],
        ),
      ),
    );
  }

  Widget _buildEnginePreviewContent() {
    if (_tournamentType == TournamentType.knockout) {
      if (_knockoutBracket.isEmpty)
        return const Text(
          "No matches generated",
          style: TextStyle(color: kTextMuted),
        );
      return Column(
        children: _knockoutBracket
            .map(
              (m) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "${m.home?.name} vs ${m.away?.name}",
                  style: const TextStyle(color: kTextPrimary, fontSize: 13),
                ),
                subtitle: Text(
                  m.roundName ?? "",
                  style: const TextStyle(color: kAccent, fontSize: 10),
                ),
                trailing: Text(
                  "${m.date.day}/${m.date.month}",
                  style: const TextStyle(color: kTextMuted, fontSize: 12),
                ),
              ),
            )
            .toList(),
      );
    } else if (_tournamentType == TournamentType.league) {
      return Column(
        children: _leagueFixtures
            .take(6)
            .map(
              (m) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "${m.home?.name} vs ${m.away?.name}",
                  style: const TextStyle(color: kTextPrimary),
                ),
                subtitle: Text(
                  m.roundName ?? "",
                  style: const TextStyle(color: kTextMuted, fontSize: 10),
                ),
                leading: const Icon(Icons.circle, size: 6, color: kAccent),
              ),
            )
            .toList(),
      );
    }
    return Column(
      children: _hybridGroups.entries
          .map(
            (e) => ExpansionTile(
              title: Text(
                e.key,
                style: const TextStyle(
                  color: kTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              children: e.value
                  .map(
                    (t) => ListTile(
                      title: Text(
                        t.name,
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: 13,
                        ),
                      ),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: CircleAvatar(
                        backgroundColor: t.color,
                        radius: 4,
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  // ─── SHARED UI COMPONENTS ───

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    bool isExpanded = true,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        decoration: BoxDecoration(
          color: kSurfaceHighlight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: kAccent, size: 20),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: kTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperRow(
    String label,
    int value,
    Function(int) onChanged, {
    int step = 1,
    int min = 1,
    int max = 100,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: kTextSecondary, fontSize: 15),
        ),
        Container(
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: kTextMuted, size: 18),
                onPressed: value > min ? () => onChanged(value - step) : null,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 24),
                  alignment: Alignment.center,
                  child: Text(
                    "$value",
                    key: ValueKey(value),
                    style: const TextStyle(
                      color: kTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: kTextMuted, size: 18),
                onPressed: value < max ? () => onChanged(value + step) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        label,
        style: const TextStyle(color: kTextSecondary, fontSize: 14),
      ),
      value: value,
      activeColor: kAccent,
      contentPadding: EdgeInsets.zero,
      dense: true,
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(color: kTextPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTextMuted),
        filled: true,
        fillColor: kSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    int selectedIndex,
    Function(int) onSelect,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          bool isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? kSurfaceHighlight : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: kAccent.withOpacity(0.5))
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  options[index],
                  style: TextStyle(
                    color: isSelected ? kAccent : kTextMuted,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTeamRow(Team team) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kDivider),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: team.color,
              radius: 16,
              child: Text(team.name[0]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTextPrimary,
                    ),
                  ),
                  Text(
                    team.hasMinPlayers ? "Ready" : "Need more players",
                    style: TextStyle(
                      color: team.hasMinPlayers ? kSuccess : kWarning,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add, color: kTextMuted),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyCTA() {
    bool isActive = false;
    if (_mode == MatchMode.friendly) {
      isActive = ValidationEngine.validateFriendly(_fTeams, _fPlayersPerSide);
    } else {
      isActive =
          ValidationEngine.validateTournament(_tTeams, _tTeamCount) &&
          !_isGenerating;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kBg,
        boxShadow: [
          BoxShadow(
            color: kAccent.withOpacity(0.05),
            blurRadius: 32,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isActive
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FootballScoreboardScreen(
                      homeTeam: _fTeams[0],
                      awayTeam: _fTeams[1],
                      durationMinutes: _fDuration,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          _mode == MatchMode.friendly ? "START MATCH" : "CREATE TOURNAMENT",
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
