import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/settings.dart';

void main() {
  group('GameSettings', () {
    test('기본값이 올바르게 설정된다', () {
      const settings = GameSettings();
      expect(settings.soundEnabled, isTrue);
      expect(settings.musicEnabled, isTrue);
      expect(settings.soundVolume, equals(0.8));
      expect(settings.musicVolume, equals(0.6));
      expect(settings.languageCode, equals('ko'));
    });

    test('copyWith가 올바르게 작동한다', () {
      const settings = GameSettings();
      final updated = settings.copyWith(
        soundEnabled: false,
        musicVolume: 0.1,
        languageCode: 'en',
      );

      expect(updated.soundEnabled, isFalse);
      expect(updated.musicVolume, equals(0.1));
      expect(updated.languageCode, equals('en'));
      // 변경되지 않은 값은 유지
      expect(updated.musicEnabled, isTrue);
    });

    test('toJson과 fromJson이 대칭적이다', () {
      const settings = GameSettings(
        soundEnabled: false,
        musicVolume: 0.5,
        languageCode: 'en',
        accessibility: AccessibilitySettings(colorBlindMode: true),
      );

      final json = settings.toJson();
      final fromJson = GameSettings.fromJson(json);

      expect(fromJson.soundEnabled, equals(settings.soundEnabled));
      expect(fromJson.musicVolume, equals(settings.musicVolume));
      expect(fromJson.languageCode, equals(settings.languageCode));
      expect(fromJson.accessibility.colorBlindMode, isTrue);
    });
  });

  group('AccessibilitySettings', () {
    test('copyWith가 올바르게 작동한다', () {
      const accessibility = AccessibilitySettings();
      final updated = accessibility.copyWith(highContrastMode: true);
      
      expect(updated.highContrastMode, isTrue);
      expect(updated.colorBlindMode, isFalse);
    });

    test('toJson과 fromJson이 대칭적이다', () {
      const accessibility = AccessibilitySettings(
        colorBlindMode: true,
        highContrastMode: true,
      );

      final json = accessibility.toJson();
      final fromJson = AccessibilitySettings.fromJson(json);

      expect(fromJson.colorBlindMode, isTrue);
      expect(fromJson.highContrastMode, isTrue);
    });
  });
}
