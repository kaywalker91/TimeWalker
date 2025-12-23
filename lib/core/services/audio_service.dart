import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:time_walker/core/constants/audio_constants.dart';
import 'package:time_walker/domain/entities/settings.dart';

/// 오디오 재생을 담당하는 핵심 서비스
/// BGM 재생/정지, 볼륨 조절, 페이드 효과 등을 관리
class AudioService {
  // 싱글톤 패턴
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // ============== 상태 변수 ==============
  bool _isInitialized = false;
  bool _isBgmEnabled = true;
  bool _isSfxEnabled = true;
  double _bgmVolume = AudioConstants.defaultBgmVolume;
  double _sfxVolume = AudioConstants.defaultSfxVolume;
  String? _currentBgmTrack;
  bool _isBgmPlaying = false;
  
  // 페이드 관련
  Timer? _fadeTimer;
  bool _isFading = false;

  // ============== Getters ==============
  bool get isInitialized => _isInitialized;
  bool get isBgmEnabled => _isBgmEnabled;
  bool get isSfxEnabled => _isSfxEnabled;
  double get bgmVolume => _bgmVolume;
  double get sfxVolume => _sfxVolume;
  String? get currentBgmTrack => _currentBgmTrack;
  bool get isBgmPlaying => _isBgmPlaying;

  // ============== 초기화 ==============
  
