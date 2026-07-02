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
      ..color = AppColors.divider.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (isActive || progress < 1.0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      
      final gradient = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          AppColors.primary.withAlpha(100),
          AppColors.primary,
        ],
        stops: const [0.0, 1.0],
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      // Add subtle glow during active session
      if (isActive) {
        final glowPaint = Paint()
          ..color = AppColors.primary.withAlpha(40)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 24
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawArc(
          rect,
          -math.pi / 2,
          2 * math.pi * progress,
          false,
          glowPaint,
        );
      }

      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );

      // Draw a glowing knob at the end of the progress
      final angle = -math.pi / 2 + 2 * math.pi * progress;
      final knobOffset = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final knobPaint = Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.fill;
      
      final knobShadow = Paint()
        ..color = AppColors.primaryDark.withAlpha(150)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(knobOffset, 12, knobShadow);
      canvas.drawCircle(knobOffset, 8, knobPaint);
    }

    // Inner subtle circle removed for a cleaner look

  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isActive != isActive;
  }
}
