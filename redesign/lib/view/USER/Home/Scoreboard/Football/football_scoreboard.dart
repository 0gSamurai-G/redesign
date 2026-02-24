import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'football_setup.dart' as setup; // Alias to avoid collision

// ─────────────────────────────────────────────────────────────────────────────
// 🎨 THEME & CONSTANTS (Spotify Dark)
// ─────────────────────────────────────────────────────────────────────────────

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF121212);
const kSurfaceHighlight = Color(0xFF2A2A2A);
const kAccent = Color(0xFF1DB954);
const kGoal = Color(0xFF22C55E);
const kYellow = Color(0xFFFACC15);
const kRed = Color(0xFFEF4444);
const kTextPrimary = Color(0xFFFFFFFF);
const kTextSecondary = Color(0xFFB3B3B3);
const kTextMuted = Color(0xFF777777);

const kSuccess = Color(0xFF22C55E);
const kWarning = Color(0xFFFACC15);
const kDivider = Color(0xFF2A2A2A);

// ─────────────────────────────────────────────────────────────────────────────
// 🧠 PROFESSIONAL MATCH MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum MatchPhase {
  preMatch,
  firstHalf,
  halfTime,
  secondHalf,
  fullTime,
  extraTimeFirst,
  extraTimeHalf,
  extraTimeSecond,
  penalties,
}

enum EventType {
  goal,
  yellowCard,
  redCard,
  substitution,
  whistle,
  varCheck,
  injuryTime,
}

enum TeamSide { home, away }

class MatchPlayer {
  final String id;
  final String name;
  final int number;

  // State
  bool isStarter;
  bool isOnPitch;
  bool isSubstitutedOut;
  bool isSentOff;

  // Stats
  int goals = 0;
  int assists = 0;
  int yellowCards = 0;
  int redCards = 0;

  MatchPlayer({
    required this.id,
    required this.name,
    this.number = 0,
    this.isStarter = false,
  }) : isOnPitch = isStarter,
       isSubstitutedOut = false,
       isSentOff = false;
}

class MatchTeam {
  final String id;
  final String name;
  final Color color;
  final List<MatchPlayer> squad;

  // Rule State
  int substitutionsUsed = 0;
  int substitutionWindowsUsed = 0; // Professional rule: 3 windows max

  MatchTeam({
    required this.id,
    required this.name,
    required this.color,
    required this.squad,
  });

  List<MatchPlayer> get pitchPlayers =>
      squad.where((p) => p.isOnPitch).toList();
  List<MatchPlayer> get benchPlayers => squad
      .where((p) => !p.isOnPitch && !p.isSubstitutedOut && !p.isSentOff)
      .toList();
}

class MatchEvent {
  final String id;
  final int realMinute; // Actual minute of game
  final int displayMinute; // 45, 90, etc.
  final int addedMinute; // +2, +4
  final EventType type;
  final TeamSide? side;
  final String title;
  final String subtitle;
  final String? playerId;
  final String? assistId;
  final String? subInId;
  final String? subOutId;
  final IconData icon;
  final Color color;

  MatchEvent({
    required this.realMinute,
    required this.displayMinute,
    this.addedMinute = 0,
    required this.type,
    this.side,
    required this.title,
    required this.subtitle,
    this.playerId,
    this.assistId,
    this.subInId,
    this.subOutId,
    required this.icon,
    required this.color,
  }) : id = DateTime.now().microsecondsSinceEpoch
           .toString(); // Should use UUID in prod

