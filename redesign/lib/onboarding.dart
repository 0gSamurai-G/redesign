import 'package:flutter/material.dart';
import 'package:redesign/login.dart';

void main() {
  runApp(const PlayZApp());
}

/* ============================================================
   APP ROOT
   ============================================================ */
class PlayZApp extends StatelessWidget {
  const PlayZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayZ Onboarding',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const OnboardingScreen(),
    );
  }
}

/* ============================================================
   ONBOARDING SCREEN (STATEFUL)
   ============================================================ */
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Spotify-style colors
  static const Color bg = Color(0xFF121212);
  // static const Color accent = Color(0xFF1DB954);
  // static const Color muted = Color(0xFF9CA3AF);

  // Page controller for swipe + button control
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  /// Centralized onboarding data
  /// Easy to modify, reorder, or A/B test later
  final List<_OnboardData> _pages = const [
    _OnboardData(
      tag: '#1 SPORTS APP',
      title: 'India’s Sports Community,\nin Your Pocket',
      subtitle:
          'Book top-rated turfs, find local players instantly, and track your match stats — all in one place.',
      image:
          'https://images.unsplash.com/photo-1546519638-68e109498ffc',
    ),
    _OnboardData(
      tag: 'FAST & EASY',
      title: 'Instant Booking\nMade Simple',
      subtitle:
          'Find nearby turfs, check real-time availability, and book your slot in seconds.',
      image:
          'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
    ),
    _OnboardData(
      tag: 'COMMUNITY',
      title: 'Never Play\nAlone Again',
      subtitle:
          'Join solo queue, connect with players nearby, and build your dream squad.',
      image:
          'https://images.unsplash.com/photo-1517649763962-0c623066013b',
    ),
    _OnboardData(
      tag: 'LEADERBOARDS',
      title: 'Gamify Your\nGame',
      subtitle:
          'Track your performance, climb ranks, and stay motivated to play more.',
      image:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a',
    ),
  ];

  /// Navigate to next page or finish onboarding
  void _next() {
    if (_currentIndex == _pages.length - 1) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  /// Final CTA handler
  void _finishOnboarding() {
    // TODO: Navigate to Login / Home
    // Navigator.pushReplacement(...)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onSkip: _finishOnboarding),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (_, index) {
                  return _OnboardPage(data: _pages[index]);
                },
              ),
            ),
            _BottomControls(
              currentIndex: _currentIndex,
              total: _pages.length,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   TOP BAR (LOGO + SKIP)
   ============================================================ */
class _TopBar extends StatelessWidget {
  final VoidCallback onSkip;

  const _TopBar({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Row(
            children: const [
              Icon(Icons.flash_on, color: Color(0xFF1DB954)),
              SizedBox(width: 6),
              Text(
                'PlayZ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: onSkip,
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   SINGLE ONBOARD PAGE
   ============================================================ */
class _OnboardPage extends StatelessWidget {
  final _OnboardData data;

  const _OnboardPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Illustration / Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.network(
                data.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 32),

          /// Tag / Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1DB954).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.tag,
              style: const TextStyle(
                color: Color(0xFF1DB954),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          /// Subtitle
          Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   BOTTOM CONTROLS (DOTS + NEXT)
   ============================================================ */
class _BottomControls extends StatelessWidget {
  final int currentIndex;
  final int total;
  final VoidCallback onNext;

  const _BottomControls({
    required this.currentIndex,
    required this.total,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLast = currentIndex == total - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Row(
        children: [
          /// Progress dots
          Row(
            children: List.generate(
              total,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                height: 6,
                width: currentIndex == index ? 24 : 6,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color(0xFF1DB954)
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const Spacer(),

          /// CTA Button
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DB954),
              foregroundColor: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(isLast ? "Let's Play" : 'Next →'),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   DATA MODEL (FUTURE FRIENDLY)
   ============================================================ */
class _OnboardData {
  final String tag;
  final String title;
  final String subtitle;
  final String image;

  const _OnboardData({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
