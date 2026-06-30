import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfessionalLoadingWidget extends StatefulWidget {
  final Color? primaryColor;
  final Color? secondaryColor;
  final double? size;
  final Duration? duration;

  const ProfessionalLoadingWidget({
    super.key,
    this.primaryColor,
    this.secondaryColor,
    this.size,
    this.duration,
  });

  @override
  State<ProfessionalLoadingWidget> createState() => _ProfessionalLoadingWidgetState();
}

class _ProfessionalLoadingWidgetState extends State<ProfessionalLoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? Colors.amberAccent;
    final secondaryColor = widget.secondaryColor ?? Colors.green;
    final size = widget.size ?? 50.0;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: CustomPaint(
              size: Size(size, size),
              painter: _LoadingPainter(
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                progress: _controller.value,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double progress;

  _LoadingPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.15
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    paint.color = secondaryColor.withOpacity(0.2);
    canvas.drawCircle(center, radius, paint);

    // Draw animated arc
    final sweepAngle = math.pi * 1.8;
    final startAngle = -math.pi / 2 + progress * math.pi * 2;

    paint.color = primaryColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Add a small dot at the end of the arc
    final dotAngle = startAngle + sweepAngle;
    final dotX = center.dx + radius * math.cos(dotAngle);
    final dotY = center.dy + radius * math.sin(dotAngle);
    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), radius * 0.2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _LoadingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.primaryColor != primaryColor || oldDelegate.secondaryColor != secondaryColor;
  }
}
