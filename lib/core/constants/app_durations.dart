/// 앱 전역 Duration 상수
///
/// 애니메이션, 타이머, 네트워크, 디바운스 등 모든 Duration 상수를 정의합니다.
/// 기존 AppAnimations의 Duration 상수를 포함하고 확장합니다.
abstract class AppDurations {
  // ============================================
  // ANIMATION - UI 애니메이션 지속 시간
  // ============================================

  /// 매우 빠른 (버튼 프레스, 토글)
  static const Duration animFastest = Duration(milliseconds: 100);

  /// 빠른 (호버, 작은 변화)
  static const Duration animFast = Duration(milliseconds: 150);

  /// 카드 호버/선택
  static const Duration cardHover = Duration(milliseconds: 200);

  /// 보통 (페이드, 스케일)
  static const Duration animNormal = Duration(milliseconds: 250);

  /// 포커스 애니메이션
  static const Duration focusAnim = Duration(milliseconds: 280);

  /// 느린 (카드 확장, 패널 전환)
  static const Duration animSlow = Duration(milliseconds: 300);

  /// 페이지 전환
  static const Duration pageTransition = Duration(milliseconds: 400);

  /// 화면 전환 (리버스)
  static const Duration pageTransitionReverse = Duration(milliseconds: 300);

  /// 포탈/특수 전환
  static const Duration portalTransition = Duration(milliseconds: 500);

  /// 매우 느린 (복잡한 애니메이션)
  static const Duration animSlower = Duration(milliseconds: 600);

  /// 씬 전환
  static const Duration sceneTransition = Duration(milliseconds: 800);

  /// 가장 느린 (스플래시, 특수 효과)
  static const Duration animSlowest = Duration(milliseconds: 1000);

  // ============================================
  // PARTICLE/EFFECT - 파티클 및 특수 효과
  // ============================================

  /// 글로우 이펙트 사이클
  static const Duration glowCycle = Duration(seconds: 2);

  /// 파티클 애니메이션 (빠른)
  static const Duration particleFast = Duration(seconds: 4);

  /// 파티클 애니메이션 (느린)
  static const Duration particleSlow = Duration(seconds: 10);

  /// 배경 파티클 사이클
  static const Duration backgroundCycle = Duration(seconds: 60);

  /// 포탈 회전
  static const Duration portalRotation = Duration(seconds: 40);

  /// 펄스 효과
  static const Duration pulse = Duration(seconds: 3);

  /// 로딩 펄스
  static const Duration loadingPulse = Duration(milliseconds: 1500);

  // ============================================
  // STAGGER - 리스트/그리드 순차 애니메이션 딜레이
  // ============================================

  /// 아이템 간 딜레이 (기본)
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// 아이템 간 딜레이 (중간)
  static const Duration staggerMedium = Duration(milliseconds: 80);

  /// 섹션 간 딜레이
  static const Duration staggerSection = Duration(milliseconds: 100);

  /// 섹션 간 딜레이 (느림)
  static const Duration staggerSectionSlow = Duration(milliseconds: 150);

  // ============================================
  // TIMER - 게임 타이머
  // ============================================

  /// 퀴즈 타이머 틱
  static const Duration quizTimerTick = Duration(seconds: 1);

  /// 타임 프리즈 아이템 지속시간
  static const Duration timeFreezeItem = Duration(seconds: 10);

  /// 보상 알림 표시 시간
  static const Duration rewardDisplay = Duration(seconds: 2);

  /// 스플래시 최소 표시 시간
  static const Duration splashMinDisplay = Duration(milliseconds: 2500);

  // ============================================
  // TYPING - 대화 타이핑 효과
  // ============================================

  /// 대화 타이핑 속도
  static const Duration typingSpeed = Duration(milliseconds: 30);

  /// 커서 깜빡임 주기
  static const Duration cursorBlink = Duration(milliseconds: 500);

  // ============================================
  // NETWORK/API - 네트워크 관련
  // ============================================

  /// API 타임아웃
  static const Duration apiTimeout = Duration(seconds: 30);

  /// 네트워크 타임아웃 (일반)
  static const Duration networkTimeout = Duration(seconds: 10);

  // ============================================
  // DEBOUNCE - 디바운스/쓰로틀
  // ============================================

  /// 저장 디바운스
  static const Duration saveDebounce = Duration(milliseconds: 500);

  /// Mock 리포지토리 딜레이 (짧은)
  static const Duration mockDelayShort = Duration(milliseconds: 50);

  /// Mock 리포지토리 딜레이 (일반)
  static const Duration mockDelayNormal = Duration(milliseconds: 100);

  /// Mock 리포지토리 딜레이 (긴)
  static const Duration mockDelayLong = Duration(milliseconds: 300);

  // ============================================
  // AUDIO - 오디오 페이드
  // ============================================

  /// BGM 페이드인
  static const Duration bgmFadeIn = Duration(milliseconds: 500);

  /// BGM 페이드아웃
  static const Duration bgmFadeOut = Duration(milliseconds: 300);

  /// BGM 크로스페이드
  static const Duration bgmCrossFade = Duration(milliseconds: 800);
}
