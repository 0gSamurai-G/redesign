import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/TRAINER/trainer_create.dart';
import 'package:redesign/TRAINER/trainer_home.dart';
import 'package:redesign/TRAINER/trainer_menu.dart';
import 'package:redesign/TRAINER/trainer_schedule.dart';
import 'package:redesign/TRAINER/trainer_students.dart';

class TrainerAppNavShell extends StatefulWidget {
  const TrainerAppNavShell({super.key});

  @override
  State<TrainerAppNavShell> createState() =>
      _TrainerAppNavShellState();
}

class _TrainerAppNavShellState extends State<TrainerAppNavShell> {
  int _currentIndex = 0;

  static const accent = Color(0xFF1DB954);
  static const bg = Color(0xFF000000);

  /// ✅ HOME IS FIRST (DEFAULT)
  final _pages = const [
    TrainerDashboardHomeScreen(), // Home
    TrainerScheduleScreen(),
    TrainerCreateOfferingsScreen(),
    TrainerStudentsScreen(),
    TrainerProfileScreen(),
  ];

  void _onTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              border: const Border(
                top: BorderSide(color: Colors.white12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _NavItem(
                  filled: Icons.home_rounded,
                  outlined: Icons.home_outlined,
                  label: 'Home',
                  index: 0,
                ),
                _NavItem(
                  filled: Icons.calendar_month_rounded,
                  outlined: Icons.calendar_month_outlined,
                  label: 'Schedule',
                  index: 1,
                ),
                _NavItem(
                  filled: Icons.add_circle,
                  outlined: Icons.add_circle_outline,
                  label: 'Create',
                  index: 2,
                ),
                _NavItem(
                  filled: Icons.groups_rounded,
                  outlined: Icons.groups_outlined,
                  label: 'Students',
                  index: 3,
                ),
                _NavItem(
                  filled: Icons.menu_rounded,
                  outlined: Icons.menu_outlined,
                  label: 'More',
                  index: 4,
                ),
              ].map((item) {
                final selected = item.index == _currentIndex;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onTap(item.index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected
                            ? item.filled
                            : item.outlined,
                        size: 26,
                        color: selected
                            ? accent
                            : Colors.white60,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected
                              ? accent
                              : Colors.white60,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}


/* ============================================================
   NAV ITEM MODEL
   ============================================================ */
class _NavItem {
  final IconData filled;
  final IconData outlined;
  final String label;
  final int index;

  const _NavItem({
    required this.filled,
    required this.outlined,
    required this.label,
    required this.index,
  });
}





