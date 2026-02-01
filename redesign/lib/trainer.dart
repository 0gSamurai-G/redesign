import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/trainer_info.dart';
import 'package:redesign/trainer_register.dart';
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




class TrainerDiscoveryScreen extends StatefulWidget {
  const TrainerDiscoveryScreen({super.key});

  @override
  State<TrainerDiscoveryScreen> createState() =>
      _TrainerDiscoveryScreenState();
}

class _TrainerDiscoveryScreenState extends State<TrainerDiscoveryScreen> {
  bool showMyTrainers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            SliverToBoxAdapter(
              child: TrainersToggle(
                isMyTrainers: showMyTrainers,
                onChanged: (v) => setState(() => showMyTrainers = v),
              ),
            ),

            /// SWITCH
            if (showMyTrainers)
              const MyTrainersSection()
            else ...[
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: _FilterChips()),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _DiscoveryGrid(),
              const SliverToBoxAdapter(child: _TrainerEndOfResults()),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
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
              suffixIcon: const Icon(Icons.tune, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
_TrainerJoinCard(
  onTap: () {
    // Navigate to Trainer Login / Onboarding
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TrainerJoinScreen()));
  },
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

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_){return AcademyDetailScreen();}));
      },
      child: Container(
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


class TrainersToggle extends StatelessWidget {
  final bool isMyTrainers;
  final ValueChanged<bool> onChanged;

  const TrainersToggle({
    super.key,
    required this.isMyTrainers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          _tab(
            label: 'My Trainers',
            active: isMyTrainers,
            onTap: () => onChanged(true),
          ),
          _tab(
            label: 'Other Trainers',
            active: !isMyTrainers,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: active ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}


class MyTrainersSection extends StatelessWidget {
  const MyTrainersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 8),

          /// HEADER
          Row(
            children: [
              Text(
                'My Trainers',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'Active & recent coaches',
                style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// FILTER CHIPS
          Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    _FilterButton(
      label: 'Active packages',
      icon: Icons.local_fire_department,
      active: true,
      onTap: () {},
    ),
    _FilterButton(
      label: 'Cricket',
      active: false,
      onTap: () {},
    ),
    _FilterButton(
      label: 'Football',
      active: false,
      onTap: () {},
    ),
    _FilterButton(
      label: 'Online',
      active: false,
      onTap: () {},
    ),
  ],
),


          const SizedBox(height: 14),

          /// TRAINER CARD
          const _MyTrainerCard(),
        ]),
      ),
    );
  }
}


class _MyTrainerCard extends StatelessWidget {
  const _MyTrainerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.15),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.surface,
                child: Text(
                  'Trainer',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rahul Sharma',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _statusPill('Active Package'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Strength & Conditioning  •  8+ yrs',
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.star,
                            size: 14, color: AppColors.accent),
                        SizedBox(width: 4),
                        Text('4.8',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TAGS
          Wrap(
            spacing: 6,
            children: const [
              _Tag('Baner • Pune'),
              _Tag('Adults'),
              _Tag('Pro Athletes'),
              _Tag('Certified'),
            ],
          ),

          const SizedBox(height: 12),

          /// PROGRESS BAR
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 4 / 8,
                backgroundColor: AppColors.surface,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 4,
              ),
              const SizedBox(height: 4),
              Text(
                '4 / 8 sessions completed',
                style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ACTIONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('View Schedule'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: AppColors.accent,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}





class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}


class _FilterButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: active ? 1 : 0.98,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: AppColors.accent.withOpacity(0.2),
          highlightColor: AppColors.accent.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.accent.withOpacity(0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: active
                    ? AppColors.accent
                    : Colors.white.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color:
                        active ? AppColors.accent : Colors.white,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active
                        ? AppColors.accent
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _TrainerJoinCard extends StatelessWidget {
  final VoidCallback onTap;

  const _TrainerJoinCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: AppColors.accent.withOpacity(0.15),
        highlightColor: AppColors.accent.withOpacity(0.08),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent.withOpacity(0.18),
                AppColors.bg,
              ],
            ),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.18),
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              /// LEFT ICON
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              /// TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you a Trainer?',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Join us to manage sessions, earnings, and your player roster — all in one dashboard.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// CTA BUTTON
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.accent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Register',
                      style: GoogleFonts.inter(
                        color: AppColors.bg,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // const SizedBox(width: 6),
                    // const Icon(
                    //   Icons.arrow_forward_rounded,
                    //   size: 16,
                    //   color: AppColors.bg,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
