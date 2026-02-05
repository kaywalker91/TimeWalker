import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// 떠다니는 파티클 애니메이션 위젯
/// 
/// 장소 탐험 화면에서 분위기를 연출하는 빛 입자/먼지 효과
class FloatingParticles extends StatefulWidget {
  /// 파티클 개수
  final int particleCount;
  
  /// 파티클 색상
  final Color particleColor;
  
  /// 파티클 최대 크기
  final double maxParticleSize;
  
  /// 에니메이션 속도 배율
  final double speedMultiplier;

  const FloatingParticles({
    super.key,
    this.particleCount = 30,
    this.particleColor = AppColors.white,
    this.maxParticleSize = 4.0,
    this.speedMultiplier = 1.0,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (10000 / widget.speedMultiplier).round()),
      vsync: this,
    )..repeat();
    
    _initParticles();
  }

  void _initParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * widget.maxParticleSize + 1,
        opacity: _random.nextDouble() * 0.6 + 0.2,
        speed: _random.nextDouble() * 0.3 + 0.1,
        direction: _random.nextDouble() * 2 * math.pi,
        flickerOffset: _random.nextDouble() * 2 * math.pi,
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
          painter: _ParticlePainter(
            particles: _particles,
            color: widget.particleColor,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  final double size;
  final double opacity;
  final double speed;
  final double direction;
  final double flickerOffset;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.direction,
    required this.flickerOffset,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;
  final double progress;

  _ParticlePainter({
    required this.particles,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // 파티클 움직임 계산
      final dx = math.cos(particle.direction) * particle.speed * progress;
      final dy = math.sin(particle.direction) * particle.speed * progress - 
                 progress * particle.speed * 0.5; // 위로 떠오르는 효과
      
      var x = (particle.x + dx) % 1.0;
      var y = (particle.y + dy) % 1.0;
      if (y < 0) y += 1.0;
      
      // 깜빡임 효과
      final flicker = (math.sin(progress * 2 * math.pi + particle.flickerOffset) + 1) / 2;
      final currentOpacity = particle.opacity * (0.5 + flicker * 0.5);
      
      final paint = Paint()
        ..color = color.withValues(alpha: currentOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 0.5);
      
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// AnimatedBuilder 위젯 (Flutter의 AnimatedBuilder와 호환)
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
