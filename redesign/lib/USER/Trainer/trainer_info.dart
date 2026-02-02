
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/USER/Trainer/book_trainer.dart';
import 'package:shimmer/shimmer.dart';

const Color kBg = Colors.black;
const Color kCard = Color(0xFF1A1A1A);
const Color kSurface = Color(0xFF121212);
const Color kGreen = Color(0xFF1DB954);
const Color kMuted = Color(0xFFA7A7A7);
const Color kYellow = Color(0xFFFFC107);
class AcademyDetailScreen extends StatefulWidget {
  const AcademyDetailScreen({super.key});

  @override
  State<AcademyDetailScreen> createState() => _AcademyDetailScreenState();
}

class _AcademyDetailScreenState extends State<AcademyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      extendBody: true,
      body: CustomScrollView(
        
        slivers: [
          _HeroSection(),
          SliverPadding(
            
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            sliver: SliverList(
              
              delegate: SliverChildListDelegate([
                _AcademyInfo(),
                const SizedBox(height: 16),
                _ActivityRow(),
                const SizedBox(height: 16),
                _StudentTypeSelector(),

                const SizedBox(height: 16),
                _Announcement(),
                const SizedBox(height: 24),
                _Location(),
                const SizedBox(height: 24),
                _Packages(),
                const SizedBox(height: 24),
                _FacilityInfo(),
                const SizedBox(height: 24),
                _Amenities(),
                
                const SizedBox(height: 24),
                _Reviews(),
                const SizedBox(height: 24),
                _Gallery(),
                const SizedBox(height: 24),
                _Certifications(),
              ]),
            ),
          )
        ],
      ),
      bottomNavigationBar: _BottomBar(),
    );
  }
}


class _HeroSection extends StatefulWidget {
  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> images = [
    'https://images.unsplash.com/photo-1593341646782-e0b495cff86d',
    'https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf',
    'https://images.unsplash.com/photo-1517649763962-0c623066013b',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      backgroundColor: kBg,
      expandedHeight: 280,
      pinned: false,
      automaticallyImplyLeading: false,
      stretch: true,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// -------------------------------
            /// PAGE VIEW (SWIPEABLE)
            /// -------------------------------
            PageView.builder(
              controller: _pageController,
              physics: const PageScrollPhysics(),
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (_, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade900,
                    highlightColor: Colors.grey.shade800,
                    child: Container(color: Colors.black),
                  ),
                  errorWidget: (_, __, ___) =>
                      const ColoredBox(color: Colors.black),
                );
              },
            ),

            /// -------------------------------
            /// GRADIENT OVERLAY (NON-BLOCKING)
            /// -------------------------------
            IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),

            /// -------------------------------
            /// TOP ICONS
            /// -------------------------------
            Positioned(
              top: topInset + 12,
              left: 16,
              child: _iconBtn(Icons.arrow_back),
            ),
            Positioned(
              top: topInset + 12,
              right: 72,
              child: _iconBtn(Icons.bookmark_border),
            ),
            Positioned(
              top: topInset + 12,
              right: 16,
              child: _iconBtn(Icons.share),
            ),

            /// -------------------------------
            /// ACADEMY BADGE
            /// -------------------------------
            Positioned(
              bottom: 34,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: kGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ACADEMY',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),

            /// -------------------------------
            /// PAGE INDICATORS
            /// -------------------------------
            Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final bool active = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------
  /// ICON BUTTON
  /// -------------------------------
Widget _iconBtn(IconData icon, {VoidCallback? onTap}) {
  return Material(
    color: Colors.black.withOpacity(0.55),
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          icon, // ✅ USE PARAMETER
          color: Colors.white,
          size: 20,
        ),
      ),
    ),
  );
}

}




