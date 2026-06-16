import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/theme.dart';

/// A beautiful circular countdown timer with an animated arc.
class CircularTimer extends StatelessWidget {
  final String displayTime;
  final double progress; // 0.0 to 1.0
  final double size;
  final bool isActive;

  const CircularTimer({
    super.key,
    required this.displayTime,
    required this.progress,
    this.size = 260,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TimerPainter(
          progress: progress,
          isActive: isActive,
        ),
        child: Center(
          child: Text(
            displayTime,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w300,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
          ),
        ),
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final bool isActive;

  _TimerPainter({required this.progress, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;

    // Background circle (track)
    final trackPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (isActive || progress < 1.0) {
      final progressPaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

      // Add subtle glow during active session
      if (isActive) {
        final glowPaint = Paint()
          ..color = AppColors.primary.withAlpha(30)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi / 2,
          2 * math.pi * progress,
          false,
          glowPaint,
        );
      }

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }

    // Inner subtle circle
    final innerPaint = Paint()
      ..color = AppColors.surfaceDim.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius - 20, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isActive != isActive;
  }
}
