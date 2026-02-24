import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/togglemode.dart';
import 'package:redesign/user_navigation.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);
const kGold = Color(0xFFF5C542);
const kRed = Color(0xFFE53935);

class TrainerDashboardHomeScreen extends StatefulWidget {
  const TrainerDashboardHomeScreen({super.key});

  @override
  State<TrainerDashboardHomeScreen> createState() => _TrainerDashboardHomeScreenState();
}

class _TrainerDashboardHomeScreenState extends State<TrainerDashboardHomeScreen> {
  AppMode _mode = AppMode.trainer;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      backgroundColor: kBg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const _DashboardHeader(),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 120 ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  TrainerModePillToggle(
                    mode: _mode,
                    onChanged: (m) {
                      setState(() => _mode = m);
                      if (_mode == AppMode.player) {
                        // switch to player shell
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => UserAppNavShell()),
                          (route) => false,
                        );
                      }

                      // Optional:
                      // Navigate or switch shell here
                    },
                  ),
                  const SizedBox(height: 16),
                  const _ProfileCompletionAlert(),
                  const SizedBox(height: 16),
                  const _MembershipCard(),
                  const SizedBox(height: 16),
                  const _MetricsRow(),
                  const SizedBox(height: 16),
                  const _WeeklyActivityCard(),
                  const SizedBox(height: 20),
                  const _QuickActions(),
                  const SizedBox(height: 24),
                  const _NewInquirySection(),
                  const SizedBox(height: 24),
                  const _SchedulePreview(),
                  const SizedBox(height: 24),
                  const _WalletSnapshot(),
                  const SizedBox(height: 16),
                  const _RatingCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────── HEADER ───────────────── */

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.black,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: CachedNetworkImageProvider(
                        'https://randomuser.me/api/portraits/men/32.jpg',
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: kGreen, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Rahul Sharma',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Trainer Pro',
                            style: TextStyle(
                                color: kGreen, fontSize: 12),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.verified,
                              color: kGreen, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
                const _HeaderIcon(Icons.search),
                const SizedBox(width: 8),
                Stack(
                  children: const [
                    _HeaderIcon(Icons.notifications_none),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: kRed,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(height: 8, width: 8),
                      ),
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


class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: kCard,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

/* ───────────────── PROFILE ALERT ───────────────── */

class _ProfileCompletionAlert extends StatelessWidget {
  const _ProfileCompletionAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kRed.withOpacity(0.25), kBg],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kRed.withOpacity(0.4)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: kRed),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Your Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Add 2 more certifications to boost visibility.',
                  style: TextStyle(color: kMuted),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white),
        ],
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
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [kGreen.withOpacity(0.25), Colors.black],
        ),
        border: Border.all(color: kGreen.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trainer Pro Plan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                'Valid till 14 Dec, 2025',
                style: TextStyle(color: kMuted),
              ),
              const Spacer(),
              _Badge('ACTIVE', kGreen),
              const SizedBox(width: 6),
              _Badge('ELITE', kGold),
            ],
          ),
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
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/* ───────────────── METRICS ───────────────── */

class _MetricsRow extends StatelessWidget {
  const _MetricsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _MetricCard(
            title: 'Earnings',
            value: '₹42.5k',
            subtitle: '+15%',
            positive: true,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            title: 'Students',
            value: '18',
            subtitle: '+3 New',
            positive: true,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            title: 'Views',
            value: '1.2k',
            subtitle: 'Avg',
            positive: false,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final bool positive;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: kMuted)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: positive ? kGreen : kMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── PLACEHOLDER SECTIONS ───────────────── */

class _WeeklyActivityCard extends StatelessWidget {
  const _WeeklyActivityCard();

  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      title: 'Weekly Activity',
      subtitle: 'Sessions conducted',
      child: const SizedBox(
        height: 80,
        child: Center(
          child: Text('Activity Graph',
              style: TextStyle(color: kMuted)),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _ActionIcon('Add Slot', Icons.add),
            _ActionIcon('Packages', Icons.inventory_2),
            _ActionIcon('Broadcast', Icons.campaign),
            _ActionIcon('Profile', Icons.person),
          ],
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ActionIcon(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: kCard,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                color: kMuted, fontSize: 12)),
      ],
    );
  }
}

/* ───────────────── INQUIRIES / SCHEDULE / WALLET / RATING ───────────────── */

class _NewInquirySection extends StatelessWidget {
  const _NewInquirySection();

  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      title: 'New Inquiries (2)',
      trailing: const Text('View All',
          style: TextStyle(color: kGreen)),
      child: const Text('Inquiry Card',
          style: TextStyle(color: kMuted)),
    );
  }
}

class _SchedulePreview extends StatelessWidget {
  const _SchedulePreview();

  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      title: 'Schedule',
      trailing: const Text('Full Calendar',
          style: TextStyle(color: kGreen)),
      child: const Text('Upcoming Sessions',
          style: TextStyle(color: kMuted)),
    );
  }
}

class _WalletSnapshot extends StatelessWidget {
  const _WalletSnapshot();

  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      title: 'Wallet Snapshot',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '₹12,450',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text('Next payout: 15 Dec',
              style: TextStyle(color: kMuted)),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard();

  @override
  Widget build(BuildContext context) {
    return _SimpleCard(
      child: Row(
        children: const [
          Icon(Icons.star, color: kGold),
          SizedBox(width: 8),
          Text('4.9 / 5',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          SizedBox(width: 6),
          Text('(24 reviews)',
              style: TextStyle(color: kMuted)),
        ],
      ),
    );
  }
}

/* ───────────────── SHARED CARD ───────────────── */

class _SimpleCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  const _SimpleCard({
    this.title,
    this.subtitle,
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
          if (title != null)
            Row(
              children: [
                Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(subtitle!,
                  style: const TextStyle(color: kMuted)),
            ),
          if (title != null || subtitle != null)
            const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
