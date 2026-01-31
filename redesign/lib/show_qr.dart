import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

const kBg = Colors.black;
const kCard = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);

class ShowQrScreen extends StatelessWidget {
  const ShowQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              const SizedBox(height: 20),
              _bookingCard(size),
              const SizedBox(height: 20),
              _qrNote(),
              const SizedBox(height: 16),
              _venueInfo(),
              const SizedBox(height: 20),
              _actions(),
              const SizedBox(height: 24),
              _support(),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TOP BAR
  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Show this QR Code at the Venue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Your booking is confirmed. This is your entry pass.',
                style: TextStyle(color: kMuted, fontSize: 13),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // BOOKING CARD
  Widget _bookingCard(Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _verifiedBadge(),
          const SizedBox(height: 20),

          /// QR PLACEHOLDER
          Container(
  width: size.width * 0.55,
  constraints: const BoxConstraints(maxWidth: 240),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: kGreen.withOpacity(0.15),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ],
),
  child: AspectRatio(
    aspectRatio: 1,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: QrImageView(
        data: 'PZ-883492-QR|CrossFit Arena|08:00-09:00', // dynamic later
        version: QrVersions.auto,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        gapless: false,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
      ),
    ),
  ),
),

          const SizedBox(height: 20),

          const Text(
            'CrossFit Arena',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            'Thu, 4 Dec · 08:00 AM – 09:00 AM',
            style: TextStyle(color: kMuted),
          ),

          const SizedBox(height: 6),

          const Text(
            'Football · Solo Queue · 4 Players',
            style: TextStyle(color: kMuted, fontSize: 13),
          ),

          const SizedBox(height: 14),

          _bookingId(),
        ],
      ),
    );
  }

  Widget _verifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kGreen.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: kGreen, size: 16),
          SizedBox(width: 6),
          Text(
            'Verified PlayZ Booking',
            style: TextStyle(color: kGreen, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _bookingId() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white24,
          style: BorderStyle.solid,
        ),
      ),
      child: const Text(
        'Booking ID: PZ-883492-QR',
        style: TextStyle(color: kMuted, fontSize: 12),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // QR NOTE
  Widget _qrNote() {
    return const Text(
      'This QR code is valid only for the selected slot.\n'
      'Keep your screen brightness high and show it at the gate or reception for a quick check-in.',
      style: TextStyle(color: kMuted, height: 1.4),
    );
  }

  // ─────────────────────────────────────────────
  // VENUE INFO
  Widget _venueInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: kGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Venue',
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Shivajinagar, Pune',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Gate Access',
                style: TextStyle(color: kMuted, fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                'QR Scan Required',
                style: TextStyle(color: kGreen),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.navigation, size: 16, color: kGreen),
                label: const Text(
                  'Get Directions',
                  style: TextStyle(color: kGreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ACTIONS
  Widget _actions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, color: Colors.black),
            label: const Text(
              'Download QR',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Save to Gallery',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SUPPORT
  Widget _support() {
    return Center(
      child: RichText(
        text: const TextSpan(
          text: 'Having trouble at the venue? ',
          style: TextStyle(color: kMuted),
          children: [
            TextSpan(
              text: 'Contact Support',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
