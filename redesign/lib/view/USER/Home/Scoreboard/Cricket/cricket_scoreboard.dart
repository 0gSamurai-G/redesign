import 'package:flutter/material.dart';

/* ═══════════════════ THEME ═══════════════════ */

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF1DB954);
const kDarkGreen = Color(0xFF0D7E3C);
const kMuted = Color(0xFF9E9E9E);
const kAmber = Color(0xFFFFC107);
const kRed = Color(0xFFE53935);
const kBlue = Color(0xFF2196F3);

/* ═══════════════════ ENUMS ═══════════════════ */

enum DismissalType {
  bowled,
  caught,
  lbw,
  runOut,
  stumped,
  hitWicket,
  retiredHurt,
}

enum ExtraType { wide, noBall, bye, legBye, penalty }

/* ═══════════════════ DATA MODELS ═══════════════════ */

class Player {
  String name;
  int runs;
  int ballsFaced;
  int fours;
  int sixes;
  double oversBowled;
  int maidens;
  int runsConceded;
  int wicketsTaken;
  bool isOnStrike;
  bool isOut;

  Player({
    required this.name,
    this.runs = 0,
    this.ballsFaced = 0,
    this.fours = 0,
    this.sixes = 0,
    this.oversBowled = 0.0,
    this.maidens = 0,
    this.runsConceded = 0,
    this.wicketsTaken = 0,
    this.isOnStrike = false,
    this.isOut = false,
  });

  double get strikeRate => ballsFaced > 0 ? (runs / ballsFaced) * 100 : 0.0;
  double get economy => oversBowled > 0 ? runsConceded / oversBowled : 0.0;

  Player copyWith({
    String? name,
    int? runs,
    int? ballsFaced,
    int? fours,
    int? sixes,
    double? oversBowled,
    int? maidens,
    int? runsConceded,
    int? wicketsTaken,
    bool? isOnStrike,
    bool? isOut,
  }) {
    return Player(
      name: name ?? this.name,
      runs: runs ?? this.runs,
      ballsFaced: ballsFaced ?? this.ballsFaced,
      fours: fours ?? this.fours,
      sixes: sixes ?? this.sixes,
      oversBowled: oversBowled ?? this.oversBowled,
      maidens: maidens ?? this.maidens,
      runsConceded: runsConceded ?? this.runsConceded,
      wicketsTaken: wicketsTaken ?? this.wicketsTaken,
      isOnStrike: isOnStrike ?? this.isOnStrike,
      isOut: isOut ?? this.isOut,
    );
  }
}

class BallEvent {
  final int runs;
  final ExtraType? extraType;
  final int extraRuns;
  final DismissalType? dismissalType;
  final String? fielder;
  final String? batterOut;
  final String? newBatter;
  final int overNumber;
  final int ballNumber;
  final bool isLegalDelivery;

  BallEvent({
    required this.runs,
    this.extraType,
    this.extraRuns = 0,
    this.dismissalType,
    this.fielder,
    this.batterOut,
    this.newBatter,
    required this.overNumber,
    required this.ballNumber,
    this.isLegalDelivery = true,
  });

  int get totalRuns => runs + extraRuns;
  bool get isWicket => dismissalType != null;
  bool get isBoundary => runs == 4 || runs == 6;
  bool get isExtra => extraType != null;

  String get displayText {
    if (isWicket) return 'W';
    if (extraType == ExtraType.wide) return 'WD';
    if (extraType == ExtraType.noBall) return 'NB';
    if (extraType == ExtraType.bye) return 'B';
    if (extraType == ExtraType.legBye) return 'LB';
    return '$totalRuns';
  }

  Color get displayColor {
    if (isWicket) return kRed;
    if (isBoundary) return kDarkGreen;
    if (isExtra) return kAmber;
    if (runs == 0) return kMuted;
    return kGreen;
  }
}

/* ═══════════════════ MAIN SCREEN ═══════════════════ */