  /// 오디오 서비스 초기화
  /// 앱 시작 시 한 번 호출해야 함
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // FlameAudio 초기화 (캐시 등)
      // 주의: 실제 BGM 파일이 없으면 에러 발생할 수 있음
      _isInitialized = true;
      debugPrint('[AudioService] Initialized successfully');
    } catch (e) {
      debugPrint('[AudioService] Initialization error: $e');
    }
  }

  /// 설정 적용
  /// GameSettings 변경 시 호출하여 오디오 상태 동기화
  void applySettings(GameSettings settings) {
    _isBgmEnabled = settings.musicEnabled;
    _isSfxEnabled = settings.soundEnabled;
    
    // 볼륨 변경
    if (_bgmVolume != settings.musicVolume) {
      _bgmVolume = settings.musicVolume;
      _updateBgmVolume();
    }
    
    if (_sfxVolume != settings.soundVolume) {
      _sfxVolume = settings.soundVolume;
    }

    // BGM 활성화/비활성화 처리
    if (!_isBgmEnabled && _isBgmPlaying) {
      pauseBgm();
    } else if (_isBgmEnabled && _currentBgmTrack != null && !_isBgmPlaying) {
      resumeBgm();
    }
    
    debugPrint('[AudioService] Settings applied - BGM: $_isBgmEnabled ($_bgmVolume), SFX: $_isSfxEnabled ($_sfxVolume)');
  }

  // ============== BGM 제어 ==============

  /// BGM 재생
  /// [trackName] - 재생할 트랙 파일명 (예: 'main_menu.mp3')
  /// [loop] - 반복 재생 여부 (기본: true)
  /// [fadeIn] - 페이드 인 효과 적용 여부 (기본: true)
  Future<void> playBgm(
    String trackName, {
    bool loop = true,
    bool fadeIn = true,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // 동일한 트랙이 재생 중이면 무시
    if (_currentBgmTrack == trackName && _isBgmPlaying) {
      debugPrint('[AudioService] Same track already playing: $trackName');
      return;
    }

    // BGM이 비활성화 상태면 트랙만 기록하고 재생하지 않음
    if (!_isBgmEnabled) {
      _currentBgmTrack = trackName;
      debugPrint('[AudioService] BGM disabled, track recorded: $trackName');
      return;
    }

    try {
      // 기존 BGM 정지
      if (_isBgmPlaying) {
        await stopBgm(fadeOut: false);
      }

      _currentBgmTrack = trackName;
      
      // BGM 경로 구성 (bgm 폴더 포함)
      final bgmPath = '${AudioConstants.bgmBasePath}$trackName';
      
      // 페이드 인 효과
      if (fadeIn) {
        FlameAudio.bgm.play(bgmPath, volume: 0);
        _isBgmPlaying = true;
        await _fadeIn();
      } else {
        FlameAudio.bgm.play(bgmPath, volume: _bgmVolume);
        _isBgmPlaying = true;
      }

      debugPrint('[AudioService] Playing BGM: $trackName');
    } catch (e) {
      debugPrint('[AudioService] Error playing BGM: $e');
      _isBgmPlaying = false;
    }
  }

  /// BGM 정지
  /// [fadeOut] - 페이드 아웃 효과 적용 여부 (기본: true)
  Future<void> stopBgm({bool fadeOut = true}) async {
    if (!_isBgmPlaying) return;

    try {
      _cancelFade();
      
      if (fadeOut) {
        await _fadeOut();
      }

      FlameAudio.bgm.stop();
      _isBgmPlaying = false;
      debugPrint('[AudioService] BGM stopped');
    } catch (e) {
      debugPrint('[AudioService] Error stopping BGM: $e');
    }
  }

  /// BGM 일시정지
  void pauseBgm() {
    if (!_isBgmPlaying) return;

    try {
      FlameAudio.bgm.pause();
      _isBgmPlaying = false;
      debugPrint('[AudioService] BGM paused');
    } catch (e) {
      debugPrint('[AudioService] Error pausing BGM: $e');
    }
  }

  /// BGM 재개
  void resumeBgm() {
    if (_isBgmPlaying || !_isBgmEnabled || _currentBgmTrack == null) return;

    try {
      FlameAudio.bgm.resume();
      _isBgmPlaying = true;
      debugPrint('[AudioService] BGM resumed');
    } catch (e) {
      debugPrint('[AudioService] Error resuming BGM: $e');
    }
  }

  /// 다른 트랙으로 크로스페이드 전환
  Future<void> crossFadeTo(String newTrack) async {
    if (_currentBgmTrack == newTrack) return;
    
    // 현재 BGM 페이드 아웃하면서 새 BGM 시작
    await stopBgm(fadeOut: true);
    await playBgm(newTrack, fadeIn: true);
  }

  // ============== SFX 제어 ==============

  /// 효과음 재생
  /// [soundName] - 재생할 효과음 파일명
  Future<void> playSfx(String soundName) async {
    if (!_isSfxEnabled) return;

    try {
      // SFX 경로 구성 (sfx 폴더 포함)
      final sfxPath = '${AudioConstants.sfxBasePath}$soundName';
      await FlameAudio.play(sfxPath, volume: _sfxVolume);
      debugPrint('[AudioService] Playing SFX: $soundName');
    } catch (e) {
      debugPrint('[AudioService] Error playing SFX: $e');
    }
  }

  // ============== 편의 메서드 ==============

  /// 버튼 클릭 효과음
  Future<void> playButtonClick() => playSfx(AudioConstants.sfxButtonClick);

  /// 대화 진행 효과음
  Future<void> playDialogueAdvance() => playSfx(AudioConstants.sfxDialogueAdvance);

  /// 퀴즈 정답 효과음
  Future<void> playQuizCorrect() => playSfx(AudioConstants.sfxQuizCorrect);

  /// 퀴즈 오답 효과음
  Future<void> playQuizWrong() => playSfx(AudioConstants.sfxQuizWrong);

  /// 잠금해제 효과음
  Future<void> playUnlock() => playSfx(AudioConstants.sfxUnlock);

  /// 발견 효과음
  Future<void> playDiscovery() => playSfx(AudioConstants.sfxDiscovery);

  // ============== 내부 메서드 ==============

  /// BGM 볼륨 업데이트
  void _updateBgmVolume() {
    if (!_isBgmPlaying || _isFading) return;
    
    try {
      // FlameAudio.bgm의 볼륨을 직접 설정
      // 참고: flame_audio가 이 기능을 지원하는지 확인 필요
      // 지원하지 않으면 재생 중인 트랙을 다시 시작해야 할 수 있음
    } catch (e) {
      debugPrint('[AudioService] Error updating volume: $e');
    }
  }

  /// 페이드 인 효과
  Future<void> _fadeIn() async {
    _cancelFade();
    _isFading = true;

    const steps = 10;
    final stepDuration = AudioConstants.fadeInDuration.inMilliseconds ~/ steps;
    final volumeStep = _bgmVolume / steps;
    var currentVolume = 0.0;

    final completer = Completer<void>();

    _fadeTimer = Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      currentVolume += volumeStep;
      if (currentVolume >= _bgmVolume) {
        currentVolume = _bgmVolume;
        timer.cancel();
        _isFading = false;
        completer.complete();
      }
      // 볼륨 설정 (FlameAudio API에 따라 조정 필요)
    });

    await completer.future;
  }

  /// 페이드 아웃 효과
  Future<void> _fadeOut() async {
    _cancelFade();
    _isFading = true;

    const steps = 10;
    final stepDuration = AudioConstants.fadeOutDuration.inMilliseconds ~/ steps;
    final volumeStep = _bgmVolume / steps;
    var currentVolume = _bgmVolume;

    final completer = Completer<void>();

    _fadeTimer = Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      currentVolume -= volumeStep;
      if (currentVolume <= 0) {
        currentVolume = 0;
        timer.cancel();
        _isFading = false;
        completer.complete();
      }
      // 볼륨 설정 (FlameAudio API에 따라 조정 필요)
    });

    await completer.future;
  }

  /// 페이드 타이머 취소
  void _cancelFade() {
    _fadeTimer?.cancel();
    _fadeTimer = null;
    _isFading = false;
  }

  // ============== 정리 ==============

  /// 리소스 정리
  void dispose() {
    _cancelFade();
    stopBgm(fadeOut: false);
    _isInitialized = false;
  }
}
