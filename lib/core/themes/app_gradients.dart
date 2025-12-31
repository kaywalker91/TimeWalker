import 'package:flutter/material.dart';
import 'app_colors.dart';

/// TimeWalker 앱 그라데이션 시스템
/// 
/// 시간 포탈과 고대 유물의 신비로운 느낌을 표현하는 그라데이션 모음
abstract class AppGradients {
  // ============================================
  // BACKGROUND GRADIENTS - 배경용 그라데이션
  // ============================================
  
  /// 메인 배경 그라데이션 - 시간의 심연
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.background,
      Color(0xFF12101E),
      Color(0xFF1A1520),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  /// 시간 포탈 배경 - 보라빛 그라데이션
  static const LinearGradient timePortal = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D0D1A),
      Color(0xFF15102A),
      Color(0xFF1A1530),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  /// 양피지 느낌 배경 (라이트 모드용)
  static const LinearGradient parchment = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF5DEB3),
      Color(0xFFEED9A0),
      Color(0xFFDCCA85),
    ],
  );

  // ============================================
  // BUTTON GRADIENTS - 버튼용 그라데이션
  // ============================================
  
  /// 황금 버튼 그라데이션 - Primary CTA
  static const LinearGradient goldenButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF2D272),
      AppColors.primary,
      Color(0xFF8B6914),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  /// 황금 버튼 (호버/프레스)
  static const LinearGradient goldenButtonPressed = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      Color(0xFF8B6914),
      Color(0xFF6B5210),
    ],
  );
  
  /// 시간 포탈 버튼 - Secondary
  static const LinearGradient portalButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.secondaryLight,
      AppColors.secondary,
      AppColors.secondaryDark,
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  /// 비활성 버튼
  static const LinearGradient disabledButton = LinearGradient(
    colors: [
      Color(0xFF3D3548),
      Color(0xFF2D2535),
    ],
  );

  // ============================================
  // CARD GRADIENTS - 카드용 그라데이션
  // ============================================
  
  /// 기본 카드 그라데이션
  static const LinearGradient card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2D2535),
      Color(0xFF1A1520),
    ],
  );
  
  /// 강조 카드 (골드 테두리 효과)
  static const LinearGradient cardHighlight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF3D3548),
      Color(0xFF2D2535),
      Color(0xFF1A1520),
    ],
  );
  
  /// 잠긴 카드
  static const LinearGradient cardLocked = LinearGradient(
    colors: [
      Color(0xFF1A1520),
      Color(0xFF12101E),
    ],
  );

  // ============================================
  // GLOW GRADIENTS - 글로우 효과용
  // ============================================
  
  /// 황금 글로우 (방사형)
  static const RadialGradient goldenGlow = RadialGradient(
    colors: [
      Color(0x80D4AF37),
      Color(0x40D4AF37),
      Color(0x00D4AF37),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  /// 시간 포탈 글로우 (방사형)
  static const RadialGradient portalGlow = RadialGradient(
    colors: [
      Color(0x807B68EE),
      Color(0x407B68EE),
      Color(0x007B68EE),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  /// 별빛 글로우
  static const RadialGradient starlightGlow = RadialGradient(
    colors: [
      Color(0xCCFFFACD),
      Color(0x66FFFACD),
      Color(0x00FFFACD),
    ],
  );

  // ============================================
  // SHIMMER GRADIENTS - 반짝임 효과용
  // ============================================
  
  /// 황금 쉬머
  static const LinearGradient goldenShimmer = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      Color(0x00D4AF37),
      Color(0x80F2D272),
      Color(0x00D4AF37),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  /// 시간 쉬머
  static const LinearGradient temporalShimmer = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      Color(0x007B68EE),
      Color(0x80B8A9F8),
      Color(0x007B68EE),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================
  // ERA GRADIENTS - 시대별 그라데이션
  // ============================================
  
  /// 고대/선사시대
  static const LinearGradient eraAncient = LinearGradient(
    colors: [
      Color(0xFFCD853F),
      Color(0xFF8B4513),
    ],
  );
  
  /// 삼국시대
  static const LinearGradient eraThreeKingdoms = LinearGradient(
    colors: [
      Color(0xFF6495ED),
      Color(0xFF4169E1),
    ],
  );
  
  /// 고려시대
  static const LinearGradient eraGoryeo = LinearGradient(
    colors: [
      Color(0xFF3CB371),
      Color(0xFF2E8B57),
    ],
  );
  
  /// 조선시대
  static const LinearGradient eraJoseon = LinearGradient(
    colors: [
      Color(0xFF00CED1),
      Color(0xFF00A36C),
    ],
  );
  
  /// 근현대
  static const LinearGradient eraModern = LinearGradient(
    colors: [
      Color(0xFF778899),
      Color(0xFF708090),
    ],
  );

  // ============================================
  // TEXT GRADIENTS - 텍스트용 그라데이션
  // ============================================
  
  /// 황금 텍스트
  static const LinearGradient goldenText = LinearGradient(
    colors: [
      Color(0xFFF2D272),
      AppColors.primary,
    ],
  );
  
  /// 시간 텍스트
  static const LinearGradient temporalText = LinearGradient(
    colors: [
      AppColors.secondaryLight,
      AppColors.secondary,
    ],
  );

  // ============================================
  // OVERLAY GRADIENTS - 오버레이용
  // ============================================
  
  /// 상단에서 어두워지는 오버레이
  static const LinearGradient fadeTop = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D0D1A),
      Color(0x000D0D1A),
    ],
  );
  
  /// 하단에서 어두워지는 오버레이
  static const LinearGradient fadeBottom = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x000D0D1A),
      Color(0xFF0D0D1A),
    ],
  );
  
  /// 비네트 효과
  static const RadialGradient vignette = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [
      Color(0x00000000),
      Color(0x80000000),
    ],
    stops: [0.5, 1.0],
  );
}
