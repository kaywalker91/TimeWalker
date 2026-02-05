import 'package:flutter/material.dart';
import 'app_colors.dart';

/// TimeWalker 앱 그림자 시스템
/// 
/// 고대 유물의 신비로운 발광 효과와 깊이감을 표현하는 그림자 모음
abstract class AppShadows {
  // ============================================
  // ELEVATION SHADOWS - 기본 고도 그림자
  // ============================================
  
  /// 없음 (Elevation 0)
  static const List<BoxShadow> none = [];
  
  /// 낮은 고도 (Elevation 1)
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  /// 중간 고도 (Elevation 2)
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x60000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  /// 높은 고도 (Elevation 3)
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x80000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  
  /// 매우 높은 고도 (Elevation 4)
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x80000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  // ============================================
  // GOLDEN GLOW SHADOWS - 황금빛 발광
  // ============================================
  
  /// 황금 글로우 (약하게)
  static List<BoxShadow> goldenGlowSm = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.3),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  /// 황금 글로우 (보통)
  static List<BoxShadow> goldenGlowMd = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.4),
      blurRadius: 16,
      spreadRadius: 2,
    ),
  ];
  
  /// 황금 글로우 (강하게)
  static List<BoxShadow> goldenGlowLg = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.5),
      blurRadius: 24,
      spreadRadius: 4,
    ),
  ];
  
  /// 황금 글로우 (매우 강하게) - 주요 CTA용
  static List<BoxShadow> goldenGlowXl = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.6),
      blurRadius: 32,
      spreadRadius: 6,
    ),
  ];

  // ============================================
  // PORTAL GLOW SHADOWS - 포탈 발광 (보라빛)
  // ============================================
  
  /// 포탈 글로우 (약하게)
  static List<BoxShadow> portalGlowSm = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.3),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  /// 포탈 글로우 (보통)
  static List<BoxShadow> portalGlowMd = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.4),
      blurRadius: 16,
      spreadRadius: 2,
    ),
  ];
  
  /// 포탈 글로우 (강하게)
  static List<BoxShadow> portalGlowLg = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.5),
      blurRadius: 24,
      spreadRadius: 4,
    ),
  ];

  // ============================================
  // CARD SHADOWS - 카드용 그림자
  // ============================================
  
  /// 기본 카드 그림자
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  
  /// 호버/선택된 카드
  static List<BoxShadow> cardHover = [
    BoxShadow(
      color: const Color(0x60000000),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.2),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
  
  /// 강조 카드 (골드 테두리 효과)
  static List<BoxShadow> cardHighlight = [
    BoxShadow(
      color: const Color(0x60000000),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.3),
      blurRadius: 16,
      spreadRadius: 2,
    ),
  ];

  // ============================================
  // BUTTON SHADOWS - 버튼용 그림자
  // ============================================
  
  /// Primary 버튼 그림자
  static List<BoxShadow> buttonPrimary = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.4),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  /// Primary 버튼 프레스 상태
  static List<BoxShadow> buttonPrimaryPressed = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.2),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
  
  /// Secondary 버튼 그림자
  static List<BoxShadow> buttonSecondary = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ============================================
  // TEXT SHADOWS - 텍스트용 그림자
  // ============================================
  
  /// 기본 텍스트 그림자
  static const List<Shadow> textSm = [
    Shadow(
      color: Color(0x80000000),
      blurRadius: 4,
      offset: Offset(1, 1),
    ),
  ];
  
  /// 강조 텍스트 그림자
  static const List<Shadow> textMd = [
    Shadow(
      color: Color(0xA0000000),
      blurRadius: 8,
      offset: Offset(2, 2),
    ),
  ];
  
  /// 헤드라인 텍스트 그림자
  static const List<Shadow> textLg = [
    Shadow(
      color: Color(0xC0000000),
      blurRadius: 12,
      offset: Offset(3, 3),
    ),
  ];
  
  /// 황금 발광 텍스트 그림자
  static List<Shadow> textGoldenGlow = [
    Shadow(
      color: AppColors.primary.withValues(alpha: 0.5),
      blurRadius: 8,
    ),
    const Shadow(
      color: Color(0x80000000),
      blurRadius: 4,
      offset: Offset(1, 1),
    ),
  ];

  // ============================================
  // INNER SHADOWS - 내부 그림자 (인셋)
  // ============================================
  
  /// 내부 그림자 (입력 필드용)
  static const List<BoxShadow> innerSm = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      blurStyle: BlurStyle.inner,
    ),
  ];
  
  /// 깊은 내부 그림자 (버튼 프레스용)
  static const List<BoxShadow> innerMd = [
    BoxShadow(
      color: Color(0x60000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      blurStyle: BlurStyle.inner,
    ),
  ];

  // ============================================
  // SPECIAL SHADOWS - 특수 효과
  // ============================================
  
  /// 시간 포탈 원형 그림자
  static List<BoxShadow> portalRing = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: AppColors.secondaryDark.withValues(alpha: 0.5),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];
  
  /// 고대 유물 발광
  static List<BoxShadow> ancientArtifact = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.primaryLight.withValues(alpha: 0.2),
      blurRadius: 40,
      spreadRadius: 4,
    ),
  ];
  
  /// 잠긴 아이템 그림자
  static const List<BoxShadow> locked = [
    BoxShadow(
      color: Color(0x80000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // ============================================
  // DIALOGUE SCREEN SHADOWS - 대화 화면용 그림자
  // ============================================
  
  /// 대화 화면 캐릭터 글로우
  /// 
  /// 캐릭터 초상화에 드롭 섀도우와 골든 글로우를 적용하여
  /// 배경과 분리되도록 깊이감을 추가합니다.
  static List<BoxShadow> dialogueCharacterGlow = [
    BoxShadow(
      color: const Color(0x66000000), // 40% 불투명도 검정
      blurRadius: 30,
      spreadRadius: 10,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: AppColors.goldenGlow.withValues(alpha: 0.15),
      blurRadius: 50,
      spreadRadius: 5,
    ),
  ];
}
