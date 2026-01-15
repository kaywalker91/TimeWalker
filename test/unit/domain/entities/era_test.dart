import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/era.dart';

void main() {
  group('Era', () {
    const eraTheme = EraTheme(
      primaryColor: Colors.blue,
      secondaryColor: Colors.blueAccent,
      accentColor: Colors.lightBlue,
      backgroundColor: Colors.white,
      textColor: Colors.black,
    );

    final era = Era(
      id: 'joseon',
      countryId: 'korea',
      name: 'Joseon',
      nameKorean: '조선',
      period: '1392-1897',
      startYear: 1392,
      endYear: 1897,
      description: 'The Joseon Dynasty',
      thumbnailAsset: 'thumb.png',
      backgroundAsset: 'bg.png',
      bgmAsset: 'bgm.mp3',
      theme: eraTheme,
      chapterIds: const ['c1', 'c2'],
      characterIds: const ['ch1', 'ch2', 'ch3'],
      locationIds: const ['loc1', 'loc2'],
      status: ContentStatus.locked,
      progress: 0.5,
    );

    test('props가 올바르게 작동한다 (Equatable)', () {
      final era2 = Era(
        id: 'joseon',
        countryId: 'korea',
        name: 'Joseon',
        nameKorean: '조선',
        period: '1392-1897',
        startYear: 1392,
        endYear: 1897,
        description: 'The Joseon Dynasty',
        thumbnailAsset: 'thumb.png',
        backgroundAsset: 'bg.png',
        bgmAsset: 'bgm.mp3',
        theme: eraTheme,
        chapterIds: const ['c1', 'c2'],
        characterIds: const ['ch1', 'ch2', 'ch3'],
        locationIds: const ['loc1', 'loc2'],
        status: ContentStatus.locked,
        progress: 0.5,
      );

      expect(era, equals(era2));
    });

    test('copyWith가 값을 올바르게 변경한다', () {
      final updatedEra = era.copyWith(
        nameKorean: '조선왕조',
        progress: 0.8,
        status: ContentStatus.available,
      );

      expect(updatedEra.nameKorean, equals('조선왕조'));
      expect(updatedEra.progress, equals(0.8));
      expect(updatedEra.status, equals(ContentStatus.available));
      // 변경되지 않은 값은 유지
      expect(updatedEra.id, equals(era.id));
      expect(updatedEra.theme, equals(era.theme));
    });

    test('progressPercent가 올바른 정수 백분율을 반환한다', () {
      expect(era.progressPercent, equals(50));
      
      final eraZero = era.copyWith(progress: 0.0);
      expect(eraZero.progressPercent, equals(0));

      final eraFull = era.copyWith(progress: 1.0);
      expect(eraFull.progressPercent, equals(100));
      
      final eraRounding = era.copyWith(progress: 0.337);
      expect(eraRounding.progressPercent, equals(34));
    });

    test('isAccessible이 status에 따라 올바른 값을 반환한다', () {
      expect(era.copyWith(status: ContentStatus.locked).isAccessible, isFalse);
      
      expect(era.copyWith(status: ContentStatus.available).isAccessible, isTrue);
      expect(era.copyWith(status: ContentStatus.inProgress).isAccessible, isTrue);
      expect(era.copyWith(status: ContentStatus.completed).isAccessible, isTrue);
    });

    test('isCompleted가 status에 따라 올바른 값을 반환한다', () {
      expect(era.copyWith(status: ContentStatus.completed).isCompleted, isTrue);
      expect(era.copyWith(status: ContentStatus.inProgress).isCompleted, isFalse);
    });

    test('durationYears가 올바른 기간을 계산한다', () {
      // 1897 - 1392 = 505
      expect(era.durationYears, equals(505));
    });

    test('characterCount가 올바른 개수를 반환한다', () {
      expect(era.characterCount, equals(3));
    });

    test('locationCount가 올바른 개수를 반환한다', () {
      expect(era.locationCount, equals(2));
    });
  });
}
