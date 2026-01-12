import 'package:time_walker/core/services/audio_service.dart';
import 'package:time_walker/domain/entities/settings.dart';

/// Mock AudioService for testing
/// 
/// 테스트에서 실제 오디오 재생을 방지하고, 
/// 호출 기록을 추적할 수 있는 Mock 클래스
class MockAudioService implements AudioService {
  // 호출 추적 변수
  bool _initializeCalled = false;
  bool _disposeCalled = false;
  final List<String> playedBgmTracks = [];
  final List<String> playedSfxSounds = [];
  
  // 상태 변수
  bool _isInitialized = false;
  bool _isBgmEnabled = true;
  bool _isSfxEnabled = true;
  double _bgmVolume = 0.6;
  double _sfxVolume = 0.8;
  String? _currentBgmTrack;
  bool _isBgmPlaying = false;

  // 추적 getter
  bool get initializeCalled => _initializeCalled;
  bool get disposeCalled => _disposeCalled;

  // AudioService interface 구현
  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isBgmEnabled => _isBgmEnabled;

  @override
  bool get isSfxEnabled => _isSfxEnabled;

  @override
  double get bgmVolume => _bgmVolume;

  @override
  double get sfxVolume => _sfxVolume;

  @override
  String? get currentBgmTrack => _currentBgmTrack;

  @override
  bool get isBgmPlaying => _isBgmPlaying;

  @override
  Future<void> initialize() async {
    _initializeCalled = true;
    _isInitialized = true;
    // 실제 초기화 로직 없음 - 즉시 완료
  }

  @override
  void applySettings(GameSettings settings) {
    _isBgmEnabled = settings.musicEnabled;
    _isSfxEnabled = settings.soundEnabled;
    _bgmVolume = settings.musicVolume;
    _sfxVolume = settings.soundVolume;
  }

  @override
  Future<void> playBgm(String trackName, {bool loop = true, bool fadeIn = true}) async {
    playedBgmTracks.add(trackName);
    _currentBgmTrack = trackName;
    if (_isBgmEnabled) {
      _isBgmPlaying = true;
    }
  }

  @override
  Future<void> stopBgm({bool fadeOut = true}) async {
    _isBgmPlaying = false;
  }

  @override
  void pauseBgm() {
    _isBgmPlaying = false;
  }

  @override
  void resumeBgm() {
    if (_isBgmEnabled && _currentBgmTrack != null) {
      _isBgmPlaying = true;
    }
  }

  @override
  Future<void> crossFadeTo(String newTrack) async {
    await stopBgm();
    await playBgm(newTrack);
  }

  @override
  Future<void> playSfx(String soundName) async {
    if (_isSfxEnabled) {
      playedSfxSounds.add(soundName);
    }
  }

  @override
  Future<void> playButtonClick() async {
    await playSfx('button_click.mp3');
  }

  @override
  Future<void> playDialogueAdvance() async {
    await playSfx('dialogue_advance.mp3');
  }

  @override
  Future<void> playQuizCorrect() async {
    await playSfx('quiz_correct.mp3');
  }

  @override
  Future<void> playQuizWrong() async {
    await playSfx('quiz_wrong.mp3');
  }

  @override
  Future<void> playUnlock() async {
    await playSfx('unlock.mp3');
  }

  @override
  Future<void> playDiscovery() async {
    await playSfx('discovery.mp3');
  }

  @override
  void dispose() {
    _disposeCalled = true;
    _isBgmPlaying = false;
    _isInitialized = false;
  }

  /// 테스트용: 상태 리셋
  void reset() {
    _initializeCalled = false;
    _disposeCalled = false;
    playedBgmTracks.clear();
    playedSfxSounds.clear();
    _isInitialized = false;
    _isBgmEnabled = true;
    _isSfxEnabled = true;
    _bgmVolume = 0.6;
    _sfxVolume = 0.8;
    _currentBgmTrack = null;
    _isBgmPlaying = false;
  }
}
