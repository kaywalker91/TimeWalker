import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// 지도 배경 컴포넌트
/// SpriteComponent를 상속하지 않고 PositionComponent를 사용하여
/// 스프라이트 로드 실패 시에도 작동하도록 함
class MapBackgroundComponent extends PositionComponent with HasGameReference<FlameGame> {
  Sprite? _sprite;
  Vector2? _spriteSize;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 지도 이미지 로드
    try {
      // Flame의 이미지 로드: assets/를 제외한 경로 사용
      _sprite = await game.loadSprite('map/world_map.png');
      _sprite?.paint.filterQuality = FilterQuality.high;
    } catch (e) {
      // 이미지 로드 실패 시 기본 색상으로 대체
      debugPrint('Failed to load map image: $e');
      _sprite = null;
    }

    // 지도 크기 설정 (이미지 원본 크기 기준)
    if (_sprite != null) {
      _spriteSize = _sprite!.originalSize;
      size = _spriteSize!.clone();
    } else {
      size = Vector2(game.size.x, game.size.y);
    }

    anchor = Anchor.topLeft;
  }

  Vector2 get imageSize => _spriteSize ?? size;

  @override
  void render(Canvas canvas) {
    if (_sprite != null) {
      // 스프라이트를 확대하여 지도 크기에 맞춤
      _sprite!.render(
        canvas,
        position: Vector2.zero(),
        size: size,
      );
    } else {
      // 기본 배경 그리기
      final paint = Paint()..color = const Color(0xFF1a1a2e);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        paint,
      );
      
      // 그리드 오버레이 (선택적)
      _drawGrid(canvas);
    }
  }
  
  /// 그리드 오버레이 그리기
  void _drawGrid(Canvas canvas) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    
    // 수직선
    for (double x = 0; x < size.x; x += 100) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.y),
        paint,
      );
    }
    
    // 수평선
    for (double y = 0; y < size.y; y += 100) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.x, y),
        paint,
      );
    }
  }
}
