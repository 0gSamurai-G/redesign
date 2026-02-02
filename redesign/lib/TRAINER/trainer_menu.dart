import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);

const kGreen = Color(0xFF1DB954);
const kGold = Color(0xFFF5C542);
const kMuted = Color(0xFFA7A7A7);
const kRed = Color(0xFFE53935);

class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const _ProfileAppBar(),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _ProfileHeaderCard(),
                const SizedBox(height: 16),

                const _MembershipCard(),
                const SizedBox(height: 16),

                const _ProfileCompletionCard(),
                const SizedBox(height: 28),

                const _SectionTitle('MANAGE PROFILE'),
                const _ManageTile(
                  icon: Icons.person_outline,
                  title: 'Public Profile Details',
                  subtitle: 'Edit bio, sports & experience',
                ),
                const _ManageTile(
                  icon: Icons.verified_outlined,
                  title: 'Certifications',
                  subtitle: 'Upload proof to get verified',
                ),
                const _ManageTile(
                  icon: Icons.tune,
                  title: 'Coaching Preferences',
                  subtitle: 'Online/Offline, Age Groups',
                ),
                const _ManageTile(
                  icon: Icons.calendar_today_outlined,
                  title: 'Availability & Block Dates',
                  subtitle: 'Manage your weekly schedule',
                ),

                const SizedBox(height: 24),
                const _SectionTitle('FINANCIALS & PACKAGES'),
                const _ManageTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Payouts & Bank Details',
                  subtitle: '₹42,500 pending payout',
                  highlight: kGreen,
                ),
                const _ManageTile(
                  icon: Icons.inventory_2_outlined,
                  title: 'Manage Packages',
                  subtitle: '4 active packages',
                ),

                const SizedBox(height: 24),
                const _SectionTitle('ACCOUNT'),
                const _DangerTile(
                  icon: Icons.logout,
                  title: 'Logout',
                ),
                const _DangerTile(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                ),

                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'App Version 2.4.0 • Trainer Build',
                    style: TextStyle(color: kMuted, fontSize: 12),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── APP BAR ───────────────── */

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ───────────────── PROFILE HEADER ───────────────── */

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: kGreen,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.black,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://randomuser.me/api/portraits/men/32.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Shimmer.fromColors(
                        baseColor: Colors.grey.shade900,
                        highlightColor:
                            Colors.grey.shade800,
                        child: Container(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black,
                child: const Icon(Icons.camera_alt,
                    size: 14, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Rahul Sharma',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Professional Cricket Coach • Helping young talent master the game. 🏏',
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: kMuted, height: 1.4),
          ),
          const SizedBox(height: 14),

          Row(
            children: const [
              _StatItem('4.9', 'Rating'),
              _StatItem('124', 'Reviews'),
              _StatItem('8 Yrs', 'Exp'),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: const [
              _Badge('Verified', kGreen),
              _Badge('Trainer Pro', kGold),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              style:
                  const TextStyle(color: kMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/* ───────────────── MEMBERSHIP ───────────────── */

class _MembershipCard extends StatelessWidget {
  const _MembershipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kGreen.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Trainer Pro – 1 Year',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Icon(Icons.verified_sharp, color: kGreen),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Valid till 15 Nov 2024',
              style: TextStyle(color: kMuted)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.8,
            color: kGreen,
            backgroundColor: Colors.white12,
            minHeight: 6,
          ),
          const SizedBox(height: 6),
          const Text('290 Days Left',
              style: TextStyle(color: kMuted)),
        ],
      ),
    );
  }
}

/* ───────────────── PROFILE COMPLETION ───────────────── */

class _ProfileCompletionCard extends StatelessWidget {
  const _ProfileCompletionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Add certifications to rank higher in search.',
                  style: TextStyle(color: kMuted),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: const [
              SizedBox(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(
                  value: 0.85,
                  strokeWidth: 5,
                  color: kGreen,
                  backgroundColor: Colors.white12,
                ),
              ),
              Text('85%',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

/* ───────────────── LIST ITEMS ───────────────── */

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ManageTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? highlight;

  const _ManageTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: highlight ?? kMuted,
              fontWeight:
                  highlight != null ? FontWeight.w600 : null),
        ),
        trailing: const Icon(Icons.chevron_right,
            color: Colors.white54),
        onTap: () {},
      ),
    );
  }
}

class _DangerTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _DangerTile({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: kRed),
        title: Text(title,
            style: const TextStyle(
                color: kRed, fontWeight: FontWeight.w600)),
        onTap: () {},
      ),
    );
  }
}
