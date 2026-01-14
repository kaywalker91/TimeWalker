import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/region.dart';
import 'package:time_walker/domain/services/country_unlock_rules.dart';

import '../../../helpers/test_utils.dart';

void main() {
  group('CountryUnlockRule', () {
    test('free 규칙 생성', () {
      const rule = CountryUnlockRule.free();
      
      expect(rule.type, equals(CountryUnlockRuleType.free));
      expect(rule.eraId, isNull);
      expect(rule.requiredProgress, isNull);
      expect(rule.requiredLevel, isNull);
    });

    test('eraProgress 규칙 생성', () {
      const rule = CountryUnlockRule.eraProgress('korea_joseon', 0.5);
      
      expect(rule.type, equals(CountryUnlockRuleType.eraProgress));
      expect(rule.eraId, equals('korea_joseon'));
      expect(rule.requiredProgress, equals(0.5));
    });

    test('level 규칙 생성', () {
      const rule = CountryUnlockRule.level(10);
      
      expect(rule.type, equals(CountryUnlockRuleType.level));
      expect(rule.requiredLevel, equals(10));
    });
  });

  group('CountryUnlockRules', () {
    // =========================================================
    // resolve 테스트
    // =========================================================
    group('resolve', () {
      test('korea는 free 규칙 반환', () {
        final country = _createMockCountry(id: 'korea');
        final region = _createMockRegion(id: 'asia');
        
        final rule = CountryUnlockRules.resolve(country: country, region: region);
        
        expect(rule, isNotNull);
        expect(rule!.type, equals(CountryUnlockRuleType.free));
      });

      test('china는 삼국시대 30% 진행 필요', () {
        final country = _createMockCountry(id: 'china');
        final region = _createMockRegion(id: 'asia');
        
        final rule = CountryUnlockRules.resolve(country: country, region: region);
        
        expect(rule, isNotNull);
        expect(rule!.type, equals(CountryUnlockRuleType.eraProgress));
        expect(rule.eraId, equals('korea_three_kingdoms'));
        expect(rule.requiredProgress, equals(0.3));
      });

      test('japan은 삼국시대 60% 진행 필요', () {
        final country = _createMockCountry(id: 'japan');
        final region = _createMockRegion(id: 'asia');
        
        final rule = CountryUnlockRules.resolve(country: country, region: region);
        
        expect(rule, isNotNull);
        expect(rule!.type, equals(CountryUnlockRuleType.eraProgress));
        expect(rule.requiredProgress, equals(0.6));
      });

      test('africa 지역 국가는 레벨 기반 해금', () {
        final country = _createMockCountry(id: 'egypt', regionId: 'africa');
        final region = _createMockRegion(id: 'africa', unlockLevel: 5);
        
        final rule = CountryUnlockRules.resolve(country: country, region: region);
        
        expect(rule, isNotNull);
        expect(rule!.type, equals(CountryUnlockRuleType.level));
        expect(rule.requiredLevel, equals(5));
      });

      test('정의되지 않은 국가는 지역 규칙 사용', () {
        final country = _createMockCountry(id: 'unknown_country', regionId: 'americas');
        final region = _createMockRegion(id: 'americas', unlockLevel: 10);
        
        final rule = CountryUnlockRules.resolve(country: country, region: region);
        
        expect(rule, isNotNull);
        expect(rule!.type, equals(CountryUnlockRuleType.level));
      });
    });

    // =========================================================
    // canUnlock 테스트
    // =========================================================
    group('canUnlock', () {
      test('korea는 항상 해금 가능', () {
        final progress = createMockUserProgress();
        final country = _createMockCountry(id: 'korea');
        final region = _createMockRegion(id: 'asia');
        
        final canUnlock = CountryUnlockRules.canUnlock(
          progress: progress,
          country: country,
          region: region,
        );
        
        expect(canUnlock, isTrue);
      });

      test('china는 삼국시대 30% 이상 진행 시 해금', () {
        // Given: 삼국시대 30% 진행
        final progress = createMockUserProgress().copyWith(
          eraProgress: {'korea_three_kingdoms': 0.3},
        );
        final country = _createMockCountry(id: 'china');
        final region = _createMockRegion(id: 'asia');
        
        // When
        final canUnlock = CountryUnlockRules.canUnlock(
          progress: progress,
          country: country,
          region: region,
        );
        
        // Then
        expect(canUnlock, isTrue);
      });

      test('china는 삼국시대 30% 미만 시 해금 불가', () {
        // Given: 삼국시대 20% 진행
        final progress = createMockUserProgress().copyWith(
          eraProgress: {'korea_three_kingdoms': 0.2},
        );
        final country = _createMockCountry(id: 'china');
        final region = _createMockRegion(id: 'asia');
        
        // When
        final canUnlock = CountryUnlockRules.canUnlock(
          progress: progress,
          country: country,
          region: region,
        );
        
        // Then
        expect(canUnlock, isFalse);
      });

      test('japan은 삼국시대 60% 이상 필요', () {
        // Given: 삼국시대 50% (미달)
        final progress = createMockUserProgress().copyWith(
          eraProgress: {'korea_three_kingdoms': 0.5},
        );
        final country = _createMockCountry(id: 'japan');
        final region = _createMockRegion(id: 'asia');
        
        expect(
          CountryUnlockRules.canUnlock(
            progress: progress,
            country: country,
            region: region,
          ),
          isFalse,
        );
        
        // Given: 삼국시대 60% (충족)
        final progressMet = createMockUserProgress().copyWith(
          eraProgress: {'korea_three_kingdoms': 0.6},
        );
        
        expect(
          CountryUnlockRules.canUnlock(
            progress: progressMet,
            country: country,
            region: region,
          ),
          isTrue,
        );
      });

      test('레벨 기반 국가는 탐험가 등급에 따라 해금', () {
        // Given: intermediate 등급 (index * 5 = 2 * 5 = 10)
        final progress = createMockUserProgress(
          rank: ExplorerRank.intermediate,
        );
        final country = _createMockCountry(id: 'egypt', regionId: 'africa');
        final region = _createMockRegion(id: 'africa', unlockLevel: 10);
        
        final canUnlock = CountryUnlockRules.canUnlock(
          progress: progress,
          country: country,
          region: region,
        );
        
        expect(canUnlock, isTrue);
      });

      test('레벨 미달 시 해금 불가', () {
        // Given: novice 등급 (index * 5 = 0 * 5 = 0)
        final progress = createMockUserProgress(
          rank: ExplorerRank.novice,
        );
        final country = _createMockCountry(id: 'brazil', regionId: 'americas');
        final region = _createMockRegion(id: 'americas', unlockLevel: 10);
        
        final canUnlock = CountryUnlockRules.canUnlock(
          progress: progress,
          country: country,
          region: region,
        );
        
        expect(canUnlock, isFalse);
      });

      test('유럽 국가들은 삼국시대 100% 완료 필요', () {
        // Given: 삼국시대 미완료
        final progress = createMockUserProgress().copyWith(
          eraProgress: {'korea_three_kingdoms': 0.9},
        );
        final country = _createMockCountry(id: 'greece');
        final region = _createMockRegion(id: 'europe');
        
        expect(
          CountryUnlockRules.canUnlock(
            progress: progress,
            country: country,
            region: region,
          ),
          isFalse,
        );
        
        // Given: 삼국시대 완료
        final progressComplete = createMockUserProgress().copyWith(
          eraProgress: {'korea_three_kingdoms': 1.0},
        );
        
        expect(
          CountryUnlockRules.canUnlock(
            progress: progressComplete,
            country: country,
            region: region,
          ),
          isTrue,
        );
      });

      test('진행률 비교 시 부동소수점 오차 허용 (0.001)', () {
        final country = _createMockCountry(id: 'china');
        final region = _createMockRegion(id: 'asia');
        
        // 0.299 (0.3 - 0.001 미만) → 해금 불가
        final progressNotMet = createMockUserProgress().copyWith(
          eraProgress: {'korea_three_kingdoms': 0.298},
        );
        expect(
          CountryUnlockRules.canUnlock(
            progress: progressNotMet,
            country: country,
            region: region,
          ),
          isFalse,
        );
        
        // 0.299 (0.3 - 0.001) → 오차 허용으로 해금 가능
        final progressAlmostMet = createMockUserProgress().copyWith(
          eraProgress: {'korea_three_kingdoms': 0.299},
        );
        expect(
          CountryUnlockRules.canUnlock(
            progress: progressAlmostMet,
            country: country,
            region: region,
          ),
          isTrue,
        );
      });
    });

    // =========================================================
    // hintFor 테스트
    // =========================================================
    group('hintFor', () {
      test('korea는 "기본 해금" 힌트', () {
        final country = _createMockCountry(id: 'korea');
        final region = _createMockRegion(id: 'asia');
        
        final hint = CountryUnlockRules.hintFor(
          country: country,
          region: region,
        );
        
        expect(hint, equals('기본 해금'));
      });

      test('china는 삼국시대 진행 힌트', () {
        final country = _createMockCountry(id: 'china');
        final region = _createMockRegion(id: 'asia');
        
        final hint = CountryUnlockRules.hintFor(
          country: country,
          region: region,
        );
        
        expect(hint, contains('삼국시대'));
        expect(hint, contains('30%'));
      });

      test('100% 진행 필요 시 "완료 시 해금" 힌트', () {
        final country = _createMockCountry(id: 'greece');
        final region = _createMockRegion(id: 'europe');
        
        final hint = CountryUnlockRules.hintFor(
          country: country,
          region: region,
        );
        
        expect(hint, contains('완료'));
      });

      test('레벨 기반 국가는 레벨 요구 힌트', () {
        final country = _createMockCountry(id: 'unknown', regionId: 'africa');
        final region = _createMockRegion(id: 'africa', unlockLevel: 5);
        
        final hint = CountryUnlockRules.hintFor(
          country: country,
          region: region,
        );
        
        expect(hint, contains('레벨'));
        expect(hint, contains('5'));
      });
    });

    // =========================================================
    // 정적 규칙 데이터 검증
    // =========================================================
    group('정적 규칙 검증', () {
      test('asia 국가들의 해금 규칙이 정의됨', () {
        final asiaCountries = ['korea', 'china', 'japan', 'india', 'mongolia'];
        final region = _createMockRegion(id: 'asia');
        
        for (final countryId in asiaCountries) {
          final country = _createMockCountry(id: countryId);
          final rule = CountryUnlockRules.resolve(country: country, region: region);
          expect(rule, isNotNull, reason: '$countryId 규칙이 정의되어야 함');
        }
      });

      test('europe 국가들의 해금 규칙이 정의됨', () {
        final europeCountries = ['greece', 'rome', 'uk', 'france', 'germany', 'italy'];
        final region = _createMockRegion(id: 'europe');
        
        for (final countryId in europeCountries) {
          final country = _createMockCountry(id: countryId);
          final rule = CountryUnlockRules.resolve(country: country, region: region);
          expect(rule, isNotNull, reason: '$countryId 규칙이 정의되어야 함');
        }
      });
    });
  });
}

// =============================================================================
// 테스트용 Mock 팩토리 함수
// =============================================================================

/// 테스트용 Country 생성
Country _createMockCountry({
  required String id,
  String regionId = 'asia',
}) {
  return Country(
    id: id,
    regionId: regionId,
    name: id,
    nameKorean: '테스트 국가',
    description: 'Test country description',
    thumbnailAsset: 'assets/images/countries/test_thumb.jpg',
    backgroundAsset: 'assets/images/countries/test_bg.jpg',
    position: const MapCoordinates(x: 0.5, y: 0.5),
    eraIds: const [],
  );
}

/// 테스트용 Region 생성
Region _createMockRegion({
  required String id,
  int unlockLevel = 0,
}) {
  return Region(
    id: id,
    name: id,
    nameKorean: '테스트 지역',
    description: 'Test region description',
    iconAsset: 'assets/images/regions/test_icon.png',
    thumbnailAsset: 'assets/images/regions/test_thumb.jpg',
    countryIds: const [],
    center: const MapCoordinates(x: 0.5, y: 0.5),
    unlockLevel: unlockLevel,
  );
}
