import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/USER/Book/bookingdetails.dart';
import 'package:shimmer/shimmer.dart';

class TurfDetailScreen extends StatefulWidget {
  const TurfDetailScreen({super.key});

  @override
  State<TurfDetailScreen> createState() => _TurfDetailScreenState();
}

class _TurfDetailScreenState extends State<TurfDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _expanded = false;

  final List<String> images = [
    'https://images.unsplash.com/photo-1571902943202-507ec2618e8f',
    'https://images.unsplash.com/photo-1554284126-aa88f22d8b74',
    'https://images.unsplash.com/photo-1599058917212-d750089bc07d',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            /// IMAGE SLIDER HEADER
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height * 0.35,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (_, index) {
                        return CachedNetworkImage(
                          imageUrl: images[index],
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade800,
                            highlightColor: Colors.grey.shade700,
                            child: Container(color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),

                  /// TOP ICONS
                  Positioned(
                    top: 35,
                    left: 16,
                    child: _circleIcon(Icons.arrow_back),
                  ),
                  Positioned(
                    top: 35,
                    right: 16,
                    child: _circleIcon(Icons.favorite_border),
                  ),

                  /// PAGE INDICATORS
                  Positioned(
                    bottom: 25,
                    right: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF1DB954)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: _greenBadge('CROSSFIT & GYM')),
                ],
              ),
            ),

            /// CONTENT
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0, 0, 00, 80),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _venueInfo(),
                    const SizedBox(height: 0),
                    _ratingRow(),
                    const SizedBox(height: 24),
                    _aboutSection(),
                    const SizedBox(height: 24),
                    _amenitiesGrid(),
                    const SizedBox(height: 24),
                    _cancellationBanner(),
                    const SizedBox(height: 24),
                    _friendsSection(),
                    const SizedBox(height: 24),
                    _reviewsSection(),
                    const SizedBox(height: 24),
                    _recommendedSection(),
                  ],
                ),
              ),
            ),
          ],
        ),

        /// STICKY BOOK NOW BAR
        bottomNavigationBar: ClipRRect(
          
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                color: Color.fromRGBO(0, 0, 0, 0.9),
                border: Border(top: BorderSide(color: Color.fromARGB(100, 163, 163, 163))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Starts from ₹1000/hr',
                      style: TextStyle(
                        color: const Color(0xFF1DB954),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ConfirmSlotScreen()));
                    },
                    child: const Text(
                      'Book Now',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ===================== SECTIONS =====================

  Widget _venueInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _greenBadge('CROSSFIT & GYM'),
          const SizedBox(height: 10),
          const Text(
            'CrossFit Arena',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 16),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Narhe, Pune • 7.9 km away',
                  style: TextStyle(color: Color(0xFFA7A7A7)),
                ),
              ),
              TextButton(
  onPressed: () {}, // future: show timings, status info, etc.
  style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    backgroundColor: const Color(0xFF1DB954).withOpacity(0.15),
    foregroundColor: const Color(0xFF1DB954),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
  child: const Text(
    'Open Now',
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
),

            ],
          ),
        ],
      ),
    );
  }

  Widget _ratingRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 16,
                color: index < 4 ? Colors.amber : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text('5.0',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          const Text('(128 Reviews)',
              style: TextStyle(color: Color(0xFFA7A7A7))),
        ],
      ),
    );
  }

  Widget _aboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Venue',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Experience premium CrossFit training with state-of-the-art equipment, cardio zones, and expert trainers. Perfect for strength and endurance.',
            maxLines: _expanded ? null : 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFFA7A7A7)),
          ),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Read more' : 'Read less',
              style: const TextStyle(color: Color(0xFF1DB954)),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bWFwc3xlbnwwfHwwfHx8MA%3D%3D',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black.withOpacity(0.7),
                    ),
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text('Get Directions'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _amenitiesGrid() {
    final items = [
      Icons.local_parking,
      Icons.water_drop,
      Icons.meeting_room,
      Icons.fitness_center,
      Icons.wifi,
      Icons.people,
    ];
    final labels = [
      'Parking',
      'Drinking Water',
      'Change Room',
      'Equipment',
      'Free WiFi',
      'Trainers',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Amenities',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              items.length,
              (index) => Container(
                width: MediaQuery.of(context).size.width / 2 - 22,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(items[index], color: Colors.white),
                    const SizedBox(height: 6),
                    Text(labels[index],
                        style:
                            const TextStyle(color: Color(0xFFA7A7A7))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cancellationBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red),
        ),
        child: Row(
          children: const [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Free cancellation up to 4 hours before the booked slot. 50% refund thereafter.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _friendsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/100')),
          SizedBox(width: 8),
          CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/101')),
          SizedBox(width: 8),
          CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/102')),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Arjun and 2 others have booked here recently.',
              style: TextStyle(color: Color(0xFFA7A7A7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('Reviews',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Text('View All (128)',
                  style: TextStyle(color: Color(0xFF1DB954))),
            ],
          ),
          const SizedBox(height: 12),
          _reviewCard('Michael S.', 'Great facilities and well maintained equipment.'),
          const SizedBox(height: 12),
          _reviewCard('Priya K.', 'Spacious and clean. Friendly trainers.'),
        ],
      ),
    );
  }

  Widget _recommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text('You Might Also Like',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        images[index],
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Gold\'s Gym',
                        style: TextStyle(color: Colors.white)),
                    const Text('2.3 km • ₹1200/hr',
                        style:
                            TextStyle(color: Color(0xFFA7A7A7))),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _reviewCard(String name, String comment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150')),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(Icons.star,
                        size: 14, color: Colors.amber),
                  ),
                ),
                Text(comment,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Color(0xFFA7A7A7))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1DB954),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }

  Widget _circleIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: Colors.black.withOpacity(0.6),
      child: Icon(icon, color: Colors.white),
    );
  }
}
