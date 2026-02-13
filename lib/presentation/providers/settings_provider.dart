import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/settings.dart';
import 'package:time_walker/domain/repositories/settings_repository.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== Settings Provider ==============

/// 게임 설정 Notifier
class SettingsNotifier extends StateNotifier<GameSettings> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(const GameSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = await _repository.getSettings();
  }

  Future<void> _saveSettings() async {
    await _repository.saveSettings(state);
  }

  void updatePlayerName(String name) {
    state = state.copyWith(playerName: name);
    _saveSettings();
  }

  void updatePlayerAvatar(int index) {
    state = state.copyWith(playerAvatarIndex: index);
    _saveSettings();
  }

  void updateSound(bool enabled) {
    state = state.copyWith(soundEnabled: enabled);
    _saveSettings();
  }

  void updateMusic(bool enabled) {
    state = state.copyWith(musicEnabled: enabled);
    _saveSettings();
  }

  void updateSoundVolume(double volume) {
    state = state.copyWith(soundVolume: volume);
    _saveSettings();
  }

  void updateMusicVolume(double volume) {
    state = state.copyWith(musicVolume: volume);
    _saveSettings();
  }

  void updateVibration(bool enabled) {
    state = state.copyWith(vibrationEnabled: enabled);
    _saveSettings();
  }

  void updateLanguage(String languageCode) {
    state = state.copyWith(languageCode: languageCode);
    _saveSettings();
  }

  void updateAccessibility(AccessibilitySettings accessibility) {
    state = state.copyWith(accessibility: accessibility);
    _saveSettings();
  }

  void completeTutorial() {
    state = state.copyWith(tutorialCompleted: true);
    _saveSettings();
  }

  void removeAds() {
    state = state.copyWith(adsRemoved: true);
    _saveSettings();
  }

  void toggleDeveloperMode(bool enabled) {
    state = state.copyWith(developerMode: enabled);
    _saveSettings();
  }

  void loadSettings(GameSettings settings) {
    state = settings;
  }
}

/// 설정 Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, GameSettings>((
  ref,
) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository);
});
