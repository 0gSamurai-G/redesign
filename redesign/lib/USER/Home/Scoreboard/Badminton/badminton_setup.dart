import 'dart:math';
import 'package:flutter/material.dart';

/// ─────────────────────────────────────────
/// 🎨 SPOTIFY DARK TOKENS
/// ─────────────────────────────────────────

const kBg = Color(0xFF000000);
const kCard = Color(0xFF121212);
const kCardElevated = Color(0xFF1E1E1E);
const kCardInteractive = Color(0xFF2A2A2A);

const kAccent = Color(0xFF1DB954);
const kAccentGlow = Color(0xFF1ED760);

const kTextPrimary = Color(0xFFFFFFFF);
const kTextSecondary = Color(0xFFB3B3B3);
const kTextMuted = Color(0xFF777777);

const kSuccess = Color(0xFF22C55E);
const kWarning = Color(0xFFFACC15);
const kDanger = Color(0xFFEF4444);
const kInfo = Color(0xFF3B82F6);

/// ─────────────────────────────────────────
/// 🧩 ENUMS
/// ─────────────────────────────────────────

enum SetupMode { friendly, tournament }

enum TournamentFormat { knockout, league, hybrid }

enum TeamSide { a, b }

/// ─────────────────────────────────────────
/// 🧩 MODELS — FRIENDLY
/// ─────────────────────────────────────────

class Player {
  final String id;
  final String name;

  Player(this.name) : id = UniqueKey().toString();
}

class FriendlyTeam {
  String name;
  Color color;
  List<Player> players;

  FriendlyTeam({required this.name, required this.color}) : players = [];
}

/// ─────────────────────────────────────────
/// 🧩 MODELS — KNOCKOUT
/// ─────────────────────────────────────────

class BracketMatch {
  String? player1;
  String? player2;

  BracketMatch({this.player1, this.player2});
}

class Seed {
  final int position;
  String? player;

  Seed(this.position, {this.player});
}

/// ─────────────────────────────────────────
/// 🧩 MODELS — LEAGUE
/// ─────────────────────────────────────────

class LeagueTeam {
  String name;
  int rank;
  List<String> players;

  LeagueTeam({required this.name, required this.rank, List<String>? players})
    : players = players ?? [];
}

class LeagueMatch {
  final LeagueTeam home;
  final LeagueTeam away;

  LeagueMatch(this.home, this.away);
}

/// ─────────────────────────────────────────
/// 🧩 MODELS — HYBRID
/// ─────────────────────────────────────────

class Group {
  final String name;
  final List<int> participants;
  Group(this.name, this.participants);
}

class MatchModel {
  final String playerA;
  final String playerB;
  MatchModel(this.playerA, this.playerB);
}

/// ─────────────────────────────────────────
/// ⚙ BRACKET ENGINE
/// ─────────────────────────────────────────

class BracketEngine {
  static int calculateRounds(int participants) {
    return (log(participants) / log(2)).round();
  }

  static int calculateMatches(int participants) {
    return participants - 1;
  }

  static List<BracketMatch> generateBracket(
    List<String> players,
    bool shuffle,
  ) {
    final list = List<String>.from(players);
    if (shuffle) list.shuffle();

    List<BracketMatch> matches = [];

    for (int i = 0; i < list.length; i += 2) {
      matches.add(
        BracketMatch(
          player1: list[i],
          player2: i + 1 < list.length ? list[i + 1] : "BYE",
        ),
      );
    }

    return matches;
  }
}

/// ─────────────────────────────────────────
/// ⚙ SEEDING ENGINE
/// ─────────────────────────────────────────

class SeedingEngine {
  static List<Seed> generateSeeds(int maxSeeds) {
    return List.generate(maxSeeds, (i) => Seed(i + 1));
  }

  static bool validateSeeds(List<Seed> seeds) {
    final assigned = seeds.where((s) => s.player != null).length;
    return assigned == seeds.length;
  }
}

/// ─────────────────────────────────────────
/// ⚙ SCHEDULE ENGINE (KNOCKOUT)
/// ─────────────────────────────────────────

class KnockoutScheduleEngine {
  static int estimateDuration(int matches, int courts, int avgMatchMinutes) {
    final totalMinutes = matches * avgMatchMinutes;
    return (totalMinutes / (courts * 60)).ceil();
  }
}

