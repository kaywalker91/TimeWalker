import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

/// 시대별 분위기 오버레이 위젯
/// 
/// 각 왕국/시대에 맞는 색상 오버레이를 적용하여
/// 장소의 분위기를 연출합니다.
class AtmosphereOverlay extends StatelessWidget {
  /// 왕국 ID (goguryeo, baekje, silla, gaya)
  final String? kingdom;
  
  /// 기본 오버레이 색상 (왕국이 없을 경우)
  final Color? defaultColor;
  
  /// 오버레이 불투명도
  final double opacity;

  const AtmosphereOverlay({
    super.key,
    this.kingdom,
    this.defaultColor,
    this.opacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    final overlayColor = _getKingdomOverlayColor();
    
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              overlayColor.withValues(alpha: opacity * 0.5),
              overlayColor.withValues(alpha: opacity),
              overlayColor.withValues(alpha: opacity * 0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Color _getKingdomOverlayColor() {
    switch (kingdom) {
      case 'goguryeo':
        // 고구려: 강인한 붉은/갈색 톤
        return AppColors.atmosphereAncient;
      case 'baekje':
        // 백제: 우아한 녹색/청록 톤
        return AppColors.atmosphereNature;
      case 'silla':
        // 신라: 황금빛 톤
        return AppColors.atmosphereRoyal;
      case 'gaya':
        // 가야: 철기 문화의 깊은 청색
        return AppColors.atmosphereIndustrial;
      default:
        return defaultColor ?? AppColors.atmosphereDefault;
    }
  }
}

/// 왕국별 분위기 설정
class KingdomAtmosphere {
  /// 왕국 ID
  final String kingdom;
  
  /// 주요 오버레이 색상
  final Color overlayColor;
  
  /// 파티클 색상
  final Color particleColor;
  
  /// 파티클 개수
  final int particleCount;
  
  /// 분위기 설명
  final String description;

  const KingdomAtmosphere({
    required this.kingdom,
    required this.overlayColor,
    required this.particleColor,
    required this.particleCount,
    required this.description,
  });

  /// 고구려 분위기
  static const goguryeo = KingdomAtmosphere(
    kingdom: 'goguryeo',
    overlayColor: AppColors.atmosphereAncient,
    particleColor: AppColors.particleFlame, // 불꽃 같은 주황
    particleCount: 25,
    description: '강인한 기상의 고구려',
  );

  /// 백제 분위기
  static const baekje = KingdomAtmosphere(
    kingdom: 'baekje',
    overlayColor: AppColors.atmosphereNature,
    particleColor: AppColors.particleNature, // 부드러운 연녹색
    particleCount: 35,
    description: '우아한 백제의 문화',
  );

  /// 신라 분위기
  static const silla = KingdomAtmosphere(
    kingdom: 'silla',
    overlayColor: AppColors.atmosphereRoyal,
    particleColor: AppColors.premiumGold, // 황금빛
    particleCount: 40,
    description: '황금의 나라 신라',
  );

  /// 가야 분위기
  static const gaya = KingdomAtmosphere(
    kingdom: 'gaya',
    overlayColor: AppColors.atmosphereIndustrial,
    particleColor: AppColors.particleMetal, // 철빛
    particleCount: 30,
    description: '철의 왕국 가야',
  );

  /// 왕국 ID로 분위기 가져오기
  static KingdomAtmosphere? fromKingdom(String? kingdom) {
    switch (kingdom) {
      case 'goguryeo':
        return goguryeo;
      case 'baekje':
        return baekje;
      case 'silla':
        return silla;
      case 'gaya':
        return gaya;
      default:
        return null;
    }
  }
}
