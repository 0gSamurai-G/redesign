import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';


class AppColors {
  static const bg = Color(0xFF000000);
  static const surface = Color(0xFF121212);
  static const muted = Color(0xFFB3B3B3);
  static const accent = Color(0xFF1DB954);
}


class GameDiaryScreen extends StatelessWidget {
  const GameDiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          children:  [
            _TopBar(),
            _Tabs(),
             SizedBox(height: 12),
            _SportFilters(),
             SizedBox(height: 22),
            _DateSelector(),
             SizedBox(height: 10),
            _ActionRow(),
            SizedBox(height: 12),
            _GameList(),
            // SizedBox(height: 24),
            const _EndOfResults()
          ],
        ),
      ),
    );
  }
}


class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.accent, size: 18),
          const SizedBox(width: 6),
          Text(
            'Shivajinagar',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          const Spacer(),
          const Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }
}




class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            'Game Diary',
            style: GoogleFonts.inter(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            'All Games',
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}




class _SportFilters extends StatelessWidget {
  const _SportFilters();

  @override
  Widget build(BuildContext context) {
    final sports = [
      ('Cricket', Icons.sports_cricket),
      ('Football', Icons.sports_soccer),
      ('Badminton', Icons.sports_tennis),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final active = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: active ? AppColors.accent : Colors.transparent,
              ),
              color: AppColors.surface,
            ),
            child: Row(
              children: [
                Icon(
                  sports[i].$2,
                  size: 16,
                  color: active ? AppColors.accent : Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  sports[i].$1,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: sports.length,
      ),
    );
  }
}




class _DateSelector extends StatelessWidget {
  const _DateSelector();

  @override
  Widget build(BuildContext context) {
    final dates =
        List.generate(10, (i) => DateTime.now().add(Duration(days: i)));

    return SizedBox(
      height: 76,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == 0;
          final d = dates[i];

          return Container(
            width: 56,
            decoration: BoxDecoration(
              color: selected ? AppColors.accent : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// MONTH
                Text(
                  DateFormat('MMM').format(d), // Dec
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.black : AppColors.muted,
                  ),
                ),

                const SizedBox(height: 2),

                /// DATE
                Text(
                  '${d.day}', // 4
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.black : Colors.white,
                  ),
                ),

                const SizedBox(height: 2),

                /// DAY
                Text(
                  DateFormat('EEE').format(d), // Thu
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: selected ? Colors.black : AppColors.muted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}





class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(
            'Host Game +',
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.swap_vert, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                'Sort',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class _GameData {
  final String hostName;
  final String time;
  final String price;
  final String onboard;
  final String address;
  final String avatarUrl;
  final String sport;
  final String type;
  final String tier;

  const _GameData({
    required this.hostName,
    required this.time,
    required this.price,
    required this.onboard,
    required this.address,
    required this.avatarUrl,
    required this.sport,
    required this.type,
    required this.tier,
  });
}

class _GameList extends StatelessWidget {
  const _GameList();

  static const _games = [
    _GameData(
      hostName: 'Deepankar Shrikant Rokade Patil',
      time: 'Thu 4 Dec, 06:30',
      price: '₹100',
      onboard: '2/22',
      address:
          'Dnyankamal Society, Sr No 20/1, Abhinav Nagar, Pune (0.8 km)',
      avatarUrl: 'https://i.pravatar.cc/100?img=1',
      sport: 'Cricket',
      type: 'Casual',
      tier: 'ELITE',
    ),_GameData(
      hostName: 'Deepankar Shrikant Rokade Patil',
      time: 'Thu 4 Dec, 06:30',
      price: '₹100',
      onboard: '2/22',
      address:
          'Dnyankamal Society, Sr No 20/1, Abhinav Nagar, Pune (0.8 km)',
      avatarUrl: 'https://i.pravatar.cc/100?img=1',
      sport: 'Cricket',
      type: 'Casual',
      tier: 'ELITE',
    ),
    _GameData(
      hostName: 'Rahul Mahadev Kulkarni',
      time: 'Fri 5 Dec, 07:00',
      price: '₹150',
      onboard: '5/18',
      address:
          'Baner Sports Complex, Near High Street, Pune (1.4 km)',
      avatarUrl: 'https://i.pravatar.cc/100?img=2',
      sport: 'Football',
      type: 'Competitive',
      tier: 'PRO',
    ),
    _GameData(
      hostName: 'Amit Prakash Deshmukh',
      time: 'Sat 6 Dec, 08:30',
      price: '₹80',
      onboard: '8/16',
      address:
          'Wakad Indoor Arena, Hinjewadi Road, Pune (2.1 km)',
      avatarUrl: 'https://i.pravatar.cc/100?img=3',
      sport: 'Badminton',
      type: 'Casual',
      tier: 'OPEN',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _games.length,
      itemBuilder: (_, i) => _GameCard(data: _games[i]),
    );
  }
}

class _GameCard extends StatelessWidget {
  final _GameData data;
  const _GameCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP
          Row(
            children: [
              _Tag(data.type),
              // const SizedBox(width: 6),
              _Tag("•"),
              _Tag(data.sport),
              const Spacer(),
              Text(
                data.price,
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// HOST
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: data.avatarUrl,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const _AvatarShimmer(),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        data.hostName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      data.time,
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                data.onboard,
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Colors.white12),

          /// LOCATION
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.muted,
                size: 14,
              ),
              const SizedBox(width: 4),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    data.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),
              _Tag(data.tier, color: Colors.blue),
            ],
          ),
        ],
      ),
    );
  }
}





class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, {this.color = AppColors.surface});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AvatarShimmer extends StatelessWidget {
  const _AvatarShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(shape: BoxShape.circle),
      ),
    );
  }
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
              color: AppColors.muted.withOpacity(0.6),
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
                color: AppColors.muted,
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
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent),
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