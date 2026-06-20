import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Thin gold linear progress bar (used under app bars, reading progress).
class GoldLinearProgress extends StatelessWidget {
  final double value; // 0..1
  final double height;
  final Color? background;
  const GoldLinearProgress({super.key, required this.value, this.height = 3, this.background});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: background ?? AppColors.surfaceAlt,
        valueColor: const AlwaysStoppedAnimation(AppColors.gold),
      ),
    );
  }
}

/// Large gold ring with a centred label — used by the Japa Mala counter.
class GoldCircularProgress extends StatelessWidget {
  final double value; // 0..1
  final double size;
  final double stroke;
  final Widget center;
  final Color trackColor;
  const GoldCircularProgress({
    super.key,
    required this.value,
    required this.center,
    this.size = 240,
    this.stroke = 10,
    this.trackColor = AppColors.darkSurfaceRing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(value.clamp(0.0, 1.0), stroke, trackColor),
        child: Center(child: center),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final double stroke;
  final Color trackColor;
  _RingPainter(this.value, this.stroke, this.trackColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [AppColors.goldDeep, AppColors.gold],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.stroke != stroke || old.trackColor != trackColor;
}
