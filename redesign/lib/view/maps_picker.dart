import 'package:flutter/material.dart';

/// COLORS
const Color kSpotifyGreen = Color(0xFF1DB954);
const Color kBg = Color(0xFF000000);
const Color kSurface = Color(0xFF0E0E0E);
const Color kCard = Color(0xFF1A1A1A);
const Color kMuted = Color(0xFFA7A7A7);

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          /// 🔥 MAP BACKGROUND (placeholder grid)
          const _MapBackground(),

          /// 🔥 TOP BAR + SEARCH
          SafeArea(
            child: Column(
              children: const [_TopBar(), SizedBox(height: 12), _SearchBar()],
            ),
          ),

          /// 🔥 CENTER PIN + LABEL
          const CenterPin(),

          /// 🔥 GPS BUTTON
          const Positioned(right: 16, bottom: 200, child: _GpsButton()),

          /// 🔥 BOTTOM SHEET
          const Align(
            alignment: Alignment.bottomCenter,
            child: _BottomLocationCard(),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 TOP BAR
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          const Text(
            "Select Location",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Text(
            "CONFIRM",
            style: TextStyle(color: kMuted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 SEARCH BAR
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: kMuted),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Search for your court or area...",
                style: TextStyle(color: kMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 MAP BACKGROUND (GRID STYLE)
class _MapBackground extends StatelessWidget {
  const _MapBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBg,
      child: CustomPaint(painter: _GridPainter(), size: Size.infinite),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    const spacing = 25;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

////////////////////////////////////////////////////////////
/// 🔥 CENTER PIN + LABEL
class CenterPin extends StatelessWidget {
  const CenterPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// LABEL
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "MOVE MAP TO ADJUST LOCATION",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),

        const SizedBox(height: 16),

        /// GLOW PIN
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: kSpotifyGreen.withOpacity(0.6),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(Icons.location_on, color: kSpotifyGreen, size: 50),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 GPS BUTTON
class _GpsButton extends StatelessWidget {
  const _GpsButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(14),
      child: const Icon(Icons.my_location, color: Colors.white),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 BOTTOM CARD
class _BottomLocationCard extends StatelessWidget {
  const _BottomLocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// DRAG HANDLE
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          /// LOCATION INFO
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kSpotifyGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on, color: kSpotifyGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Shivajinagar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Fergusson College Rd, Shivajinagar, Pune, Maharashtra 411004, India",
                      style: TextStyle(color: kMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// CONFIRM BUTTON
          Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kSpotifyGreen,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: kSpotifyGreen.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "Confirm Location",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
