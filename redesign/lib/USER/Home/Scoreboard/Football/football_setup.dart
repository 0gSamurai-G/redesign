import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* ─────────────────── THEME ─────────────────── */

const Color kBg = Color(0xFF000000);
const Color kSurface = Color(0xFF0E0E0E);
const Color kGreen = Color(0xFF1DB954);
const Color kMuted = Color(0xFF9E9E9E);
const Color kAmber = Color(0xFFFFC107);

enum MatchMode { friendly, tournament }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: kBg),
      home: const FriendlyFootballSetupScreen(),
    );
  }
}

/* ─────────────────── SCREEN ─────────────────── */

class FriendlyFootballSetupScreen extends StatefulWidget {
  const FriendlyFootballSetupScreen({super.key});

  @override
  State<FriendlyFootballSetupScreen> createState() =>
      _FriendlyFootballSetupScreenState();
}

class _FriendlyFootballSetupScreenState
    extends State<FriendlyFootballSetupScreen> {
  MatchMode mode = MatchMode.friendly;

  int playersPerSide = 11;
  int maxSquad = 18;
  int maxSubs = 3;
  int halfDuration = 45;

  String timerType = 'Count Up';
  bool extraTime = false;
  bool penalties = false;

  bool rollingSubs = true;
  bool cards = true;
  bool stats = true;
  bool timeline = true;
  bool allowDraw = true;

  bool teamsValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      bottomNavigationBar: _stickyCta(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _appBar(),
            SliverToBoxAdapter(child: _contextBanner()),
            SliverToBoxAdapter(child: _modeTabs()),
            SliverToBoxAdapter(
              child: AnimatedCrossFade(
                firstChild: Column(children: _friendlyContent()),
                secondChild: _tournamentContent(),
                crossFadeState: mode == MatchMode.friendly
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 400),
                firstCurve: Curves.easeInOut,
                secondCurve: Curves.easeInOut,
                sizeCurve: Curves.easeInOut,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  /* ─────────────────── APP BAR ─────────────────── */

  Widget _appBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: kBg,
      elevation: 0,
      title: const Text(
        'Friendly Match',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  /* ─────────────────── CONTEXT ─────────────────── */

  Widget _contextBanner() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: kGreen, size: 18),
              SizedBox(width: 8),
              Text(
                'FRIENDLY MATCH CONTEXT',
                style: TextStyle(
                  color: kMuted,
                  fontSize: 11,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'This setup is for a friendly match. Results will not affect rankings or tournaments.',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 8),
          const Text(
            'You can convert this to a tournament later without losing stats.',
            style: TextStyle(
              color: kGreen,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Set things up the way you like. You can adjust rules and details later if plans change.',
            style: TextStyle(color: kMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /* ─────────────────── MODE TABS ─────────────────── */

  Widget _modeTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _tab('Friendly', MatchMode.friendly),
            _tab('Tournament', MatchMode.tournament),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, MatchMode value) {
    final selected = mode == value;
    final isTournament = value == MatchMode.tournament;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => mode = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.black : kMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isTournament) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: selected
                          ? Colors.black54
                          : kMuted.withOpacity(0.5),
                    ),
                  ],
                ],
              ),
              if (isTournament)
                Text(
                  'Setup later',
                  style: TextStyle(
                    fontSize: 9,
                    color: selected ? Colors.black54 : kMuted.withOpacity(0.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /* ─────────────────── FRIENDLY CONTENT ─────────────────── */

  List<Widget> _friendlyContent() {
    return [
      _matchFormat(),
      _smartPresets(),
      _teams(),
      _rules(),
      _matchControl(),
      _tracking(),
      _resultType(),
      _schedule(),
      _preview(),
      const SizedBox(height: 20),
    ];
  }

  Widget _tournamentContent() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: kMuted.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tournament setup unlocks advanced\nscheduling & brackets',
            textAlign: TextAlign.center,
            style: TextStyle(color: kMuted),
          ),
        ],
      ),
    );
  }

  /* ─────────────────── MATCH FORMAT ─────────────────── */

  Widget _matchFormat() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MATCH FORMAT',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          _choiceRow(
            'PLAYERS PER SIDE',
            [5, 7, 9, 11],
            playersPerSide,
            (v) => setState(() => playersPerSide = v),
            hint: playersPerSide == 11
                ? 'Standard outdoor friendly format'
                : null,
          ),
          const SizedBox(height: 12),
          const Center(
            child: Opacity(
              opacity: 0.5,
              child: SizedBox(
                height: 20,
                child: VerticalDivider(width: 1, thickness: 1, color: kMuted),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _choiceRow(
            'MAX SQUAD SIZE',
            [playersPerSide + 5, playersPerSide + 7, playersPerSide + 12],
            maxSquad,
            (v) => setState(() => maxSquad = v),
            hint: 'Squad size includes bench players',
          ),
        ],
      ),
    );
  }

  /* ─────────────────── SMART PRESETS ─────────────────── */

  Widget _smartPresets() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'SMART RECOMMENDATION',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Used in 72% of friendly matches',
                  style: TextStyle(
                    color: kGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Apply safe defaults used in most local friendly games.',
                  style: TextStyle(color: kMuted, fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text(
                      'Apply Rules',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text(
                      'Preview rules',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* ─────────────────── TEAMS ─────────────────── */

  Widget _teams() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TEAMS & ROSTERS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 1.1,
                ),
              ),
              _setupQualityBadge(),
            ],
          ),
          const SizedBox(height: 16),
          _team('Manchester United', Colors.red, 4),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: kSurface, thickness: 1),
          ),
          _team('Real Madrid', Colors.grey, 0),
        ],
      ),
    );
  }

  Widget _team(String name, Color color, int playersCount) {
    final bool isReady = playersCount >= 7;
    final bool almostReady = playersCount > 0 && playersCount < 7;
    final Color statusColor = isReady
        ? kGreen
        : (almostReady ? kAmber : kMuted);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 6, backgroundColor: color),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$playersCount / 7 required',
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (playersCount == 0)
          const Text(
            'Add players to get started',
            style: TextStyle(color: kMuted, fontSize: 13),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: playersCount / 7,
              backgroundColor: kBg,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 4,
            ),
          ),
        const SizedBox(height: 4),
        TextButton.icon(
          onPressed: () => setState(() => teamsValid = !teamsValid),
          icon: Icon(Icons.person_add_outlined, size: 16, color: kGreen),
          label: Text(
            playersCount == 0 ? 'Add players' : 'Manage roster',
            style: const TextStyle(color: kGreen),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            minimumSize: const Size(0, 32),
          ),
        ),
      ],
    );
  }

  /* ─────────────────── RULES ─────────────────── */

  Widget _rules() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MATCH RULES',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          _choiceRow(
            'HALF DURATION (MINUTES)',
            [20, 30, 40, 45],
            halfDuration,
            (v) => setState(() => halfDuration = v),
            hint: halfDuration < 40
                ? 'Tip: Shorter halves work well for training games'
                : null,
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: rollingSubs,
            onChanged: (v) => setState(() => rollingSubs = v),
            title: const Text(
              'Rolling substitutions',
              style: TextStyle(fontSize: 14),
            ),
            subtitle: const Text(
              'Unlimited player rotations allowed',
              style: TextStyle(fontSize: 12, color: kMuted),
            ),
            activeColor: kGreen,
            contentPadding: EdgeInsets.zero,
          ),
          AnimatedCrossFade(
            firstChild: _choiceRow(
              'MAX SUBSTITUTIONS',
              [3, 5, 7, 10],
              maxSubs,
              (v) => setState(() => maxSubs = v),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: !rollingSubs
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  /* ─────────────────── MATCH CONTROL ─────────────────── */

  Widget _matchControl() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MATCH CONTROL',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          _timerTypeSelector(),
          const SizedBox(height: 12),
          const Text(
            'Manual recommended for casual games',
            style: TextStyle(
              color: kGreen,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TIMER TYPE', style: TextStyle(color: kMuted, fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            _timerOption('Count Up', Icons.timer_outlined),
            const SizedBox(width: 12),
            _timerOption('Countdown', Icons.hourglass_bottom_outlined),
          ],
        ),
      ],
    );
  }

  Widget _timerOption(String label, IconData icon) {
    final selected = timerType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => timerType = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? kGreen.withOpacity(0.1) : kSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? kGreen : kMuted.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: selected ? kGreen : kMuted),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? kGreen : kMuted,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ─────────────────── TRACKING ─────────────────── */

  Widget _tracking() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MATCH DETAILS & TRACKING',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          _toggle(
            'Player statistics',
            stats,
            (v) => setState(() => stats = v),
            subtitle: 'May slightly increase setup time',
          ),
          _toggle(
            'Match timeline',
            timeline,
            (v) => setState(() => timeline = v),
            subtitle: 'Goal • Substitution • Card',
          ),
          _toggle('Yellow/Red cards', cards, (v) => setState(() => cards = v)),
        ],
      ),
    );
  }

  Widget _toggle(
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    String? subtitle,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12, color: kMuted))
          : null,
      activeColor: kGreen,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  /* ─────────────────── RESULT TYPE ─────────────────── */

  Widget _resultType() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MATCH RESULT TYPE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _resultOption('Allow Draw', true),
              const SizedBox(width: 12),
              _resultOption('Must have winner', false),
            ],
          ),
          const SizedBox(height: 12),
          if (!allowDraw) ...[
            const Text(
              'IF SCORES ARE TIED:',
              style: TextStyle(color: kMuted, fontSize: 11),
            ),
            const SizedBox(height: 8),
            _toggle(
              'Extra time',
              extraTime,
              (v) => setState(() => extraTime = v),
            ),
            _toggle(
              'Penalties',
              penalties,
              (v) => setState(() => penalties = v),
            ),
            const Text(
              'Match will not end without a result',
              style: TextStyle(
                color: kAmber,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else
            const Text(
              'Not needed when draws are allowed',
              style: TextStyle(color: kMuted, fontSize: 11),
            ),
        ],
      ),
    );
  }

  Widget _resultOption(String label, bool value) {
    final selected = allowDraw == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => allowDraw = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? kGreen.withOpacity(0.1) : kSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? kGreen : kMuted.withOpacity(0.2),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? kGreen : kMuted,
              fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /* ─────────────────── SCHEDULE ─────────────────── */

  Widget _schedule() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MATCH SCHEDULE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: kMuted,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Today • 20:00',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    'Starts in ~3 hours',
                    style: TextStyle(color: kGreen, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Weather check available after setup',
            style: TextStyle(
              color: kMuted,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /* ─────────────────── PREVIEW ─────────────────── */

  Widget _preview() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MATCH PREVIEW',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Manchester United vs Real Madrid\nFriendly • ${playersPerSide}v${playersPerSide} • Today at 20:00',
            style: const TextStyle(color: kMuted, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _checkItem(!teamsValid, 'Add at least 7 players to each team'),
              _checkItem(false, 'Match format configured'),
              _checkItem(false, 'Standard rules applied'),
            ],
          ),
          if (teamsValid) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check_circle_outline, color: kGreen, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Everything looks good. You’re ready to play.',
                      style: TextStyle(
                        color: kGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _checkItem(bool pending, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            pending ? Icons.circle : Icons.check_circle,
            size: 16,
            color: pending ? kAmber : kGreen,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: pending ? Colors.white : kMuted,
              fontSize: 13,
              fontWeight: pending ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stickyCta() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: kBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_done_outlined,
                size: 12,
                color: kMuted.withOpacity(0.5),
              ),
              const SizedBox(width: 4),
              Text(
                'Auto-saved draft',
                style: TextStyle(color: kMuted.withOpacity(0.5), fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: teamsValid ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBackgroundColor: kSurface,
              elevation: 0,
            ),
            child: const Text(
              'Continue to match screen',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          if (!teamsValid)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Add players to continue',
                style: TextStyle(
                  color: kAmber,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /* ─────────────────── HELPERS ─────────────────── */

  Widget _setupQualityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kMuted.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Quality: ',
            style: TextStyle(color: kMuted, fontSize: 10),
          ),
          Text(
            teamsValid ? '82%' : '45%',
            style: const TextStyle(
              color: kAmber,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }

  Widget _choiceRow(
    String label,
    List<int> values,
    int selected,
    ValueChanged<int> onSelect, {
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: kMuted, fontSize: 12)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values
              .map(
                (v) => ChoiceChip(
                  label: Text('$v'),
                  selected: selected == v,
                  selectedColor: kGreen,
                  labelStyle: TextStyle(
                    color: selected == v ? Colors.black : Colors.white,
                    fontWeight: selected == v
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (_) => onSelect(v),
                  backgroundColor: kBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: selected == v ? kGreen : kMuted.withOpacity(0.2),
                  ),
                  showCheckmark: false,
                ),
              )
              .toList(),
        ),
        if (hint != null) ...[
          const SizedBox(height: 8),
          Text(
            hint,
            style: const TextStyle(
              color: kMuted,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
