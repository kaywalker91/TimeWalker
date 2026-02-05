import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_gradients.dart';
import 'app_shadows.dart';

/// TimeWalker 앱 공통 데코레이션 시스템
/// 
/// 카드, 버튼, 컨테이너 등에서 재사용할 수 있는 BoxDecoration 모음
abstract class AppDecorations {
  // ============================================
  // CARD DECORATIONS - 카드 데코레이션
  // ============================================
  
  /// 기본 카드
  static BoxDecoration card = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
    boxShadow: AppShadows.card,
  );
  
  /// 강조 카드 (골드 테두리)
  static BoxDecoration cardHighlight = BoxDecoration(
    gradient: AppGradients.card,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.primary.withValues(alpha: 0.5),
      width: 2,
    ),
    boxShadow: AppShadows.cardHighlight,
  );
  
  /// 선택된 카드
  static BoxDecoration cardSelected = BoxDecoration(
    gradient: AppGradients.cardHighlight,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.primary,
      width: 2,
    ),
    boxShadow: AppShadows.goldenGlowMd,
  );
  
  /// 잠긴 카드
  static BoxDecoration cardLocked = BoxDecoration(
    gradient: AppGradients.cardLocked,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.border.withValues(alpha: 0.3),
      width: 1,
    ),
    boxShadow: AppShadows.locked,
  );
  
  /// 부드러운 카드 (그라데이션 배경)
  static BoxDecoration cardSoft = BoxDecoration(
    gradient: AppGradients.card,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: AppColors.border.withValues(alpha: 0.5),
      width: 1,
    ),
  );

  // ============================================
  // BUTTON DECORATIONS - 버튼 데코레이션
  // ============================================
  
  /// Primary 버튼 (골드)
  static BoxDecoration buttonPrimary = BoxDecoration(
    gradient: AppGradients.goldenButton,
    borderRadius: BorderRadius.circular(12),
    boxShadow: AppShadows.buttonPrimary,
  );
  
  /// Primary 버튼 (프레스)
  static BoxDecoration buttonPrimaryPressed = BoxDecoration(
    gradient: AppGradients.goldenButtonPressed,
    borderRadius: BorderRadius.circular(12),
    boxShadow: AppShadows.buttonPrimaryPressed,
  );
  
  /// Secondary 버튼 (포탈)
  static BoxDecoration buttonSecondary = BoxDecoration(
    gradient: AppGradients.portalButton,
    borderRadius: BorderRadius.circular(12),
    boxShadow: AppShadows.buttonSecondary,
  );
  
  /// Outline 버튼
  static BoxDecoration buttonOutline = BoxDecoration(
    color: AppColors.transparent,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.primary.withValues(alpha: 0.6),
      width: 2,
    ),
  );
  
  /// Ghost 버튼 (투명)
  static BoxDecoration buttonGhost = BoxDecoration(
    color: AppColors.surface.withValues(alpha: 0.3),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
  );
  
  /// Disabled 버튼
  static BoxDecoration buttonDisabled = BoxDecoration(
    gradient: AppGradients.disabledButton,
    borderRadius: BorderRadius.circular(12),
  );

  // ============================================
  // CONTAINER DECORATIONS - 컨테이너 데코레이션
  // ============================================
  
  /// 기본 컨테이너
  static BoxDecoration container = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.border.withValues(alpha: 0.5),
      width: 1,
    ),
  );
  
  /// 강조 컨테이너 (골드)
  static BoxDecoration containerHighlight = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.borderAccent,
      width: 1.5,
    ),
    boxShadow: AppShadows.goldenGlowSm,
  );
  
  /// 다이얼로그 컨테이너
  static BoxDecoration dialog = BoxDecoration(
    gradient: AppGradients.card,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
    boxShadow: AppShadows.xl,
  );
  
  /// 바텀시트 컨테이너
  static BoxDecoration bottomSheet = BoxDecoration(
    color: AppColors.surface,
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(24),
    ),
    border: const Border(
      top: BorderSide(color: AppColors.border, width: 1),
    ),
  );

  // ============================================
  // PANEL DECORATIONS - 패널 데코레이션
  // ============================================
  
  /// 상태 패널 (HUD)
  static BoxDecoration statusPanel = BoxDecoration(
    color: AppColors.background.withValues(alpha: 0.85),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.primary.withValues(alpha: 0.3),
      width: 1,
    ),
    boxShadow: AppShadows.md,
  );
  
  /// 정보 패널
  static BoxDecoration infoPanel = BoxDecoration(
    color: AppColors.surface.withValues(alpha: 0.9),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.info.withValues(alpha: 0.3),
      width: 1,
    ),
  );
  
  /// 경고 패널
  static BoxDecoration warningPanel = BoxDecoration(
    color: AppColors.warning.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.warning.withValues(alpha: 0.3),
      width: 1,
    ),
  );
  
  /// 성공 패널
  static BoxDecoration successPanel = BoxDecoration(
    color: AppColors.success.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.success.withValues(alpha: 0.3),
      width: 1,
    ),
  );
  
  /// 오류 패널
  static BoxDecoration errorPanel = BoxDecoration(
    color: AppColors.error.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.error.withValues(alpha: 0.3),
      width: 1,
    ),
  );

  // ============================================
  // INPUT DECORATIONS - 입력 필드 데코레이션
  // ============================================
  
  /// 기본 입력 필드
  static BoxDecoration input = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
  );
  
  /// 포커스된 입력 필드
  static BoxDecoration inputFocused = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.primary,
      width: 2,
    ),
    boxShadow: AppShadows.goldenGlowSm,
  );
  
  /// 오류 입력 필드
  static BoxDecoration inputError = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.error,
      width: 2,
    ),
  );

  // ============================================
  // CHIP DECORATIONS - 칩 데코레이션
  // ============================================
  
  /// 기본 칩
  static BoxDecoration chip = BoxDecoration(
    color: AppColors.surfaceLight,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
  );
  
  /// 선택된 칩
  static BoxDecoration chipSelected = BoxDecoration(
    color: AppColors.primary.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: AppColors.primary,
      width: 2,
    ),
  );

  // ============================================
  // SPECIAL DECORATIONS - 특수 효과
  // ============================================
  
  /// 시간 포탈 링
  static BoxDecoration portalRing = BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      colors: [
        AppColors.secondary.withValues(alpha: 0.0),
        AppColors.secondary.withValues(alpha: 0.3),
        AppColors.secondaryDark.withValues(alpha: 0.5),
      ],
      stops: const [0.0, 0.7, 1.0],
    ),
    boxShadow: AppShadows.portalRing,
  );
  
  /// 황금 원형 배지
  static BoxDecoration goldenBadge = BoxDecoration(
    shape: BoxShape.circle,
    gradient: AppGradients.goldenButton,
    boxShadow: AppShadows.goldenGlowMd,
  );
  
  /// 대화창 배경
  static BoxDecoration dialogueBox = BoxDecoration(
    color: AppColors.background.withValues(alpha: 0.95),
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(24),
    ),
    border: const Border(
      top: BorderSide(
        color: AppColors.border,
        width: 1,
      ),
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0x80000000),
        blurRadius: 20,
        offset: Offset(0, -10),
      ),
    ],
  );
  
  /// 프로그레스 바 배경
  static BoxDecoration progressBackground = BoxDecoration(
    color: AppColors.surfaceLight,
    borderRadius: BorderRadius.circular(8),
  );
  
  /// 프로그레스 바 전경
  static BoxDecoration progressForeground = BoxDecoration(
    gradient: AppGradients.goldenButton,
    borderRadius: BorderRadius.circular(8),
    boxShadow: AppShadows.goldenGlowSm,
  );

  // ============================================
  // ERA DECORATIONS - 시대별 테마 데코레이션
  // ============================================
  
  /// 시대별 카드 데코레이션 생성
  static BoxDecoration eraCard(Color eraColor) {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: eraColor,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: eraColor.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
  
  /// 잠긴 시대 카드
  static BoxDecoration eraCardLocked = BoxDecoration(
    color: AppColors.surface.withValues(alpha: 0.3),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: AppColors.border.withValues(alpha: 0.3),
      width: 2,
    ),
  );
}
