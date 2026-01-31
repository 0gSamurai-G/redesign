
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/onboarding.dart';

void main() {
  runApp(const PlayZApp());
}

class PlayZApp extends StatelessWidget {
  const PlayZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayZ',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
    );
  }
}

/* ============================================================
   SPLASH SCREEN
   ============================================================ */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color bg = Color(0xFF121212);
  static const Color accent = Color(0xFF1DB954);

  late AnimationController _logoController;
  late AnimationController _rippleController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _rippleAnim;

  final List<_GlassBubble> _glassBubbles = [];

  @override
  void initState() {
    super.initState();

    /// Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    /// Single ripple
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _rippleAnim =
        CurvedAnimation(parent: _rippleController, curve: Curves.easeOut);

    _logoController.forward();
    _rippleController.forward();

    /// Glass morph bubbles (3–4 only)
    for (int i = 0; i < 4; i++) {
      _glassBubbles.add(_GlassBubble(vsync: this));
    }

    Timer(const Duration(seconds: 3), _goNext);
  }

  void _goNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _rippleController.dispose();
    for (final g in _glassBubbles) {
      g.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bg, // PURE SPOTIFY BLACK
      body: Stack(
        children: [
          /// Subtle glass bubbles (ambient only)
          ..._glassBubbles.map((b) => b.build(size)),

          /// Logo + ripple
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _rippleAnim,
                      builder: (_, __) {
                        final v = _rippleAnim.value;
                        return Opacity(
                          opacity: 1 - v,
                          child: Container(
                            width: 110 + v * 120,
                            height: 110 + v * 120,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(28 + v * 26),
                              border: Border.all(
                                color: accent.withOpacity(0.8),
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.6),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.flash_on,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'PlayZ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "LET'S PLAY. LET'S WIN.",
                  style: TextStyle(
                    color: accent.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
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

/* ============================================================
   GLASS MORPH BUBBLE (SUBTLE)
   ============================================================ */
class _GlassBubble {
  final AnimationController controller;
  late Animation<Offset> animation;
  final double size;

  _GlassBubble({required TickerProvider vsync})
      : size = 120 + Random().nextDouble() * 80,
        controller = AnimationController(
          vsync: vsync,
          duration: Duration(seconds: 16 + Random().nextInt(8)),
        ) {
    animation = Tween<Offset>(
      begin: Offset(Random().nextDouble(), Random().nextDouble()),
      end: Offset(Random().nextDouble(), Random().nextDouble()),
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutSine),
    );
    controller.repeat(reverse: true);
  }

  Widget build(Size screen) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Positioned(
          left: screen.width * animation.value.dx - size / 2,
          top: screen.height * animation.value.dy - size / 2,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1DB954).withOpacity(0.05),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(color: Colors.transparent),
            ),
          ),
        );
      },
    );
  }

  void dispose() => controller.dispose();
}

/* ============================================================
   NEXT SCREEN PLACEHOLDER
   ============================================================ */
class DummyNextScreen extends StatelessWidget {
  const DummyNextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Text('Next Screen', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}