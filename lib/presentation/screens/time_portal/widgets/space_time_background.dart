import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 시공간 배경 위젯
/// 
/// 움직이는 별과 시간 파동 효과를 표시합니다.
class SpaceTimeBackground extends StatefulWidget {
  final Widget? child;

  const SpaceTimeBackground({super.key, this.child});

  @override
  State<SpaceTimeBackground> createState() => _SpaceTimeBackgroundState();
}

class _SpaceTimeBackgroundState extends State<SpaceTimeBackground>
    with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _waveController;
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _generateStars();
  }

  void _generateStars() {
    final random = math.Random(42);
    _stars = List.generate(80, (index) {
      return _Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 0.5,
        twinkleSpeed: random.nextDouble() * 2 + 1,
        brightness: random.nextDouble() * 0.5 + 0.5,
      );
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 그라데이션 배경
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D1B2A),  // 깊은 우주색
                Color(0xFF1B263B),  // 중간 톤
                Color(0xFF0D1B2A),  // 다시 깊은 색
              ],
            ),
          ),
        ),
        
        // 성운 효과
        AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return CustomPaint(
              painter: _NebulaPainter(
                animation: _waveController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // 별들
        AnimatedBuilder(
          animation: _starController,
          builder: (context, child) {
            return CustomPaint(
              painter: _StarFieldPainter(
                stars: _stars,
                animation: _starController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // 시간 파동 효과
        AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return CustomPaint(
              painter: _TimeWavePainter(
                animation: _waveController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // 자식 위젯
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

/// 별 데이터
class _Star {
  final double x;
  final double y;
  final double size;
  final double twinkleSpeed;
  final double brightness;

  const _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleSpeed,
    required this.brightness,
  });
}

/// 별 필드 페인터
class _StarFieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double animation;

  _StarFieldPainter({required this.stars, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // 반짝임 효과
      final twinkle = (math.sin(animation * math.pi * 2 * star.twinkleSpeed) + 1) / 2;
      final alpha = (star.brightness * 0.5 + twinkle * 0.5).clamp(0.0, 1.0);
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;
      
      // 별 위치
      final x = star.x * size.width;
      final y = star.y * size.height;
      
      // 별 그리기 (큰 별은 글로우 효과)
      if (star.size > 1.5) {
        // 글로우
        final glowPaint = Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: alpha * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(x, y), star.size * 2, glowPaint);
      }
      
      canvas.drawCircle(Offset(x, y), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter oldDelegate) => true;
}

/// 성운 페인터
class _NebulaPainter extends CustomPainter {
  final double animation;

  _NebulaPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // 보라색 성운
    final purpleNebula = Paint()
      ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    
    final offset1 = Offset(
      size.width * 0.3 + math.sin(animation * math.pi * 2) * 20,
      size.height * 0.4 + math.cos(animation * math.pi * 2) * 15,
    );
    canvas.drawCircle(offset1, size.width * 0.3, purpleNebula);
    
    // 청색 성운
    final blueNebula = Paint()
      ..color = const Color(0xFF3B82F6).withValues(alpha: 0.04)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    
    final offset2 = Offset(
      size.width * 0.7 + math.cos(animation * math.pi * 2) * 25,
      size.height * 0.6 + math.sin(animation * math.pi * 2) * 20,
    );
    canvas.drawCircle(offset2, size.width * 0.35, blueNebula);
  }

  @override
  bool shouldRepaint(_NebulaPainter oldDelegate) => true;
}

/// 시간 파동 페인터
class _TimeWavePainter extends CustomPainter {
  final double animation;

  _TimeWavePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // 여러 개의 동심원 파동
    for (int i = 0; i < 3; i++) {
      final phase = (animation + i * 0.33) % 1.0;
      final radius = phase * size.width * 0.6;
      final alpha = (1.0 - phase) * 0.1;
      
      final paint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_TimeWavePainter oldDelegate) => true;
}