/// ─────────────────────────────────────────
/// ⚙ KNOCKOUT VALIDATION ENGINE
/// ─────────────────────────────────────────

class KnockoutValidationEngine {
  static bool isPowerOfTwo(int n) {
    return (n & (n - 1)) == 0;
  }

  static bool canCreateTournament({
    required bool identityValid,
    required bool structureValid,
    required bool seedingValid,
  }) {
    return identityValid && structureValid && seedingValid;
  }
}

/// ─────────────────────────────────────────
/// ⚙ LEAGUE ENGINE
/// ─────────────────────────────────────────

class LeagueEngine {
  static List<LeagueMatch> generateRoundRobin(List<LeagueTeam> teams) {
    List<LeagueMatch> matches = [];
    for (int i = 0; i < teams.length; i++) {
      for (int j = i + 1; j < teams.length; j++) {
        matches.add(LeagueMatch(teams[i], teams[j]));
      }
    }
    return matches;
  }

  static int calculateMatches(int n) {
    return (n * (n - 1)) ~/ 2;
  }
}

/// ─────────────────────────────────────────
/// ⚙ LEAGUE VALIDATION ENGINE
/// ─────────────────────────────────────────

class LeagueValidationEngine {
  static bool validate({
    required String name,
    required int teams,
    required int squadSize,
    required List<LeagueTeam> teamList,
  }) {
    if (name.trim().isEmpty) return false;
    if (teams < 2) return false;
    if (teamList.length != teams) return false;

    final allPlayers = <String>{};

    for (final t in teamList) {
      if (t.players.length > squadSize) return false;
      for (final p in t.players) {
        if (allPlayers.contains(p)) return false;
        allPlayers.add(p);
      }
    }

    return true;
  }
}

/// ─────────────────────────────────────────
/// ⚙ GROUP ENGINE (HYBRID)
/// ─────────────────────────────────────────

class GroupEngine {
  static List<Group> generateGroups(int totalParticipants, int groups) {
    final perGroup = totalParticipants ~/ groups;
    List<Group> result = [];

    int counter = 1;
    for (int i = 0; i < groups; i++) {
      result.add(
        Group(
          "Group ${String.fromCharCode(65 + i)}",
          List.generate(perGroup, (_) => counter++),
        ),
      );
    }
    return result;
  }

  static List<MatchModel> generateGroupMatches(Group g) {
    List<MatchModel> matches = [];
    for (int i = 0; i < g.participants.length; i++) {
      for (int j = i + 1; j < g.participants.length; j++) {
        matches.add(
          MatchModel("P${g.participants[i]}", "P${g.participants[j]}"),
        );
      }
    }
    return matches;
  }
}

/// ─────────────────────────────────────────
/// ⚙ KNOCKOUT ENGINE (HYBRID)
/// ─────────────────────────────────────────

class HybridKnockoutEngine {
  static List<MatchModel> generateBracket(int knockoutPlayers) {
    List<MatchModel> matches = [];
    for (int i = 1; i <= knockoutPlayers ~/ 2; i++) {
      matches.add(MatchModel("Seed $i", "Seed ${knockoutPlayers - i + 1}"));
    }
    return matches;
  }
}

/// ─────────────────────────────────────────
/// ⚙ SCHEDULE ENGINE (HYBRID)
/// ─────────────────────────────────────────

class HybridScheduleEngine {
  static int estimateDays(int matches, int courts) {
    final matchesPerDay = courts * 20;
    return (matches / matchesPerDay).ceil();
  }
}

/// ─────────────────────────────────────────
/// 🏸 UNIFIED BADMINTON SETUP SCREEN
/// ─────────────────────────────────────────

class BadmintonSetupScreen extends StatefulWidget {
  const BadmintonSetupScreen({super.key});

  @override
  State<BadmintonSetupScreen> createState() => _BadmintonSetupScreenState();
}

class _BadmintonSetupScreenState extends State<BadmintonSetupScreen> {
  /// ───────────────────────────────────────
  /// PRIMARY / SECONDARY MODE
  /// ───────────────────────────────────────

  SetupMode _mode = SetupMode.friendly;
  TournamentFormat _format = TournamentFormat.knockout;

