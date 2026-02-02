import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/USER/Home/home.dart';
import 'package:redesign/USER/Book/show_qr.dart';
import 'package:shimmer/shimmer.dart';

const kBg = Colors.black;
const kCard = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);
const kYellow = Color(0xFFFFC107);

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _heroController;
late Animation<double> _scaleAnim;
late Animation<double> _moveUpAnim;
late Animation<double> _contentOpacity;


  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }


  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _successAnimation(),
              const SizedBox(height: 0),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Confirmation sent to john.doe@gmail.com',
                style: TextStyle(color: kMuted),
              ),
              const SizedBox(height: 24),

              _venueCard(size),
              const SizedBox(height: 20),

              _paymentSummary(),
              const SizedBox(height: 20),

              _thingsToRemember(),
              const SizedBox(height: 28),

              _primaryActions(),
              const SizedBox(height: 20),

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

  // ------------------------------------------------------------
  // SUCCESS ANIMATION (CHECK + RIPPLE)
  Widget _successAnimation() {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rippleController,
            builder: (_, __) {
              return Container(
                width: 120 * _rippleController.value,
                height: 120 * _rippleController.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGreen.withOpacity(
                    1 - _rippleController.value,
                  ),
                ),
              );
            },
          ),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kGreen,
            ),
            child: const Icon(Icons.check, size: 36, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // VENUE CARD
  Widget _venueCard(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1546519638-68e109498ffc',
                  height: size.width * 0.45,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade900,
                    highlightColor: Colors.grey.shade800,
                    child: Container(color: Colors.black),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.sports_soccer,
                            color: kGreen, size: 16),
                        SizedBox(width: 6),
                        Text('Football',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
  padding: const EdgeInsets.symmetric(vertical: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Text(
          'CrossFit Arena',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 4),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Text(
          'ID: #PZ-883492',
          style: TextStyle(
            color: kMuted,
            fontFamily: 'monospace',
          ),
        ),
      ),

      const SizedBox(height: 16),

      /// 🔥 NOTCHED DASHED DIVIDER
      const NotchedDashedDivider(),

      const SizedBox(height: 16),

      _infoRow('Date', 'Thu, 4 Dec'),
      _infoRow('Time', '08:00 – 09:00 AM'),
      _infoRow('Players', '4 (Solo Queue)'),
      _infoRow('Location', 'Shivajinagar'),
      const SizedBox(height: 8),
      _weatherCard(),
      const SizedBox(height: 12),
      _qrBlock(),
    ],
  ),
),

        ],
      ),
    );
  }






  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: kMuted)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _weatherCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.wb_sunny, color: kYellow),
            SizedBox(width: 8),
            Text('24°C • Partly Cloudy • Good conditions',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _qrBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_){return ShowQrScreen();}));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Scan at Entry',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Show this code at reception',
                        style: TextStyle(color: kMuted)),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white,),
                width: 56,
                height: 56,
                
                child: const Icon(Icons.qr_code, size: 40,color: Colors.black,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PAYMENT SUMMARY
  Widget _paymentSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _priceRow('Slot Price (1 hr)', '₹400.00'),
          _priceRow('Convenience Fee', '₹50.00'),
          _priceRow('Equipment (Ball)', 'Included'),
          const Divider(color: Colors.grey),
          Row(
            children: [
              const Text('Total Paid',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Text('₹450.00',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kYellow.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('+10 ZC',
                    style: TextStyle(color: kYellow)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: kMuted)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // REMINDERS
  Widget _thingsToRemember() {
    final reminders = [
      'Arrive 15 minutes early',
      'Wear non-marking shoes',
      'Show QR code at reception',
      'Cancellations up to 2 hours prior',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Things to Remember',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...reminders.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6, color: kGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(e, style: const TextStyle(color: kMuted)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ACTION BUTTONS
  Widget _primaryActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {},
            child: const Text('Go to My Bookings',
                style:
                    TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade800),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          ),
          onPressed: () {},
          child: const Text('Invite Friends',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}


class NotchedDashedDivider extends StatelessWidget {
  const NotchedDashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// DASHED LINE
          Positioned.fill(
            child: CustomPaint(
              painter: _DashedLinePainter(),
            ),
          ),

          /// LEFT NOTCH
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 16,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black, // matches background
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(16),
                ),
              ),
            ),
          ),

          /// RIGHT NOTCH
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 16,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 1;

    const dashWidth = 6.0;
    const dashSpace = 6.0;

    double startX = 20; // leave space for notch
    final endX = size.width - 20;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}