  String get timeLabel {
    if (addedMinute > 0) return "$displayMinute+$addedMinute'";
    return "$displayMinute'";
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ⚙️ MATCH ENGINE (THE CORE)
// ─────────────────────────────────────────────────────────────────────────────

class MatchEngine extends ChangeNotifier {
  // Config
  final int halfDuration; // minutes
  final bool extraTimeEnabled;
  final bool penaltiesEnabled;
  final int maxSubs;

  // Teams
  late MatchTeam homeTeam;
  late MatchTeam awayTeam;

  // Unidirectional State Flow
  final ValueNotifier<int> seconds = ValueNotifier(0); // Raw seconds
  final ValueNotifier<int> addedSeconds = ValueNotifier(
    0,
  ); // Stoppage time accumulator
  final ValueNotifier<MatchPhase> phase = ValueNotifier(MatchPhase.preMatch);
  final ValueNotifier<bool> isRunning = ValueNotifier(false);
  final ValueNotifier<List<MatchEvent>> events = ValueNotifier([]);

  // Scores
  final ValueNotifier<int> homeScore = ValueNotifier(0);
  final ValueNotifier<int> awayScore = ValueNotifier(0);

  Timer? _timer;

  MatchEngine({
    required setup.Team home,
    required setup.Team away,
    this.halfDuration = 45,
    this.extraTimeEnabled = false,
    this.penaltiesEnabled = false,
    this.maxSubs = 5,
  }) {
    // Initialize Teams & Squads
    homeTeam = _initTeam(home);
    awayTeam = _initTeam(away);
  }

  MatchTeam _initTeam(setup.Team t) {
    // Logic to select starters vs bench (first 11 are starters for now)
    List<MatchPlayer> squad = [];
    for (int i = 0; i < t.players.length; i++) {
      squad.add(
        MatchPlayer(
          id: t.players[i].id,
          name: t.players[i].name,
          number: i + 1,
          isStarter: i < 11,
        ),
      );
    }
    // If no players, create dummy squad
    if (squad.isEmpty) {
      for (int i = 0; i < 16; i++) {
        squad.add(
          MatchPlayer(
            id: "p_$i",
            name: "Player ${i + 1}",
            number: i + 1,
            isStarter: i < 11,
          ),
        );
      }
    }

    return MatchTeam(id: t.id, name: t.name, color: t.color, squad: squad);
  }

  @override
  void dispose() {
    _timer?.cancel();
    seconds.dispose();
    addedSeconds.dispose();
    super.dispose();
  }

  // ─── CLOCK ENGINE ───

  void toggleTimer() {
    if (isRunning.value)
      _stopTimer();
    else
      _startTimer();
  }

  void _startTimer() {
    if (phase.value == MatchPhase.fullTime) return;

    if (phase.value == MatchPhase.preMatch) {
      endPhase(); // Start First Half
      return;
    }

    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Standard Time vs Stoppage Time Logic
      if (phase.value == MatchPhase.firstHalf &&
          seconds.value >= halfDuration * 60) {
        addedSeconds.value++;
      } else if (phase.value == MatchPhase.secondHalf &&
          seconds.value >= (halfDuration * 2) * 60) {
        addedSeconds.value++;
      } else {
        seconds.value++;
      }
    });
    notifyListeners();
  }

  void _stopTimer() {
    isRunning.value = false;
    _timer?.cancel();
    notifyListeners();
  }

  void endPhase() {
    _stopTimer();
    MatchPhase next = MatchPhase.fullTime;

    switch (phase.value) {
      case MatchPhase.preMatch:
        next = MatchPhase.firstHalf;
        seconds.value = 0;
        addedSeconds.value = 0;
        _log(EventType.whistle, null, "Match Started", "Kick Off");
        break;
      case MatchPhase.firstHalf:
        next = MatchPhase.halfTime;
        _log(EventType.whistle, null, "Half Time", "End of First Half");
        break;
      case MatchPhase.halfTime:
        next = MatchPhase.secondHalf;
        seconds.value = halfDuration * 60;
        addedSeconds.value = 0;
        _log(EventType.whistle, null, "Second Half", "Kick Off");
        break;
      case MatchPhase.secondHalf:
        // Check for Extra Time or End
        next = MatchPhase.fullTime;
        _log(EventType.whistle, null, "Full Time", "Match Ended");
        break;
      default:
        break;
    }
    phase.value = next;
    notifyListeners();
  }

  // ─── GAMEPLAY ACTIONS ───

  void processGoal(TeamSide side, MatchPlayer? scorer, MatchPlayer? assist) {
    if (side == TeamSide.home) {
      homeScore.value++;
      if (scorer != null) scorer.goals++;
      if (assist != null) assist.goals++; // Logic error fixed: assist.assists++
    } else {
      awayScore.value++;
      if (scorer != null) scorer.goals++;
    }

    _log(
      EventType.goal,
      side,
      "GOAL!",
      "${scorer?.name ?? 'Unknown'} (${assist != null ? 'ast. ${assist.name}' : 'Solo'})",
      icon: Icons.sports_soccer,
      color: kGoal,
      playerId: scorer?.id,
      assistId: assist?.id,
    );
    HapticFeedback.heavyImpact();
  }

