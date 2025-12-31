import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';

/// 화면별 BGM 자동 관리를 위한 믹스인
/// 
/// 사용법:
/// ```dart
/// class _MyScreenState extends ConsumerState<MyScreen> 
///     with BgmScreenMixin {
///   @override
///   String? get bgmTrack => AudioConstants.bgmMainMenu;
/// }
/// ```
mixin BgmScreenMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// 이 화면에서 재생할 BGM 트랙 이름
  /// null을 반환하면 BGM 변경 없음
  String? get bgmTrack => null;
  
  /// 화면 진입 시 BGM을 자동으로 시작할지 여부
  bool get autoStartBgm => true;
  
  /// 화면에서 나갈 때 BGM을 정지할지 여부
  bool get stopBgmOnDispose => false;
  
  @override
  void initState() {
    super.initState();
    if (autoStartBgm && bgmTrack != null) {
      _setupBgm();
    }
  }
  
  @override
  void dispose() {
    if (stopBgmOnDispose) {
      _stopBgm();
    }
    debugPrint('[BgmScreenMixin] ${T.toString()} disposed');
    super.dispose();
  }
  
  /// BGM 설정 (initState 후 첫 프레임에서 실행)
  void _setupBgm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final currentTrack = ref.read(currentBgmTrackProvider);
      if (currentTrack != bgmTrack) {
        _playBgm();
      }
    });
  }
  
  /// BGM 재생
  void _playBgm() {
    final track = bgmTrack;
    if (track == null) return;
    
    final controller = ref.read(bgmControllerProvider.notifier);
    
    // 트랙 이름에 따라 적절한 메서드 호출
    switch (track) {
      case AudioConstants.bgmMainMenu:
        controller.playMainMenuBgm();
        break;
      case AudioConstants.bgmWorldMap:
        controller.playWorldMapBgm();
        break;
      case AudioConstants.bgmDialogue:
        controller.playDialogueBgm();
        break;
      case AudioConstants.bgmQuiz:
        controller.playQuizBgm();
        break;
      case AudioConstants.bgmEncyclopedia:
        controller.playEncyclopediaBgm();
        break;
      default:
        // 시대별 BGM 등 커스텀 트랙은 직접 playEraBgm 호출 필요
        debugPrint('[BgmScreenMixin] Unknown track: $track - manual handling required');
    }
  }
  
  /// BGM 정지
  void _stopBgm() {
    if (!mounted) return;
    ref.read(bgmControllerProvider.notifier).stopBgm();
  }
  
  /// 수동으로 BGM 재생 (특정 시점에 BGM을 변경하고 싶을 때)
  void playScreenBgm() {
    _playBgm();
  }
  
  /// 시대별 BGM 재생 (EraExplorationScreen 등에서 사용)
  void playEraBgm(String eraId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final currentTrack = ref.read(currentBgmTrackProvider);
      final eraBgm = AudioConstants.getBGMForEra(eraId);
      
      if (currentTrack != eraBgm) {
        ref.read(bgmControllerProvider.notifier).playEraBgm(eraId);
      }
    });
  }
}

/// StatefulWidget용 라이프사이클 로깅 믹스인
/// 
/// 디버깅 시 화면 생성/소멸 추적에 사용
mixin LifecycleLoggingMixin<T extends StatefulWidget> on State<T> {
  String get screenName => T.toString();
  
  @override
  void initState() {
    super.initState();
    debugPrint('[Lifecycle] $screenName initState');
  }
  
  @override
  void dispose() {
    debugPrint('[Lifecycle] $screenName dispose');
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('[Lifecycle] $screenName didChangeDependencies');
  }
  
  @override
  void deactivate() {
    debugPrint('[Lifecycle] $screenName deactivate');
    super.deactivate();
  }
}

/// ConsumerStatefulWidget용 라이프사이클 로깅 믹스인
mixin ConsumerLifecycleLoggingMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  String get screenName => T.toString();
  
  @override
  void initState() {
    super.initState();
    debugPrint('[Lifecycle] $screenName initState');
  }
  
  @override
  void dispose() {
    debugPrint('[Lifecycle] $screenName dispose');
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('[Lifecycle] $screenName didChangeDependencies');
  }
  
  @override
  void deactivate() {
    debugPrint('[Lifecycle] $screenName deactivate');
    super.deactivate();
  }
}