class _AcademyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'PowerPlay Cricket Academy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.star, color: kYellow, size: 14),
                  SizedBox(width: 4),
                  Text('4.9', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    /// LOCATION
    Row(
      children: const [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: kMuted,
        ),
        SizedBox(width: 6),
        Text(
          'Kothrud, Pune • 2.3 km away',
          style: TextStyle(
            color: kMuted,
            fontSize: 14,
          ),
        ),
      ],
    ),

    const SizedBox(height: 6),

    /// OPEN STATUS (RichText)
    Row(
      children: [
        const Icon(
          Icons.access_time,
          size: 16,
          color: kMuted,
        ),
        const SizedBox(width: 6),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: kMuted,
            ),
            children: [
              TextSpan(
                text: 'Open Now',
                style: TextStyle(
                  color: kGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' • Closes at 10:00 PM',
                style: TextStyle(
                  color: kMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 14
                ),
              ),
            ],
          ),
        ),
      ],
    ),

    const SizedBox(height: 6),

    /// CERTIFICATION
    Row(
      children: const [
        Icon(
          Icons.verified_outlined,
          size: 16,
          color: kGreen,
        ),
        SizedBox(width: 6),
        Text(
          'Govt. Certified Sports Facility',
          style: TextStyle(
            color: kMuted,
            fontSize: 14,
          ),
        ),
      ],
    ),
  ],
),
        const SizedBox(height: 12),
        const Text(
          'A premier cricket training center equipped with turf wickets, bowling machines, and expert coaching staff. We focus on technique, fitness, and match temperament for aspiring cricketers.',
          style: TextStyle(
            color: kMuted,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}




class _ActivityRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _Activity(icon: Icons.sports_cricket, label: 'Cricket'),
          _Activity(icon: Icons.fitness_center, label: 'Fitness'),
          _Activity(icon: Icons.emoji_events, label: 'Matches'),
        ],
      ),
    );
  }
}

class _Activity extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Activity({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: kCard,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: kMuted, fontSize: 12)),
      ],
    );
  }
}


class _StudentTypeSelector extends StatefulWidget {
  @override
  State<_StudentTypeSelector> createState() => _StudentTypeSelectorState();
}

class _StudentTypeSelectorState extends State<_StudentTypeSelector> {
  String selected = 'Kids';

  final List<String> types = ['Kids', 'Adults', 'Women Only'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Student Type',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: types.map((type) {
            final bool active = type == selected;
            return GestureDetector(
              onTap: () => setState(() => selected = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: active ? kGreen : Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: active ? kGreen : kGreen,
                    width: 1,
                  ),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: active ? Colors.black : kGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}




class _Tags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tags = ['Kids Camp', 'Competitive', 'Outdoor Turf'];
    return Wrap(
      spacing: 8,
      children: tags
          .map((t) => Chip(
                label: Text(t),
                backgroundColor: Colors.black,
                side: BorderSide(color: kGreen),
                labelStyle: const TextStyle(color: kGreen),
              ))
          .toList(),
    );
  }
}


class _Announcement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kYellow.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: const [
        Icon(Icons.campaign, color: kYellow),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Summer Camp Registration Open!\nBatch starts 10th Feb • Limited slots',
            style: TextStyle(color: kYellow),
          ),
        )
      ]),
    );
  }
}


class _Packages extends StatefulWidget {
  @override
  State<_Packages> createState() => _PackagesState();
}

class _PackagesState extends State<_Packages> {
  int selectedIndex = 1; // Default: Monthly (Most Popular)

  final List<_PackageModel> packages = [
    _PackageModel(
      title: 'Trial Session',
      price: 'FREE',
      subtitle: '1 Day Trial • Coach Interaction',
      features: [
        'Ground walkthrough',
        'Coach interaction',
        'Skill assessment',
      ],
    ),
    _PackageModel(
      title: 'Monthly Transformation',
      price: '₹2,000',
      badge: 'MOST POPULAR',
      subtitle: '12 Sessions / Month • 1 Hour',
      features: [
        'Customized Diet Plan',
        'Weekly Progress Track',
        'Net Practice',
      ],
    ),
    _PackageModel(
      title: '3 Month Plan',
      price: '₹5,500',
      subtitle: 'Quarterly Training Program',
      features: [
        'Structured coaching',
        'Fitness drills',
        'Match practice',
      ],
    ),
    _PackageModel(
      title: '6 Month Plan',
      price: '₹10,000',
      subtitle: 'Half Year Commitment',
      features: [
        'Advanced technique training',
        'Video analysis',
        'Performance reports',
      ],
    ),
    _PackageModel(
      title: 'Annual Pro Plan',
      price: '₹18,000',
      subtitle: 'Best Value • Full Year',
      features: [
        'Elite coaching',
        'Tournament preparation',
        'Priority batches',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Packages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text('View all', style: TextStyle(color: kGreen)),
          ],
        ),
        const SizedBox(height: 12),

        ...List.generate(packages.length, (index) {
          final pkg = packages[index];
          final bool active = index == selectedIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
              },
              child: _PackageCard(
                model: pkg,
                active: active,
              ),
            ),
          );
        }),
      ],
    );
  }
}

/* ---------------------------------------------------------- */
/* PACKAGE CARD */

class _PackageCard extends StatelessWidget {
  final _PackageModel model;
  final bool active;

