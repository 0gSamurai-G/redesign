import 'dart:ui';
import 'package:flutter/material.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);

const kGreen = Color(0xFF1DB954);
const kBlue = Color(0xFF42A5F5);
const kGold = Color(0xFFF5C542);
const kPurple = Color(0xFF9C27B0);
const kMuted = Color(0xFFA7A7A7);

class TrainerCreateOfferingsScreen extends StatefulWidget {
  const TrainerCreateOfferingsScreen({super.key});

  @override
  State<TrainerCreateOfferingsScreen> createState() =>
      _TrainerCreateOfferingsScreenState();
}

class _TrainerCreateOfferingsScreenState
    extends State<TrainerCreateOfferingsScreen> {
  bool _showBoost = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const _CreateOfferingAppBar(),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (_showBoost) ...[
                  _BoostCard(onClose: () {
                    setState(() => _showBoost = false);
                  }),
                  const SizedBox(height: 24),
                ],

                const Text(
                  'New Offering',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),

                _OfferingGrid(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── APP BAR ───────────────── */

class _CreateOfferingAppBar extends StatelessWidget {
  const _CreateOfferingAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Offerings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Manage packages & sessions',
                            style: TextStyle(color: kMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.help_outline,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ───────────────── BOOST CARD ───────────────── */

class _BoostCard extends StatelessWidget {
  final VoidCallback onClose;
  const _BoostCard({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kBlue.withOpacity(0.25),
            Colors.black,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBlue.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.flash_on,
              color: kBlue, size: 22),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Boost Conversions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Trainers who offer a Trial Session see 3× more bookings. Create one in under 2 minutes!',
                  style: TextStyle(
                    color: kMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onClose,
            child: const Icon(Icons.close,
                color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── OFFERING GRID ───────────────── */

class _OfferingGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 2;
        if (constraints.maxWidth >= 900) {
          columns = 4;
        } else if (constraints.maxWidth >= 600) {
          columns = 3;
        }

        return GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            _OfferingCard(
              icon: Icons.inventory_2_outlined,
              color: kGreen,
              title: 'Package',
              description:
                  'Monthly, quarterly or custom plans',
            ),
            _OfferingCard(
              icon: Icons.groups_outlined,
              color: kBlue,
              title: 'Session',
              description:
                  'Single class, batch or workshop',
            ),
            _OfferingCard(
              icon: Icons.star_outline,
              color: kGold,
              title: 'Trial Offer',
              badge: 'HOT',
              description:
                  'Low-cost entry for new students',
            ),
            _OfferingCard(
              icon: Icons.schedule_outlined,
              color: kPurple,
              title: 'Availability',
              description:
                  'Manage your open time slots',
            ),
          ],
        );
      },
    );
  }
}

/* ───────────────── OFFERING CARD ───────────────── */

class _OfferingCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String? badge;

  const _OfferingCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Icon(icon,
                        color: color, size: 20),
                  ),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: kGold.withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: kGold,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  color: kMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
