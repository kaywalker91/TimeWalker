import 'package:time_walker/core/constants/audio_constants.dart';

/// 화면 라우트에 따른 BGM 설정을 관리하는 유틸리티 클래스
/// 
/// 라우터 수준에서 BGM 전환을 자동으로 처리하기 위해 사용됩니다.
class ScreenBgmConfig {
  ScreenBgmConfig._();

  /// 라우트 경로에 맞는 BGM 트랙 이름을 반환합니다.
  /// 
  /// Returns:
  /// - BGM 트랙 이름 (예: 'bgm_main_menu')
  /// - null: BGM 변경 없음 (현재 트랙 유지)
  /// - empty string: BGM 정지
  static String? getBgmForRoute(String routePath) {
    // 정확한 경로 매칭
    switch (routePath) {
      case '/':
        return null; // 스플래시 - BGM 없음
      case '/main-menu':
        return AudioConstants.bgmMainMenu;
      case '/world-map':
        return AudioConstants.bgmWorldMap;
      case '/encyclopedia':
        return AudioConstants.bgmEncyclopedia;
      case '/quiz':
        return AudioConstants.bgmQuiz;
      case '/settings':
      case '/profile':
      case '/shop':
      case '/inventory':
      case '/achievements':
        return null; // 이전 BGM 유지
    }

    // 패턴 매칭 (동적 라우트)
    if (routePath.contains('/dialogue/')) {
      return AudioConstants.bgmDialogue;
    }
    
    if (routePath.contains('/quiz-play/')) {
      return AudioConstants.bgmQuiz;
    }
    
    // 시대 탐험 화면 - 시대별 BGM은 화면 내에서 처리
    if (routePath.contains('/era/')) {
      // 시대 ID 추출하여 해당 시대 BGM 반환
      final eraIdMatch = RegExp(r'/era/([^/]+)').firstMatch(routePath);
      if (eraIdMatch != null) {
        final eraId = eraIdMatch.group(1)!;
        return AudioConstants.getBGMForEra(eraId);
      }
    }
    
    // 기본값: BGM 변경 없음
    return null;
  }

  /// 특정 라우트가 BGM을 멈춰야 하는지 확인
  static bool shouldStopBgm(String routePath) {
    // 현재는 없음 - 필요시 추가
    return false;
  }

  /// 특정 라우트가 BGM을 일시정지해야 하는지 확인
  static bool shouldPauseBgm(String routePath) {
    // 다이얼로그나 인게임 특별 상황에서 사용 가능
    return false;
  }

  /// 화면 전환 시 페이드아웃/페이드인 효과가 필요한지 확인
  static bool shouldFadeBgm(String fromRoute, String toRoute) {
    final fromBgm = getBgmForRoute(fromRoute);
    final toBgm = getBgmForRoute(toRoute);
    
    // BGM이 변경될 때만 페이드 효과 적용
    return fromBgm != null && toBgm != null && fromBgm != toBgm;
  }

  /// 디버깅용: 라우트에 대한 BGM 정보 출력
  static String debugInfo(String routePath) {
    final bgm = getBgmForRoute(routePath);
    return '[ScreenBgmConfig] Route: $routePath -> BGM: ${bgm ?? "unchanged"}';
  }
}

/// 화면 전환 시 BGM 상태를 나타내는 열거형
enum BgmTransitionType {
  /// BGM 변경 없음
  noChange,
  /// 새로운 BGM으로 즉시 전환
  immediate,
  /// 페이드아웃 후 페이드인
  crossfade,
  /// BGM 정지
  stop,
  /// BGM 일시정지
  pause,
}

/// 화면 전환 정보를 담는 클래스
class BgmTransition {
  final BgmTransitionType type;
  final String? targetTrack;
  final Duration fadeDuration;

  const BgmTransition({
    required this.type,
    this.targetTrack,
    this.fadeDuration = const Duration(milliseconds: 500),
  });

  static BgmTransition noChange() => const BgmTransition(type: BgmTransitionType.noChange);
  
  static BgmTransition immediate(String track) => BgmTransition(
    type: BgmTransitionType.immediate,
    targetTrack: track,
  );
  
  static BgmTransition crossfade(String track, {Duration? duration}) => BgmTransition(
    type: BgmTransitionType.crossfade,
    targetTrack: track,
    fadeDuration: duration ?? const Duration(milliseconds: 500),
  );
  
  static BgmTransition stop() => const BgmTransition(type: BgmTransitionType.stop);
  
  static BgmTransition pause() => const BgmTransition(type: BgmTransitionType.pause);

  /// 화면 전환에 따른 BGM 전환 정보 계산
  static BgmTransition fromRouteChange(String? fromRoute, String toRoute, String? currentBgm) {
    final targetBgm = ScreenBgmConfig.getBgmForRoute(toRoute);
    
    // BGM 변경이 필요 없는 경우
    if (targetBgm == null || targetBgm == currentBgm) {
      return BgmTransition.noChange();
    }
    
    // 이전 라우트에서 BGM이 있었으면 크로스페이드
    if (fromRoute != null && ScreenBgmConfig.getBgmForRoute(fromRoute) != null) {
      return BgmTransition.crossfade(targetBgm);
    }
    
    // 없었으면 즉시 재생
    return BgmTransition.immediate(targetBgm);
  }
}
