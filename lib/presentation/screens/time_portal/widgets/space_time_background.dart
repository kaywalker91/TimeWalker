import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/themes.dart';

/// 시공간 배경 위젯
/// 
/// 깊이감 있는 우주 배경과 시간의 흐름(Flow)을 표현합니다.
/// 문명 선택에 따라 배경 분위기가 은은하게 변화합니다.
class SpaceTimeBackground extends StatefulWidget {
  final Widget? child;
  final Color? targetColor; // 문명 테마 색상 (없으면 기본 우주색)

  const SpaceTimeBackground({
    super.key, 
    this.child,
    this.targetColor,
  });

  @override
  State<SpaceTimeBackground> createState() => _SpaceTimeBackgroundState();
}

class _SpaceTimeBackgroundState extends State<SpaceTimeBackground>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  
  // 파티클 시스템
  late List<_StarLayer> _starLayers;
  late List<_FlowParticle> _flowParticles;
  
  // 배경색 애니메이션


  @override
  void initState() {
    super.initState();
    
    // 메인 루프 컨트롤러 (모든 애니메이션 구동)
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // 긴 주기로 반복
    )..repeat();

    _initLayers();
    _initFlowParticles();
  }

  @override
  void didUpdateWidget(SpaceTimeBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetColor != oldWidget.targetColor) {
      // 색상 변경 시 부드럽게 전환하기 위한 로직은 AnimatedContainer로 처리하거나
      // 여기서는 CustomPainter에 전달할 값을 업데이트
    }
  }

  void _initLayers() {
    // 3중 레이어 (원거리, 중거리, 근거리)
    _starLayers = [
      _StarLayer(count: 100, speed: 0.2, scale: 0.5, brightness: 0.6), // 먼 배경
      _StarLayer(count: 60, speed: 0.5, scale: 0.8, brightness: 0.8),  // 중간
      _StarLayer(count: 30, speed: 1.0, scale: 1.2, brightness: 1.0),  // 가까운
    ];
  }

  void _initFlowParticles() {
    final random = math.Random();
    _flowParticles = List.generate(40, (index) {
      return _FlowParticle(
        random: random,
        delay: random.nextDouble() * 5.0,
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 기본 배경 (색상 전환)
        AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                // 타겟 컬러가 있으면 은은하게 섞임
                widget.targetColor?.withValues(alpha: 0.15) ?? AppColors.spaceGradientMid,
                AppColors.spaceDeep,
                Colors.black,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),

        // 2. 별 필드 (Parallax & Twinkle)
        AnimatedBuilder(
          animation: _mainController,
          builder: (context, child) {
            return CustomPaint(
              painter: _DeepSpacePainter(
                layers: _starLayers,
                animationValue: _mainController.value,
              ),
              size: Size.infinite,
            );
          },
        ),

        // 3. 시간의 흐름 (Energy Flow)
        AnimatedBuilder(
          animation: _mainController,
          builder: (context, child) {
            return CustomPaint(
              painter: _TimeFlowPainter(
                particles: _flowParticles,
                time: _mainController.value,
                color: widget.targetColor ?? AppColors.portalGlow,
              ),
              size: Size.infinite,
            );
          },
        ),

        // 4. 비네팅 및 오버레이
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.spaceDeep.withValues(alpha: 0.4),
                Colors.transparent,
                AppColors.spaceDeep.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),

        // 5. 컨텐츠
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

// --- Helper Classes & Painters ---

class _StarLayer {
  final int count;
  final double speed;
  final double scale;
  final double brightness;
  late final List<_Star> stars;

  _StarLayer({
    required this.count,
    required this.speed,
    required this.scale,
    required this.brightness,
  }) {
    final random = math.Random();
    stars = List.generate(count, (_) => _Star(random: random));
  }
}

class _Star {
  final double x; // 0.0 ~ 1.0
  final double y; // 0.0 ~ 1.0
  final double sizeBase;
  final double blinkOffset;

  _Star({required math.Random random})
      : x = random.nextDouble(),
        y = random.nextDouble(),
        sizeBase = random.nextDouble() * 1.5 + 0.5,
        blinkOffset = random.nextDouble() * math.pi * 2;
}

class _DeepSpacePainter extends CustomPainter {
  final List<_StarLayer> layers;
  final double animationValue; // 0.0 ~ 1.0 (60초 주기)

  _DeepSpacePainter({required this.layers, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final layer in layers) {
      final paint = Paint()..style = PaintingStyle.fill;
      
      // 레이어 이동 (Parallax): 시간이 지날수록 천천히 이동
      // Y축으로 아주 천천히 상승하거나 흐르는 느낌
      final dy = animationValue * layer.speed * 100; 

      for (final star in layer.stars) {
        // 반짝임
        final blink = math.sin((animationValue * 50) + star.blinkOffset);
        final opacity = ((blink + 1) / 2 * 0.5 + 0.5) * layer.brightness;
        
        paint.color = Colors.white.withValues(alpha: opacity);

        // 좌표 계산 (Looping)
        double yPos = (star.y * size.height + dy) % size.height;
        double xPos = star.x * size.width;

        // 화면 밖으로 나가면 반대편에서 등장하는 것 같은 자연스러움
        canvas.drawCircle(
          Offset(xPos, yPos), 
          star.sizeBase * layer.scale, 
          paint
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DeepSpacePainter oldDelegate) => true;
}

class _FlowParticle {
  double x;
  double y;
  double speed;
  double length;
  double opacity;
  double delay;

  _FlowParticle({required math.Random random, required this.delay})
      : x = random.nextDouble() * 1.5 - 0.25, // 화면보다 넓게 분포
        y = random.nextDouble() * 1.5 - 0.25,
        speed = random.nextDouble() * 0.5 + 0.5,
        length = random.nextDouble() * 40 + 20,
        opacity = random.nextDouble() * 0.4 + 0.1;
}

class _TimeFlowPainter extends CustomPainter {
  final List<_FlowParticle> particles;
  final double time; // 0.0 ~ 1.0
  final Color color;

  _TimeFlowPainter({
    required this.particles, 
    required this.time,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 대각선 방향 (좌상 -> 우하) 흐름
    final flowPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 초당 프레임 변화(time은 0~1로 느리게 변하므로, 빠르게 변하는 값이 필요)
    // 여기서는 time 자체를 오프셋으로 쓰되, 입자 개별 속도 적용
    // 실제로는 time * constant 로 이동 거리를 계산
    final moveBase = time * 1000; 

    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      
      // 이동 계산 (대각선)
      final moveDist = (moveBase * p.speed) + (p.delay * 100);
      
      // 화면 좌표 매핑 (Looping)
      // 대각선 이동을 위해 X, Y 모두 변화
      double cx = (p.x * size.width + moveDist * 0.5) % (size.width * 1.5) - (size.width * 0.25);
      double cy = (p.y * size.height + moveDist * 0.5) % (size.height * 1.5) - (size.height * 0.25);

      // 꼬리가 있는 선 그리기
      flowPaint.color = color.withValues(alpha: p.opacity);
      flowPaint.strokeWidth = p.speed * 2;
      
      // 흐름 방향 벡터 (1, 1)
      final tailX = cx - p.length * 0.5; // 약간 기울기
      final tailY = cy - p.length * 0.5;

      // 화면 안에 있을 때만 그리기 (최적화)
      if (cx > -50 && cx < size.width + 50 && cy > -50 && cy < size.height + 50) {
        // 그라데이션 라인 효과 (선두는 밝고 꼬리는 투명)
        final gradientShader = LinearGradient(
          colors: [
            color.withValues(alpha: 0.0),
            color.withValues(alpha: p.opacity),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromPoints(Offset(tailX, tailY), Offset(cx, cy)));
        
        flowPaint.shader = gradientShader;
        canvas.drawLine(Offset(tailX, tailY), Offset(cx, cy), flowPaint);
        flowPaint.shader = null; // 초기화
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TimeFlowPainter oldDelegate) => true;
}
