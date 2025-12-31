import 'package:flutter/material.dart';

/// TimeWalker 애니메이션 상수
/// 
/// 일관된 애니메이션 타이밍과 커브를 정의
abstract class AppAnimations {
  // ============================================
  // DURATIONS - 애니메이션 지속 시간
  // ============================================
  
  /// 매우 빠른 (버튼 프레스)
  static const Duration fastest = Duration(milliseconds: 100);
  
  /// 빠른 (호버, 토글)
  static const Duration fast = Duration(milliseconds: 150);
  
  /// 보통 (페이드, 스케일)
  static const Duration normal = Duration(milliseconds: 250);
  
  /// 느린 (화면 전환)
  static const Duration slow = Duration(milliseconds: 400);
  
  /// 매우 느린 (복잡한 애니메이션)
  static const Duration slower = Duration(milliseconds: 600);
  
  /// 가장 느린 (스플래시, 특수 효과)
  static const Duration slowest = Duration(milliseconds: 1000);

  // ============================================
  // CURVES - 애니메이션 커브
  // ============================================
  
  /// 기본 부드러운 커브
  static const Curve defaultCurve = Curves.easeInOut;
  
  /// 부드러운 감속 (등장)
  static const Curve decelerate = Curves.decelerate;
  
  /// 부드러운 가속 (사라짐)
  static const Curve accelerate = Curves.easeIn;
  
  /// 탄성 있는 등장
  static const Curve bouncy = Curves.elasticOut;
  
  /// 오버슈트 후 정착
  static const Curve overshoot = Curves.easeOutBack;
  
  /// 시간 포탈 효과용
  static const Curve portal = Curves.easeInOutCubic;
  
  /// 부드러운 스프링
  static const Curve spring = Curves.easeOutQuint;

  // ============================================
  // DELAYS - 스태거 딜레이
  // ============================================
  
  /// 아이템 간 딜레이 (리스트 애니메이션)
  static const Duration staggerDelay = Duration(milliseconds: 50);
  
  /// 섹션 간 딜레이
  static const Duration sectionDelay = Duration(milliseconds: 150);
}
