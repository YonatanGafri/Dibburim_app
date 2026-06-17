import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

/// A custom widget that displays the "דיבורים" logo.
/// It renders the entire word as a single text block for perfect kerning,
/// and overlays a custom-drawn heart inside the letter "ב" (Bet) as a dagesh.
class DibburimLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const DibburimLogo({
    super.key,
    this.fontSize = 42.0, // Large, bold size for a professional logo look
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppColors.primary;

    // Heebo w900 (Black) gives a very solid, premium modern look
    final textStyle = GoogleFonts.heebo(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: logoColor,
      letterSpacing: -0.5, // Tighter letter spacing for a crafted logo feel
      height: 1.0,
    );

    // Measure the text layout to size our canvas perfectly
    final textPainter = TextPainter(
      text: TextSpan(text: 'דיבורים', style: textStyle),
      textDirection: TextDirection.rtl,
    )..layout();

    return CustomPaint(
      size: textPainter.size,
      painter: _LogoPainter(
        textPainter: textPainter,
        fontSize: fontSize,
        logoColor: logoColor,
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final TextPainter textPainter;
  final double fontSize;
  final Color logoColor;

  _LogoPainter({
    required this.textPainter,
    required this.fontSize,
    required this.logoColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the base text "דיבורים"
    textPainter.paint(canvas, Offset.zero);

    // 2. Find the bounding box of the letter 'ב' (index 2)
    final boxes = textPainter.getBoxesForSelection(
      const TextSelection(baseOffset: 2, extentOffset: 3),
    );

    if (boxes.isNotEmpty) {
      final box = boxes.first.toRect();

      // 3. Draw a beautiful heart using the Material icon!
      // This guarantees perfect heart proportions without squashing.
      final heartSize = fontSize * 0.22;

      final heartPainterFill = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.favorite.codePoint),
          style: TextStyle(
            fontFamily: Icons.favorite.fontFamily,
            package: Icons.favorite.fontPackage,
            fontSize: heartSize,
            color: logoColor.withValues(alpha: 0.2), // Light fill
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final heartPainterStroke = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.favorite.codePoint),
          style: TextStyle(
            fontFamily: Icons.favorite.fontFamily,
            package: Icons.favorite.fontPackage,
            fontSize: heartSize,
            foreground: Paint()
              ..color = logoColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = fontSize * 0.035
              ..strokeJoin = StrokeJoin.round,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // 4. Center it perfectly inside the 'ב'
      // Shift slightly right so it's not near the 'ו', and shift slightly up
      // because the Hebrew baseline means the glyph sits in the upper part of the box.
      final dx =
          box.center.dx - (heartPainterFill.width / 2) + (fontSize * 0.04);
      final dy =
          box.center.dy - (heartPainterFill.height / 2) - (fontSize * 0.05);

      final offset = Offset(dx, dy);

      // Draw fill then stroke
      heartPainterFill.paint(canvas, offset);
      heartPainterStroke.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) {
    return oldDelegate.fontSize != fontSize ||
        oldDelegate.logoColor != logoColor;
  }
}
