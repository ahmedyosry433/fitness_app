import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';

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
                  color: const Color(0xFF222222).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ), // Optional subtle border
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      customIcon: (color) => CustomPaint(
                        size: const Size(26, 26),
                        painter: HomeIconPainter(color: color),
                      ),
                      label: 'Explore',
                      index: 0,
                    ),
                    _buildNavItem(
                      customIcon: (color) => CustomPaint(
                        size: const Size(26, 26),
                        painter: SmartCoachIconPainter(color: color),
                      ),
                      label: 'Smart coach',
                      index: 1,
                    ),
                    _buildNavItem(
                      customIcon: (color) => CustomPaint(
                        size: const Size(26, 26),
                        painter: DumbbellIconPainter(color: color),
                      ),
                      label: 'Workout',
                      index: 2,
                      isSlanted: true, // Slant the dumbbell
                    ),
                    _buildNavItem(
                      customIcon: (color) => CustomPaint(
                        size: const Size(26, 26),
                        painter: ProfileIconPainter(color: color),
                      ),
                      label: 'Profile',
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
    final color = isSelected ? const Color(0xFFFF5722) : Colors.white;

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

class SmartCoachIconPainter extends CustomPainter {
  final Color color;
  SmartCoachIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Outer shape: circle with a less rounded bottom-right corner
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.elliptical(size.width / 2, size.height / 2),
      topRight: Radius.elliptical(size.width / 2, size.height / 2),
      bottomLeft: Radius.elliptical(size.width / 2, size.height / 2),
      bottomRight: Radius.elliptical(size.width / 5.5, size.height / 5.5),
    );
    canvas.drawRRect(rrect, paint);

    // Sparkle (4-pointed star)
    final sparkleCenter = Offset(size.width * 0.55, size.height * 0.45);
    final sparkleRadiusX = size.width * 0.18;
    final sparkleRadiusY = size.height * 0.22;

    final path = Path();
    // Top point
    path.moveTo(sparkleCenter.dx, sparkleCenter.dy - sparkleRadiusY);
    path.quadraticBezierTo(
      sparkleCenter.dx,
      sparkleCenter.dy,
      sparkleCenter.dx + sparkleRadiusX,
      sparkleCenter.dy,
    );
    // Right point
    path.quadraticBezierTo(
      sparkleCenter.dx,
      sparkleCenter.dy,
      sparkleCenter.dx,
      sparkleCenter.dy + sparkleRadiusY,
    );
    // Bottom point
    path.quadraticBezierTo(
      sparkleCenter.dx,
      sparkleCenter.dy,
      sparkleCenter.dx - sparkleRadiusX,
      sparkleCenter.dy,
    );
    // Left point
    path.quadraticBezierTo(
      sparkleCenter.dx,
      sparkleCenter.dy,
      sparkleCenter.dx,
      sparkleCenter.dy - sparkleRadiusY,
    );
    canvas.drawPath(path, paint);

    // Small dot (bottom left of sparkle)
    final dotCenter = Offset(size.width * 0.35, size.height * 0.65);
    canvas.drawCircle(dotCenter, size.width * 0.04, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DumbbellIconPainter extends CustomPainter {
  final Color color;
  DumbbellIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);

    // Center Bar
    canvas.drawLine(
      Offset(size.width * 0.35, center.dy),
      Offset(size.width * 0.65, center.dy),
      paint,
    );

    // Inner Pills
    final pillWidth = size.width * 0.18;
    final pillHeight = size.height * 0.5;
    final pillRadius = Radius.circular(pillWidth / 2);

    // Left pill
    final leftPillRect = Rect.fromCenter(
      center: Offset(size.width * 0.3, center.dy),
      width: pillWidth,
      height: pillHeight,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(leftPillRect, pillRadius), paint);

    // Right pill
    final rightPillRect = Rect.fromCenter(
      center: Offset(size.width * 0.7, center.dy),
      width: pillWidth,
      height: pillHeight,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rightPillRect, pillRadius), paint);

    // Outer arcs
    final arcWidth = size.width * 0.12;
    final arcHeight = size.height * 0.35;

    // Left arc
    final leftArcPath = Path();
    leftArcPath.addArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.15, center.dy),
        width: arcWidth,
        height: arcHeight,
      ),
      math.pi / 2, // Start from bottom
      math.pi, // Sweep to top (clockwise, draws left half)
    );
    canvas.drawPath(leftArcPath, paint);

    // Right arc
    final rightArcPath = Path();
    rightArcPath.addArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.85, center.dy),
        width: arcWidth,
        height: arcHeight,
      ),
      -math.pi / 2, // Start from top
      math.pi, // Sweep to bottom (clockwise, draws right half)
    );
    canvas.drawPath(rightArcPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ProfileIconPainter extends CustomPainter {
  final Color color;
  ProfileIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Head
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.3),
      size.height * 0.22,
      paint,
    );

    // Body (wide pill)
    final bodyRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.8),
      width: size.width * 0.75,
      height: size.height * 0.28,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(size.height * 0.14)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HomeIconPainter extends CustomPainter {
  final Color color;
  HomeIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    final left = size.width * 0.15;
    final right = size.width * 0.85;
    final bottom = size.height * 0.85;
    final wallTop = size.height * 0.45;
    final peak = size.height * 0.15;
    final mid = size.width / 2;

    final doorLeft = size.width * 0.38;
    final doorRight = size.width * 0.62;
    final doorTop = size.height * 0.55;
    final doorRadius = (doorRight - doorLeft) / 2;
    final doorArchCenterY = doorTop + doorRadius;

    path.moveTo(doorLeft, bottom);
    path.lineTo(left, bottom);
    path.lineTo(left, wallTop);
    path.lineTo(mid, peak);
    path.lineTo(right, wallTop);
    path.lineTo(right, bottom);
    path.lineTo(doorRight, bottom);
    path.lineTo(doorRight, doorArchCenterY);

    path.arcToPoint(
      Offset(doorLeft, doorArchCenterY),
      radius: Radius.circular(doorRadius),
      clockwise: false,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
