import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/core/services/audio_service.dart';
import 'package:time_walker/presentation/providers/settings_provider.dart';

/// AudioService 싱글톤 인스턴스를 제공하는 Provider
final audioServiceProvider = Provider<AudioService>((ref) {
  final audioService = AudioService();
  
  // 초기화
  audioService.initialize();
  
  // 초기 설정 적용
  final settings = ref.read(settingsProvider);
  audioService.applySettings(settings);
  
  // 설정 변경 감지 및 자동 적용
  ref.listen(settingsProvider, (previous, next) {
    audioService.applySettings(next);
  });
  
  // Provider 해제 시 정리
  ref.onDispose(() {
    audioService.dispose();
  });
  
  return audioService;
});

/// 현재 재생 중인 BGM 트랙을 추적하는 StateProvider
final currentBgmTrackProvider = StateProvider<String?>((ref) => null);

/// BGM 재생 상태를 추적하는 StateProvider
final isBgmPlayingProvider = StateProvider<bool>((ref) => false);

/// BGM 컨트롤러 - 화면에서 BGM을 제어하기 위한 클래스
class BgmController extends StateNotifier<BgmState> {
  final AudioService _audioService;
  final Ref _ref;

  BgmController(this._audioService, this._ref) : super(const BgmState());

  /// 메인 메뉴 BGM 재생
  Future<void> playMainMenuBgm() async {
    await _playBgm(AudioConstants.bgmMainMenu);
  }

  /// 월드맵 BGM 재생
  Future<void> playWorldMapBgm() async {
    await _playBgm(AudioConstants.bgmWorldMap);
  }

  /// 시대별 BGM 재생
  Future<void> playEraBgm(String eraId) async {
    final trackName = AudioConstants.getBGMForEra(eraId);
    await _playBgm(trackName);
  }

  /// 대화 BGM 재생
  Future<void> playDialogueBgm() async {
    await _playBgm(AudioConstants.bgmDialogue);
  }

  /// 퀴즈 BGM 재생
  Future<void> playQuizBgm() async {
    await _playBgm(AudioConstants.bgmQuiz);
  }

  /// 도감 BGM 재생
  Future<void> playEncyclopediaBgm() async {
    await _playBgm(AudioConstants.bgmEncyclopedia);
  }

  /// BGM 재생 (내부 메서드)
  Future<void> _playBgm(String trackName) async {
    await _audioService.playBgm(trackName);
    state = state.copyWith(
      currentTrack: trackName,
      isPlaying: true,
    );
    _ref.read(currentBgmTrackProvider.notifier).state = trackName;
    _ref.read(isBgmPlayingProvider.notifier).state = true;
  }

  /// BGM 정지
  Future<void> stopBgm() async {
    await _audioService.stopBgm();
    state = state.copyWith(isPlaying: false);
    _ref.read(isBgmPlayingProvider.notifier).state = false;
  }

  /// BGM 일시정지
  void pauseBgm() {
    _audioService.pauseBgm();
    state = state.copyWith(isPlaying: false);
    _ref.read(isBgmPlayingProvider.notifier).state = false;
  }

  /// BGM 재개
  void resumeBgm() {
    _audioService.resumeBgm();
    state = state.copyWith(isPlaying: true);
    _ref.read(isBgmPlayingProvider.notifier).state = true;
  }

  /// BGM 토글
  void toggleBgm() {
    if (state.isPlaying) {
      pauseBgm();
    } else {
      resumeBgm();
    }
  }
}

/// BGM 상태
class BgmState {
  final String? currentTrack;
  final bool isPlaying;

  const BgmState({
    this.currentTrack,
    this.isPlaying = false,
  });

  BgmState copyWith({
    String? currentTrack,
    bool? isPlaying,
  }) {
    return BgmState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

/// BGM 컨트롤러 Provider
final bgmControllerProvider = StateNotifierProvider<BgmController, BgmState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return BgmController(audioService, ref);
});

/// SFX 편의 메서드를 제공하는 Provider
final sfxProvider = Provider<SfxPlayer>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return SfxPlayer(audioService);
});

/// 효과음 재생 편의 클래스
class SfxPlayer {
  final AudioService _audioService;

  SfxPlayer(this._audioService);

  /// 버튼 클릭음
  Future<void> playButtonClick() => _audioService.playButtonClick();

  /// 대화 진행음
  Future<void> playDialogueAdvance() => _audioService.playDialogueAdvance();

  /// 퀴즈 정답음
  Future<void> playQuizCorrect() => _audioService.playQuizCorrect();

  /// 퀴즈 오답음
  Future<void> playQuizWrong() => _audioService.playQuizWrong();

  /// 잠금해제음
  Future<void> playUnlock() => _audioService.playUnlock();

  /// 발견음
  Future<void> playDiscovery() => _audioService.playDiscovery();

  /// 커스텀 효과음
  Future<void> play(String soundName) => _audioService.playSfx(soundName);
}
