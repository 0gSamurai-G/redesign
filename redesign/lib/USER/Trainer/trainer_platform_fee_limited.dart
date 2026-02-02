import 'dart:ui';
import 'package:flutter/material.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);
const kAmber = Color(0xFFF5C542);

class TrainerLimitedAccessScreen extends StatelessWidget {
  const TrainerLimitedAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // const _LimitedAccessAppBar(),
        _LimitedAccessHeader(),
            SliverPadding(
              padding:
                  EdgeInsets.fromLTRB(16, 12, 16, 140 + bottomInset),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  
                  const _LimitedAccessBanner(),
                  const SizedBox(height: 20),
                  const _CurrentStatusCard(),
                  const SizedBox(height: 20),
                  const _AllowedFeaturesCard(),
                  const SizedBox(height: 20),
                  const _LockedFeaturesCard(),
                ]),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM ACTIONS
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: kCard)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// PRIMARY CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Upgrade to Trainer Pro ↗',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// SECONDARY CTA
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side:
                      BorderSide(color: Colors.white.withOpacity(0.3)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14,horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text(
                  'Continue with Limited Access',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────── APP BAR ───────────────── */

class _LimitedAccessHeader extends StatelessWidget {
  const _LimitedAccessHeader();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Limited Access Mode',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'You can upgrade anytime',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 13,
                      ),
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


/* ───────────────── WARNING BANNER ───────────────── */

class _LimitedAccessBanner extends StatelessWidget {
  const _LimitedAccessBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            kAmber.withOpacity(0.25),
            Colors.black,
          ],
        ),
        border: Border.all(
          color: kAmber.withOpacity(0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.warning_amber_rounded,
              color: kAmber, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "You're in Limited Access",
                  style: TextStyle(
                    color: kAmber,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Some trainer features are locked until you activate a Trainer Pro plan.',
                  style:
                      TextStyle(color: kMuted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── CURRENT STATUS ───────────────── */

class _CurrentStatusCard extends StatelessWidget {
  const _CurrentStatusCard();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: 'CURRENT STATUS',
      children: const [
        _StatusRow('Membership Plan', 'None'),
        _StatusRow(
          'Access Level',
          'Limited',
          badge: true,
        ),
        _StatusRow('Visibility', 'Private'),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final bool badge;

  const _StatusRow(
    this.label,
    this.value, {
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(color: kMuted)),
          ),
          badge
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kAmber.withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Limited',
                    style: TextStyle(
                      color: kAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Text(value,
                  style: const TextStyle(
                      color: Colors.white)),
        ],
      ),
    );
  }
}

/* ───────────────── ALLOWED FEATURES ───────────────── */

class _AllowedFeaturesCard extends StatelessWidget {
  const _AllowedFeaturesCard();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: 'WHAT YOU CAN DO',
      children: const [
        _CheckRow(
            'Complete your trainer profile'),
        _CheckRow(
            'Upload certifications & details'),
        _CheckRow(
            'Set availability & pricing'),
        _CheckRow(
            'Access help & support'),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String text;
  const _CheckRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              color: kGreen, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── LOCKED FEATURES ───────────────── */

class _LockedFeaturesCard extends StatelessWidget {
  const _LockedFeaturesCard();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: 'LOCKED FEATURES',
      trailing:
          const Icon(Icons.lock, color: kMuted),
      children: [
        const _LockRow(
            'Public trainer listing & search'),
        const _LockRow(
            'Receiving student leads'),
        const _LockRow(
            'In-app chat with students'),
        const _LockRow(
            'Accepting payments & bookings'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: const [
              Icon(Icons.auto_awesome,
                  color: kGreen, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Unlock all features to start earning and growing your career immediately.',
                  style: TextStyle(
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LockRow extends StatelessWidget {
  final String text;
  const _LockRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.lock_outline,
              color: kMuted, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: kMuted)),
          ),
        ],
      ),
    );
  }
}

/* ───────────────── SHARED CARD ───────────────── */

class _CardWrapper extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  const _CardWrapper({
    required this.title,
    required this.children,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