  void processCard(
    TeamSide side,
    MatchPlayer player,
    EventType type,
    String reason,
  ) {
    if (type == EventType.yellowCard) {
      player.yellowCards++;
      if (player.yellowCards >= 2) {
        // Second Yellow -> Red Logiic
        _log(
          EventType.yellowCard,
          side,
          "2nd Yellow Card",
          "${player.name} (Sent Off)",
          color: kYellow,
          playerId: player.id,
        );
        _executeRedCard(side, player, "Second Booking");
      } else {
        _log(
          EventType.yellowCard,
          side,
          "Yellow Card",
          player.name,
          color: kYellow,
          playerId: player.id,
        );
      }
    } else {
      _executeRedCard(side, player, reason);
    }
    notifyListeners();
  }

  void _executeRedCard(TeamSide side, MatchPlayer player, String reason) {
    player.redCards++;
    player.isSentOff = true;
    player.isOnPitch = false;
    _log(
      EventType.redCard,
      side,
      "Red Card",
      "${player.name} - $reason",
      color: kRed,
      playerId: player.id,
    );
    HapticFeedback.heavyImpact();
  }

  bool processSubstitution(
    TeamSide side,
    MatchPlayer subOut,
    MatchPlayer subIn,
  ) {
    final team = side == TeamSide.home ? homeTeam : awayTeam;

    // Validate Rules
    if (team.substitutionsUsed >= maxSubs) return false;

    // Execute Sub
    subOut.isOnPitch = false;
    subOut.isSubstitutedOut = true;
    subIn.isOnPitch = true;

    team.substitutionsUsed++;

    _log(
      EventType.substitution,
      side,
      "Substitution",
      "IN: ${subIn.name}\nOUT: ${subOut.name}",
      icon: Icons.compare_arrows,
      color: kAccent,
      subInId: subIn.id,
      subOutId: subOut.id,
    );
    return true;
  }