  /// ───────────────────────────────────────
  /// FRIENDLY STATE
  /// ───────────────────────────────────────

  bool _isDoubles = false;

  final FriendlyTeam _teamA = FriendlyTeam(name: "Team A", color: kAccent);
  final FriendlyTeam _teamB = FriendlyTeam(name: "Team B", color: kInfo);

  TeamSide? _coinWinner;
  String? _decision;

  TeamSide? _servingTeam;
  Player? _firstServer;

  bool _enableLets = true;
  bool _enableFaultOverride = false;

  /// ───────────────────────────────────────
  /// KNOCKOUT STATE
  /// ───────────────────────────────────────

  final int _koParticipants = 32;
  bool _shuffleBracket = false;

  final List<String> _koPlayers = List.generate(32, (i) => "Player ${i + 1}");

  late List<Seed> _seeds;
  List<BracketMatch> _bracket = [];

  /// ───────────────────────────────────────
  /// LEAGUE STATE
  /// ───────────────────────────────────────

  String _tournamentName = "Winter Super League";
  int _leagueTotalTeams = 8;
  int _squadSize = 4;

  final int _pointsWin = 2;
  final int _pointsLoss = 0;

  final List<String> _tieBreakers = [
    "Matches Won",
    "Game Difference",
    "Point Difference",
    "Head-to-Head",
  ];

  List<LeagueTeam> _leagueTeams = [];
  List<LeagueMatch> _leagueMatches = [];

  /// ───────────────────────────────────────
  /// HYBRID STATE
  /// ───────────────────────────────────────

  int _hybridTotalParticipants = 32;
  int _playersPerTeam = 1;
  int _groupCount = 8;
  int _qualifiersPerGroup = 2;

  int _availableCourts = 4;

  bool _rallyScoring = true;
  bool _intervalEnabled = true;
  bool _changeEnds = true;
  bool _serviceRotation = true;

  List<Group> _groups = [];
  List<MatchModel> _groupMatches = [];
  List<MatchModel> _hybridKnockoutMatches = [];

  /// ───────────────────────────────────────
  /// FRIENDLY VALIDATION
  /// ───────────────────────────────────────

  bool get _isRosterValid {
    final requiredCount = _isDoubles ? 2 : 1;
    return _teamA.players.length == requiredCount &&
        _teamB.players.length == requiredCount;
  }

  bool get _isCoinComplete => _coinWinner != null && _decision != null;

  bool get _isServiceReady => _servingTeam != null && _firstServer != null;

  bool get _engineReady => _isRosterValid && _isCoinComplete && _isServiceReady;

  bool _isDuplicate(Player player) {
    return _teamA.players.any((p) => p.id == player.id) ||
        _teamB.players.any((p) => p.id == player.id);
  }

  void _addPlayer(FriendlyTeam team) async {
    final player = Player("Player ${DateTime.now().second}");
    if (_isDuplicate(player)) return;

    final maxP = _isDoubles ? 2 : 1;
    if (team.players.length >= maxP) return;

    setState(() {
      team.players.add(player);
    });
  }

  void _removePlayer(FriendlyTeam team, Player player) {
    setState(() {
      team.players.remove(player);
      if (_firstServer == player) _firstServer = null;
    });
  }

  /// ───────────────────────────────────────
  /// LEAGUE VALIDATION
  /// ───────────────────────────────────────

  bool get _isLeagueValid => LeagueValidationEngine.validate(
    name: _tournamentName,
    teams: _leagueTotalTeams,
    squadSize: _squadSize,
    teamList: _leagueTeams,
  );

  /// ───────────────────────────────────────
  /// HYBRID VALIDATION
  /// ───────────────────────────────────────

  bool get _isHybridValid =>
      _hybridTotalParticipants % _groupCount == 0 &&
      _qualifiersPerGroup < (_hybridTotalParticipants ~/ _groupCount);

  /// ───────────────────────────────────────
  /// INIT STATE
  /// ───────────────────────────────────────

  @override
  void initState() {
    super.initState();

    // Knockout init
    _seeds = SeedingEngine.generateSeeds(8);
    _generateKnockoutBracket();

    // League init
    _initLeagueTeams();

    // Hybrid init
    _regenerateHybrid();
  }

