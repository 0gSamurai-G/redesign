

import 'package:flutter/material.dart';
import 'package:redesign/USER/Home/Bookings/qr_in_bookings.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF1DB954);
const kMuted = Colors.white70;
const kRed = Color(0xFFE53935);
const kAmber = Color(0xFFFFB300);

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            const _BookingsHeader(),
            const _SearchAndFilters(),
            _BookingsTabs(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _UpcomingBookings(),
                  _PastBookings(),
                  _CancelledBookings(),
                  _EmptyState(
                    icon: Icons.timer_off,
                    text: 'No waitlisted bookings',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _BookingsHeader extends StatelessWidget {
  const _BookingsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Bookings',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('Upcoming sessions & history',
                    style: TextStyle(color: kMuted, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 18,
            backgroundImage:
                NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
          ),
        ],
      ),
    );
  }
}


class _SearchAndFilters extends StatelessWidget {
  const _SearchAndFilters();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search by venue, sport or ID…',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: kSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              _FilterChip('Filters', icon: Icons.tune),
              _FilterChip('This Week'),
              _FilterChip('Football'),
              _FilterChip('Cricket'),
              _FilterChip('Badminton'),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _FilterChip(this.label, {this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        backgroundColor: kSurface,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: 14, color: kGreen),
            if (icon != null) const SizedBox(width: 6),
            Text(label,
                style:
                    const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        shape: StadiumBorder(
          side: BorderSide(color: kGreen.withOpacity(0.6)),
        ),
      ),
    );
  }
}


class _BookingsTabs extends StatelessWidget {
  final TabController controller;
  const _BookingsTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,                 // 🔑 allows left alignment
  tabAlignment: TabAlignment.start,   // 🔑 Flutter 3.10+
  padding: const EdgeInsets.only(left: 16), // 👈 shifts tabs left
      controller: controller,
      indicatorColor: kGreen,
      labelColor: kGreen,
      unselectedLabelColor: Colors.white70,
      tabs: const [
        Tab(text: 'Upcoming'),
        Tab(text: 'Past'),
        Tab(text: 'Cancelled'),
        Tab(text: 'Waitlist'),
      ],
    );
  }
}


class _WeatherAlert extends StatelessWidget {
  const _WeatherAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A1C1C), Color(0xFF2A0F0F)],
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.umbrella, color: kAmber),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Heavy rain forecast. Venue will confirm status by 6:00 AM tomorrow.',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}


class _UpcomingBookings extends StatelessWidget {
  const _UpcomingBookings();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 32),
      children: const [
        _WeatherAlert(),
        _BookingCardUpcoming(),
      ],
    );
  }
}


class _BookingCardUpcoming extends StatelessWidget {
  const _BookingCardUpcoming();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),

      /// 🔹 CARD TAP (ONLY THIS navigates)
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const BookingQrScreen(),
              ),
            );
          },

          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a',
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Neon Futsal Arena',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Court 4 · 5-a-side',
                            style: TextStyle(
                              color: kMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _StatusBadge('CONFIRMED', kGreen),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  '20:00 – 21:00 · 60 mins',
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),

                const SizedBox(height: 6),

                const Text(
                  '📍 Shivajinagar, Pune · 2.5 km away',
                  style: TextStyle(color: kMuted, fontSize: 12),
                ),

                const SizedBox(height: 12),

                /// 🔹 ACTIONS (SEPARATE — DO NOT NAVIGATE)
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _ActionChip(
                      Icons.directions,
                      'Directions',
                      onTap: () {
                        // open maps
                      },
                    ),
                    _ActionChip(
                      Icons.chat_bubble_outline,
                      'Chat',
                      onTap: () {
                        // open chat
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _PastBookings extends StatelessWidget {
  const _PastBookings();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: const [
        _CompletedBookingCard(),
      ],
    );
  }
}

class _CompletedBookingCard extends StatelessWidget {
  const _CompletedBookingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// VENUE IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1517649763962-0c623066013b',
                  height: 52,
                  width: 52,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              /// INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Smash Zone',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Badminton · 60 mins',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Dec 2, 7:00 PM  •  ₹450 Paid',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              /// STATUS
              _StatusBadge(
                'COMPLETED',
                Colors.white24,
                textColor: Colors.white70,
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// ACTIONS
          Row(
            children: [
              _ActionChip(
                Icons.download_outlined,
                'Invoice',
                onTap: () {},
              ),
              const Spacer(),
              _ActionChip(
                Icons.refresh_rounded,
                'Book Again',
                outlined: true,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _CancelledBookings extends StatelessWidget {
  const _CancelledBookings();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: const [
        _CancelledBookingCard(),
      ],
    );
  }
}
class _CancelledBookingCard extends StatelessWidget {
  const _CancelledBookingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// VENUE IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                  height: 52,
                  width: 52,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              /// INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Metro City Turf',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '7-a-side · 60 mins',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Nov 28, 6:00 PM  •  Refunded',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              /// STATUS
              _StatusBadge('CANCELLED', kRed),
            ],
          ),

          const SizedBox(height: 14),

          /// BOTTOM ROW
          Row(
            children: [
              const Icon(
                Icons.cancel_outlined,
                size: 16,
                color: kRed,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Cancelled by you',
                  style: TextStyle(
                    color: kRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _ActionChip(
                Icons.info_outline,
                'Details',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white38),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}


class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const _StatusBadge(
    this.label,
    this.color, {
    super.key,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextColor = textColor ?? color;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12), // soft fill
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withOpacity(0.6), // 🔥 outline
          width: 1,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: resolvedTextColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}


class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool outlined;

  const _ActionChip(
    this.icon,
    this.label, {
    this.onTap,
    this.outlined = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        outlined ? Colors.white.withOpacity(0.35) : Colors.transparent;

    final backgroundColor =
        outlined ? Colors.transparent : Colors.white.withOpacity(0.08);

    final contentColor = Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: contentColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 13,
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