  void _log(
    EventType type,
    TeamSide? side,
    String title,
    String subtitle, {
    IconData? icon,
    Color? color,
    String? playerId,
    String? assistId,
    String? subInId,
    String? subOutId,
  }) {
    // Calculate Display Time
    int currentMin = seconds.value ~/ 60;
    int displayMin = currentMin;
    int added = 0;

    if (phase.value == MatchPhase.firstHalf && currentMin >= halfDuration) {
      displayMin = halfDuration;
      added = currentMin - halfDuration;
    } else if (phase.value == MatchPhase.secondHalf &&
        currentMin >= halfDuration * 2) {
      displayMin = halfDuration * 2;
      added = currentMin - (halfDuration * 2);
    }

    final event = MatchEvent(
      realMinute: currentMin,
      displayMinute: displayMin,
      addedMinute: added,
      type: type,
      side: side,
      title: title,
      subtitle: subtitle,
      icon: icon ?? Icons.info,
      color: color ?? kTextPrimary,
      playerId: playerId,
      assistId: assistId,
      subInId: subInId,
      subOutId: subOutId,
    );

    List<MatchEvent> list = List.from(events.value);
    list.insert(0, event);
    events.value = list;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 📱 MAIN SCREEN UI
// ─────────────────────────────────────────────────────────────────────────────

class FootballScoreboardScreen extends StatefulWidget {
  final setup.Team homeTeam;
  final setup.Team awayTeam;
  final int durationMinutes;

  const FootballScoreboardScreen({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.durationMinutes,
  });

  @override
  State<FootballScoreboardScreen> createState() =>
      _FootballScoreboardScreenState();
}

class _FootballScoreboardScreenState extends State<FootballScoreboardScreen> {
  late MatchEngine _engine;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _engine = MatchEngine(
      home: widget.homeTeam,
      away: widget.awayTeam,
      halfDuration: widget.durationMinutes,
    );
  }

  @override
  void dispose() {
    _engine.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Container(height: 1, color: kDivider),
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [_buildEventFeed()],
              ),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ───

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: kSurface,
      child: Column(
        children: [
          // Teams & Scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeamBlock(
                _engine.homeTeam,
                _engine.homeScore,
                CrossAxisAlignment.start,
              ),
              _buildClock(),
              _buildTeamBlock(
                _engine.awayTeam,
                _engine.awayScore,
                CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClock() {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _engine.seconds,
          builder: (ctx, sec, _) {
            // Logic to display 45+2 etc
            int displaySec = sec;

            // Format mm:ss
            String min = (displaySec ~/ 60).toString().padLeft(2, '0');
            String s = (displaySec % 60).toString().padLeft(2, '0');

            return ValueListenableBuilder<int>(
              valueListenable: _engine.addedSeconds,
              builder: (ctx, added, _) {
                String timeStr = "$min:$s";
                if (added > 0)
                  timeStr +=
                      "+${(added ~/ 60) + 1}"; // Show +1 minute immediately
                return Text(
                  timeStr,
                  style: const TextStyle(
                    color: kAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder<MatchPhase>(
          valueListenable: _engine.phase,
          builder: (_, p, __) => _buildPhaseBadge(p),
        ),
      ],
    );
  }

  Widget _buildPhaseBadge(MatchPhase p) {
    String label = "PRE-MATCH";
    Color col = kTextSecondary;
    switch (p) {
      case MatchPhase.firstHalf:
        label = "1ST HALF";
        col = kSuccess;
        break;
      case MatchPhase.halfTime:
        label = "HALF TIME";
        col = kWarning;
        break;
      case MatchPhase.secondHalf:
        label = "2ND HALF";
        col = kSuccess;
        break;
      case MatchPhase.fullTime:
        label = "FULL TIME";
        col = kRed;
        break;
      default:
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: col.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTeamBlock(
    MatchTeam team,
    ValueNotifier<int> score,
    CrossAxisAlignment align,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(
            team.name,
            style: const TextStyle(
              color: kTextSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<int>(
            valueListenable: score,
            builder: (_, val, __) => Text(
              "$val",
              style: const TextStyle(
                color: kTextPrimary,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── EVENT FEED ───

  Widget _buildEventFeed() {
    return ValueListenableBuilder<List<MatchEvent>>(
      valueListenable: _engine.events,
      builder: (ctx, events, _) {
        if (events.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: Text(
                "Waiting for Kick Off...",
                style: TextStyle(color: kTextSecondary),
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final e = events[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: kDivider, width: 0.5)),
                color: kSurface,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      e.timeLabel,
                      style: const TextStyle(
                        color: kTextSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: e.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(e.icon, size: 18, color: e.color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: const TextStyle(
                            color: kTextPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (e.subtitle.isNotEmpty)
                          Text(
                            e.subtitle,
                            style: const TextStyle(
                              color: kTextMuted,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }, childCount: events.length),
        );
      },
    );
  }

  // ─── CONTROLS ───

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: kSurfaceHighlight,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildBigBtn(
                  "GOAL",
                  kGoal,
                  Icons.sports_soccer,
                  _showGoalModal,
                ),
                const SizedBox(width: 12),
                _buildBigBtn("CARD", kYellow, Icons.style, _showCardModal),
                const SizedBox(width: 12),
                _buildBigBtn(
                  "SUB",
                  kAccent,
                  Icons.compare_arrows,
                  _showSubModal,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _engine.isRunning,
                    builder: (_, run, __) => _buildAuxBtn(
                      run ? "PAUSE" : "RESUME",
                      run ? Icons.pause : Icons.play_arrow,
                      _engine.toggleTimer,
                      isActive: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAuxBtn("PHASE", Icons.flag, _engine.endPhase),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigBtn(
    String label,
    Color col,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Material(
        color: col.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: col, size: 28),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(color: col, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuxBtn(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return Material(
      color: isActive ? kAccent : kSurface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.black : kTextSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.black : kTextSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── MODALS (PROFESSIONAL WORKFLOWS) ───

  void _showGoalModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _GoalWorkflow(engine: _engine),
    );
  }

  void _showCardModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CardWorkflow(engine: _engine),
    );
  }

  void _showSubModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SubWorkflow(engine: _engine),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 🧬 WORKFLOW WIDGETS (Internal)
// ─────────────────────────────────────────────────────────────────────────────

class _GoalWorkflow extends StatefulWidget {
  final MatchEngine engine;
  const _GoalWorkflow({required this.engine});
  @override
  State<_GoalWorkflow> createState() => _GoalWorkflowState();
}

class _GoalWorkflowState extends State<_GoalWorkflow> {
  int step = 0; // 0=Team, 1=Scorer, 2=Assist
  TeamSide? selectedSide;
  MatchPlayer? scorer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildStepContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String title = "SELECT TEAM";
    if (step == 1) title = "SELECT SCORER";
    if (step == 2) title = "SELECT ASSIST (Optional)";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kDivider)),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: kTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (step == 0) {
      return Row(
        children: [
          _teamBtn(widget.engine.homeTeam, TeamSide.home),
          _teamBtn(widget.engine.awayTeam, TeamSide.away),
        ],
      );
    }

    final team = selectedSide == TeamSide.home
        ? widget.engine.homeTeam
        : widget.engine.awayTeam;
    // Show players on pitch + bench (sometimes subs score immediately or records are messy)
    // Ideally only pitch players.
    final players = team.pitchPlayers;

    return ListView.builder(
      itemCount: players.length + 1, // +1 for "None/Own Goal"
      itemBuilder: (ctx, i) {
        if (i == players.length) {
          return ListTile(
            title: Text(
              step == 2 ? "No Assist" : "Own Goal / Unknown",
              style: const TextStyle(color: kTextMuted),
            ),
            onTap: () => _finish(null),
          );
        }
        final p = players[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: kSurfaceHighlight,
            child: Text(
              "${p.number}",
              style: const TextStyle(color: kTextPrimary),
            ),
          ),
          title: Text(p.name, style: const TextStyle(color: kTextPrimary)),
          onTap: () {
            if (step == 1) {
              setState(() {
                scorer = p;
                step = 2;
              });
            } else {
              _finish(p);
            }
          },
        );
      },
    );
  }

  Widget _teamBtn(MatchTeam team, TeamSide side) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectedSide = side;
          step = 1;
        }),
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: team.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: team.color),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, color: team.color, size: 48),
              const SizedBox(height: 12),
              Text(
                team.name,
                style: const TextStyle(
                  color: kTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finish(MatchPlayer? p) {
    if (step == 1 && p == null) {
      // Unknown Scorer / Own Goal
      setState(() {
        scorer = null;
        step = 2;
      });
      return;
    }

    if (step == 2) {
      widget.engine.processGoal(selectedSide!, scorer, p); // p is assist
      Navigator.pop(context);
    }
  }
}

class _CardWorkflow extends StatefulWidget {
  final MatchEngine engine;
  const _CardWorkflow({required this.engine});
  @override
  State<_CardWorkflow> createState() => _CardWorkflowState();
}

class _CardWorkflowState extends State<_CardWorkflow> {
  TeamSide? selectedSide;
  MatchPlayer? selectedPlayer;

  @override // Simplify for brevity: Team -> Player -> Type (Yellow/Red)
  Widget build(BuildContext context) {
    if (selectedSide == null) {
      return Container(
        height: 300,
        color: kSurface,
        child: Row(
          children: [
            _btn(widget.engine.homeTeam, TeamSide.home),
            _btn(widget.engine.awayTeam, TeamSide.away),
          ],
        ),
      );
    }
    if (selectedPlayer == null) {
      final team = selectedSide == TeamSide.home
          ? widget.engine.homeTeam
          : widget.engine.awayTeam;
      return Container(
        height: 500,
        color: kSurface,
        child: ListView(
          children: team.pitchPlayers
              .map(
                (p) => ListTile(
                  title: Text(
                    p.name,
                    style: const TextStyle(color: kTextPrimary),
                  ),
                  onTap: () => setState(() => selectedPlayer = p),
                ),
              )
              .toList(),
        ),
      );
    }
    return Container(
      height: 300,
      color: kSurface,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.engine.processCard(
                  selectedSide!,
                  selectedPlayer!,
                  EventType.yellowCard,
                  "Foul",
                );
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                color: kYellow,
                child: const Center(
                  child: Text(
                    "YELLOW",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.engine.processCard(
                  selectedSide!,
                  selectedPlayer!,
                  EventType.redCard,
                  "Serious Foul",
                );
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                color: kRed,
                child: const Center(
                  child: Text(
                    "RED",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(MatchTeam t, TeamSide s) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => selectedSide = s),
      child: Container(
        color: kSurface,
        child: Center(
          child: Text(t.name, style: const TextStyle(color: kTextPrimary)),
        ),
      ),
    ),
  );
}

class _SubWorkflow extends StatelessWidget {
  final MatchEngine engine;
  const _SubWorkflow({required this.engine});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: kSurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, color: kTextMuted, size: 48),
          const SizedBox(height: 16),
          const Text(
            "Substitution Workflow\nComing Soon",
            textAlign: TextAlign.center,
            style: TextStyle(color: kTextMuted),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: kAccent)),
          ),
        ],
      ),
    );
  }
}
