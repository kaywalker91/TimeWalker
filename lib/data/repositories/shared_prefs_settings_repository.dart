import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_walker/domain/entities/settings.dart';
import 'package:time_walker/domain/repositories/settings_repository.dart';

/// SharedPreferences를 사용한 설정 저장소 구현
class SharedPrefsSettingsRepository implements SettingsRepository {
  static const String _settingsKey = 'game_settings';
  final SharedPreferences _prefs;

  SharedPrefsSettingsRepository(this._prefs);

  @override
  Future<GameSettings> getSettings() async {
    try {
      final jsonString = _prefs.getString(_settingsKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return GameSettings.fromJson(jsonMap);
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
    // 저장된 설정이 없거나 에러 발생 시 기본값 반환
    return const GameSettings();
  }

  @override
  Future<void> saveSettings(GameSettings settings) async {
    try {
      final jsonString = jsonEncode(settings.toJson());
      await _prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}
