import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF121212);
const kCard = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);
const kYellow = Color(0xFFFFC107);

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _successController;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _successController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// SUCCESS ICON
              SizedBox(
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _RippleEffect(controller: _rippleController),
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _successController,
                        curve: Curves.easeOutBack,
                      ),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: kGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: kGreen.withOpacity(0.6),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.black,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// SUCCESS TEXT
              FadeTransition(
                opacity: _successController,
                child: Column(
                  children: const [
                    Text(
                      'Payment Successful!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You are successfully enrolled in the\n1-Day Trial Access program.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ACADEMY CARD
              _AcademySummaryCard(),

              const SizedBox(height: 16),

              /// PACKAGE CARD
              _PackagePurchasedCard(),

              const SizedBox(height: 28),

              /// ACTIONS
              spotifyOutlinedButton(
  text: 'Chat with Academy',
  icon: Icons.chat_bubble_outline,
  onTap: () {
    // navigate to chat
  },
),


              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: kMuted,
                    fontSize: 14,
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

/// ───────────────── SUCCESS RIPPLE ─────────────────

class _RippleEffect extends StatelessWidget {
  final AnimationController controller;
  final double baseSize;

  const _RippleEffect({
    required this.controller,
    this.baseSize = 96, // size of the core circle
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final value = controller.value;

        final double rippleSize = baseSize + (value * 80);
        final double opacity = (1 - value).clamp(0.0, 1.0);

        return Container(
          width: rippleSize,
          height: rippleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: kGreen.withOpacity(0.35 * opacity),
              width: 2.5,
            ),
          ),
        );
      },
    );
  }
}


/// ───────────────── ACADEMY SUMMARY ─────────────────

class _AcademySummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade900,
                highlightColor: Colors.grey.shade800,
                child: Container(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'PowerPlay Cricket Academy',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: kMuted, size: 14),
                    SizedBox(width: 4),
                    Text('Baner, Pune',
                        style: TextStyle(color: kMuted, fontSize: 12)),
                    SizedBox(width: 10),
                    Icon(Icons.star, color: kYellow, size: 14),
                    SizedBox(width: 4),
                    Text('4.9',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────────────── PACKAGE PURCHASED ─────────────────

class _PackagePurchasedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: const Border(
          left: BorderSide(color: kGreen, width: 3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PACKAGE PURCHASED',
            style: TextStyle(
              color: kGreen,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1-Day Trial Access',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: kMuted),
              SizedBox(width: 6),
              Text('Valid for 24 Hours',
                  style: TextStyle(color: kMuted)),
            ],
          ),

          const Divider(color: Colors.grey),

          _infoRow('Amount Paid', '₹150.00'),
          _infoRow('Rewards Earned', '+15 Z Coins',
              valueColor: kYellow),

          const SizedBox(height: 8),

          Row(
            children: const [
              Text('Transaction ID',
                  style: TextStyle(color: kMuted, fontSize: 12)),
              Spacer(),
              Text(
                '#TXN882901',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: const [
              _Chip(label: 'Kit Provided'),
              _Chip(label: '1 Hr Net Practice'),
            ],
          )
        ],
      ),
    );
  }

  static Widget _infoRow(String label, String value,
      {Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: kMuted)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: valueColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// ───────────────── CHIP ─────────────────

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

Widget spotifyOutlinedButton({
  required String text,
  required VoidCallback onTap,
  IconData? icon,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      splashColor: kGreen.withOpacity(0.15),
      highlightColor: kGreen.withOpacity(0.08),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: kGreen, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: kGreen.withOpacity(0.25),
              blurRadius: 12,
              spreadRadius: -6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: kBg, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: const TextStyle(
                color: kBg,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
