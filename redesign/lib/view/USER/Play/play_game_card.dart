import 'package:flutter/material.dart';

class SpotifyColors {
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceSoft = Color(0xFF181818);
  static const Color primary = Color(0xFF22C55E);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color urgent = Color(0xFFF59E0B);
  static const Color textSecondary = Color(0xFF9CA3AF);
}

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpotifyColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: const [
              _HeroSection(),
              SliverToBoxAdapter(child: _ContentSection()),
            ],
          ),
          const _JoinBar(),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// HERO SECTION
////////////////////////////////////////////////////////////////

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.42;

    return SliverAppBar(
      expandedHeight: height,
      backgroundColor: Colors.black,
      pinned: false,
      leading: const BackButton(),
      actions: const [
        Icon(Icons.share_outlined),
        SizedBox(width: 12),
        Icon(Icons.more_vert),
        SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=1200",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 28,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _TagRow(),
                  SizedBox(height: 16),
                  _StartIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: const [
        _Tag("COMPETITIVE"),
        _Tag("DOUBLES"),
        _Tag("ELITE", color: Colors.purple),
      ],
    );
  }
}

class _StartIndicator extends StatelessWidget {
  const _StartIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.circle, size: 10, color: SpotifyColors.primary),
        SizedBox(width: 8),
        Text(
          "Starts in 45m",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////
/// CONTENT SECTION
////////////////////////////////////////////////////////////////

class _ContentSection extends StatelessWidget {
  const _ContentSection();

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.05;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 24, padding, 120),
      child: Column(
        children: const [
          _SlotsCard(),
          SizedBox(height: 20),
          _CompetitivenessCard(),
          SizedBox(height: 28),
          _PlayerPool(),
          SizedBox(height: 28),
          _LocationCard(),
          SizedBox(height: 28),
          _RulesSection(),
          SizedBox(height: 28),
          _ReliabilityCard(),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// SLOTS CARD (Premium)
////////////////////////////////////////////////////////////////

class _SlotsCard extends StatelessWidget {
  const _SlotsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: SpotifyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Slots Filling Fast",
                      style: TextStyle(
                        fontSize: 12,
                        color: SpotifyColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "8",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: SpotifyColors.urgent,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "/ 10",
                          style: TextStyle(
                            fontSize: 18,
                            color: SpotifyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "Match Quality",
                    style: TextStyle(
                      fontSize: 12,
                      color: SpotifyColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "High Priority ⚡",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: SpotifyColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFFFB020)],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white12),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatColumn("Average Rating", "4.2 ⭐"),
              _StatColumn("Skill Spread", "Balanced ⚖️"),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;

  const _StatColumn(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: SpotifyColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////
/// COMPETITIVENESS CARD
////////////////////////////////////////////////////////////////

class _CompetitivenessCard extends StatelessWidget {
  const _CompetitivenessCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: SpotifyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: const [
                CircularProgressIndicator(
                  value: 0.94,
                  strokeWidth: 6,
                  backgroundColor: Colors.white12,
                  color: SpotifyColors.accentBlue,
                ),
                Text(
                  "94%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Competitiveness",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Fair & Balanced Match",
                  style: TextStyle(color: SpotifyColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// PLAYER POOL
////////////////////////////////////////////////////////////////

class _PlayerPool extends StatelessWidget {
  const _PlayerPool();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Player Pool",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.yellow, Colors.red],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150?u=$index",
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Player ${index + 1}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////
/// LOCATION
////////////////////////////////////////////////////////////////

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SpotifyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf",
                ),
                fit: BoxFit.cover,
                opacity: 0.35,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Badminton Hub",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Sector 4, HSR Layout",
                  style: TextStyle(color: SpotifyColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// RULES SECTION
////////////////////////////////////////////////////////////////

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "RULES",
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            color: SpotifyColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _RuleChip("Best of 3"),
            _RuleChip("21 pts"),
            _RuleChip("Shuttles Provided"),
          ],
        ),
      ],
    );
  }
}

class _RuleChip extends StatelessWidget {
  final String label;

  const _RuleChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: SpotifyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(label),
    );
  }
}

////////////////////////////////////////////////////////////////
/// RELIABILITY
////////////////////////////////////////////////////////////////

class _ReliabilityCard extends StatelessWidget {
  const _ReliabilityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF052e1b)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "RELIABILITY",
            style: TextStyle(fontSize: 12, color: SpotifyColors.textSecondary),
          ),
          SizedBox(height: 16),
          Text(
            "98%",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            "Trusted Host",
            style: TextStyle(
              color: SpotifyColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
/// JOIN BAR
////////////////////////////////////////////////////////////////

class _JoinBar extends StatelessWidget {
  const _JoinBar();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: SpotifyColors.primary,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          onPressed: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Join Match",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    "₹200",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "₹150",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

////////////////////////////////////////////////////////////////
/// TAG
////////////////////////////////////////////////////////////////

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag(this.label, {this.color = Colors.white24});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
