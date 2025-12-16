import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/settings.dart';

// ============== Settings Provider ==============

/// 게임 설정 Notifier
class SettingsNotifier extends StateNotifier<GameSettings> {
  SettingsNotifier() : super(const GameSettings());

  void updateSound(bool enabled) {
    state = state.copyWith(soundEnabled: enabled);
  }

  void updateMusic(bool enabled) {
    state = state.copyWith(musicEnabled: enabled);
  }

  void updateSoundVolume(double volume) {
    state = state.copyWith(soundVolume: volume);
  }

  void updateMusicVolume(double volume) {
    state = state.copyWith(musicVolume: volume);
  }

  void updateVibration(bool enabled) {
    state = state.copyWith(vibrationEnabled: enabled);
  }

  void updateLanguage(String languageCode) {
    state = state.copyWith(languageCode: languageCode);
  }

  void updateAccessibility(AccessibilitySettings accessibility) {
    state = state.copyWith(accessibility: accessibility);
  }

  void completeTutorial() {
    state = state.copyWith(tutorialCompleted: true);
  }

  void removeAds() {
    state = state.copyWith(adsRemoved: true);
  }

  void loadSettings(GameSettings settings) {
    state = settings;
  }
}

/// 설정 Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, GameSettings>((
  ref,
) {
  return SettingsNotifier();
});
