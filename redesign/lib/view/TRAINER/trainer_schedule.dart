import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);
const kYellow = Color(0xFFF5C542);
const kBlue = Color(0xFF42A5F5);
const kRed = Color(0xFFE53935);

class TrainerScheduleScreen extends StatelessWidget {
  const TrainerScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: kGreen,
          icon: const Icon(Icons.add),
          label: const Text(
            'Add Availability',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const _ScheduleAppBar(),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 180),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _MonthAndViewSelector(),
                const SizedBox(height: 16),
                const _DateStrip(),
                const SizedBox(height: 16),
                const _DailySummary(),
                const SizedBox(height: 16),
                const _OverlapAlert(),
                const SizedBox(height: 24),

                const _SectionTitle('MORNING'),
                const _SessionCardCompleted(),
                const SizedBox(height: 12),
                const _SessionCardUpcoming(),
                const SizedBox(height: 14),
                const _FreeSlot(),

                const SizedBox(height: 24),
                const _SectionTitle('AFTERNOON'),
                const _SessionCardRequest(),

                const SizedBox(height: 24),
                const _SectionTitle('EVENING'),
                const _SessionCardBatch(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── APP BAR ───────────────── */

class _ScheduleAppBar extends StatelessWidget {
  const _ScheduleAppBar();

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
                padding:
                    const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Schedule',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Today, 4 Oct',
                            style: TextStyle(color: kMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_today,
                          color: Colors.white),
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

/* ───────────────── MONTH + VIEW ───────────────── */

class _MonthAndViewSelector extends StatelessWidget {
  const _MonthAndViewSelector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'October 2023',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: const [
              _ViewTab('Day', true),
              _ViewTab('Week', false),
              _ViewTab('Month', false),
            ],
          ),
        ),
      ],
    );
  }
}

class _ViewTab extends StatelessWidget {
  final String text;
  final bool active;
  const _ViewTab(this.text, this.active);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? kGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

/* ───────────────── DATE STRIP ───────────────── */

class _DateStrip extends StatelessWidget {
  const _DateStrip();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _DateChip(
          day: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][i],
          date: (i + 2).toString().padLeft(2, '0'),
          active: i == 2,
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String day;
  final String date;
  final bool active;

  const _DateChip({
    required this.day,
    required this.date,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 56,
      decoration: BoxDecoration(
        color: active ? kGreen : kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: active ? Colors.black : kMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: active ? Colors.black : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              color: active ? Colors.black : kGreen,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}

/* ───────────────── SUMMARY ───────────────── */

class _DailySummary extends StatelessWidget {
  const _DailySummary();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _SummaryCard('SESSIONS', '4')),
        SizedBox(width: 12),
        Expanded(child: _SummaryCard('HOURS', '5.5')),
        SizedBox(width: 12),
        Expanded(
            child: _SummaryCard('EST. EARN', '₹2.8k',
                highlight: true)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final bool highlight;

  const _SummaryCard(
    this.title,
    this.value, {
    this.highlight = false,
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
            style: TextStyle(
              color: highlight ? kYellow : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── ALERT ───────────────── */

class _OverlapAlert extends StatelessWidget {
  const _OverlapAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [kRed.withOpacity(.3), kBg]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kRed.withOpacity(.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.warning_amber, color: kRed),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Overlapping Sessions',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'You have two sessions scheduled at 06:00 PM.',
                  style: TextStyle(color: kMuted),
                ),
                SizedBox(height: 8),
                Text(
                  'RESOLVE NOW',
                  style: TextStyle(
                      color: kRed,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── SESSION CARDS ───────────────── */

class _SessionBase extends StatelessWidget {
  final Color border;
  final Widget child;
  const _SessionBase(this.child, {this.border = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

/* COMPLETED */

class _SessionCardCompleted extends StatelessWidget {
  const _SessionCardCompleted();

  @override
  Widget build(BuildContext context) {
    return _SessionBase(
      Column(
        children: const [
          _SessionHeader('06:00', 'AM', '₹600', 'COMPLETED'),
          _SessionUser('Rohit Verma', 'Strength', 'FitCore Gym'),
          SizedBox(height: 10),
          _SessionAction('Add Notes'),
        ],
      ),
    );
  }
}

/* UPCOMING */

class _SessionCardUpcoming extends StatelessWidget {
  const _SessionCardUpcoming();

  @override
  Widget build(BuildContext context) {
    return _SessionBase(
      border: kGreen,
      Column(
        children: const [
          _SessionHeader('08:00', 'AM', '₹800', 'IN 15 MINS',
              badgeColor: kGreen),
          _SessionUser(
              'Ananya Singh', 'Batting Practice', 'Online'),
          SizedBox(height: 10),
          _ActionRow(['Start Session', 'Chat']),
        ],
      ),
    );
  }
}

/* REQUEST */

class _SessionCardRequest extends StatelessWidget {
  const _SessionCardRequest();

  @override
  Widget build(BuildContext context) {
    return _SessionBase(
      border: kBlue,
      Column(
        children: const [
          _SessionHeader('04:00', 'PM', '', 'NEW REQUEST',
              badgeColor: kBlue),
          _SessionUser(
              'Vikram Malhotra', 'Cricket Trial', 'Shivajinagar'),
          SizedBox(height: 10),
          _ActionRow(['Accept', 'Decline']),
        ],
      ),
    );
  }
}

/* BATCH */

class _SessionCardBatch extends StatelessWidget {
  const _SessionCardBatch();

  @override
  Widget build(BuildContext context) {
    return _SessionBase(
      Column(
        children: const [
          _SessionHeader('06:00', 'PM', '₹1,400', 'BATCH U-14',
              badgeColor: Colors.purple),
          _SessionUser(
              'Group Session', '8 Students', 'CrossFit Arena'),
          SizedBox(height: 10),
          _SessionAction('Manage Attendance'),
        ],
      ),
    );
  }
}

/* ───────────────── HELPERS ───────────────── */

class _SessionHeader extends StatelessWidget {
  final String time;
  final String meridiem;
  final String earn;
  final String badge;
  final Color badgeColor;

  const _SessionHeader(
    this.time,
    this.meridiem,
    this.earn,
    this.badge, {
    this.badgeColor = kMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 4),
        Text(meridiem, style: const TextStyle(color: kMuted)),
        const Spacer(),
        if (badge.isNotEmpty)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (earn.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              earn,
              style: const TextStyle(
                color: kYellow,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _SessionUser extends StatelessWidget {
  final String name;
  final String type;
  final String location;

  const _SessionUser(this.name, this.type, this.location);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          const CircleAvatar(radius: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '$type • $location',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: kMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final List<String> actions;
  const _ActionRow(this.actions);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: actions
          .map(
            (a) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: a == 'Accept'
                    ? kBlue
                    : a == 'Decline'
                        ? Colors.transparent
                        : kGreen,
                borderRadius: BorderRadius.circular(14),
                border: a == 'Decline'
                    ? Border.all(color: Colors.white24)
                    : null,
              ),
              child: Text(
                a,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SessionAction extends StatelessWidget {
  final String text;
  const _SessionAction(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
              color: kGreen, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        const Icon(Icons.chevron_right,
            color: Colors.white54),
      ],
    );
  }
}

class _FreeSlot extends StatelessWidget {
  const _FreeSlot();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.schedule, color: kMuted, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Free from 09:00 AM to 03:00 PM',
            style: TextStyle(color: kMuted),
          ),
        ),
        Text(
          '+ Add Slot',
          style: TextStyle(
              color: kGreen, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: kMuted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
