import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/utils/screen_bgm_config.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';

/// GoRouter 네비게이션 이벤트를 감지하여 BGM을 자동으로 관리하는 옵저버
/// 
/// 사용법:
/// ```dart
/// GoRouter(
///   observers: [BgmNavigatorObserver(ref)],
///   ...
/// )
/// ```
class BgmNavigatorObserver extends NavigatorObserver {
  final Ref _ref;
  String? _currentRoute;
  
  BgmNavigatorObserver(this._ref);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _handleRouteChange(
      fromRoute: previousRoute?.settings.name,
      toRoute: route.settings.name,
      eventType: 'push',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _handleRouteChange(
      fromRoute: route.settings.name,
      toRoute: previousRoute?.settings.name,
      eventType: 'pop',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _handleRouteChange(
      fromRoute: oldRoute?.settings.name,
      toRoute: newRoute?.settings.name,
      eventType: 'replace',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _handleRouteChange(
      fromRoute: route.settings.name,
      toRoute: previousRoute?.settings.name,
      eventType: 'remove',
    );
  }

  void _handleRouteChange({
    required String? fromRoute,
    required String? toRoute,
    required String eventType,
  }) {
    if (toRoute == null) return;
    
    // 동일한 라우트로의 변경은 무시
    if (_currentRoute == toRoute) return;
    
    debugPrint('[BgmNavigatorObserver] $eventType: $fromRoute -> $toRoute');
    
    final currentBgm = _ref.read(currentBgmTrackProvider);
    final transition = BgmTransition.fromRouteChange(fromRoute, toRoute, currentBgm);
    
    _applyTransition(transition);
    _currentRoute = toRoute;
  }

  void _applyTransition(BgmTransition transition) {
    switch (transition.type) {
      case BgmTransitionType.noChange:
        // BGM 변경 없음
        break;
        
      case BgmTransitionType.immediate:
        if (transition.targetTrack != null) {
          _playBgm(transition.targetTrack!);
        }
        break;
        
      case BgmTransitionType.crossfade:
        if (transition.targetTrack != null) {
          // 크로스페이드는 현재 간단히 즉시 전환으로 처리
          // 향후 AudioService에 fadeOut/fadeIn 기능 추가 시 개선 가능
          _playBgm(transition.targetTrack!);
        }
        break;
        
      case BgmTransitionType.stop:
        _ref.read(bgmControllerProvider.notifier).stopBgm();
        break;
        
      case BgmTransitionType.pause:
        _ref.read(bgmControllerProvider.notifier).pauseBgm();
        break;
    }
  }

  void _playBgm(String trackName) {
    final controller = _ref.read(bgmControllerProvider.notifier);
    
    // 트랙 이름에 따라 적절한 메서드 호출
    if (trackName.contains('main_menu')) {
      controller.playMainMenuBgm();
    } else if (trackName.contains('world_map')) {
      controller.playWorldMapBgm();
    } else if (trackName.contains('dialogue')) {
      controller.playDialogueBgm();
    } else if (trackName.contains('quiz')) {
      controller.playQuizBgm();
    } else if (trackName.contains('encyclopedia')) {
      controller.playEncyclopediaBgm();
    } else if (trackName.contains('era_')) {
      // 시대별 BGM - eraId 추출 필요
      final eraIdMatch = RegExp(r'era_(\w+)').firstMatch(trackName);
      if (eraIdMatch != null) {
        controller.playEraBgm(eraIdMatch.group(1)!);
      }
    } else {
      debugPrint('[BgmNavigatorObserver] Unknown BGM track: $trackName');
    }
  }
}

/// NavigatorObserver를 위한 Provider
/// 
/// GoRouter 설정에서 사용:
/// ```dart
/// final router = GoRouter(
///   observers: [ref.read(bgmNavigatorObserverProvider)],
///   ...
/// );
/// ```
final bgmNavigatorObserverProvider = Provider<BgmNavigatorObserver>((ref) {
  return BgmNavigatorObserver(ref);
});
