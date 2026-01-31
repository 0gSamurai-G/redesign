// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// /* ============================================================
//    BOOK TURF SCREEN
//    ============================================================ */
// class BookTurfScreen extends StatelessWidget {
//   const BookTurfScreen({super.key});

//   static const bg = Color(0xFF000000);
//   static const surface = Color(0xFF121212);
//   static const accent = Color(0xFF1DB954);
//   static const muted = Color(0xFFB3B3B3);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bg,
//       extendBody: true,
//       body: SafeArea(
//         top: true,
//         bottom: false,
//         child: ListView(
//           padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
//           children: const [
//             _TopBar(),
//             SizedBox(height: 14),
//             _SearchBar(),
//             SizedBox(height: 16),
//             _SportFilters(),
//             SizedBox(height: 28),
//             _SectionHeader(title: 'Trending Near You'),
//             SizedBox(height: 14),
//             _TrendingList(),
//             SizedBox(height: 16),
//             _FilterRow(),
//             SizedBox(height: 28),
//             _SectionHeader(title: 'Available Turfs'),
//             SizedBox(height: 14),
//             _AvailableTurfsList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /* ============================================================
//    TOP BAR
//    ============================================================ */
// class _TopBar extends StatelessWidget {
//   const _TopBar();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20,left: 20),
//       child: Row(
//         children: [
//           const Icon(Icons.location_on, color: BookTurfScreen.accent),
//           const SizedBox(width: 6),
//           Text(
//             'Shivajinagar',
//             style: GoogleFonts.inter(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const Icon(Icons.keyboard_arrow_down, color: BookTurfScreen.muted),
//           const Spacer(),
//           const Icon(Icons.notifications_none, color: Colors.white),
//         ],
//       ),
//     );
//   }
// }

// /* ============================================================
//    SEARCH BAR
//    ============================================================ */
// class _SearchBar extends StatelessWidget {
//   const _SearchBar();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20,left: 20),
//       child: Container(
//         height: 48,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           color: BookTurfScreen.surface,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.search, color: BookTurfScreen.muted),
//             const SizedBox(width: 10),
//             Text(
//               'Search turfs, sports, or venues...',
//               style: GoogleFonts.inter(
//                 color: BookTurfScreen.muted,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /* ============================================================
//    SPORT FILTERS
//    ============================================================ */
// class _SportFilters extends StatelessWidget {
//   const _SportFilters();

//   @override
//   Widget build(BuildContext context) {
//     final sports = [
//       'All Sports',
//       'Football',
//       'Cricket',
//       'Badminton',
//       'Basketball',
//       'Tennis',
//     ];

