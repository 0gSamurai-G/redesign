import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class AppColors {
  static const bg = Color(0xFF000000);
  static const card = Color(0xFF121212);
  static const surface = Color(0xFF1A1A1A);
  static const muted = Color(0xFFB3B3B3);
  static const accent = Color(0xFF1DB954);
}


enum EntityType { trainer, academy }

class DiscoveryItem {
  final String name;
  final String subtitle;
  final double rating;
  final EntityType type;
  final List<String> images;
  final List<String> tags;
  final List<IconData> sports;

  const DiscoveryItem({
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.type,
    required this.images,
    required this.tags,
    required this.sports,
  });
}




class TrainerDiscoveryScreen extends StatelessWidget {
  const TrainerDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.bg,
      body: SafeArea(
        top: true,
        bottom: false, 
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: _FilterChips()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            _DiscoveryGrid(),
            const SliverToBoxAdapter(child: _TrainerEndOfResults()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}


class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                'Shivajinagar',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              const Spacer(),
              const Icon(Icons.notifications_none, color: Colors.white),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            cursorColor: AppColors.accent,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search trainers, sports...',
              hintStyle: GoogleFonts.inter(color: AppColors.muted),
              prefixIcon: const Icon(Icons.search, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _FilterChips extends StatefulWidget {
  const _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int selected = 0;
  final chips = ['All', 'Cricket', 'Fitness', 'Football', 'Yoga'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final active = selected == i;
          return GestureDetector(
            onTap: () => setState(() => selected = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                chips[i],
                style: GoogleFonts.inter(
                  color: active ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



class _DiscoveryGrid extends StatelessWidget {
  final items = const [
    DiscoveryItem(
      name: 'Rahul Sharma',
      subtitle: 'FitCore Gym, Pune',
      rating: 4.8,
      type: EntityType.trainer,
      images: [
        'https://images.unsplash.com/photo-1599058917212-d750089bc07c',
      ],
      tags: ['Adults', 'Strength'],
      sports: [Icons.fitness_center],
    ),
    DiscoveryItem(
      name: 'PowerPlay Cricket',
      subtitle: 'Kothrud, Pune',
      rating: 4.9,
      type: EntityType.academy,
      images: [
        'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
      ],
      tags: ['Kids', 'Camp'],
      sports: [Icons.sports_cricket, Icons.groups],
    ),
    DiscoveryItem(
      name: 'Anjali Deshmukh',
      subtitle: 'Viman Nagar',
      rating: 5.0,
      type: EntityType.trainer,
      images: [
        'https://images.unsplash.com/photo-1599058917212-d750089bc07c',
      ],
      tags: ['Women', 'Yoga'],
      sports: [Icons.self_improvement],
    ),
    DiscoveryItem(
      name: 'Smash Zone',
      subtitle: 'Baner, Pune',
      rating: 4.5,
      type: EntityType.academy,
      images: [
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      ],
      tags: ['Pro', 'Coaching'],
      sports: [Icons.sports_tennis],
    ),DiscoveryItem(
      name: 'Anjali Deshmukh',
      subtitle: 'Viman Nagar',
      rating: 5.0,
      type: EntityType.trainer,
      images: [
        'https://images.unsplash.com/photo-1599058917212-d750089bc07c',
      ],
      tags: ['Women', 'Yoga'],
      sports: [Icons.self_improvement],
    ),
    DiscoveryItem(
      name: 'Smash Zone',
      subtitle: 'Baner, Pune',
      rating: 4.5,
      type: EntityType.academy,
      images: [
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
      ],
      tags: ['Pro', 'Coaching'],
      sports: [Icons.sports_tennis],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final columns = width >= 900 ? 3 : 2;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) => _DiscoveryCard(item: items[i]),
          childCount: items.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
      ),
    );
  }
}



class _DiscoveryCard extends StatefulWidget {
  final DiscoveryItem item;
  const _DiscoveryCard({required this.item});

  @override
  State<_DiscoveryCard> createState() => _DiscoveryCardState();
}

class _DiscoveryCardState extends State<_DiscoveryCard> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.08,
                  child: PageView.builder(
                    itemCount: item.images.length,
                    onPageChanged: (i) => setState(() => index = i),
                    itemBuilder: (_, i) => CachedNetworkImage(
                      imageUrl: item.images[i],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: Container(color: Colors.grey.shade800),
                      ),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                ),

                /// TYPE BADGE
                Positioned(
                  top: 8,
                  left: 8,
                  child: _Pill(
                    item.type == EntityType.trainer
                        ? 'TRAINER'
                        : 'ACADEMY',
                  ),
                ),

                /// SPORTS ICONS
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: item.sports.take(2).map((icon) {
                      return Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 14, color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          /// INFO
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _Rating(item.rating),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: item.tags.map(_TagChip.new).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white70),
        color: Colors.black54,
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  final double rating;
  const _Rating(this.rating);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 12, color: AppColors.accent),
          const SizedBox(width: 2),
          Text(
            rating.toString(),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  const _TagChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: Colors.white,
        ),
      ),
    );
  }
}




class _TrainerEndOfResults extends StatelessWidget {
  const _TrainerEndOfResults();

  static const _illustrationUrl =
      'https://illustrations.popsy.co/gray/fitness-trainer.svg';

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
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 56),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🖼️ ILLUSTRATION (CACHED + SHIMMER)
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
              Icons.fitness_center,
              size: imageSize * 0.6,
              color: AppColors.muted.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 20),

          /// TITLE
          Text(
            'That’s all for now',
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
            constraints: const BoxConstraints(maxWidth: 340),
            child: Text(
              'No more trainers or academies found.\nTry a different sport or expand your filters.',
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

          /// CTA – FUTURE READY
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
              'Try Another Sport',
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