class CricketScoreboardScreen extends StatefulWidget {
  const CricketScoreboardScreen({super.key});

  @override
  State<CricketScoreboardScreen> createState() =>
      _CricketScoreboardScreenState();
}

class _CricketScoreboardScreenState extends State<CricketScoreboardScreen> {
  // Match State
  int totalRuns = 0;
  int wickets = 0;
  int overs = 0;
  int balls = 0;
  int inningsNumber = 1;
  int? targetScore;
  String matchStatus = 'LIVE';

  // Teams
  late List<Player> battingTeam;
  late List<Player> bowlingTeam;
  late Player striker;
  late Player nonStriker;
  late Player currentBowler;

  // Ball History
  List<BallEvent> ballHistory = [];
  List<BallEvent> currentOverBalls = [];

  // Partnership
  int partnershipRuns = 0;
  int partnershipBalls = 0;

  // Tab
  int statsTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeMatch();
  }

  void _initializeMatch() {
    battingTeam = [
      Player(name: 'V Kohli', isOnStrike: true),
      Player(name: 'S Yadav'),
      Player(name: 'R Sharma'),
      Player(name: 'KL Rahul'),
      Player(name: 'H Pandya'),
      Player(name: 'R Pant'),
      Player(name: 'R Jadeja'),
      Player(name: 'R Ashwin'),
      Player(name: 'J Bumrah'),
      Player(name: 'M Shami'),
      Player(name: 'A Patel'),
    ];

    bowlingTeam = [
      Player(name: 'J Hazlewood'),
      Player(name: 'P Cummins'),
      Player(name: 'M Starc'),
      Player(name: 'A Zampa'),
      Player(name: 'G Maxwell'),
      Player(name: 'M Marsh'),
      Player(name: 'D Warner'),
      Player(name: 'S Smith'),
      Player(name: 'T Head'),
      Player(name: 'M Labuschagne'),
      Player(name: 'A Carey'),
    ];

    striker = battingTeam[0];
    nonStriker = battingTeam[1];
    currentBowler = bowlingTeam[0];

    // Sample data
    totalRuns = 184;
    wickets = 4;
    overs = 18;
    balls = 2;
    targetScore = 198;
    striker.runs = 64;
    striker.ballsFaced = 42;
    striker.fours = 6;
    striker.sixes = 2;
    nonStriker.runs = 38;
    nonStriker.ballsFaced = 25;
    nonStriker.fours = 3;
    nonStriker.sixes = 1;
    currentBowler.oversBowled = 3.2;
    currentBowler.runsConceded = 28;
    currentBowler.wicketsTaken = 1;
    partnershipRuns = 52;
    partnershipBalls = 34;

    currentOverBalls = [
      BallEvent(runs: 1, overNumber: 18, ballNumber: 1),
      BallEvent(runs: 4, overNumber: 18, ballNumber: 2),
    ];
  }

  String get oversDisplay => '$overs.${balls}';
  double get currentRunRate =>
      overs > 0 || balls > 0 ? totalRuns / (overs + balls / 6) : 0;
  double get requiredRunRate {
    if (targetScore == null) return 0;
    final remaining = targetScore! - totalRuns;
    final totalOvers = 20;
    final oversRemaining = totalOvers - overs - balls / 6;
    return oversRemaining > 0 ? remaining / oversRemaining : 0;
  }

  int get projectedScore {
    final rate = currentRunRate;
    return (rate * 20).round();
  }

  double get winProbability {
    if (targetScore == null) return 0.5;
    final progress = totalRuns / targetScore!;
    return (progress * 0.8 + (1 - wickets / 10) * 0.2).clamp(0.0, 1.0);
  }

  void _addRuns(int runs) {
    setState(() {
      totalRuns += runs;
      striker.runs += runs;
      striker.ballsFaced++;
      partnershipRuns += runs;
      partnershipBalls++;

      if (runs == 4) striker.fours++;
      if (runs == 6) striker.sixes++;

      currentBowler.runsConceded += runs;

      final ball = BallEvent(
        runs: runs,
        overNumber: overs,
        ballNumber: balls + 1,
      );
      ballHistory.add(ball);
      currentOverBalls.add(ball);

      balls++;
      if (balls == 6) {
        _completeOver();
      }

      if (runs % 2 == 1) _rotateStrike();

      _checkMatchEnd();
    });
  }

  void _addExtra(ExtraType type, int additionalRuns) {
    setState(() {
      int extraRuns = 1 + additionalRuns;
      totalRuns += extraRuns;
      currentBowler.runsConceded += extraRuns;

      bool isLegal = type == ExtraType.bye || type == ExtraType.legBye;

      final ball = BallEvent(
        runs: 0,
        extraType: type,
        extraRuns: extraRuns,
        overNumber: overs,
        ballNumber: balls + (isLegal ? 1 : 0),
        isLegalDelivery: isLegal,
      );
      ballHistory.add(ball);
      currentOverBalls.add(ball);

      if (isLegal) {
        striker.ballsFaced++;
        partnershipBalls++;
        balls++;
        if (balls == 6) _completeOver();
      }

      if (additionalRuns % 2 == 1) _rotateStrike();
    });
  }

  void _addWicket(
    DismissalType type, {
    String? fielder,
    Player? newBatter,
    bool newBatterOnStrike = true,
  }) {
    setState(() {
      wickets++;
      striker.isOut = true;
      currentBowler.wicketsTaken++;

      final ball = BallEvent(
        runs: 0,
        dismissalType: type,
        fielder: fielder,
        batterOut: striker.name,
        newBatter: newBatter?.name,
        overNumber: overs,
        ballNumber: balls + 1,
      );
      ballHistory.add(ball);
      currentOverBalls.add(ball);

      striker.ballsFaced++;
      balls++;

      partnershipRuns = 0;
      partnershipBalls = 0;

      if (newBatter != null) {
        if (newBatterOnStrike) {
          striker = newBatter;
        } else {
          striker = nonStriker;
          nonStriker = newBatter;
        }
      }

      if (balls == 6) _completeOver();
      _checkMatchEnd();
    });
  }

  void _completeOver() {
    overs++;
    balls = 0;
    currentOverBalls = [];
    _rotateStrike();
    _showBowlerChangeDialog();
  }

  void _rotateStrike() {
    final temp = striker;
    striker = nonStriker;
    nonStriker = temp;
  }

  void _changeBowler(Player newBowler) {
    setState(() {
      currentBowler = newBowler;
    });
  }

  void _undo() {
    if (ballHistory.isEmpty) return;
    setState(() {
      final lastBall = ballHistory.removeLast();
      if (currentOverBalls.isNotEmpty) currentOverBalls.removeLast();

      totalRuns -= lastBall.totalRuns;
      if (lastBall.isLegalDelivery) {
        if (balls == 0) {
          overs--;
          balls = 5;
        } else {
          balls--;
        }
        striker.ballsFaced--;
        partnershipBalls--;
      }

      if (!lastBall.isExtra) {
        striker.runs -= lastBall.runs;
        if (lastBall.runs == 4) striker.fours--;
        if (lastBall.runs == 6) striker.sixes--;
      }

      currentBowler.runsConceded -= lastBall.totalRuns;

      if (lastBall.isWicket) {
        wickets--;
        currentBowler.wicketsTaken--;
      }

      if (lastBall.runs % 2 == 1 ||
          (!lastBall.isLegalDelivery && lastBall.extraRuns % 2 == 1)) {
        _rotateStrike();
      }
    });
  }

  void _endInnings() {
    setState(() {
      if (inningsNumber == 1) {
        targetScore = totalRuns + 1;
        inningsNumber = 2;
        totalRuns = 0;
        wickets = 0;
        overs = 0;
        balls = 0;
        ballHistory = [];
        currentOverBalls = [];
        partnershipRuns = 0;
        partnershipBalls = 0;

        final temp = battingTeam;
        battingTeam = bowlingTeam;
        bowlingTeam = temp;

        striker = battingTeam[0];
        nonStriker = battingTeam[1];
        currentBowler = bowlingTeam[0];

        for (var p in battingTeam) {
          p.runs = 0;
          p.ballsFaced = 0;
          p.fours = 0;
          p.sixes = 0;
          p.isOut = false;
        }
        for (var p in bowlingTeam) {
          p.oversBowled = 0;
          p.runsConceded = 0;
          p.wicketsTaken = 0;
          p.maidens = 0;
        }
      } else {
        _endMatch();
      }
    });
  }

  void _checkMatchEnd() {
    if (inningsNumber == 2 &&
        targetScore != null &&
        totalRuns >= targetScore!) {
      _endMatch();
    }
    if (wickets >= 10 || (overs >= 20 && balls == 0)) {
      if (inningsNumber == 1) {
        _endInnings();
      } else {
        _endMatch();
      }
    }
  }

  void _endMatch() {
    setState(() {
      matchStatus = 'COMPLETED';
    });
  }

  String get matchResult {
    if (matchStatus != 'COMPLETED' || targetScore == null) return '';
    final wicketsRemaining = 10 - wickets;
    if (totalRuns >= targetScore!) {
      return 'India won by $wicketsRemaining wickets';
    } else {
      return 'Australia won by ${targetScore! - totalRuns - 1} runs';
    }
  }

  void _showBowlerChangeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => _BowlerSelectSheet(
        bowlers: bowlingTeam,
        currentBowler: currentBowler,
        onSelect: (b) {
          _changeBowler(b);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showExtrasModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => _ExtrasModal(
        onSelect: (type, runs) {
          _addExtra(type, runs);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showWicketWizard() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => _WicketWizard(
        battingTeam: battingTeam,
        bowlingTeam: bowlingTeam,
        striker: striker,
        nonStriker: nonStriker,
        onComplete: (type, fielder, newBatter, onStrike) {
          _addWicket(
            type,
            fielder: fielder,
            newBatter: newBatter,
            newBatterOnStrike: onStrike,
          );
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildOverProgress()),
            SliverToBoxAdapter(child: _buildMatchContext()),
            SliverToBoxAdapter(child: _buildPlayerStats()),
            SliverToBoxAdapter(child: _buildBallTimeline()),
            SliverToBoxAdapter(child: _buildScoringConsole()),
            SliverToBoxAdapter(child: _buildAdvancedActions()),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _teamLogo('IND', Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'India',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'vs Australia · ${inningsNumber == 1 ? "1st" : "2nd"} Innings',
                      style: const TextStyle(color: kMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$totalRuns',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        ' /$wickets',
                        style: const TextStyle(color: kMuted, fontSize: 24),
                      ),
                    ],
                  ),
                  Text(
                    'P${inningsNumber}  $oversDisplay Overs',
                    style: const TextStyle(color: kMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statBadge('CRR ${currentRunRate.toStringAsFixed(2)}'),
              if (targetScore != null)
                _projBadge('Proj: $projectedScore - ${projectedScore + 12}'),
              _statBadge(
                'Avg ${(totalRuns / (wickets == 0 ? 1 : wickets)).round()}',
              ),
            ],
          ),
          if (targetScore != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target: $targetScore',
                  style: const TextStyle(color: kMuted, fontSize: 13),
                ),
                Text(
                  'Need ${targetScore! - totalRuns} off ${(20 - overs) * 6 - balls} balls',
                  style: const TextStyle(color: kAmber, fontSize: 13),
                ),
              ],
            ),
          ],
          if (matchStatus == 'COMPLETED') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                matchResult,
                style: const TextStyle(
                  color: kGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _teamLogo(String code, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _statBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _projBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: kGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: kGreen,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOverProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (ctx, i) {
          if (i < currentOverBalls.length) {
            final ball = currentOverBalls[i];
            return _ballCircle(
              ball.displayText,
              ball.displayColor,
              filled: true,
            );
          }
          return _ballCircle('', kMuted, filled: false);
        },
      ),
    );
  }

  Widget _ballCircle(String text, Color color, {required bool filled}) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: filled ? color.withOpacity(0.2) : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMatchContext() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _contextItem(
              'WIN PROB',
              '${(winProbability * 100).round()}%',
              kGreen,
            ),
          ),
          Expanded(
            child: _contextItem(
              'PARTNERSHIP',
              '$partnershipRuns ($partnershipBalls)',
              Colors.white,
            ),
          ),
          Expanded(
            child: _contextItem(
              'RUN RATE',
              'RRR ${requiredRunRate.toStringAsFixed(1)}',
              kAmber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contextItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _statsTab('Batting', 0),
              _statsTab('Bowling', 1),
              _statsTab('Comm', 2),
            ],
          ),
          if (statsTabIndex == 0) _buildBattingStats(),
          if (statsTabIndex == 1) _buildBowlingStats(),
          if (statsTabIndex == 2) _buildCommentary(),
        ],
      ),
    );
  }

  Widget _statsTab(String title, int index) {
    final selected = statsTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => statsTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white10 : Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : kMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBattingStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BATTERS',
            style: TextStyle(
              color: kMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _batterRow(striker, isStriker: true),
          const SizedBox(height: 8),
          _batterRow(nonStriker, isStriker: false),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Extras: ${currentOverBalls.where((b) => b.isExtra).fold(0, (sum, b) => sum + b.extraRuns)}',
                style: const TextStyle(color: kMuted, fontSize: 12),
              ),
              Text(
                'Partnership: $partnershipRuns ($partnershipBalls)',
                style: const TextStyle(color: kMuted, fontSize: 12),
              ),
              Text(
                'Run Rate: ${currentRunRate.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: kGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _batterRow(Player p, {required bool isStriker}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isStriker ? kGreen.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isStriker ? Border.all(color: kGreen.withOpacity(0.3)) : null,
      ),
      child: Row(
        children: [
          if (isStriker)
            const Icon(Icons.star, color: kGreen, size: 16)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              p.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${p.runs}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${p.ballsFaced}',
              style: const TextStyle(color: kMuted),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${p.fours}',
              style: const TextStyle(color: kMuted),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '${p.sixes}',
              style: const TextStyle(color: kMuted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlingStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BOWLERS',
            style: TextStyle(
              color: kMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _bowlerRow(currentBowler, isCurrent: true),
        ],
      ),
    );
  }

  Widget _bowlerRow(Player p, {required bool isCurrent}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent ? kGreen.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: kGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CURRENT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${p.oversBowled.toStringAsFixed(1)} ov  ·  ${p.maidens} M  ·  ${p.runsConceded} R  ·  ${p.wicketsTaken} W',
                  style: const TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'Econ: ${p.economy.toStringAsFixed(1)}',
            style: const TextStyle(color: kAmber, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentary() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Ball-by-ball commentary coming soon...',
        style: TextStyle(color: kMuted),
      ),
    );
  }

  Widget _buildBallTimeline() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PREV OVER',
                style: TextStyle(
                  color: kMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${ballHistory.length > 6 ? ballHistory.sublist(ballHistory.length - 6).fold(0, (sum, b) => sum + b.totalRuns) : 0} Runs',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ballHistory.length,
              itemBuilder: (ctx, i) {
                final ball = ballHistory[i];
                return Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: ball.displayColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    ball.displayText,
                    style: TextStyle(
                      color: ball.displayColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoringConsole() {
    final isMatchOver = matchStatus == 'COMPLETED';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _scoreBtn('0', 'DOT', isMatchOver ? null : () => _addRuns(0)),
              const SizedBox(width: 12),
              _scoreBtn('1', 'RUN', isMatchOver ? null : () => _addRuns(1)),
              const SizedBox(width: 12),
              _scoreBtn('2', 'RUNS', isMatchOver ? null : () => _addRuns(2)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _scoreBtn('3', 'RUNS', isMatchOver ? null : () => _addRuns(3)),
              const SizedBox(width: 12),
              _scoreBtn(
                '4',
                'FOUR',
                isMatchOver ? null : () => _addRuns(4),
                highlight: true,
              ),
              const SizedBox(width: 12),
              _scoreBtn(
                '6',
                'SIX',
                isMatchOver ? null : () => _addRuns(6),
                highlight: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _actionBtn(
                Icons.add_circle_outline,
                'EXTRA',
                isMatchOver ? null : _showExtrasModal,
                kAmber,
              ),
              const SizedBox(width: 12),
              _actionBtn(
                Icons.sports_cricket,
                'WICKET',
                isMatchOver ? null : _showWicketWizard,
                kRed,
              ),
              const SizedBox(width: 12),
              _actionBtn(
                Icons.undo,
                'UNDO',
                isMatchOver ? null : _undo,
                kMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreBtn(
    String value,
    String label,
    VoidCallback? onTap, {
    bool highlight = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: highlight
                ? kGreen.withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight ? kGreen : Colors.white24,
              width: highlight ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: highlight ? kGreen : Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontStyle: value == '0' ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: highlight ? kGreen.withOpacity(0.7) : kMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(
    IconData icon,
    String label,
    VoidCallback? onTap,
    Color color,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _advBtn(
                Icons.swap_horiz,
                'Change Bowler',
                'End of over',
                _showBowlerChangeDialog,
              ),
              const SizedBox(width: 12),
              _advBtn(Icons.videocam, 'Video Refer', 'Third Umpire', () {}),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _advBtn(Icons.person_off, 'Retire Batter', 'Hurt / Out', () {}),
              const SizedBox(width: 12),
              _advBtn(
                Icons.pause_circle_outline,
                'Match Break',
                'Drinks / Rain',
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _advBtn(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: kMuted, size: 22),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: kMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ═══════════════════ MODALS ═══════════════════ */

class _BowlerSelectSheet extends StatelessWidget {
  final List<Player> bowlers;
  final Player currentBowler;
  final ValueChanged<Player> onSelect;

  const _BowlerSelectSheet({
    required this.bowlers,
    required this.currentBowler,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Bowler',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...bowlers.map(
            (b) => ListTile(
              title: Text(b.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                '${b.oversBowled.toStringAsFixed(1)} ov - ${b.runsConceded} runs - ${b.wicketsTaken} wkt',
                style: const TextStyle(color: kMuted, fontSize: 12),
              ),
              trailing: b == currentBowler
                  ? const Icon(Icons.check_circle, color: kGreen)
                  : null,
              onTap: () => onSelect(b),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtrasModal extends StatefulWidget {
  final Function(ExtraType, int) onSelect;
  const _ExtrasModal({required this.onSelect});

  @override
  State<_ExtrasModal> createState() => _ExtrasModalState();
}

class _ExtrasModalState extends State<_ExtrasModal> {
  ExtraType? selectedType;
  int additionalRuns = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Extra Type',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExtraType.values.map((t) {
              final sel = selectedType == t;
              return GestureDetector(
                onTap: () => setState(() => selectedType = t),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? kAmber.withOpacity(0.2) : Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: sel ? Border.all(color: kAmber) : null,
                  ),
                  child: Text(
                    t.name.toUpperCase(),
                    style: TextStyle(
                      color: sel ? kAmber : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Additional Runs',
            style: TextStyle(color: kMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [0, 1, 2, 3, 4].map((r) {
              final sel = additionalRuns == r;
              return GestureDetector(
                onTap: () => setState(() => additionalRuns = r),
                child: Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: sel ? kGreen.withOpacity(0.2) : Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: sel ? Border.all(color: kGreen) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$r',
                    style: TextStyle(
                      color: sel ? kGreen : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedType != null
                  ? () => widget.onSelect(selectedType!, additionalRuns)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'CONFIRM',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WicketWizard extends StatefulWidget {
  final List<Player> battingTeam;
  final List<Player> bowlingTeam;
  final Player striker;
  final Player nonStriker;
  final Function(DismissalType, String?, Player?, bool) onComplete;

  const _WicketWizard({
    required this.battingTeam,
    required this.bowlingTeam,
    required this.striker,
    required this.nonStriker,
    required this.onComplete,
  });

  @override
  State<_WicketWizard> createState() => _WicketWizardState();
}

class _WicketWizardState extends State<_WicketWizard> {
  int step = 0;
  DismissalType? dismissalType;
  String? fielder;
  Player? newBatter;
  bool newBatterOnStrike = true;

  List<Player> get availableBatters => widget.battingTeam
      .where((p) => !p.isOut && p != widget.striker && p != widget.nonStriker)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Wicket Wizard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text('Step ${step + 1}/4', style: const TextStyle(color: kMuted)),
            ],
          ),
          const SizedBox(height: 20),
          if (step == 0) _dismissalStep(),
          if (step == 1) _fielderStep(),
          if (step == 2) _newBatterStep(),
          if (step == 3) _confirmStep(),
        ],
      ),
    );
  }

  Widget _dismissalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How was the batter dismissed?',
          style: TextStyle(color: kMuted),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DismissalType.values.map((t) {
            final sel = dismissalType == t;
            return GestureDetector(
              onTap: () => setState(() {
                dismissalType = t;
                step = 1;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: sel ? kRed.withOpacity(0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                  border: sel ? Border.all(color: kRed) : null,
                ),
                child: Text(
                  t.name.toUpperCase(),
                  style: TextStyle(color: sel ? kRed : Colors.white),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _fielderStep() {
    final needsFielder =
        dismissalType == DismissalType.caught ||
        dismissalType == DismissalType.runOut ||
        dismissalType == DismissalType.stumped;
    if (!needsFielder) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && step == 1) setState(() => step = 2);
      });
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select fielder', style: TextStyle(color: kMuted)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.bowlingTeam.map((p) {
            final sel = fielder == p.name;
            return GestureDetector(
              onTap: () => setState(() {
                fielder = p.name;
                step = 2;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: sel ? kBlue.withOpacity(0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  p.name,
                  style: TextStyle(
                    color: sel ? kBlue : Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _newBatterStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select new batter', style: TextStyle(color: kMuted)),
        const SizedBox(height: 12),
        ...availableBatters.map(
          (p) => ListTile(
            title: Text(p.name, style: const TextStyle(color: Colors.white)),
            trailing: newBatter == p
                ? const Icon(Icons.check_circle, color: kGreen)
                : null,
            onTap: () => setState(() {
              newBatter = p;
              step = 3;
            }),
          ),
        ),
      ],
    );
  }

  Widget _confirmStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.striker.name} - ${dismissalType?.name.toUpperCase()}',
          style: const TextStyle(
            color: kRed,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (fielder != null)
          Text('Fielder: $fielder', style: const TextStyle(color: kMuted)),
        if (newBatter != null)
          Text(
            'New Batter: ${newBatter!.name}',
            style: const TextStyle(color: kMuted),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              'New batter on strike?',
              style: TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Switch(
              value: newBatterOnStrike,
              onChanged: (v) => setState(() => newBatterOnStrike = v),
              activeColor: kGreen,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => widget.onComplete(
              dismissalType!,
              fielder,
              newBatter,
              newBatterOnStrike,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'CONFIRM WICKET',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
