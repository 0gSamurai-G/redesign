import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF1DB954);
const kRed = Color(0xFFE53935);
const kAmber = Color(0xFFF5C542);
const kMuted = Color(0xFFA7A7A7);

enum BookingStatus { confirmed, cancelled, expired }

class BookingQrScreen extends StatelessWidget {
  const BookingQrScreen({super.key});

  final BookingStatus status = BookingStatus.confirmed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              // Header (moved from AppBar into the scrollable body)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Booking Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              _QrSection(status: status),
              const SizedBox(height: 20),
              _BookingInfoCard(),
              const SizedBox(height: 12),
              _LocationCard(),
              const SizedBox(height: 12),
              _PaymentSummaryCard(),
              const SizedBox(height: 12),
              const _WeatherAlert(),
              const SizedBox(height: 20),
              _ActionSection(status: status),
              const SizedBox(height: 24),
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


class _QrSection extends StatelessWidget {
  final BookingStatus status;
  const _QrSection({required this.status});

  Color get glowColor {
    switch (status) {
      case BookingStatus.confirmed:
        return kGreen;
      case BookingStatus.cancelled:
        return kRed;
      case BookingStatus.expired:
        return Colors.white24;
    }
  }

  String get statusText {
    switch (status) {
      case BookingStatus.confirmed:
        return 'CONFIRMED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
      case BookingStatus.expired:
        return 'EXPIRED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth * 0.75;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.35),
                    blurRadius: 5,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
                child: QrImageView(
                  data: 'BOOKING_ID_PZ_8821',
                  size: size,
                  backgroundColor: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Show this QR at the venue counter',
          style: TextStyle(color: kMuted),
        ),
        const SizedBox(height: 10),
        _StatusBadge(statusText,
            status == BookingStatus.confirmed ? kGreen : kRed),
        const SizedBox(height: 6),
        const Text(
          'Booking ID: #PZ-8821',
          style: TextStyle(color: kMuted, fontSize: 12),
        ),
      ],
    );
  }
}


class _BookingInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Booking Information',
      child: Column(
        children: const [
          _InfoRow('Venue', 'Neon Futsal Arena'),
          _InfoRow('Date', 'Today, 24 Oct'),
          _InfoRow('Time', '20:00 – 21:00', highlight: true),
          _InfoRow('Sport', 'Football (5-a-side)'),
          _InfoRow('Court', 'Court 4'),
          _InfoRow('Duration', '60 mins'),
          _InfoRow('Players', '10 max'),
        ],
      ),
    );
  }
}


class _LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Location',
      trailing: const Text('2.5 km away',
          style: TextStyle(color: kGreen, fontWeight: FontWeight.w600)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plot No 45, behind FC Road, Shivajinagar, Pune, Maharashtra 411005',
            style: TextStyle(color: kMuted),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.near_me_outlined),
            label: const Text('Get Directions'),
          )
        ],
      ),
    );
  }
}


class _PaymentSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Payment Summary',
      child: Column(
        children: const [
          _AmountRow('Court Fee', '₹1,200'),
          _AmountRow('Conv. Fee', '₹40'),
          Divider(color: Colors.white12),
          _AmountRow('Total Paid', '₹1,240', highlight: true),
          SizedBox(height: 6),
          _AmountRow('Payment Method', 'UPI ••••8821'),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '⬇ Download Invoice',
              style: TextStyle(
                color: kGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _WeatherAlert extends StatelessWidget {
  const _WeatherAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2C00), Color(0xFF1E1400)],
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.cloud_outlined, color: kAmber),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Light rain expected during your slot. Venue has covered roof available.',
              style: TextStyle(color: kAmber),
            ),
          ),
        ],
      ),
    );
  }
}


class _ActionSection extends StatelessWidget {
  final BookingStatus status;
  const _ActionSection({required this.status});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (status == BookingStatus.confirmed)
          _PrimaryAction('Chat with Venue', Icons.chat),
        _OutlinedAction('Add to Calendar', Icons.event),
        if (status == BookingStatus.confirmed)
          _OutlinedAction('Reschedule', Icons.schedule),
        _DangerAction('Cancel Booking'),
      ],
    );
  }
}


class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Card({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}


class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _InfoRow(
    this.label,
    this.value, {
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
              style: const TextStyle(
                color: kMuted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: highlight ? kGreen : Colors.white,
                fontSize: 13,
                fontWeight:
                    highlight ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _AmountRow(
    this.label,
    this.value, {
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
              style: TextStyle(
                color: highlight ? Colors.white : kMuted,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.white : Colors.white70,
              fontSize: 14,
              fontWeight:
                  highlight ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


class _PrimaryAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _PrimaryAction(
    this.label,
    this.icon, {
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kGreen,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _OutlinedAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _OutlinedAction(
    this.label,
    this.icon, {
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _DangerAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _DangerAction(
    this.label, {
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: kRed.withOpacity(0.4),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: kRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