  void _generateKnockoutBracket() {
    _bracket = BracketEngine.generateBracket(_koPlayers, _shuffleBracket);
    setState(() {});
  }

  void _initLeagueTeams() {
    _leagueTeams = List.generate(
      _leagueTotalTeams,
      (i) => LeagueTeam(name: "Team ${i + 1}", rank: i + 1),
    );
    _generateLeagueMatches();
  }

  void _generateLeagueMatches() {
    _leagueMatches = LeagueEngine.generateRoundRobin(_leagueTeams);
    setState(() {});
  }

  void _regenerateHybrid() {
    _groups = GroupEngine.generateGroups(_hybridTotalParticipants, _groupCount);

    _groupMatches = [];
    for (final g in _groups) {
      _groupMatches.addAll(GroupEngine.generateGroupMatches(g));
    }

    final koPlayers = _groupCount * _qualifiersPerGroup;
    _hybridKnockoutMatches = HybridKnockoutEngine.generateBracket(koPlayers);

    setState(() {});
  }

  /// ───────────────────────────────────────
  /// 🧱 BUILD
  /// ───────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _sliver(_modeSelector()),
            if (_mode == SetupMode.tournament)
              _sliver(_tournamentFormatSelector()),
            ..._buildContent().map((w) => _sliver(w)),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🔀 DYNAMIC CONTENT BUILDER
  /// ───────────────────────────────────────