//     return SizedBox(
//       height: 38,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.only(right: 20,left: 20),
//         itemCount: sports.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (_, i) {
//           final active = i == 0;
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: active
//                   ? BookTurfScreen.accent.withOpacity(0.15)
//                   : BookTurfScreen.surface,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: active
//                     ? BookTurfScreen.accent
//                     : Colors.transparent,
//               ),
//             ),
//             child: Text(
//               sports[i],
//               style: GoogleFonts.inter(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color:
//                     active ? BookTurfScreen.accent : Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// /* ============================================================
//    SECTION HEADER
//    ============================================================ */
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   const _SectionHeader({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20,left: 20),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.inter(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const Spacer(),
//           Text(
//             'See all',
//             style: GoogleFonts.inter(
//               color: BookTurfScreen.muted,
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ============================================================
//    TRENDING LIST
//    ============================================================ */
// class _TrendingList extends StatelessWidget {
//   const _TrendingList();

//   static final _trending = [
//     _TrendingData('Metro Futsal', '4.9', '2km',
//         'https://images.unsplash.com/photo-1546519638-68e109498ffc'),
//     _TrendingData('Pro Cricket Arena', '4.7', '3.5km',
//         'https://images.unsplash.com/photo-1521412644187-c49fa049e84d'),
//     _TrendingData('Smash Badminton', '4.8', '1.8km',
//         'https://images.unsplash.com/photo-1599058917212-d750089bc07c'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 170,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.only(right: 20,left: 20),
//         itemCount: _trending.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 14),
//         itemBuilder: (_, i) =>
//             _TrendingTile(data: _trending[i]),
//       ),
//     );
//   }
// }

// class _TrendingTile extends StatelessWidget {
//   final _TrendingData data;
//   const _TrendingTile({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150,
//       decoration: BoxDecoration(
//         color: BookTurfScreen.surface,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Image.network(
//               data.image,
//               height: 100,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data.name,
//                   style: GoogleFonts.inter(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '⭐ ${data.rating} • ${data.distance}',
//                   style: GoogleFonts.inter(
//                     color: BookTurfScreen.muted,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ============================================================
//    FILTER ROW
//    ============================================================ */
// class _FilterRow extends StatelessWidget {
//   const _FilterRow();

//   @override
//   Widget build(BuildContext context) {
//     final filters = ['Filters', 'Nearest', 'Top Rated', 'Low Price'];

//     return SizedBox(
//       height: 40, // 👈 important for ListView
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         itemCount: filters.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (context, index) {
//           final f = filters[index];

//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.white24),
//             ),
//             child: Text(
//               f,
//               style: GoogleFonts.inter(
//                 color: Colors.white,
//                 fontSize: 12,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// /* ============================================================
//    AVAILABLE TURFS LIST
//    ============================================================ */
// class _AvailableTurfsList extends StatelessWidget {
//   const _AvailableTurfsList();

//   static final _turfs = [
//     _TurfData(
//       name: 'CrossFit Arena',
//       location: 'Narhe, Pune',
//       price: 1000,
//       images: [
//         'https://images.unsplash.com/photo-1508098682722-e99c43a406b2',
//         'https://images.unsplash.com/photo-1546519638-68e109498ffc',
//       ],
//     ),
//     _TurfData(
//       name: 'Greenfield Turf',
//       location: 'Baner, Pune',
//       price: 1200,
//       images: [
//         'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
//         'https://images.unsplash.com/photo-1546519638-68e109498ffc',
//       ],
//     ),
//     _TurfData(
//       name: 'Urban Sports Hub',
//       location: 'Wakad, Pune',
//       price: 900,
//       images: [
//         'https://images.unsplash.com/photo-1546519638-68e109498ffc',
//         'https://images.unsplash.com/photo-1508098682722-e99c43a406b2',
//       ],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20,left: 20),
//       child: Column(
//         children: _turfs
//             .map(
//               (turf) => Padding(
//                 padding: const EdgeInsets.only(bottom: 18),
//                 child: _TurfCard(data: turf),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }

// class _TurfCard extends StatefulWidget {
//   final _TurfData data;
//   const _TurfCard({required this.data});

//   @override
//   State<_TurfCard> createState() => _TurfCardState();
// }

// class _TurfCardState extends State<_TurfCard> {
//   int _pageIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final data = widget.data;

//     return Container(
//       decoration: BoxDecoration(
//         color: BookTurfScreen.surface,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// IMAGE PAGE VIEW
//           ClipRRect(
//             borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(18)),
//             child: Stack(
//               children: [
//                 SizedBox(
//                   height: 180,
//                   child: PageView.builder(
//                     itemCount: data.images.length,
//                     onPageChanged: (i) =>
//                         setState(() => _pageIndex = i),
//                     itemBuilder: (_, i) => Image.network(
//                       data.images[i],
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),

//                 /// DOT INDICATOR
//                 if (data.images.length > 1)
//                   Positioned(
//                     bottom: 10,
//                     left: 0,
//                     right: 0,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(
//                         data.images.length,
//                         (i) => Container(
//                           margin:
//                               const EdgeInsets.symmetric(horizontal: 3),
//                           width: 6,
//                           height: 6,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: i == _pageIndex
//                                 ? Colors.white
//                                 : Colors.white38,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Turf name
//                 Text(
//                   data.name,
//                   style: GoogleFonts.inter(
//                     color: BookTurfScreen.accent,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),

//                 const SizedBox(height: 4),

//                 /// Location
//                 Text(
//                   data.location,
//                   style: GoogleFonts.inter(
//                     color: BookTurfScreen.muted,
//                     fontSize: 12,
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 /// Rating + reviews + distance
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.star,
//                       size: 14,
//                       color: Colors.amber,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '4.6',
//                       style: GoogleFonts.inter(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       ' (128 reviews)',
//                       style: GoogleFonts.inter(
//                         color: BookTurfScreen.muted,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       '• 2.4 km away',
//                       style: GoogleFonts.inter(
//                         color: BookTurfScreen.muted,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 14),

//                 /// Price + CTA
//                 Row(
//   children: [
//     RichText(
//       text: TextSpan(
//         style: GoogleFonts.inter(
//           fontSize: 13,
//           color: BookTurfScreen.muted,
//         ),
//         children: [
//           const TextSpan(
//             text: 'Starts from ',
//           ),
//           TextSpan(
//             text: '₹${data.price}',
//             style: const TextStyle(
//               color: BookTurfScreen.accent,
//               fontWeight: FontWeight.w700,
//               fontSize: 18, // 👈 slightly bigger
//             ),
//           ),
//           const TextSpan(
//             text: '/hr',
//             style: TextStyle(
//               color: BookTurfScreen.accent,
//               fontWeight: FontWeight.w700,
//               fontSize: 18, // 👈 same bigger size
//             ),
//           ),
//         ],
//       ),
//     ),
//     const Spacer(),
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: BookTurfScreen.accent,
//         foregroundColor: Colors.black,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 10,
//         ),
//       ),
//       onPressed: () {},
//       child: const Text('Book'),
//     ),
//   ],
// ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ============================================================
//    DATA MODEL (UPDATED)
//    ============================================================ */
// class _TurfData {
//   final String name;
//   final String location;
//   final int price;
//   final List<String> images;

//   _TurfData({
//     required this.name,
//     required this.location,
//     required this.price,
//     required this.images,
//   });
// }

// /* ============================================================
//    DATA MODELS
//    ============================================================ */
// class _TrendingData {
//   final String name;
//   final String rating;
//   final String distance;
//   final String image;

//   _TrendingData(this.name, this.rating, this.distance, this.image);
// }

// // class _TurfData {
// //   final String name;
// //   final String location;
// //   final int price;
// //   final String image;

// //   _TurfData({
// //     required this.name,
// //     required this.location,
// //     required this.price,
// //     required this.image,
// //   });
// // }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/home.dart';
import 'package:redesign/turfdetails.dart';
import 'package:shimmer/shimmer.dart';

/* ============================================================
   BOOK TURF SCREEN
   ============================================================ */
class BookTurfScreen extends StatelessWidget {
  const BookTurfScreen({super.key});

  static const bg = Color(0xFF000000);
  static const surface = Color(0xFF121212);
  static const accent = Color(0xFF1DB954);
  static const muted = Color(0xFFB3B3B3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children:  [
            _TopBar(),
            SizedBox(height: 14),
            _SearchBar(),
            SizedBox(height: 16),
            _SportFilters(),
            SizedBox(height: 28),
            _SectionHeader(title: 'Trending Near You'),
            SizedBox(height: 14),
            _TrendingList(),
            SizedBox(height: 16),
            _FilterRow(),
            SizedBox(height: 28),
            _SectionHeader(title: 'Available Turfs'),
            SizedBox(height: 14),
            _AvailableTurfsList(),
            SizedBox(height: 0),
            const _EndOfResults()
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   TOP BAR
   ============================================================ */
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: BookTurfScreen.accent),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Shivajinagar',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down,
              color: BookTurfScreen.muted),
          const SizedBox(width: 8),
          const Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }
}

/* ============================================================
   SEARCH BAR
   ============================================================ */
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: BookTurfScreen.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: BookTurfScreen.muted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search turfs, sports, or venues...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: BookTurfScreen.muted,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   SPORT FILTERS
   ============================================================ */
class _SportFilters extends StatefulWidget {
  const _SportFilters();

  @override
  State<_SportFilters> createState() => _SportFiltersState();
}
class _SportFiltersState extends State<_SportFilters> {
  int _selectedIndex = 0;

  final List<String> sports = const [
    'All Sports',
    'Football',
    'Cricket',
    'Badminton',
    'Basketball',
    'Tennis',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final bool isSelected = i == _selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                _selectedIndex = i;
              });

              /// 🔮 Future upgrade hook:
              /// trigger filter logic / API / analytics here
              // onSportSelected(sports[i]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? BookTurfScreen.accent // green background
                    : BookTurfScreen.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                sports[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.black // 🔥 black text on green
                      : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/* ============================================================
   SECTION HEADER
   ============================================================ */
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            'See all',
            style: GoogleFonts.inter(
              color: BookTurfScreen.muted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   TRENDING LIST
   ============================================================ */
class _TrendingList extends StatelessWidget {
  const _TrendingList();

  static final _trending = [
    _TrendingData(
      'Metro Futsal',
      '4.9',
      '2km',
      'https://images.unsplash.com/photo-1546519638-68e109498ffc',
    ),
    _TrendingData(
      'Pro Cricket Arena',
      '4.7',
      '3.5km',
      'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
    ),
    _TrendingData(
      'Smash Badminton',
      '4.8',
      '1.8km',
      'https://images.unsplash.com/photo-1599058917212-d750089bc07c',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _trending.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _TrendingTile(data: _trending[i]),
      ),
    );
  }
}

class _TrendingTile extends StatelessWidget {
  final _TrendingData data;
  const _TrendingTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Container(
        decoration: BoxDecoration(
          color: BookTurfScreen.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ IMAGE WITH CACHE + SHIMMER
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: data.image,
                cacheKey: data.image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const _TrendingImageShimmer(),
                errorWidget: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 28,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '⭐ ${data.rating} • ${data.distance}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: BookTurfScreen.muted,
                      fontSize: 12,
                    ),
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

/* ============================================================
   SHIMMER PLACEHOLDER (TRENDING IMAGE)
   ============================================================ */

class _TrendingImageShimmer extends StatelessWidget {
  const _TrendingImageShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey.shade800,
      ),
    );
  }
}

/* ============================================================
   FILTER ROW
   ============================================================ */
class _FilterRow extends StatefulWidget {
  const _FilterRow();

  @override
  State<_FilterRow> createState() => _FilterRowState();
}

class _FilterRowState extends State<_FilterRow> {
  int _selectedIndex = 0;

  final List<String> filters = const [
    'Filters',
    'Nearest',
    'Top Rated',
    'Low Price',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final bool isSelected = index == _selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });

              /// 🔮 Future upgrade hook
              /// sort / filter logic can be triggered here
              // onFilterSelected(filters[index]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? BookTurfScreen.accent // green
                    : BookTurfScreen.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? BookTurfScreen.accent
                      : Colors.white24,
                ),
              ),
              child: Text(
                filters[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.black // 🔥 black text on green
                      : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/* ============================================================
   AVAILABLE TURFS
   ============================================================ */


class _AvailableTurfsList extends StatelessWidget {
  const _AvailableTurfsList();

  static final _turfs = [
    _TurfData(
      name: 'CrossFit Arena',
      location: 'Narhe, Pune',
      price: 1000,
      images: [
        'https://images.unsplash.com/photo-1508098682722-e99c43a406b2',
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      ],
    ),
    _TurfData(
      name: 'Greenfield Turf',
      location: 'Baner, Pune',
      price: 1200,
      images: [
        'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      ],
    ),
    _TurfData(
      name: 'Urban Sports Hub',
      location: 'Wakad, Pune',
      price: 900,
      images: [
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
        'https://images.unsplash.com/photo-1508098682722-e99c43a406b2',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _turfs
            .map(
              (turf) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _TurfCard(data: turf),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TurfCard extends StatefulWidget {
  final _TurfData data;
  const _TurfCard({required this.data});

  @override
  State<_TurfCard> createState() => _TurfCardState();
}

class _TurfCardState extends State<_TurfCard>
    with AutomaticKeepAliveClientMixin {
  int _pageIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final data = widget.data;
    final width = MediaQuery.of(context).size.width;
    final imageHeight = width * 0.48;

    return Container(
      decoration: BoxDecoration(
        color: BookTurfScreen.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE PAGE VIEW (CACHED + SHIMMER)
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                SizedBox(
                  height: imageHeight,
                  child: PageView.builder(
                    itemCount: data.images.length,
                    onPageChanged: (i) =>
                        setState(() => _pageIndex = i),
                    itemBuilder: (_, i) => CachedNetworkImage(
                      imageUrl: data.images[i],
                      cacheKey: data.images[i],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => _ImageShimmer(
                        height: imageHeight,
                      ),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),

                /// PAGE INDICATOR
                if (data.images.length > 1)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        data.images.length,
                        (i) => Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: 3),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _pageIndex
                                ? Colors.white
                                : Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// DETAILS
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    /// 🔥 NAVIGABLE CONTENT ONLY
    InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            // builder: (_) => const UserHomePage(),
            builder: (_) => const TurfDetailScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: BookTurfScreen.accent,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: BookTurfScreen.muted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: '⭐ '),
                      TextSpan(
                        text: '4.6',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '(128 reviews) • 2.4 km away',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: BookTurfScreen.muted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),

    /// 🔥 PRICE + BOOK (NOT NAVIGABLE)
    Row(
      children: [
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                color: BookTurfScreen.muted,
              ),
              children: [
                const TextSpan(text: 'Starts from '),
                TextSpan(
                  text: '₹${data.price}',
                  style: const TextStyle(
                    color: BookTurfScreen.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const TextSpan(text: '/hr'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            // 👉 booking flow only
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: BookTurfScreen.accent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Book'),
        ),
      ],
    ),
  ],
)

          ),
        ],
      ),
    );
  }
}

/// 🔥 SHIMMER PLACEHOLDER (REUSABLE)
class _ImageShimmer extends StatelessWidget {
  final double height;
  const _ImageShimmer({required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade800,
      ),
    );
  }
}

/* ============================================================
   DATA MODEL
   ============================================================ */
class _TurfData {
  final String name;
  final String location;
  final int price;
  final List<String> images;

  _TurfData({
    required this.name,
    required this.location,
    required this.price,
    required this.images,
  });
}

/* ============================================================
   DATA MODELS
   ============================================================ */
// class _TurfData {
//   final String name;
//   final String location;
//   final int price;
//   final List<String> images;

//   _TurfData({
//     required this.name,
//     required this.location,
//     required this.price,
//     required this.images,
//   });
// }

class _TrendingData {
  final String name;
  final String rating;
  final String distance;
  final String image;

  _TrendingData(this.name, this.rating, this.distance, this.image);
}



class _EndOfResults extends StatelessWidget {
  const _EndOfResults();

  static const _illustrationUrl =
      'https://illustrations.popsy.co/gray/sporty-man.svg';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// Responsive sizing
    final imageSize = width < 360
        ? 90.0
        : width < 600
            ? 120.0
            : 140.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ILLUSTRATION (CACHED + SHIMMER)
          CachedNetworkImage(
            imageUrl: _illustrationUrl,
            height: imageSize,
            width: imageSize,
            fit: BoxFit.contain,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade700,
              child: Container(
                height: imageSize,
                width: imageSize,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            errorWidget: (_, __, ___) => Icon(
              Icons.sports_soccer,
              size: imageSize * 0.6,
              color: BookTurfScreen.muted.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 20),

          /// TITLE
          Text(
            'You’ve reached the end!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          /// SUBTITLE
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              'No more turfs nearby. Try exploring a new sport or adjust your filters.',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: BookTurfScreen.muted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// CTA BUTTON (OPTIONAL, FUTURE READY)
          OutlinedButton(
            onPressed: () {
              // 🔮 Future upgrade:
              // - Reset filters
              // - Open sport selector
              // - Expand radius
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: BookTurfScreen.accent,
              side: const BorderSide(color: BookTurfScreen.accent),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: Text(
              'Explore Other Sports',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
