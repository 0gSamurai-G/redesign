import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/trainer_payment.dart';

const kBg = Color(0xFF000000);
const kCard = Color(0xFF1A1A1A);
const kSurface = Color(0xFF121212);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);
const kYellow = Color(0xFFF5C542);

class ChoosePackageScreen extends StatefulWidget {
  const ChoosePackageScreen({super.key});

  @override
  State<ChoosePackageScreen> createState() => _ChoosePackageScreenState();
}

class _ChoosePackageScreenState extends State<ChoosePackageScreen> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  final List<_PackageModel> packages = [
    _PackageModel(
      badge: 'TRIAL SESSION',
      title: '1-Day Trial Access',
      desc:
          'Perfect for first-timers. Includes facility tour, skill assessment, and 1 hour net practice.',
      chips: ['1 Day', 'Kit Provided'],
      price: 150,
      billing: 'Single payment',
      coins: 15,
      highlight: true,
    ),
    _PackageModel(
      badge: 'MOST POPULAR',
      title: 'Monthly Coaching',
      desc:
          'Comprehensive training focusing on technique and fitness. Includes weekend matches.',
      chips: ['1 Month', '3 Sessions / Week'],
      price: 2000,
      billing: 'Billed monthly',
      coins: 200,
    ),
    _PackageModel(
      badge: 'BEST VALUE',
      title: 'Quarterly Pro Pass',
      desc:
          'For serious athletes. Intensive drills, video analysis, and personal mentoring.',
      chips: ['3 Months', '5 Sessions / Week', 'Video Analysis'],
      price: 5500,
      billing: 'Billed quarterly',
      coins: 600,
      badgeColor: kYellow,
    ),
    _PackageModel(
      title: 'Half-Year Performance Plan',
      desc: 'Advanced coaching, fitness tracking, and match exposure.',
      chips: ['6 Months', '5 Sessions / Week'],
      price: 9800,
      billing: 'Billed half-yearly',
      coins: 1200,
    ),
    _PackageModel(
      title: 'Annual Elite Program',
      desc:
          'Long-term mentorship, tournament preparation, and advanced analytics.',
      chips: ['12 Months', 'Priority Batches'],
      price: 18000,
      billing: 'Billed yearly',
      coins: 3000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              children: [
                _AppBar(),
                _AcademyCard(),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: _selectedIndex,
                  builder: (_, value, __) {
                    return Column(
                      children: List.generate(packages.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PackageCard(
                            data: packages[i],
                            selected: value == i,
                            onTap: () => _selectedIndex.value = i,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
          _BottomCTA(packages: packages, selectedIndex: _selectedIndex),
        ],
      ),
    );
  }
}

/* ───────────────── APP BAR ───────────────── */

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.black54,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose a Package',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Select a plan that fits your goals',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/* ───────────────── ACADEMY CARD ───────────────── */

class _AcademyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PowerPlay Cricket Academy',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text('⭐ 4.9 (128 Reviews)',
                    style: TextStyle(color: kMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── PACKAGE CARD ───────────────── */

class _PackageCard extends StatelessWidget {
  final _PackageModel data;
  final bool selected;
  final VoidCallback onTap;

  const _PackageCard({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? kGreen : Colors.transparent,
              width: 1.6,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: kGreen.withOpacity(0.35),
                      blurRadius: 16,
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                if (data.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.badgeColor ?? kGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(data.badge!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                const Spacer(),
                Icon(
                  selected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: selected ? kGreen : kMuted,
                )
              ]),
              const SizedBox(height: 10),
              Text(data.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(data.desc,
                  style:
                      const TextStyle(color: kMuted, height: 1.4)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.chips
                    .map((e) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(e,
                              style: const TextStyle(
                                  color: kMuted, fontSize: 12)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10),
              Row(
                children: [
                  Text('₹${data.price}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('+${data.coins} Z Coins',
                      style: const TextStyle(
                          color: kYellow, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Text(data.billing,
                  style:
                      const TextStyle(color: kMuted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────── BOTTOM CTA ───────────────── */

class _BottomCTA extends StatelessWidget {
  final List<_PackageModel> packages;
  final ValueNotifier<int> selectedIndex;

  const _BottomCTA({
    required this.packages,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (_, i, __) {
        final p = packages[i];
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: const BoxDecoration(color: Colors.black),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selected: ${p.title}',
                  style: const TextStyle(color: kMuted)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PaymentSuccessScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Continue — ₹${p.price}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ───────────────── MODEL ───────────────── */

class _PackageModel {
  final String? badge;
  final Color? badgeColor;
  final String title;
  final String desc;
  final List<String> chips;
  final int price;
  final String billing;
  final int coins;
  final bool highlight;

  _PackageModel({
    this.badge,
    this.badgeColor,
    required this.title,
    required this.desc,
    required this.chips,
    required this.price,
    required this.billing,
    required this.coins,
    this.highlight = false,
  });
}
