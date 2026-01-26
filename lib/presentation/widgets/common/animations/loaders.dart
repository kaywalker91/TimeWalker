import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// 회전하는 시간 로더
class TimeLoader extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const TimeLoader({
    super.key,
    this.size = 48,
    this.color = AppColors.primary,
    this.strokeWidth = 3,
  });

  @override
  State<TimeLoader> createState() => _TimeLoaderState();
}

class _TimeLoaderState extends State<TimeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _TimeLoaderPainter(
            progress: _controller.value,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}

class _TimeLoaderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _TimeLoaderPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // 배경 원
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius, bgPaint);
    
    // 회전하는 호
    final arcPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final startAngle = progress * 2 * math.pi;
    const sweepAngle = 1.5;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
    
    // 시계 바늘 (시침)
    final hourHandPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * 0.8
      ..strokeCap = StrokeCap.round;
    
    final hourAngle = progress * 2 * math.pi - math.pi / 2;
    final hourHandLength = radius * 0.5;
    final hourEnd = Offset(
      center.dx + hourHandLength * math.cos(hourAngle),
      center.dy + hourHandLength * math.sin(hourAngle),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);
    
    // 시계 바늘 (분침)
    final minuteAngle = progress * 12 * math.pi - math.pi / 2;
    final minuteHandLength = radius * 0.7;
    final minuteEnd = Offset(
      center.dx + minuteHandLength * math.cos(minuteAngle),
      center.dy + minuteHandLength * math.sin(minuteAngle),
    );
    canvas.drawLine(center, minuteEnd, hourHandPaint..strokeWidth = strokeWidth * 0.5);
    
    // 중심점
    canvas.drawCircle(center, strokeWidth, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TimeLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
