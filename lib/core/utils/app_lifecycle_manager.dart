import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';

/// 앱 라이프사이클 관리 위젯
/// 
/// 앱이 백그라운드로 전환될 때 BGM을 일시정지하고,
/// 포그라운드로 돌아오면 BGM을 재개합니다.
/// 
/// 사용 방법:
/// ```dart
/// AppLifecycleManager(
///   child: MaterialApp(...),
/// )
/// ```
class AppLifecycleManager extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleManager({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends ConsumerState<AppLifecycleManager>
    with WidgetsBindingObserver {
  
  /// BGM이 일시정지되기 전 재생 중이었는지 추적
  bool _wasPlayingBeforePause = false;
  
  /// 현재 앱 상태
  AppLifecycleState? _currentState;

  @override
  void initState() {
    super.initState();
    // 라이프사이클 옵저버 등록
    WidgetsBinding.instance.addObserver(this);
    debugPrint('[AppLifecycleManager] Initialized');
  }

  @override
  void dispose() {
    // 라이프사이클 옵저버 해제
    WidgetsBinding.instance.removeObserver(this);
    debugPrint('[AppLifecycleManager] Disposed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // 이전 상태와 동일하면 무시
    if (_currentState == state) return;
    
    _currentState = state;
    debugPrint('[AppLifecycleManager] App state changed to: $state');

    switch (state) {
      case AppLifecycleState.paused:
        // 앱이 백그라운드로 전환됨
        _onAppPaused();
        break;
        
      case AppLifecycleState.resumed:
        // 앱이 포그라운드로 복귀함
        _onAppResumed();
        break;
        
      case AppLifecycleState.inactive:
        // 앱이 비활성 상태 (전화 수신 등)
        // 이 상태에서는 아직 BGM을 중지하지 않음
        debugPrint('[AppLifecycleManager] App inactive');
        break;
        
      case AppLifecycleState.detached:
        // 앱이 시스템에서 분리됨
        _onAppDetached();
        break;
        
      case AppLifecycleState.hidden:
        // 앱이 숨겨진 상태 (일부 플랫폼에서만 발생)
        debugPrint('[AppLifecycleManager] App hidden');
        break;
    }
  }

  /// 앱이 백그라운드로 전환될 때 호출
  void _onAppPaused() {
    debugPrint('[AppLifecycleManager] App paused - checking BGM status');
    
    try {
      final audioService = ref.read(audioServiceProvider);
      
      // 현재 BGM이 재생 중인지 확인
      _wasPlayingBeforePause = audioService.isBgmPlaying;
      
      if (_wasPlayingBeforePause) {
        // BGM 일시정지
        audioService.pauseBgm();
        debugPrint('[AppLifecycleManager] BGM paused (was playing)');
      } else {
        debugPrint('[AppLifecycleManager] BGM was not playing');
      }
    } catch (e) {
      debugPrint('[AppLifecycleManager] Error pausing BGM: $e');
    }
  }

  /// 앱이 포그라운드로 복귀할 때 호출
  void _onAppResumed() {
    debugPrint('[AppLifecycleManager] App resumed - checking BGM status');
    
    try {
      final audioService = ref.read(audioServiceProvider);
      
      // 이전에 재생 중이었다면 재개
      if (_wasPlayingBeforePause) {
        audioService.resumeBgm();
        debugPrint('[AppLifecycleManager] BGM resumed');
      } else {
        debugPrint('[AppLifecycleManager] BGM was not playing before pause');
      }
      
      // 플래그 초기화
      _wasPlayingBeforePause = false;
    } catch (e) {
      debugPrint('[AppLifecycleManager] Error resuming BGM: $e');
    }
  }

  /// 앱이 시스템에서 분리될 때 호출
  void _onAppDetached() {
    debugPrint('[AppLifecycleManager] App detached - stopping BGM');
    
    try {
      final audioService = ref.read(audioServiceProvider);
      audioService.stopBgm(fadeOut: false);
    } catch (e) {
      debugPrint('[AppLifecycleManager] Error stopping BGM: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// 앱 라이프사이클 상태를 추적하는 Provider
/// 
/// 다른 위젯에서 앱 상태를 확인하고 싶을 때 사용
final appLifecycleStateProvider = StateProvider<AppLifecycleState?>((ref) => null);

/// 앱 라이프사이클 관리 믹스인
/// 
/// StatefulWidget에서 직접 사용하고 싶을 때 이 믹스인을 사용
/// 
/// 사용 방법:
/// ```dart
/// class MyWidgetState extends State<MyWidget> with AppLifecycleMixin {
///   @override
///   void onAppPaused() {
///     // 백그라운드로 전환될 때 처리
///   }
///   
///   @override
///   void onAppResumed() {
///     // 포그라운드로 복귀할 때 처리
///   }
/// }
/// ```
mixin AppLifecycleMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  
  AppLifecycleState? _lifecycleState;
  
  AppLifecycleState? get lifecycleState => _lifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
    
    switch (state) {
      case AppLifecycleState.paused:
        onAppPaused();
        break;
      case AppLifecycleState.resumed:
        onAppResumed();
        break;
      case AppLifecycleState.inactive:
        onAppInactive();
        break;
      case AppLifecycleState.detached:
        onAppDetached();
        break;
      case AppLifecycleState.hidden:
        onAppHidden();
        break;
    }
  }

  /// 앱이 백그라운드로 전환될 때 호출
  void onAppPaused() {}

  /// 앱이 포그라운드로 복귀할 때 호출
  void onAppResumed() {}

  /// 앱이 비활성 상태일 때 호출
  void onAppInactive() {}

  /// 앱이 시스템에서 분리될 때 호출
  void onAppDetached() {}

  /// 앱이 숨겨진 상태일 때 호출
  void onAppHidden() {}

  // WidgetsBindingObserver 기본 구현
  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() => Future.value(false);

  @override
  Future<bool> didPushRoute(String route) => Future.value(false);

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      Future.value(false);
}
