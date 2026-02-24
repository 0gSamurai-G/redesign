import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/trainer_navigation.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);

class TrainerPaymentSuccessScreen extends StatefulWidget {
  const TrainerPaymentSuccessScreen({super.key});

  @override
  State<TrainerPaymentSuccessScreen> createState() =>
      _TrainerPaymentSuccessScreenState();
}

class _TrainerPaymentSuccessScreenState
    extends State<TrainerPaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 40, 16, 140 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SuccessRipple(),
              /// SUCCESS ICON
              // AnimatedScale(
              //   scale: 1.0,
              //   duration: const Duration(milliseconds: 600),
              //   curve: Curves.easeOutBack,
              //   child: Stack(
              //     alignment: Alignment.center,
              //     children: [
              //       AnimatedBuilder(
              //         animation: _pulseController,
              //         builder: (_, __) {
              //           return Container(
              //             height: 110,
              //             width: 110,
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: kGreen.withOpacity(
              //                   0.25 + (_pulseController.value * 0.2)),
              //             ),
              //           );
              //         },
              //       ),
              //       Container(
              //         height: 72,
              //         width: 72,
              //         decoration: const BoxDecoration(
              //           color: kGreen,
              //           shape: BoxShape.circle,
              //         ),
              //         child: const Icon(Icons.check_rounded,
              //             color: Colors.white, size: 36),
              //       ),
              //     ],
              //   ),
              // ),
        
              const SizedBox(height: 24),
        
              /// SUCCESS TEXT
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your Trainer Pro membership is now active',
                style: TextStyle(
                  color: kMuted,
                  fontSize: 14,
                ),
              ),
        
              const SizedBox(height: 28),
        
              /// MEMBERSHIP CARD
              _MembershipSummaryCard(),
        
              const SizedBox(height: 20),
        
              /// BENEFITS
              _BenefitsUnlocked(),
        
              const SizedBox(height: 20),
        
              /// NEXT STEPS
              _NextStepsCard(),
        
              const SizedBox(height: 20),
        
              /// PAYMENT DETAILS
              _PaymentDetailsCard(),
            ],
          ),
        ),
      ),

      /// BOTTOM CTA
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: kCard)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// PRIMARY CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TrainerAppNavShell()));
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
                    'Go to Trainer Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// SECONDARY CTA
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: kGreen,
                  side: const BorderSide(color: kGreen),
                  padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'View Membership Details',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Need help? Contact Support',
                  style: TextStyle(
                    color: kMuted,
                    decoration: TextDecoration.underline,
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

/* ───────────────── MEMBERSHIP SUMMARY ───────────────── */

class _MembershipSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kGreen.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'MEMBERSHIP ACTIVE',
                style: TextStyle(
                  color: kMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Spacer(),
              Icon(Icons.verified_rounded, color: kGreen, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Trainer Pro – 1 Year',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.calendar_month_rounded,
                  size: 16, color: kGreen),
              SizedBox(width: 6),
              Text(
                'Valid until Dec 15, 2024',
                style: TextStyle(color: kGreen),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PriceRow(label: 'Plan Price', value: '₹4,999.00'),
          _PriceRow(label: 'GST (18%)', value: '₹899.82'),
          const Divider(color: kCard),
          _PriceRow(
            label: 'Total Charged',
            value: '₹5,898.82',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _PriceRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: highlight ? Colors.white : kMuted),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? kGreen : Colors.white,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              fontSize: highlight ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── BENEFITS ───────────────── */

class _BenefitsUnlocked extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      title: 'BENEFITS UNLOCKED',
      children: const [
        _BenefitRow('Verified Trainer Badge Activated'),
        _BenefitRow('Public Profile is Now Live'),
        _BenefitRow('Student Leads Enabled'),
        _BenefitRow('Analytics Dashboard Access'),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String text;
  const _BenefitRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded,
                size: 16, color: kGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── NEXT STEPS ───────────────── */

class _NextStepsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      title: 'NEXT STEPS',
      children: const [
        _StepRow(
          step: '1',
          title: 'Complete Your Profile',
          subtitle: 'Add photos and bio to attract students',
        ),
        _StepRow(
          step: '2',
          title: 'Set Availability',
          subtitle: 'Define your training slots',
        ),
        _StepRow(
          step: '3',
          title: 'Start Accepting Students',
          subtitle: 'Reply to incoming leads',
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;

  const _StepRow({
    required this.step,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: const BoxDecoration(
              color: kGreen,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: kMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── PAYMENT DETAILS ───────────────── */

class _PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      title: 'PAYMENT DETAILS',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.download_rounded, size: 16),
        label: const Text('PDF'),
        style: OutlinedButton.styleFrom(
          foregroundColor: kGreen,
          side: const BorderSide(color: kGreen),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      children: const [
        _DetailRow('Method', 'UPI (Google Pay)'),
        _DetailRow('Transaction ID', 'TXN88291039', mono: true),
        _DetailRow('Date', 'Dec 15, 2023, 10:42 AM'),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;

  const _DetailRow(this.label, this.value, {this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: kMuted)),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: mono ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── SHARED CARD ───────────────── */

class _SimpleCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  const _SimpleCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}


class SuccessRipple extends StatefulWidget {
  const SuccessRipple({super.key});

  @override
  State<SuccessRipple> createState() => _SuccessRippleState();
}

class _SuccessRippleState extends State<SuccessRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      child: SizedBox(
        height: 140,
        width: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Ripple 1
            _RippleWave(
              controller: _controller,
              delay: 0.0,
            ),

            /// Ripple 2 (delayed)
            // _RippleWave(
            //   controller: _controller,
            //   delay: 0.33,
            // ),

            // /// Ripple 3 (delayed)
            // _RippleWave(
            //   controller: _controller,
            //   delay: 0.66,
            // ),

            /// Core success circle
            Container(
              height: 72,
              width: 72,
              decoration: const BoxDecoration(
                color: kGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _RippleWave extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const _RippleWave({
    required this.controller,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final progress =
            ((controller.value + delay) % 1.0).clamp(0.0, 1.0);

        final scale = 1.0 + progress * 1.8;
        final opacity = (1.0 - progress).clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity * 0.35,
          child: Transform.scale(
            scale: scale,
            child: Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kGreen,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


