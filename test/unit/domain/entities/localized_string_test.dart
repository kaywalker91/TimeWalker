import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/localized_string.dart';

void main() {
  group('LocalizedString', () {
    test('should create LocalizedString with ko and en values', () {
      // Arrange & Act
      final localizedString = LocalizedString(
        ko: '세종대왕',
        en: 'King Sejong the Great',
      );

      // Assert
      expect(localizedString.ko, '세종대왕');
      expect(localizedString.en, 'King Sejong the Great');
    });

    test('should get value by locale code', () {
      // Arrange
      final localizedString = LocalizedString(
        ko: '조선 제4대 국왕',
        en: '4th King of Joseon',
      );

      // Act & Assert
      expect(localizedString.get(const Locale('ko')), '조선 제4대 국왕');
      expect(localizedString.get(const Locale('en')), '4th King of Joseon');
    });

    test('should fallback to Korean when locale not found', () {
      // Arrange
      final localizedString = LocalizedString(
        ko: '한글 창제',
        en: 'Creation of Hangeul',
      );

      // Act & Assert
      expect(localizedString.get(const Locale('ja')), '한글 창제'); // Fallback to Korean
      expect(localizedString.get(const Locale('zh')), '한글 창제'); // Fallback to Korean
    });

    test('should create from JSON', () {
      // Arrange
      final json = {
        'ko': '훈민정음',
        'en': 'Hunminjeongeum',
      };

      // Act
      final localizedString = LocalizedString.fromJson(json);

      // Assert
      expect(localizedString.ko, '훈민정음');
      expect(localizedString.en, 'Hunminjeongeum');
    });

    test('should convert to JSON', () {
      // Arrange
      final localizedString = LocalizedString(
        ko: '한글',
        en: 'Hangeul',
      );

      // Act
      final json = localizedString.toJson();

      // Assert
      expect(json['ko'], '한글');
      expect(json['en'], 'Hangeul');
    });

    test('should support equality comparison', () {
      // Arrange
      final string1 = LocalizedString(ko: '테스트', en: 'Test');
      final string2 = LocalizedString(ko: '테스트', en: 'Test');
      final string3 = LocalizedString(ko: '다름', en: 'Different');

      // Act & Assert
      expect(string1, equals(string2));
      expect(string1, isNot(equals(string3)));
    });

    test('should have consistent hashCode for equal instances', () {
      // Arrange
      final string1 = LocalizedString(ko: '해시', en: 'Hash');
      final string2 = LocalizedString(ko: '해시', en: 'Hash');

      // Act & Assert
      expect(string1.hashCode, equals(string2.hashCode));
    });
  });
}