  const _PackageCard({
    required this.model,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active ? kGreen : Colors.transparent,
          width: 1.4,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: kGreen.withOpacity(0.25),
                  blurRadius: 14,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.badge != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                model.badge!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          Row(
            children: [
              Expanded(
                child: Text(
                  model.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                model.price,
                style: const TextStyle(
                  color: kGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          if (model.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              model.subtitle!,
              style: const TextStyle(color: kMuted),
            ),
          ],

          /// FEATURES (ONLY WHEN ACTIVE)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: model.features
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.check,
                              color: kGreen, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            f,
                            style:
                                const TextStyle(color: kMuted),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            crossFadeState: active
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------------- */
/* MODEL */

class _PackageModel {
  final String title;
  final String price;
  final String? subtitle;
  final String? badge;
  final List<String> features;

  _PackageModel({
    required this.title,
    required this.price,
    this.subtitle,
    this.badge,
    required this.features,
  });
}



class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding:
              const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.7),
            border: Border(
              top: BorderSide(color: Color(0xFF1A1A1A)),
            ),
          ),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kGreen),
                  foregroundColor: kGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Chat with Academy'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ChoosePackageScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Book Trial'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}


Widget _FacilityInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Facility Info',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),

      GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2, // 🔥 tighter height
        ),
        itemCount: 4,
        itemBuilder: (_, index) {
          final items = const [
            _FacilityData('Surface', 'Astro Turf + Grass', Icons.grass),
            _FacilityData('Equipment', 'Available for Rent', Icons.sports_cricket),
            _FacilityData('Batch Size', 'Max 15 Students', Icons.group),
            _FacilityData('Parking', 'Free Valet', Icons.local_parking),
          ];
          return _FacilityTile(data: items[index]);
        },
      ),
    ],
  );
}

/* ---------------------------------------------------------- */
/* TILE */

class _FacilityTile extends StatelessWidget {
  final _FacilityData data;

  const _FacilityTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12), // ⬅ reduced
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔥 critical
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: kGreen, size: 18),

          const SizedBox(height: 8),

          Text(
            data.title,
            style: const TextStyle(
              color: kMuted,
              fontSize: 11,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            data.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------------- */
/* DATA MODEL */

class _FacilityData {
  final String title;
  final String value;
  final IconData icon;

  const _FacilityData(this.title, this.value, this.icon);
}


Widget _Amenities() {
  final items = [
    'CCTV Monitored',
    'First Aid Kit',
    'RO Water',
    'Change Rooms',
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Safety & Amenities',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items
            .map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  e,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13),
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}


Widget _Location() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Location',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Container(
        height: 160,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Opacity(
                opacity: 0.5,
                child: Image.network(
                  'https://img.freepik.com/premium-vector/colored-city-map-digital-concept_23-2148311690.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.near_me, size: 18),
              label: const Text('Get Directions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            )
          ],
        ),
      ),
    ],
  );
}


Widget _Reviews() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: const [
          Text(
            'Reviews (128)',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text('View All',
              style: TextStyle(color: kGreen)),
        ],
      ),
      const SizedBox(height: 12),
      _ReviewTile(
        name: 'Rohan M.',
        rating: 5,
        text:
            'Best academy for kids in Kothrud. Coaches are patient and the ground is well maintained.',
      ),
      const SizedBox(height: 10),
      _ReviewTile(
        name: 'Priya S.',
        rating: 4,
        text:
            'Good facilities but evening batches get crowded. Morning slots are perfect.',
      ),
    ],
  );
}

class _ReviewTile extends StatelessWidget {
  final String name;
  final int rating;
  final String text;

  const _ReviewTile({
    required this.name,
    required this.rating,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey.shade700,
                child: const Icon(Icons.person,
                    size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star,
                    size: 14,
                    color:
                        i < rating ? kYellow : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(text,
              style:
                  const TextStyle(color: kMuted, height: 1.4)),
        ],
      ),
    );
  }
}


Widget _Gallery() {
  final items = [
    'Training Ground',
    'Client Success',
    'Equipment',
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Transformations & Gallery',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              const SizedBox(width: 12),
          itemBuilder: (_, i) {
            return Container(
              width: 180,
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(14),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(10),
              child: Text(
                items[i],
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    ],
  );
}


Widget _Certifications() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Certifications',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        children: const [
          _CertBadge('ACE Personal Trainer'),
          _CertBadge('Sports Nutrition L1'),
        ],
      ),
    ],
  );
}

class _CertBadge extends StatelessWidget {
  final String label;
  const _CertBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600)),
    );
  }
}
