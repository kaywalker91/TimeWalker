import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/settings.dart';
import 'package:time_walker/presentation/providers/audio_provider.dart';
import 'package:time_walker/presentation/providers/settings_provider.dart';

import 'mock_audio_service.dart';
import 'mock_repositories.dart';

// ============== Mock Providers ==============

/// Mock AudioService를 사용하는 Provider 오버라이드 생성
/// 
/// 테스트에서 AudioService를 모킹하여 실제 오디오 재생을 방지
/// 
/// Example:
/// ```dart
/// final container = ProviderContainer(
///   overrides: createMockAudioOverrides(),
/// );
/// ```
List<Override> createMockAudioOverrides({
  MockAudioService? mockAudioService,
  GameSettings? initialSettings,
}) {
  final audioService = mockAudioService ?? MockAudioService();
  
  return [
    // SettingsProvider override (AudioService가 의존)
    settingsProvider.overrideWith((ref) {
      final notifier = SettingsNotifier(MockSettingsRepository());
      if (initialSettings != null) {
        notifier.loadSettings(initialSettings);
      }
      return notifier;
    }),
    
    // AudioServiceProvider override
    audioServiceProvider.overrideWith((ref) {
      audioService.initialize();
      final settings = ref.read(settingsProvider);
      audioService.applySettings(settings);
      
      ref.listen(settingsProvider, (previous, next) {
        audioService.applySettings(next);
      });
      
      ref.onDispose(() {
        audioService.dispose();
      });
      
      return audioService;
    }),
    
    // BGM Controller override - audioServiceProvider를 통해 가져옴
    bgmControllerProvider.overrideWith((ref) {
      final service = ref.watch(audioServiceProvider);
      return BgmController(service, ref);
    }),
    
    // SFX Provider override - audioServiceProvider를 통해 가져옴
    sfxProvider.overrideWith((ref) {
      final service = ref.watch(audioServiceProvider);
      return SfxPlayer(service);
    }),
  ];
}

/// 테스트용 ProviderContainer 생성 (Mock Audio 포함)
/// 
/// 기본적인 Mock 오버라이드가 적용된 컨테이너를 반환합니다.
/// 추가 오버라이드가 필요한 경우 [additionalOverrides]를 사용하세요.
ProviderContainer createTestContainerWithMockAudio({
  MockAudioService? mockAudioService,
  GameSettings? initialSettings,
  List<Override> additionalOverrides = const [],
}) {
  return ProviderContainer(
    overrides: [
      ...createMockAudioOverrides(
        mockAudioService: mockAudioService,
        initialSettings: initialSettings,
      ),
      ...additionalOverrides,
    ],
  );
}
