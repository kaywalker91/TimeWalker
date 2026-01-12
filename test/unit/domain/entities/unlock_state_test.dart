import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/unlock_state.dart';

void main() {
  group('UnlockState', () {
    // =========================================================
    // 기본 생성 및 copyWith 테스트
    // =========================================================
    group('생성자 및 copyWith', () {
      test('기본값으로 생성 시 모든 목록이 비어있어야 함', () {
        // When
        const state = UnlockState();

        // Then
        expect(state.unlockedRegionIds, isEmpty);
        expect(state.unlockedCountryIds, isEmpty);
        expect(state.unlockedEraIds, isEmpty);
        expect(state.unlockedCharacterIds, isEmpty);
        expect(state.unlockedFactIds, isEmpty);
      });

      test('모든 필드를 지정하여 생성 가능해야 함', () {
        // When
        const state = UnlockState(
          unlockedRegionIds: ['asia', 'europe'],
          unlockedCountryIds: ['korea', 'japan'],
          unlockedEraIds: ['joseon', 'goryeo'],
          unlockedCharacterIds: ['sejong', 'yi_sun_sin'],
          unlockedFactIds: ['fact_1', 'fact_2'],
        );

        // Then
        expect(state.unlockedRegionIds, equals(['asia', 'europe']));
        expect(state.unlockedCountryIds, equals(['korea', 'japan']));
        expect(state.unlockedEraIds, equals(['joseon', 'goryeo']));
        expect(state.unlockedCharacterIds, equals(['sejong', 'yi_sun_sin']));
        expect(state.unlockedFactIds, equals(['fact_1', 'fact_2']));
      });

      test('copyWith으로 특정 필드만 변경 가능해야 함', () {
        // Given
        const original = UnlockState(
          unlockedRegionIds: ['asia'],
          unlockedCountryIds: ['korea'],
        );

        // When
        final updated = original.copyWith(
          unlockedRegionIds: ['asia', 'europe'],
        );

        // Then
        expect(updated.unlockedRegionIds, equals(['asia', 'europe']));
        expect(updated.unlockedCountryIds, equals(['korea'])); // 변경 안 됨
      });
    });

    // =========================================================
    // 해금 상태 확인 테스트
    // =========================================================
    group('해금 상태 확인', () {
      test('isRegionUnlocked - 해금된 지역', () {
        // Given
        const state = UnlockState(
          unlockedRegionIds: ['asia', 'europe'],
        );

        // Then
        expect(state.isRegionUnlocked('asia'), isTrue);
        expect(state.isRegionUnlocked('europe'), isTrue);
        expect(state.isRegionUnlocked('africa'), isFalse);
      });

      test('isRegionUnlocked - americas 특수 처리 (americas 해금 시)', () {
        // Given: americas가 해금된 경우
        const state = UnlockState(
          unlockedRegionIds: ['americas'],
        );

        // Then: north_america, south_america도 해금으로 간주
        expect(state.isRegionUnlocked('americas'), isTrue);
        expect(state.isRegionUnlocked('north_america'), isTrue);
        expect(state.isRegionUnlocked('south_america'), isTrue);
      });

      test('isRegionUnlocked - americas 특수 처리 (하위 지역 해금 시)', () {
        // Given: north_america가 해금된 경우
        const state = UnlockState(
          unlockedRegionIds: ['north_america'],
        );

        // Then: americas도 해금으로 간주
        expect(state.isRegionUnlocked('americas'), isTrue);
        expect(state.isRegionUnlocked('north_america'), isTrue);
        expect(state.isRegionUnlocked('south_america'), isFalse);
      });

      test('isCountryUnlocked - 국가 해금 확인', () {
        // Given
        const state = UnlockState(
          unlockedCountryIds: ['korea', 'china'],
        );

        // Then
        expect(state.isCountryUnlocked('korea'), isTrue);
        expect(state.isCountryUnlocked('china'), isTrue);
        expect(state.isCountryUnlocked('japan'), isFalse);
      });

      test('isEraUnlocked - 시대 해금 확인', () {
        // Given
        const state = UnlockState(
          unlockedEraIds: ['joseon', 'three_kingdoms'],
        );

        // Then
        expect(state.isEraUnlocked('joseon'), isTrue);
        expect(state.isEraUnlocked('three_kingdoms'), isTrue);
        expect(state.isEraUnlocked('goryeo'), isFalse);
      });

      test('isCharacterUnlocked - 인물 해금 확인', () {
        // Given
        const state = UnlockState(
          unlockedCharacterIds: ['sejong', 'yi_sun_sin'],
        );

        // Then
        expect(state.isCharacterUnlocked('sejong'), isTrue);
        expect(state.isCharacterUnlocked('yi_sun_sin'), isTrue);
        expect(state.isCharacterUnlocked('gwanggaeto'), isFalse);
      });

      test('isFactUnlocked - 역사 사실 해금 확인', () {
        // Given
        const state = UnlockState(
          unlockedFactIds: ['fact_1', 'fact_2'],
        );

        // Then
        expect(state.isFactUnlocked('fact_1'), isTrue);
        expect(state.isFactUnlocked('fact_2'), isTrue);
        expect(state.isFactUnlocked('fact_3'), isFalse);
      });
    });

    // =========================================================
    // 해금 메서드 테스트
    // =========================================================
    group('해금 메서드', () {
      test('unlockRegion - 새 지역 해금', () {
        // Given
        const state = UnlockState(
          unlockedRegionIds: ['asia'],
        );

        // When
        final updated = state.unlockRegion('europe');

        // Then
        expect(updated.isRegionUnlocked('asia'), isTrue);
        expect(updated.isRegionUnlocked('europe'), isTrue);
        expect(state.isRegionUnlocked('europe'), isFalse); // 원본 불변
      });

      test('unlockRegion - 이미 해금된 지역은 중복 추가 안 됨', () {
        // Given
        const state = UnlockState(
          unlockedRegionIds: ['asia'],
        );

        // When
        final updated = state.unlockRegion('asia');

        // Then
        expect(updated.unlockedRegionIds, hasLength(1));
        expect(identical(state, updated), isTrue); // 동일 객체 반환
      });

      test('unlockCountry - 국가 해금', () {
        // Given
        const state = UnlockState();

        // When
        final updated = state.unlockCountry('korea');

        // Then
        expect(updated.isCountryUnlocked('korea'), isTrue);
      });

      test('unlockEra - 시대 해금', () {
        // Given
        const state = UnlockState();

        // When
        final updated = state.unlockEra('joseon');

        // Then
        expect(updated.isEraUnlocked('joseon'), isTrue);
      });

      test('unlockCharacter - 인물 해금', () {
        // Given
        const state = UnlockState();

        // When
        final updated = state.unlockCharacter('sejong');

        // Then
        expect(updated.isCharacterUnlocked('sejong'), isTrue);
      });

      test('unlockFact - 역사 사실 해금', () {
        // Given
        const state = UnlockState();

        // When
        final updated = state.unlockFact('fact_1');

        // Then
        expect(updated.isFactUnlocked('fact_1'), isTrue);
      });

      test('연속 해금 - 여러 항목 순차적으로 해금', () {
        // Given
        const state = UnlockState();

        // When
        final updated = state
            .unlockRegion('asia')
            .unlockCountry('korea')
            .unlockEra('joseon')
            .unlockCharacter('sejong');

        // Then
        expect(updated.isRegionUnlocked('asia'), isTrue);
        expect(updated.isCountryUnlocked('korea'), isTrue);
        expect(updated.isEraUnlocked('joseon'), isTrue);
        expect(updated.isCharacterUnlocked('sejong'), isTrue);
      });
    });

    // =========================================================
    // 통계 테스트
    // =========================================================
    group('통계', () {
      test('unlockedCharacterCount - 해금된 인물 수', () {
        // Given
        const state = UnlockState(
          unlockedCharacterIds: ['sejong', 'yi_sun_sin', 'gwanggaeto'],
        );

        // Then
        expect(state.unlockedCharacterCount, equals(3));
      });

      test('unlockedFactCount - 해금된 역사 사실 수', () {
        // Given
        const state = UnlockState(
          unlockedFactIds: ['fact_1', 'fact_2'],
        );

        // Then
        expect(state.unlockedFactCount, equals(2));
      });
    });

    // =========================================================
    // Equatable 테스트
    // =========================================================
    group('Equatable', () {
      test('동일한 속성을 가진 두 객체는 같아야 함', () {
        // Given
        const state1 = UnlockState(
          unlockedRegionIds: ['asia'],
          unlockedEraIds: ['joseon'],
        );
        const state2 = UnlockState(
          unlockedRegionIds: ['asia'],
          unlockedEraIds: ['joseon'],
        );

        // Then
        expect(state1, equals(state2));
      });

      test('다른 속성을 가진 두 객체는 달라야 함', () {
        // Given
        const state1 = UnlockState(unlockedRegionIds: ['asia']);
        const state2 = UnlockState(unlockedRegionIds: ['europe']);

        // Then
        expect(state1, isNot(equals(state2)));
      });
    });

    // =========================================================
    // toString 테스트
    // =========================================================
    group('toString', () {
      test('toString이 해금된 항목 수를 포함해야 함', () {
        // Given
        const state = UnlockState(
          unlockedRegionIds: ['asia', 'europe'],
          unlockedCountryIds: ['korea'],
          unlockedEraIds: ['joseon', 'goryeo', 'baekje'],
        );

        // When
        final result = state.toString();

        // Then
        expect(result, contains('UnlockState'));
        expect(result, contains('2')); // regions
        expect(result, contains('1')); // countries
        expect(result, contains('3')); // eras
      });
    });
  });
}