  List<Widget> _buildContent() {
    if (_mode == SetupMode.friendly) {
      return [
        _matchFormatCard(),
        _rosterSection(),
        _rulesEngine(),
        _coinTossCard(),
        _serviceEngineCard(),
        _validationCard(),
        _initializeButton(),
      ];
    }

    switch (_format) {
      case TournamentFormat.knockout:
        return [_koStructureCard(), _seedingCard(), _bracketCard()];

      case TournamentFormat.league:
        return [
          TournamentIdentityCard(
            name: _tournamentName,
            onNameChanged: (v) => setState(() => _tournamentName = v),
          ),
          LeagueStructureEngineCard(
            teams: _leagueTotalTeams,
            squadSize: _squadSize,
            onTeamsChanged: (v) {
              _leagueTotalTeams = v;
              _initLeagueTeams();
            },
            onSquadChanged: (v) => setState(() => _squadSize = v),
          ),
          TeamManagementCard(teams: _leagueTeams, squadSize: _squadSize),
          const LeagueRuleEngineCard(),
          StandingsLogicCard(
            win: _pointsWin,
            loss: _pointsLoss,
            tieBreakers: _tieBreakers,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final item = _tieBreakers.removeAt(oldIndex);
                _tieBreakers.insert(newIndex, item);
              });
            },
          ),
          MatchGeneratorCard(matches: _leagueMatches),
          LeagueSystemCheckCard(valid: _isLeagueValid),
          CreateLeagueButton(enabled: _isLeagueValid),
        ];

      case TournamentFormat.hybrid:
        return [
          _hybridDescriptionCard(),
          _hybridStructureCard(),
          _groupConfigCard(),
          _qualificationCard(),
          _knockoutPreview(),
          _hybridRuleCard(),
          _scheduleCard(),
          _systemCard(),
          _hybridCreateButton(),
        ];
    }
  }

  /// ───────────────────────────────────────
  /// 🧱 SHARED HELPERS
  /// ───────────────────────────────────────

  SliverToBoxAdapter _sliver(Widget child) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: child,
    ),
  );

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _segButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? kAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : kTextSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: kTextSecondary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _check(String text, bool valid) {
    return Row(
      children: [
        Icon(
          valid ? Icons.check_circle : Icons.error,
          color: valid ? kSuccess : kWarning,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: kTextPrimary)),
      ],
    );
  }

  Widget _stepper(
    String label,
    int value,
    Function(int) onChanged, {
    int min = 2,
    int max = 512,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: kTextPrimary)),
        Row(
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove, color: kTextSecondary),
            ),
            Text("$value", style: const TextStyle(color: kTextPrimary)),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add, color: kTextSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusRow(bool ok, String label) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.error,
          color: ok ? kSuccess : kDanger,
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: ok ? kSuccess : kDanger)),
      ],
    );
  }

  /// ───────────────────────────────────────
  /// 🥇 PRIMARY MODE SELECTOR
  /// ───────────────────────────────────────

  Widget _modeSelector() {
    return _card(
      child: Row(
        children: [
          _segButton("Friendly", _mode == SetupMode.friendly, () {
            setState(() => _mode = SetupMode.friendly);
          }),
          _segButton("Tournament", _mode == SetupMode.tournament, () {
            setState(() => _mode = SetupMode.tournament);
          }),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🥈 SECONDARY TOURNAMENT FORMAT SELECTOR
  /// ───────────────────────────────────────

  Widget _tournamentFormatSelector() {
    return _card(
      child: Row(
        children: [
          _segButton("Knockout", _format == TournamentFormat.knockout, () {
            setState(() => _format = TournamentFormat.knockout);
          }),
          _segButton("League", _format == TournamentFormat.league, () {
            setState(() => _format = TournamentFormat.league);
          }),
          _segButton("Hybrid", _format == TournamentFormat.hybrid, () {
            setState(() => _format = TournamentFormat.hybrid);
          }),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏸 FRIENDLY — MATCH FORMAT
  /// ───────────────────────────────────────

  Widget _matchFormatCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MATCH FORMAT",
            style: TextStyle(
              color: kTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _segButton("Singles", !_isDoubles, () {
                setState(() => _isDoubles = false);
              }),
              _segButton("Doubles", _isDoubles, () {
                setState(() => _isDoubles = true);
              }),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _isDoubles ? "2 vs 2" : "1 vs 1",
            style: const TextStyle(
              color: kTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "3 × 21 pts • Cap 30 • Interval at 11",
            style: TextStyle(color: kTextMuted),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏸 FRIENDLY — ROSTER
  /// ───────────────────────────────────────

  Widget _rosterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_teamCard(_teamA), _teamCard(_teamB)],
    );
  }

  Widget _teamCard(FriendlyTeam team) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            team.name,
            style: TextStyle(color: team.color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...team.players.map((p) => _playerChip(team, p)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _addPlayer(team),
            style: ElevatedButton.styleFrom(backgroundColor: team.color),
            child: const Text("+ Add Player"),
          ),
        ],
      ),
    );
  }

  Widget _playerChip(FriendlyTeam team, Player p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kCardElevated,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Text(p.name, style: const TextStyle(color: kTextPrimary)),
          ),
          IconButton(
            onPressed: () => _removePlayer(team, p),
            icon: const Icon(Icons.close, color: kDanger),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏸 FRIENDLY — RULES ENGINE
  /// ───────────────────────────────────────

  Widget _rulesEngine() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "RULES ENGINE (BWF STD)",
            style: TextStyle(
              color: kTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SwitchListTile(
            value: _enableLets,
            activeColor: kAccent,
            onChanged: (v) => setState(() => _enableLets = v),
            title: const Text(
              "Enable Lets",
              style: TextStyle(color: kTextPrimary),
            ),
          ),
          SwitchListTile(
            value: _enableFaultOverride,
            activeColor: kAccent,
            onChanged: (v) => setState(() => _enableFaultOverride = v),
            title: const Text(
              "Enable Fault Override",
              style: TextStyle(color: kTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏸 FRIENDLY — COIN TOSS
  /// ───────────────────────────────────────

  Widget _coinTossCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PRE-MATCH PROTOCOL",
            style: TextStyle(
              color: kTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _segButton("Team A", _coinWinner == TeamSide.a, () {
                setState(() => _coinWinner = TeamSide.a);
              }),
              _segButton("Team B", _coinWinner == TeamSide.b, () {
                setState(() => _coinWinner = TeamSide.b);
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏸 FRIENDLY — SERVICE ENGINE
  /// ───────────────────────────────────────

  Widget _serviceEngineCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SERVICE ENGINE",
            style: TextStyle(
              color: kTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButton<TeamSide>(
            dropdownColor: kCardElevated,
            value: _servingTeam,
            hint: const Text(
              "Serving Team",
              style: TextStyle(color: kTextMuted),
            ),
            items: const [
              DropdownMenuItem(value: TeamSide.a, child: Text("Team A")),
              DropdownMenuItem(value: TeamSide.b, child: Text("Team B")),
            ],
            onChanged: (v) => setState(() => _servingTeam = v),
          ),
          const SizedBox(height: 12),
          const Text(
            "Start Side: Even (Right)",
            style: TextStyle(color: kTextSecondary),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏸 FRIENDLY — VALIDATION
  /// ───────────────────────────────────────

  Widget _validationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MATCH VALIDATION",
            style: TextStyle(
              color: kTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _check("Roster valid", _isRosterValid),
          _check("Coin toss complete", _isCoinComplete),
          _check("Service ready", _isServiceReady),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏸 FRIENDLY — INITIALIZE BUTTON
  /// ───────────────────────────────────────

  Widget _initializeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _engineReady ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Initialize Match →",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 KNOCKOUT — STRUCTURE CARD
  /// ───────────────────────────────────────

  Widget _koStructureCard() {
    final rounds = BracketEngine.calculateRounds(_koParticipants);
    final matches = BracketEngine.calculateMatches(_koParticipants);

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("STRUCTURE ENGINE"),
          const SizedBox(height: 12),
          Text(
            "Participants: $_koParticipants",
            style: const TextStyle(color: kTextPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            "Rounds: $rounds",
            style: const TextStyle(color: kTextSecondary),
          ),
          Text(
            "Matches: $matches",
            style: const TextStyle(color: kTextSecondary),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kAccent),
            onPressed: () {
              _shuffleBracket = !_shuffleBracket;
              _generateKnockoutBracket();
            },
            child: const Text("Shuffle Bracket"),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 KNOCKOUT — SEEDING CARD
  /// ───────────────────────────────────────

  Widget _seedingCard() {
    final valid = SeedingEngine.validateSeeds(_seeds);

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("SEEDING ENGINE"),
          const SizedBox(height: 12),
          ..._seeds.map(
            (seed) => ListTile(
              title: Text(
                "Seed ${seed.position}",
                style: const TextStyle(color: kTextPrimary),
              ),
              subtitle: Text(
                seed.player ?? "Unassigned",
                style: const TextStyle(color: kTextMuted),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add, color: kAccent),
                onPressed: () {
                  setState(() {
                    seed.player = "Player ${seed.position}";
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            valid ? "VALID ✓" : "INCOMPLETE",
            style: TextStyle(color: valid ? kSuccess : kDanger),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 KNOCKOUT — BRACKET CARD
  /// ───────────────────────────────────────

  Widget _bracketCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("BRACKET PREVIEW"),
          const SizedBox(height: 12),
          ..._bracket.map(
            (match) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kCardElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${match.player1} vs ${match.player2}",
                style: const TextStyle(color: kTextPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — DESCRIPTION
  /// ───────────────────────────────────────

  Widget _hybridDescriptionCard() {
    return _card(
      child: const Text(
        "Group Stage + Knockout\n\nPlayers compete in round robin groups first. Top performers qualify for elimination bracket.",
        style: TextStyle(color: kTextSecondary),
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — STRUCTURE CARD
  /// ───────────────────────────────────────

  Widget _hybridStructureCard() {
    return _card(
      child: Column(
        children: [
          _stepper("Total Participants", _hybridTotalParticipants, (v) {
            _hybridTotalParticipants = v;
            _regenerateHybrid();
          }, min: 4),
          _stepper(
            "Players per Team",
            _playersPerTeam,
            (v) {
              setState(() => _playersPerTeam = v);
            },
            min: 1,
            max: 2,
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — GROUP CONFIG
  /// ───────────────────────────────────────

  Widget _groupConfigCard() {
    return _card(
      child: Column(
        children: [
          _stepper("Number of Groups", _groupCount, (v) {
            _groupCount = v;
            _regenerateHybrid();
          }),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _groups
                  .map(
                    (g) => Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kCardElevated,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.name,
                            style: const TextStyle(color: kTextPrimary),
                          ),
                          Text(
                            "${g.participants.length} Players",
                            style: const TextStyle(color: kTextMuted),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — QUALIFICATION
  /// ───────────────────────────────────────

  Widget _qualificationCard() {
    final ko = _groupCount * _qualifiersPerGroup;

    return _card(
      child: Column(
        children: [
          _stepper(
            "Qualifiers per Group",
            _qualifiersPerGroup,
            (v) {
              _qualifiersPerGroup = v;
              _regenerateHybrid();
            },
            min: 1,
            max: (_hybridTotalParticipants ~/ _groupCount) - 1,
          ),
          const SizedBox(height: 12),
          Text(
            "$_hybridTotalParticipants → $ko → Champion",
            style: const TextStyle(color: kTextSecondary),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — KNOCKOUT PREVIEW
  /// ───────────────────────────────────────

  Widget _knockoutPreview() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Knockout Preview", style: TextStyle(color: kTextPrimary)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _hybridKnockoutMatches
                  .map(
                    (m) => Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kCardElevated,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "${m.playerA} vs ${m.playerB}",
                        style: const TextStyle(color: kTextPrimary),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — RULE CARD
  /// ───────────────────────────────────────

  Widget _hybridRuleCard() {
    return _card(
      child: Column(
        children: [
          _hybridToggle(
            "Rally Scoring",
            _rallyScoring,
            (v) => setState(() => _rallyScoring = v),
          ),
          _hybridToggle(
            "Interval at 11",
            _intervalEnabled,
            (v) => setState(() => _intervalEnabled = v),
          ),
          _hybridToggle(
            "Change Ends",
            _changeEnds,
            (v) => setState(() => _changeEnds = v),
          ),
          _hybridToggle(
            "Service Rotation",
            _serviceRotation,
            (v) => setState(() => _serviceRotation = v),
          ),
        ],
      ),
    );
  }

  Widget _hybridToggle(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      activeColor: kAccent,
      onChanged: onChanged,
      title: Text(label, style: const TextStyle(color: kTextPrimary)),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — SCHEDULE
  /// ───────────────────────────────────────

  Widget _scheduleCard() {
    final totalMatches = _groupMatches.length + _hybridKnockoutMatches.length;
    final days = HybridScheduleEngine.estimateDays(
      totalMatches,
      _availableCourts,
    );

    return _card(
      child: Column(
        children: [
          _stepper(
            "Available Courts",
            _availableCourts,
            (v) {
              setState(() => _availableCourts = v);
            },
            min: 1,
            max: 20,
          ),
          const SizedBox(height: 12),
          Text(
            "Estimated Duration: $days Day(s)",
            style: const TextStyle(color: kTextSecondary),
          ),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — SYSTEM CHECK
  /// ───────────────────────────────────────

  Widget _systemCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statusRow(_isHybridValid, "Group & Qualification Valid"),
          _statusRow(_hybridKnockoutMatches.isNotEmpty, "Knockout Generated"),
        ],
      ),
    );
  }

  /// ───────────────────────────────────────
  /// 🏆 HYBRID — CREATE BUTTON
  /// ───────────────────────────────────────

  Widget _hybridCreateButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: _isHybridValid ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          minimumSize: const Size(double.infinity, 56),
        ),
        child: const Text(
          "Create Hybrid Tournament →",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────
/// 🧩 LEAGUE MODULAR CARD WIDGETS
/// ─────────────────────────────────────────

class TournamentIdentityCard extends StatelessWidget {
  final String name;
  final ValueChanged<String> onNameChanged;

  const TournamentIdentityCard({
    super.key,
    required this.name,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _leagueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leagueSection("TOURNAMENT IDENTITY"),
          const SizedBox(height: 12),
          TextField(
            style: const TextStyle(color: kTextPrimary),
            decoration: const InputDecoration(
              hintText: "Tournament Name",
              hintStyle: TextStyle(color: kTextMuted),
            ),
            controller: TextEditingController(text: name),
            onChanged: onNameChanged,
          ),
        ],
      ),
    );
  }
}

class LeagueStructureEngineCard extends StatelessWidget {
  final int teams;
  final int squadSize;
  final ValueChanged<int> onTeamsChanged;
  final ValueChanged<int> onSquadChanged;

  const LeagueStructureEngineCard({
    super.key,
    required this.teams,
    required this.squadSize,
    required this.onTeamsChanged,
    required this.onSquadChanged,
  });

  @override
  Widget build(BuildContext context) {
    final matches = LeagueEngine.calculateMatches(teams);

    return _leagueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leagueSection("STRUCTURE ENGINE"),
          const SizedBox(height: 12),
          _leagueStepper("Total Teams", teams, onTeamsChanged),
          _leagueStepper("Squad Size", squadSize, onSquadChanged),
          const SizedBox(height: 8),
          Text(
            "Total Matches: $matches",
            style: const TextStyle(color: kTextSecondary),
          ),
        ],
      ),
    );
  }
}

class TeamManagementCard extends StatelessWidget {
  final List<LeagueTeam> teams;
  final int squadSize;

  const TeamManagementCard({
    super.key,
    required this.teams,
    required this.squadSize,
  });

  @override
  Widget build(BuildContext context) {
    return _leagueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leagueSection("TEAM MANAGEMENT"),
          const SizedBox(height: 12),
          ...teams.map(
            (t) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kCardElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(t.name, style: const TextStyle(color: kTextPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}

class LeagueRuleEngineCard extends StatelessWidget {
  const LeagueRuleEngineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _leagueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leagueSection("RULE ENGINE"),
          const SizedBox(height: 12),
          _leagueToggle("Rally Scoring System"),
          _leagueToggle("Max Score Cap (30)"),
          _leagueToggle("Interval at 11"),
          _leagueToggle("Match History Logging"),
        ],
      ),
    );
  }
}

class StandingsLogicCard extends StatelessWidget {
  final int win;
  final int loss;
  final List<String> tieBreakers;
  final Function(int, int) onReorder;

  const StandingsLogicCard({
    super.key,
    required this.win,
    required this.loss,
    required this.tieBreakers,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return _leagueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leagueSection("STANDINGS LOGIC"),
          const SizedBox(height: 12),
          Text(
            "Points for Win: $win",
            style: const TextStyle(color: kTextPrimary),
          ),
          Text(
            "Points for Loss: $loss",
            style: const TextStyle(color: kTextPrimary),
          ),
          const SizedBox(height: 12),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: onReorder,
            children: tieBreakers
                .map(
                  (e) => ListTile(
                    key: ValueKey(e),
                    title: Text(e, style: const TextStyle(color: kTextPrimary)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class MatchGeneratorCard extends StatelessWidget {
  final List<LeagueMatch> matches;

  const MatchGeneratorCard({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    return _leagueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leagueSection("MATCH GENERATOR"),
          const SizedBox(height: 12),
          ...matches
              .take(4)
              .map(
                (m) => Text(
                  "${m.home.name} vs ${m.away.name}",
                  style: const TextStyle(color: kTextPrimary),
                ),
              ),
        ],
      ),
    );
  }
}

class LeagueSystemCheckCard extends StatelessWidget {
  final bool valid;

  const LeagueSystemCheckCard({super.key, required this.valid});

  @override
  Widget build(BuildContext context) {
    return _leagueCard(
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle : Icons.error,
            color: valid ? kSuccess : kDanger,
          ),
          const SizedBox(width: 8),
          Text(
            valid ? "League Ready" : "Configuration Incomplete",
            style: TextStyle(color: valid ? kSuccess : kDanger),
          ),
        ],
      ),
    );
  }
}

class CreateLeagueButton extends StatelessWidget {
  final bool enabled;

  const CreateLeagueButton({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: enabled ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? kAccent : kCardInteractive,
          minimumSize: const Size(double.infinity, 56),
        ),
        child: const Text(
          "Create League Tournament →",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────
/// 🎨 LEAGUE TOP-LEVEL HELPERS
/// ─────────────────────────────────────────

Widget _leagueCard({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );
}

Widget _leagueSection(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: kTextSecondary,
      letterSpacing: 1.2,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _leagueToggle(String label) {
  return SwitchListTile(
    value: true,
    onChanged: (_) {},
    activeColor: kAccent,
    title: Text(label, style: const TextStyle(color: kTextPrimary)),
  );
}

Widget _leagueStepper(String label, int value, Function(int) onChange) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: kTextPrimary)),
      Row(
        children: [
          IconButton(
            onPressed: () => onChange(max(2, value - 1)),
            icon: const Icon(Icons.remove, color: kTextSecondary),
          ),
          Text("$value", style: const TextStyle(color: kTextPrimary)),
          IconButton(
            onPressed: () => onChange(value + 1),
            icon: const Icon(Icons.add, color: kTextSecondary),
          ),
        ],
      ),
    ],
  );
}
