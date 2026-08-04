import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness/core/theme/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor = AppColors.primaryOrange,
    this.iconColor = Colors.white,
    this.size = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onPressed ??
          () {
            if (context.canPop()) {
              context.pop();
            }
          },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: CustomPaint(painter: BackIconPainter(color: iconColor)),
        ),
      ),
    );
  }
}

class BackIconPainter extends CustomPainter {
  final Color color;

  BackIconPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Draw vertical line
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);

    // Draw chevron '<'
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * 0.4, size.height * 0.5)
      ..lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
