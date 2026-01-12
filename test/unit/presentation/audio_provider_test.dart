import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/settings.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/settings_provider.dart';

import '../../mocks/mock_audio_service.dart';
import '../../mocks/mock_providers.dart';

void main() {
  late MockAudioService mockAudioService;
  late ProviderContainer container;

  setUp(() {
    mockAudioService = MockAudioService();
    container = createTestContainerWithMockAudio(
      mockAudioService: mockAudioService,
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('audioServiceProvider 테스트', () {
    test('AudioService가 올바르게 제공됨', () {
      final audioService = container.read(audioServiceProvider);

      expect(audioService, isNotNull);
      expect(audioService, isA<MockAudioService>());
    });

    test('AudioService가 초기화됨', () {
      container.read(audioServiceProvider);

      expect(mockAudioService.initializeCalled, isTrue);
    });

    test('설정 변경이 AudioService에 적용됨', () {
      container.read(audioServiceProvider);

      // 설정 변경
      container.read(settingsProvider.notifier).updateMusic(false);

      expect(mockAudioService.isBgmEnabled, isFalse);
    });

    test('볼륨 변경이 AudioService에 적용됨', () {
      container.read(audioServiceProvider);

      // 볼륨 변경
      container.read(settingsProvider.notifier).updateMusicVolume(0.5);

      expect(mockAudioService.bgmVolume, equals(0.5));
    });
  });

  group('bgmControllerProvider 테스트', () {
    test('BgmController가 올바르게 제공됨', () {
      final bgmController = container.read(bgmControllerProvider.notifier);

      expect(bgmController, isNotNull);
      expect(bgmController, isA<BgmController>());
    });

    test('메인 메뉴 BGM 재생', () async {
      final bgmController = container.read(bgmControllerProvider.notifier);

      await bgmController.playMainMenuBgm();

      expect(mockAudioService.playedBgmTracks.isNotEmpty, isTrue);
      expect(container.read(isBgmPlayingProvider), isTrue);
    });

    test('BGM 정지', () async {
      final bgmController = container.read(bgmControllerProvider.notifier);

      await bgmController.playMainMenuBgm();
      await bgmController.stopBgm();

      expect(mockAudioService.isBgmPlaying, isFalse);
      expect(container.read(isBgmPlayingProvider), isFalse);
    });

    test('BGM 일시정지 및 재개', () async {
      final bgmController = container.read(bgmControllerProvider.notifier);

      await bgmController.playWorldMapBgm();
      expect(container.read(isBgmPlayingProvider), isTrue);

      bgmController.pauseBgm();
      expect(container.read(isBgmPlayingProvider), isFalse);

      bgmController.resumeBgm();
      expect(container.read(isBgmPlayingProvider), isTrue);
    });

    test('BGM 토글', () async {
      final bgmController = container.read(bgmControllerProvider.notifier);

      await bgmController.playQuizBgm();
      expect(container.read(isBgmPlayingProvider), isTrue);

      bgmController.toggleBgm();
      expect(container.read(isBgmPlayingProvider), isFalse);

      bgmController.toggleBgm();
      expect(container.read(isBgmPlayingProvider), isTrue);
    });
  });

  group('sfxProvider 테스트', () {
    test('SfxPlayer가 올바르게 제공됨', () {
      final sfxPlayer = container.read(sfxProvider);

      expect(sfxPlayer, isNotNull);
      expect(sfxPlayer, isA<SfxPlayer>());
    });

    test('버튼 클릭 효과음 재생', () async {
      final sfxPlayer = container.read(sfxProvider);

      await sfxPlayer.playButtonClick();

      expect(mockAudioService.playedSfxSounds.isNotEmpty, isTrue);
    });

    test('퀴즈 정답 효과음 재생', () async {
      final sfxPlayer = container.read(sfxProvider);

      await sfxPlayer.playQuizCorrect();

      expect(mockAudioService.playedSfxSounds.isNotEmpty, isTrue);
    });

    test('SFX 비활성화 상태에서 컨테이너 생성 시 재생되지 않음', () async {
      // SFX가 비활성화된 상태로 컨테이너 생성
      final disabledMock = MockAudioService();
      final disabledContainer = createTestContainerWithMockAudio(
        mockAudioService: disabledMock,
        initialSettings: const GameSettings(
          soundEnabled: false,
        ),
      );

      final sfxPlayer = disabledContainer.read(sfxProvider);
      await sfxPlayer.playButtonClick();

      // SFX가 비활성화되어 있으므로 재생되지 않음
      expect(disabledMock.playedSfxSounds, isEmpty);
      
      disabledContainer.dispose();
    });
  });

  group('설정 연동 테스트', () {
    test('음악 비활성화 설정이 AudioService에 반영됨', () async {
      // AudioService 초기화
      container.read(audioServiceProvider);
      expect(mockAudioService.isBgmEnabled, isTrue);

      // 음악 비활성화
      container.read(settingsProvider.notifier).updateMusic(false);

      // 설정이 AudioService에 반영됨
      expect(mockAudioService.isBgmEnabled, isFalse);
    });

    test('커스텀 초기 설정으로 컨테이너 생성', () {
      final customSettings = const GameSettings(
        musicEnabled: false,
        soundEnabled: false,
        musicVolume: 0.3,
        soundVolume: 0.2,
      );

      final customContainer = createTestContainerWithMockAudio(
        mockAudioService: mockAudioService,
        initialSettings: customSettings,
      );

      customContainer.read(audioServiceProvider);

      expect(mockAudioService.isBgmEnabled, isFalse);
      expect(mockAudioService.isSfxEnabled, isFalse);
      expect(mockAudioService.bgmVolume, equals(0.3));
      expect(mockAudioService.sfxVolume, equals(0.2));

      customContainer.dispose();
    });
  });
}
