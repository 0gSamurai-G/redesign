import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/view/USER/More/edit_profile.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/login.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';


class AppColors {
  static const bg = Color(0xFF000000);
  static const surface = Color(0xFF121212);
  static const card = Color(0xFF1A1A1A);
  static const accent = Color(0xFF1DB954);
  static const muted = Color(0xFFB3B3B3);
}


class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final _controller = Get.find<UserProfileController>();
  bool darkMode = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      _controller.fetchUserProfile(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0,0,0,100),
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 16),
            const _ZCoinsCard(),
            const SizedBox(height: 28),
            const _SectionTitle('My Tools'),
            const SizedBox(height: 14),
            const _ToolsGrid(),
            const SizedBox(height: 28),
            const _SectionTitle('Dive Into Your Sports'),
            const SizedBox(height: 14),
            const _SportsRow(), // ✅ INCLUDED
            const SizedBox(height: 28),
            const _RewardsCard(),
            const SizedBox(height: 28),
            const _SectionTitle('Help & Preferences'),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.help_outline,
              label: 'Support & FAQ',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.settings,
              label: 'App Settings',
              onTap: () {},
            ),
            _DarkModeTile(
              value: darkMode,
              onChanged: (v) => setState(() => darkMode = v),
            ),
            _SettingsTile(
              icon: Icons.logout,
              label: 'Log Out',
              color: Colors.red,
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Version 2.4.0 (Build 3020)',
                style: GoogleFonts.inter(
                  color: Colors.white24,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Logout',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to logout? You will need to sign in again to access your matches and profile.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx); // Close dialog
                    await FirebaseAuth.instance.signOut();
                    await UserPreferences.clearUser();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Cancel Button
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<UserProfileController>();
    return Obx(() {
      final user = _controller.rxUser.value;
      final name = user?.fullName ?? 'User';
      final imageUrl = _controller.profileImageUrl;
      final email = user?.primaryEmail ?? '';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ClipOval(
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: const CircleAvatar(radius: 26),
                      ),
                      errorWidget: (_, __, ___) => const CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xFF1A1A1A),
                        child: Icon(Icons.person, color: Colors.white38),
                      ),
                    )
                  : const CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFF1A1A1A),
                      child: Icon(Icons.person, color: Colors.white38),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _Badge('ELITE'),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: AppColors.surface,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
              child: Text(
                'Edit',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}


class _ZCoinsCard extends StatelessWidget {
  const _ZCoinsCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              AppColors.surface.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.monetization_on, color: AppColors.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Z Coins Balance\n340',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}


class _ToolsGrid extends StatelessWidget {
  const _ToolsGrid();

  @override
  Widget build(BuildContext context) {
    final tools = const [
      ('My Bookings', Icons.event),
      ('My Games & Teams', Icons.emoji_events),
      ('My Groups', Icons.groups),
      ('Invites & Requests', Icons.mail),
      ('Leaderboards', Icons.leaderboard),
      ('Goals & Missions', Icons.track_changes),
      ('Notifications', Icons.notifications),
      ('AI Coach', Icons.psychology),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tools.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (_, i) {
          final highlight = tools[i].$1 == 'AI Coach';
          return Container(
            decoration: BoxDecoration(
              color: highlight ? AppColors.accent : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tools[i].$2,
                  color: highlight ? Colors.black : Colors.white,
                ),
                const SizedBox(height: 6),
                Text(
                  tools[i].$1,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: highlight ? Colors.black : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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


class _SportsRow extends StatelessWidget {
  const _SportsRow();

  @override
  Widget build(BuildContext context) {
    final sports = const [
      ('Cricket', Icons.sports_cricket),
      ('Football', Icons.sports_soccer),
      ('Badminton', Icons.sports_tennis),
      ('Basketball', Icons.sports_basketball),
    ];

    return SizedBox(
      // height removed ❌
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (int i = 0; i < sports.length; i++) ...[
              _SportCard(
                name: sports[i].$1,
                icon: sports[i].$2,
              ),
              if (i != sports.length - 1)
                const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    );
  }
}





class _SportCard extends StatelessWidget {
  final String name;
  final IconData icon;

  const _SportCard({
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 140,
        maxWidth: 170, // slightly tighter = better density
      ),
      child: Container(
        padding: const EdgeInsets.all(12), // reduced padding
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔑
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ACTIONS
            _SportButton('Find Game', filled: true),
            const SizedBox(height: 6),
            _SportButton('Join Group', filled: false),
          ],
        ),
      ),
    );
  }
}





class _SportButton extends StatelessWidget {
  final String label;
  final bool filled;

  const _SportButton(
    this.label, {
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? AppColors.accent : Colors.transparent,
          foregroundColor: filled ? Colors.black : Colors.white,
          side: filled ? BorderSide.none : BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: () {},
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}




class _RewardsCard extends StatelessWidget {
  const _RewardsCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            // TODO: Navigate to Rewards Center
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),

              /// Base surface (separates from black bg)
              color: AppColors.surface,

              /// Soft Spotify glow
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],

              /// Subtle gradient overlay
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface,
                  AppColors.accent.withOpacity(0.12),
                ],
              ),

              /// Thin border for contrast
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
              ),
            ),
            child: Row(
              children: [
                /// ICON CONTAINER (Spotify style)
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withOpacity(0.15),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: AppColors.accent,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rewards Center',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Redeem coins for merch & discounts',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                /// CTA
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
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



class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.color = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: GoogleFonts.inter(color: color),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      ),
    );
  }
}


class _DarkModeTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DarkModeTile({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
        title: Text(
          'Dark Mode',
          style: GoogleFonts.inter(color: Colors.white),
        ),
      ),
    );
  }
}


class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}


class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
