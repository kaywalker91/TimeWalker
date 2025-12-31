import 'package:flutter/material.dart';
import 'app_colors.dart';

/// TimeWalker 앱 타이포그래피 시스템
/// 
/// 고풍스러운 역사 탐험 느낌을 주는 텍스트 스타일 정의
abstract class AppTextStyles {
  // ============================================
  // FONT FAMILIES - 폰트 패밀리
  // ============================================
  
  /// 기본 폰트 (본문, UI)
  static const String fontFamily = 'NotoSansKR';
  
  /// 제목용 폰트 (추후 커스텀 폰트 적용 예정)
  static const String fontFamilyDisplay = 'NotoSansKR';

  // ============================================
  // DISPLAY STYLES - 대형 제목
  // ============================================
  
  /// Display Large - 앱 타이틀, 스플래시
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    letterSpacing: 3,
    fontFamily: fontFamilyDisplay,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Display Medium - 주요 화면 타이틀
  static const TextStyle displayMedium = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    fontFamily: fontFamilyDisplay,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  /// Display Small - 섹션 타이틀
  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
    fontFamily: fontFamilyDisplay,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ============================================
  // HEADLINE STYLES - 헤드라인
  // ============================================
  
  /// Headline Large - 화면 헤더
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28, 
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  /// Headline Medium - 서브 헤더
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24, 
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  /// Headline Small - 카드 제목
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ============================================
  // TITLE STYLES - 타이틀
  // ============================================
  
  /// Title Large - 주요 타이틀
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  /// Title Medium - 일반 타이틀
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
    height: 1.4,
  );
  
  /// Title Small - 작은 타이틀
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14, 
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // ============================================
  // BODY STYLES - 본문
  // ============================================
  
  /// Body Large - 주요 본문
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.6,
  );
  
  /// Body Medium - 일반 본문
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.6,
  );
  
  /// Body Small - 작은 본문
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ============================================
  // LABEL STYLES - 라벨
  // ============================================
  
  /// Label Large - 버튼 텍스트
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
    height: 1.4,
  );
  
  /// Label Medium - 칩, 태그
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.3,
  );
  
  /// Label Small - 캡션
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.3,
  );

  // ============================================
  // SPECIAL STYLES - 특수 스타일
  // ============================================
  
  /// 대화 텍스트 - 역사 인물 대사
  static const TextStyle dialogue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.7,
    letterSpacing: 0.3,
  );
  
  /// 화자 이름
  static const TextStyle speakerName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );
  
  /// 선택지 텍스트
  static const TextStyle choice = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  /// 시대 기간 (연도)
  static const TextStyle period = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.primary,
    letterSpacing: 1.0,
  );
  
  /// 도감 설명
  static const TextStyle encyclopediaDescription = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    color: AppColors.textSecondary,
    height: 1.7,
  );
  
  /// 퀴즈 질문
  static const TextStyle quizQuestion = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  /// 골드 강조 텍스트
  static const TextStyle goldAccent = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    color: AppColors.primary,
  );
  
  /// 잠긴 콘텐츠
  static const TextStyle locked = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: AppColors.textDisabled,
  );
  
  /// 힌트/설명
  static const TextStyle hint = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    color: AppColors.textHint,
    fontStyle: FontStyle.italic,
  );
  
  /// 버튼 텍스트 (대형)
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: 1.5,
  );
  
  /// 버튼 텍스트 (기본)
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: 1.0,
  );
  
  /// 뱃지/태그
  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );
  
  /// 숫자 (포인트, 점수)
  static const TextStyle number = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    color: AppColors.primary,
    letterSpacing: 1.0,
  );
  
  /// 큰 숫자 (통계)
  static const TextStyle numberLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    color: AppColors.primary,
    letterSpacing: 2.0,
  );
}
