import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/USER/Trainer/trainer_platform_fee_limited.dart';
import 'package:redesign/USER/Trainer/trainer_platform_fee_success.dart';
import 'package:shimmer/shimmer.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);
const kGold = Color(0xFFF5C542);
const kRed = Color(0xFFE53935);

class TrainerProAccessScreen extends StatefulWidget {
  const TrainerProAccessScreen({super.key});

  @override
  State<TrainerProAccessScreen> createState() =>
      _TrainerProAccessScreenState();
}

class _TrainerProAccessScreenState extends State<TrainerProAccessScreen> {
  final ValueNotifier<int> selectedIndex = ValueNotifier(1);

  Duration offerTime = const Duration(hours: 4, minutes: 23, seconds: 12);
  Timer? timer;

  final plans = const [
    _Plan(
      title: '6 Months',
      price: '₹2,999',
      monthly: '₹500 / month',
      subtitle: 'Cost of a coffee per week',
    ),
    _Plan(
      title: '1 Year',
      price: '₹4,999',
      monthly: '₹416 / month',
      badge: 'MOST POPULAR',
      savings: 'Save 20%',
      subtitle: 'Best balance of price & value',
    ),
    _Plan(
      title: '3 Years',
      price: '₹11,999',
      monthly: '₹333 / month',
      badge: 'BEST VALUE',
      savings: 'Save 35%',
      subtitle: 'Maximum long-term savings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (offerTime.inSeconds > 0) {
        setState(() => offerTime -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    selectedIndex.dispose();
    super.dispose();
  }

  String _format(Duration d) =>
      '${d.inHours.toString().padLeft(2, '0')}:'
      '${(d.inMinutes % 60).toString().padLeft(2, '0')}:'
      '${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 700;
            final bottomInset = MediaQuery.of(context).padding.bottom;
        
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _OfferBanner(text: _format(offerTime)),
                
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    120 + bottomInset,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                        BlurredHeader(),
                      const SizedBox(height: 16),
                      const _VideoCard(),
                      const SizedBox(height: 16),
                      const _ValueCard(),
                      const SizedBox(height: 14),
                      const _TrustTags(),
                      const SizedBox(height: 24),
                      const _MembershipHeader(),
                      const SizedBox(height: 12),
                      
                      ValueListenableBuilder<int>(
                        valueListenable: selectedIndex,
                        builder: (_, value, __) {
                          if (isTablet) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.9,
                              ),
                              itemCount: plans.length,
                              itemBuilder: (_, i) => _PlanCard(
                                plan: plans[i],
                                selected: value == i,
                                onTap: () =>
                                    selectedIndex.value = i,
                              ),
                            );
                          }
        
                          return Column(
                            children: List.generate(
                              plans.length,
                              (i) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 12),
                                child: _PlanCard(
                                  plan: plans[i],
                                  selected: value == i,
                                  onTap: () =>
                                      selectedIndex.value = i,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
        
                      _FreeVsProComparison(),
                      const SizedBox(height: 20),
                      _WhyGoProSection(),
        
        const SizedBox(height: 20),
                      const _TrainerSuccessStories(),
        const SizedBox(height: 24),
        const _MoneyBackGuarantee(),
        const SizedBox(height: 32),
        const _FaqSection(),
        const SizedBox(height: 36),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _BottomCTA(
        plans: plans,
        selectedIndex: selectedIndex,
      ),
    );
  }
}

/* ───────────────── OFFER BANNER ───────────────── */

class _OfferBanner extends StatelessWidget {
  final String text;
  const _OfferBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          // top: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer,
                  color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'SPECIAL OFFER ENDS IN $text',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────── APP BAR ───────────────── */

class BlurredHeader extends StatelessWidget {
  const BlurredHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            16,
            topInset + 12,
            16,
            16,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(height: 10),
              Text(
                'Trainer Pro Access',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Invest in your coaching career',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/* ───────────────── VIDEO CARD ───────────────── */

class _VideoCard extends StatelessWidget {
  const _VideoCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1599058917212-d750089bc07c',
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade900,
                highlightColor: Colors.grey.shade800,
                child: Container(color: Colors.black),
              ),
            ),
            Container(color: Colors.black45),
            const Icon(Icons.play_circle_fill,
                size: 64, color: Colors.white),
            Positioned(
              left: 12,
              bottom: 12,
              right: 12,
              child: Text(
                'See how top trainers are winning',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────── VALUE CARD ───────────────── */

class _ValueCard extends StatelessWidget {
  const _ValueCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kGreen.withOpacity(0.25),
            Colors.black,
          ],
        ),
        border: Border.all(
          color: kGreen.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: kGreen.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ───── Header Row ─────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Icon badge
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGreen.withOpacity(0.18),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: kGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              /// Title + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Grow Your Business',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Get verified, manage students, and receive secure payouts directly to your bank account.',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// ───── Metrics ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _ValueMetric(
                value: '5k+',
                label: 'TRAINERS',
              ),
              _ValueMetric(
                value: '₹10Cr+',
                label: 'PAID OUT',
              ),
              _ValueMetric(
                value: '100%',
                label: 'SECURE',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _ValueMetric extends StatelessWidget {
  final String value;
  final String label;

  const _ValueMetric({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: kMuted,
            fontSize: 11,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

/* ───────────────── MODELS & SMALL WIDGETS ───────────────── */

class _Metric extends StatelessWidget {
  final String value, label;
  const _Metric(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: kMuted, fontSize: 11)),
      ],
    );
  }
}

class _Plan {
  final String title, price, monthly, subtitle;
  final String? badge, savings;

  const _Plan({
    required this.title,
    required this.price,
    required this.monthly,
    required this.subtitle,
    this.badge,
    this.savings,
  });
}

/* ───────────────── PLAN CARD ───────────────── */

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? kGreen : Colors.transparent,
          width: 1.4,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: kGreen.withOpacity(0.28),
                  blurRadius: 5,
                )
              ]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        plan.badge == 'BEST VALUE' ? kGold : kGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    plan.badge!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(plan.price,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  if (selected)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.check_circle,
                          color: kGreen, size: 18),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(plan.monthly,
                  style: const TextStyle(color: kMuted)),
              if (plan.savings != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(plan.savings!,
                      style: const TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.w600)),
                ),
              const SizedBox(height: 6),
              Text(
                plan.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: kMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────── BOTTOM CTA ───────────────── */

class _BottomCTA extends StatelessWidget {
  final List<_Plan> plans;
  final ValueNotifier<int> selectedIndex;

  const _BottomCTA({
    required this.plans,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (_, i, __) {
          final plan = plans[i];

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(top: BorderSide(color: kCard)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ───── Selected Plan Row ─────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Plan',
                            style: TextStyle(
                              color: kMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plan.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      plan.price,
                      style: const TextStyle(
                        color: kGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// ───── Primary CTA Button ─────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TrainerPaymentSuccessScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(
                      'Continue to Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// ───── Skip Option ─────
                GestureDetector(
                  onTap: () {
                    // handle skip
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TrainerLimitedAccessScreen()));
                  },
                  child: const Text(
                    'Skip for now (Limited Access)',
                    style: TextStyle(
                      color: kMuted,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


/* ───────────────── TRUST TAGS ───────────────── */

class _TrustTags extends StatelessWidget {
  const _TrustTags();

  @override
  Widget build(BuildContext context) {
    final tags = const [
      _TrustTag(icon: Icons.verified, label: 'VERIFIED'),
      _TrustTag(icon: Icons.flash_on, label: 'INSTANT'),
      _TrustTag(icon: Icons.public, label: 'GLOBAL'),
      _TrustTag(icon: Icons.workspace_premium, label: 'PREMIER'),
    ];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => tags[i],
      ),
    );
  }
}

class _TrustTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: kMuted),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: kMuted,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

/* ───────────────── HEADER ───────────────── */

class _MembershipHeader extends StatelessWidget {
  const _MembershipHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'SELECT MEMBERSHIP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const Spacer(),
        Row(
          children: const [
            Icon(Icons.lock_outline_rounded,
                size: 14, color: kGreen),
            SizedBox(width: 6),
            Text(
              'SECURE PAYMENT',
              style: TextStyle(
                color: kGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _FreeVsProComparison extends StatelessWidget {
  const _FreeVsProComparison();

  @override
  Widget build(BuildContext context) {
    final rows = const [
      _ComparisonRow(
        feature: 'Verified Badge',
        basic: false,
        pro: true,
      ),
      _ComparisonRow(
        feature: 'Unlimited Students',
        basic: false,
        pro: true,
      ),
      _ComparisonRow(
        feature: 'Secure Payments',
        basic: true,
        pro: true,
      ),
      _ComparisonRow(
        feature: 'Priority Support',
        basic: false,
        pro: true,
      ),
      _ComparisonRow(
        feature: 'Marketing Boost',
        basic: false,
        pro: true,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FREE VS PRO COMPARISON',
            style: TextStyle(
              color: kMuted,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),

          /// Header Row
          Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  'Feature',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'BASIC',
                    style: TextStyle(
                      color: kMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'PRO',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: kCard, height: 1),

          /// Rows
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      row.feature,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: _CheckIcon(enabled: row.basic),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: _CheckIcon(
                        enabled: row.pro,
                        highlight: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── HELPERS ───────────────── */

class _ComparisonRow {
  final String feature;
  final bool basic;
  final bool pro;

  const _ComparisonRow({
    required this.feature,
    required this.basic,
    required this.pro,
  });
}

class _CheckIcon extends StatelessWidget {
  final bool enabled;
  final bool highlight;

  const _CheckIcon({
    required this.enabled,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return const Icon(
        Icons.close_rounded,
        size: 18,
        color: kMuted,
      );
    }

    return Icon(
      Icons.check_circle_rounded,
      size: 18,
      color: highlight ? kGreen : Colors.white,
    );
  }
}


class _WhyGoProSection extends StatelessWidget {
  const _WhyGoProSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'WHY GO PRO?',
          style: TextStyle(
            color: kMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 16),

        _WhyGoProItem(
          icon: Icons.verified_rounded,
          title: 'Instant Trust Factor',
          description:
              'Verified profiles get 3x more inquiries from parents. Stand out in search results.',
        ),
        SizedBox(height: 16),

        _WhyGoProItem(
          icon: Icons.group_rounded,
          title: 'Zero Commission on Leads',
          description:
              "Direct inquiries from athletes in your area. We don’t charge for connections.",
        ),
        SizedBox(height: 16),

        _WhyGoProItem(
          icon: Icons.grid_view_rounded,
          title: 'Automated Management',
          description:
              'Track attendance, payments, and schedule sessions without the spreadsheet headache.',
        ),
      ],
    );
  }
}

/* ───────────────── ITEM ───────────────── */

class _WhyGoProItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _WhyGoProItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: kGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: kMuted,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




class _TrainerSuccessStories extends StatelessWidget {
  const _TrainerSuccessStories();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TRAINER SUCCESS STORIES',
          style: TextStyle(
            color: kMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _stories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _StoryCard(story: _stories[i]),
          ),
        ),
      ],
    );
  }
}

class _Story {
  final String name;
  final String role;
  final String quote;
  final String imageUrl;
  final bool verified;

  const _Story({
    required this.name,
    required this.role,
    required this.quote,
    required this.imageUrl,
    this.verified = true,
  });
}

const _stories = [
  _Story(
    name: 'Rahul Sharma',
    role: 'Cricket Coach • Pune',
    quote:
        'Since joining, my student base doubled in just 3 months. The dashboard makes management so easy.',
    imageUrl:
        'https://randomuser.me/api/portraits/men/32.jpg',
  ),
  _Story(
    name: 'Anita Verma',
    role: 'Fitness Trainer • Delhi',
    quote:
        'I get genuine leads every week now. The verification badge builds instant trust.',
    imageUrl:
        'https://randomuser.me/api/portraits/women/44.jpg',
  ),
];


class _StoryCard extends StatelessWidget {
  final _Story story;
  const _StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(story.imageUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            story.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (story.verified)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: kGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'VERIFIED',
                              style: TextStyle(
                                color: kGreen,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      story.role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: kMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              '"${story.quote}"',
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _MoneyBackGuarantee extends StatelessWidget {
  const _MoneyBackGuarantee();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.verified_user_rounded,
              color: kGreen, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '7-Day Money Back Guarantee',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'If your application is rejected or you change your mind within 7 days, get a full refund.',
                  style: TextStyle(
                    color: kMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'FREQUENTLY ASKED QUESTIONS',
          style: TextStyle(
            color: kMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 12),
        _FaqTile(
          question: 'How do payouts work?',
          answer:
              'Payouts are processed securely and deposited directly into your bank account.',
        ),
        _FaqTile(
          question: 'Can I upgrade my plan later?',
          answer:
              'Yes, you can upgrade anytime and only pay the difference.',
        ),
        _FaqTile(
          question: 'Is my data secure?',
          answer:
              'We use bank-grade security and encrypted storage.',
        ),
        _FaqTile(
          question: 'Do you provide students?',
          answer:
              'We help you get discovered. Direct inquiries depend on your profile and activity.',
        ),
      ],
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      collapsedBackgroundColor: kCard,
      backgroundColor: kCard,
      iconColor: kGreen,
      collapsedIconColor: kMuted,
      title: Text(
        question,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: const TextStyle(
              color: kMuted,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}


