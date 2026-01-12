import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/domain/entities/exploration_state.dart';

void main() {
  group('ExplorationState', () {
    // =========================================================
    // 기본 생성 및 copyWith 테스트
    // =========================================================
    group('생성자 및 copyWith', () {
      test('기본값으로 생성 시 올바른 초기값을 가져야 함', () {
        // When
        const state = ExplorationState();

        // Then
        expect(state.regionProgress, isEmpty);
        expect(state.countryProgress, isEmpty);
        expect(state.eraProgress, isEmpty);
        expect(state.totalKnowledge, equals(0));
      });

      test('모든 필드를 지정하여 생성 가능해야 함', () {
        // When
        const state = ExplorationState(
          regionProgress: {'asia': 0.5, 'europe': 0.3},
          countryProgress: {'korea': 0.8, 'japan': 0.2},
          eraProgress: {'joseon': 1.0, 'goryeo': 0.5},
          totalKnowledge: 5000,
        );

        // Then
        expect(state.regionProgress, equals({'asia': 0.5, 'europe': 0.3}));
        expect(state.countryProgress, equals({'korea': 0.8, 'japan': 0.2}));
        expect(state.eraProgress, equals({'joseon': 1.0, 'goryeo': 0.5}));
        expect(state.totalKnowledge, equals(5000));
      });

      test('copyWith으로 특정 필드만 변경 가능해야 함', () {
        // Given
        const original = ExplorationState(
          totalKnowledge: 1000,
          eraProgress: {'joseon': 0.5},
        );

        // When
        final updated = original.copyWith(totalKnowledge: 2000);

        // Then
        expect(updated.totalKnowledge, equals(2000));
        expect(updated.eraProgress, equals({'joseon': 0.5})); // 변경 안 됨
      });
    });

    // =========================================================
    // 진행률 조회 테스트
    // =========================================================
    group('진행률 조회', () {
      test('getRegionProgress - 존재하는 지역 진행률', () {
        // Given
        const state = ExplorationState(
          regionProgress: {'asia': 0.75, 'europe': 0.5},
        );

        // Then
        expect(state.getRegionProgress('asia'), equals(0.75));
        expect(state.getRegionProgress('europe'), equals(0.5));
      });

      test('getRegionProgress - 존재하지 않는 지역은 0.0', () {
        // Given
        const state = ExplorationState(
          regionProgress: {'asia': 0.75},
        );

        // Then
        expect(state.getRegionProgress('africa'), equals(0.0));
      });

      test('getCountryProgress - 국가 진행률 조회', () {
        // Given
        const state = ExplorationState(
          countryProgress: {'korea': 0.8, 'japan': 0.3},
        );

        // Then
        expect(state.getCountryProgress('korea'), equals(0.8));
        expect(state.getCountryProgress('china'), equals(0.0));
      });

      test('getEraProgress - 시대 진행률 조회', () {
        // Given
        const state = ExplorationState(
          eraProgress: {'joseon': 1.0, 'goryeo': 0.6},
        );

        // Then
        expect(state.getEraProgress('joseon'), equals(1.0));
        expect(state.getEraProgress('goryeo'), equals(0.6));
        expect(state.getEraProgress('baekje'), equals(0.0));
      });
    });

    // =========================================================
    // 전체 진행률 계산 테스트
    // =========================================================
    group('overallProgress', () {
      test('overallProgress - 여러 시대의 평균 계산', () {
        // Given
        const state = ExplorationState(
          eraProgress: {
            'joseon': 1.0,      // 100%
            'goryeo': 0.5,      // 50%
            'baekje': 0.0,      // 0%
          },
        );

        // Then: 평균 = (1.0 + 0.5 + 0.0) / 3 ≈ 0.5
        expect(state.overallProgress, closeTo(0.5, 0.001));
      });

      test('overallProgress - 시대가 없으면 0.0', () {
        // Given
        const state = ExplorationState(eraProgress: {});

        // Then
        expect(state.overallProgress, equals(0.0));
      });

      test('overallProgress - 모두 완료 시 1.0', () {
        // Given
        const state = ExplorationState(
          eraProgress: {'era1': 1.0, 'era2': 1.0, 'era3': 1.0},
        );

        // Then
        expect(state.overallProgress, equals(1.0));
      });
    });

    // =========================================================
    // 진행률 업데이트 테스트
    // =========================================================
    group('진행률 업데이트', () {
      test('updateRegionProgress - 지역 진행률 업데이트', () {
        // Given
        const state = ExplorationState(
          regionProgress: {'asia': 0.3},
        );

        // When
        final updated = state.updateRegionProgress('asia', 0.8);

        // Then
        expect(updated.getRegionProgress('asia'), equals(0.8));
        expect(state.getRegionProgress('asia'), equals(0.3)); // 원본 불변
      });

      test('updateRegionProgress - 새 지역 추가', () {
        // Given
        const state = ExplorationState(
          regionProgress: {'asia': 0.5},
        );

        // When
        final updated = state.updateRegionProgress('europe', 0.3);

        // Then
        expect(updated.getRegionProgress('asia'), equals(0.5));
        expect(updated.getRegionProgress('europe'), equals(0.3));
      });

      test('updateRegionProgress - 값이 0.0~1.0으로 클램프됨', () {
        // Given
        const state = ExplorationState();

        // When
        final updated1 = state.updateRegionProgress('asia', 1.5); // 1보다 큼
        final updated2 = state.updateRegionProgress('europe', -0.5); // 0보다 작음

        // Then
        expect(updated1.getRegionProgress('asia'), equals(1.0));
        expect(updated2.getRegionProgress('europe'), equals(0.0));
      });

      test('updateEraProgress - 시대 진행률 업데이트', () {
        // Given
        const state = ExplorationState(
          eraProgress: {'joseon': 0.5},
        );

        // When
        final updated = state.updateEraProgress('joseon', 0.9);

        // Then
        expect(updated.getEraProgress('joseon'), equals(0.9));
      });

      test('addKnowledge - 지식 포인트 추가', () {
        // Given
        const state = ExplorationState(totalKnowledge: 1000);

        // When
        final updated = state.addKnowledge(500);

        // Then
        expect(updated.totalKnowledge, equals(1500));
        expect(state.totalKnowledge, equals(1000)); // 원본 불변
      });
    });

    // =========================================================
    // Equatable 테스트
    // =========================================================
    group('Equatable', () {
      test('동일한 속성을 가진 두 객체는 같아야 함', () {
        // Given
        const state1 = ExplorationState(
          totalKnowledge: 1000,
          eraProgress: {'joseon': 0.5},
        );
        const state2 = ExplorationState(
          totalKnowledge: 1000,
          eraProgress: {'joseon': 0.5},
        );

        // Then
        expect(state1, equals(state2));
      });

      test('다른 속성을 가진 두 객체는 달라야 함', () {
        // Given
        const state1 = ExplorationState(totalKnowledge: 1000);
        const state2 = ExplorationState(totalKnowledge: 2000);

        // Then
        expect(state1, isNot(equals(state2)));
      });
    });

    // =========================================================
    // toString 테스트
    // =========================================================
    group('toString', () {
      test('toString이 totalKnowledge와 overallProgress를 포함해야 함', () {
        // Given
        const state = ExplorationState(
          totalKnowledge: 5000,
          eraProgress: {'joseon': 1.0, 'goryeo': 0.5},
        );

        // When
        final result = state.toString();

        // Then
        expect(result, contains('5000'));
        expect(result, contains('ExplorationState'));
      });
    });
  });
}
