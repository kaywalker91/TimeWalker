import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// 떠다니는 입자 효과 위젯
class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double maxSize;

  const FloatingParticles({
    super.key,
    this.particleCount = 30,
    this.particleColor = AppColors.primaryLight,
    this.maxSize = 4,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _particles = List.generate(widget.particleCount, (index) {
      final random = math.Random(index);
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * widget.maxSize + 1,
        speed: random.nextDouble() * 0.5 + 0.2,
        opacity: random.nextDouble() * 0.5 + 0.2,
        phase: random.nextDouble() * 2 * math.pi,
      );
    });
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
          size: Size.infinite,
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.particleColor,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.phase,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final animatedY = (particle.y - progress * particle.speed) % 1.0;
      final twinkle = (math.sin(progress * 2 * math.pi + particle.phase) + 1) / 2;
      
      final paint = Paint()
        ..color = color.withValues(alpha: particle.opacity * twinkle);
      
      canvas.drawCircle(
        Offset(particle.x * size.width, animatedY * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// 시간 포탈 링 애니메이션 위젯
class TimePortalRings extends StatefulWidget {
  final double size;
  final Color color;

  const TimePortalRings({
    super.key,
    this.size = 200,
    this.color = AppColors.secondary,
  });

  @override
  State<TimePortalRings> createState() => _TimePortalRingsState();
}

class _TimePortalRingsState extends State<TimePortalRings>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
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
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 외부 링
              _buildRing(
                size: widget.size,
                rotation: _controller.value * 2 * math.pi,
                opacity: 0.3,
              ),
              // 중간 링
              _buildRing(
                size: widget.size * 0.75,
                rotation: -_controller.value * 2 * math.pi,
                opacity: 0.4,
              ),
              // 내부 링
              _buildRing(
                size: widget.size * 0.5,
                rotation: _controller.value * 4 * math.pi,
                opacity: 0.5,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRing({
    required double size,
    required double rotation,
    required double opacity,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.color.withValues(alpha: opacity),
            width: 2,
          ),
        ),
        child: CustomPaint(
          painter: _PortalRingDashPainter(
            color: widget.color.withValues(alpha: opacity * 1.5),
          ),
        ),
      ),
    );
  }
}

class _PortalRingDashPainter extends CustomPainter {
  final Color color;

  _PortalRingDashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final startRadius = radius * 0.85;
      
      final start = Offset(
        center.dx + startRadius * math.cos(angle),
        center.dy + startRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
