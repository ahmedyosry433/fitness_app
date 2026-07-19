import 'dart:ui';
import 'package:fitness/features/home/presentation/view/widgets/custom_nav_icons.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:fitness/core/theme/app_colors.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.black22.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      customIcon: (color) => CustomPaint(
                        size: const Size(26, 26),
                        painter: HomeIconPainter(color: color),
                      ),
                      label: LocaleKeys.home_explore.tr(),
                      index: 0,
                    ),
                    _buildNavItem(
                      customIcon: (color) => CustomPaint(
                        size: const Size(26, 26),
                        painter: SmartCoachIconPainter(color: color),
                      ),
                      label: LocaleKeys.home_smart_coach.tr(),
                      index: 1,
                    ),
                    _buildNavItem(
                      customIcon: (color) => CustomPaint(
                        size: const Size(26, 26),
                        painter: DumbbellIconPainter(color: color),
                      ),
                      label: LocaleKeys.home_workout.tr(),
                      index: 2,
                      isSlanted: true, 
                    ),
                    _buildNavItem(
                      customIcon: (color) => CustomPaint(
                        size: const Size(26, 26),
                        painter: ProfileIconPainter(color: color),
                      ),
                      label: LocaleKeys.home_profile.tr(),
                      index: 3,
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

  Widget _buildNavItem({
    IconData? icon,
    Widget Function(Color color)? customIcon,
    required String label,
    required int index,
    bool isSlanted = false,
  }) {
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected ? AppColors.orangePrimary : Colors.white;

    Widget iconWidget = customIcon != null
        ? customIcon(color)
        : Icon(icon, color: color, size: 28);

    if (isSlanted) {
      iconWidget = Transform.rotate(angle: -math.pi / 4, child: iconWidget);
    }

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          if (isSelected) ...[
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ],
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
