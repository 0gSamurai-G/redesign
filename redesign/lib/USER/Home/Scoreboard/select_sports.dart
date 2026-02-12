import 'package:flutter/material.dart';
import 'package:redesign/USER/Home/Scoreboard/Cricket/cricket_setup_friendly.dart';
import 'package:redesign/USER/Home/Scoreboard/Football/football_setup.dart';
import 'package:redesign/USER/Home/Scoreboard/Badminton/badminton_setup.dart';

void main() {
  runApp(const MyApp());
}

/* ─────────────────── THEME COLORS ─────────────────── */

const Color kBg = Color(0xFF000000);
const Color kSurface = Color(0xFF0E0E0E);
const Color kGreen = Color(0xFF1DB954);
const Color kMuted = Color(0xFF9E9E9E);

/* ─────────────────── APP ROOT ─────────────────── */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: kBg),
      home: const SelectSportScreen(),
    );
  }
}

/* ─────────────────── SELECT SPORT SCREEN ─────────────────── */

class SelectSportScreen extends StatefulWidget {
  const SelectSportScreen({super.key});

  @override
  State<SelectSportScreen> createState() => _SelectSportScreenState();
}

class _SelectSportScreenState extends State<SelectSportScreen> {
  String searchQuery = '';
  String? selectedSport;

  final Map<String, bool> expanded = {
    'Team Sports': true,
    'Racquet Sports': false,
    'Fitness': false,
  };

  late final Map<String, List<_SportItem>> categories;

  @override
  void initState() {
    super.initState();

    /// 👇 DEFINE NAVIGATION PER SPORT HERE
    categories = {
      'Team Sports': [
        _SportItem(
          'Cricket',
          Icons.sports_cricket,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => FriendlySetupScreen())),
        ),
        _SportItem(
          'Football',
          Icons.sports_soccer,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const MatchSetupScreen())),
        ),
        _SportItem(
          'Box Cricket',
          Icons.sports_baseball,
          onTap: () => _openSetup('Box Cricket'),
        ),
        _SportItem(
          'Basketball',
          Icons.sports_basketball,
          onTap: () => _openSetup('Basketball'),
        ),
        _SportItem(
          'Volleyball',
          Icons.sports_volleyball,
          onTap: () => _openSetup('Volleyball'),
        ),
        _SportItem(
          'Hockey',
          Icons.sports_hockey,
          onTap: () => _openSetup('Hockey'),
        ),
      ],
      'Racquet Sports': [
        _SportItem(
          'Tennis',
          Icons.sports_tennis,
          onTap: () => _openSetup('Tennis'),
        ),
        _SportItem(
          'Badminton',
          Icons.sports,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BadmintonSetupScreen()),
          ),
        ),
        _SportItem(
          'Table Tennis',
          Icons.sports_tennis,
          onTap: () => _openSetup('Table Tennis'),
        ),
        _SportItem(
          'Squash',
          Icons.sports_handball,
          onTap: () => _openSetup('Squash'),
        ),
      ],
      'Fitness': [
        _SportItem(
          'Workout',
          Icons.fitness_center,
          onTap: () => _openSetup('Workout'),
        ),
        _SportItem(
          'Running',
          Icons.directions_run,
          onTap: () => _openSetup('Running'),
        ),
        _SportItem(
          'Yoga',
          Icons.self_improvement,
          onTap: () => _openSetup('Yoga'),
        ),
        _SportItem('Swimming', Icons.pool, onTap: () => _openSetup('Swimming')),
        _SportItem(
          'Cycling',
          Icons.directions_bike,
          onTap: () => _openSetup('Cycling'),
        ),
        _SportItem(
          'Combat',
          Icons.sports_mma,
          onTap: () => _openSetup('Combat'),
        ),
      ],
    };
  }

  void _openSetup(String sport) {
    setState(() => selectedSport = sport);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SportMatchSetupScreen(sport: sport)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const _AppBar(),
            _SearchBar(
              onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
            ),
            ...categories.entries.map(
              (entry) => _CategorySection(
                title: entry.key,
                sports: entry.value,
                expanded: expanded[entry.key]!,
                selectedSport: selectedSport,
                searchQuery: searchQuery,
                onToggle: () {
                  setState(() {
                    expanded[entry.key] = !expanded[entry.key]!;
                  });
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────── APP BAR ─────────────────── */

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: kBg,
      elevation: 0,
      leading: const BackButton(),
      title: const Text(
        'Select Sport',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () {})],
    );
  }
}

/* ─────────────────── SEARCH BAR ─────────────────── */

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search sports...',
            hintStyle: const TextStyle(color: kMuted),
            prefixIcon: const Icon(Icons.search, color: kMuted),
            filled: true,
            fillColor: kSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

/* ─────────────────── CATEGORY SECTION ─────────────────── */

class _CategorySection extends StatelessWidget {
  final String title;
  final List<_SportItem> sports;
  final bool expanded;
  final String? selectedSport;
  final String searchQuery;
  final VoidCallback onToggle;

  const _CategorySection({
    required this.title,
    required this.sports,
    required this.expanded,
    required this.selectedSport,
    required this.searchQuery,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = sports
        .where((s) => s.name.toLowerCase().contains(searchQuery))
        .toList();

    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: kMuted,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final columns = width > 900
                    ? 5
                    : width > 600
                    ? 4
                    : 3;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, i) {
                    final sport = filtered[i];
                    return _SportTile(
                      sport: sport,
                      selected: sport.name == selectedSport,
                    );
                  },
                );
              },
            ),
          ),
        const Divider(color: Colors.white12),
      ]),
    );
  }
}

/* ─────────────────── SPORT TILE ─────────────────── */

class _SportTile extends StatelessWidget {
  final _SportItem sport;
  final bool selected;

  const _SportTile({required this.sport, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: sport.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? kGreen : Colors.transparent,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(sport.icon, color: selected ? kGreen : kMuted, size: 28),
              const SizedBox(height: 8),
              Text(
                sport.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? kGreen : kMuted,
                  fontSize: 12,
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

/* ─────────────────── SPORT ITEM MODEL ─────────────────── */

class _SportItem {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const _SportItem(this.name, this.icon, {required this.onTap});
}

/* ─────────────────── NEXT SCREEN ─────────────────── */

class SportMatchSetupScreen extends StatelessWidget {
  final String sport;

  const SportMatchSetupScreen({super.key, required this.sport});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        title: Text('$sport Match Setup'),
      ),
      body: Center(
        child: Text(
          'Setup screen for $sport',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
