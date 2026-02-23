import 'package:flutter/material.dart';

const kSpotifyGreen = Color(0xFF1DB954);
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

enum AppMode { player, trainer }

class TrainerModePillToggle extends StatelessWidget {
  final AppMode mode;
  final ValueChanged<AppMode> onChanged;
  final bool compact;

  const TrainerModePillToggle({
    super.key,
    required this.mode,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double height = 30;
        final double pillWidth = constraints.maxWidth;
        final double segmentWidth = pillWidth / 2;

        return Container(
          margin: compact ? EdgeInsets.zero : const EdgeInsets.only(top: 12),
          height: height,
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// 🔹 ACTIVE SLIDING PILL
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                left: mode == AppMode.player ? 0 : segmentWidth,
                child: Container(
                  width: segmentWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: kSpotifyGreen,
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: kSpotifyGreen.withOpacity(0.50),
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔹 TABS
              Row(
                children: [
                  _PillTab(
                    width: segmentWidth,
                    label: 'Player',
                    active: mode == AppMode.player,
                    onTap: () => onChanged(AppMode.player),
                  ),
                  _PillTab(
                    width: segmentWidth,
                    label: 'Trainer',
                    active: mode == AppMode.trainer,
                    onTap: () => onChanged(AppMode.trainer),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PillTab extends StatelessWidget {
  final double width;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PillTab({
    required this.width,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.black : kMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
