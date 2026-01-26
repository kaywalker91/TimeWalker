import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/data/repositories/mock_era_repository.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/presentation/themes/era_theme_registry.dart';

void main() {
  group('MockEraRepository', () {
    late MockEraRepository repository;

    setUp(() {
      repository = MockEraRepository();
    });

    group('getAllEras', () {
      test('returns list of all eras', () async {
        // Act
        final eras = await repository.getAllEras();

        // Assert
        expect(eras, isNotEmpty);
        expect(eras, isA<List<Era>>());
      });

      test('returns fresh data on each call (for hot reload support)', () async {
        // Act
        final eras1 = await repository.getAllEras();
        final eras2 = await repository.getAllEras();

        // Assert
        expect(eras1.length, equals(eras2.length));
        // Lists should be equal but not identical references
        expect(eras1, equals(eras2));
        expect(identical(eras1, eras2), isFalse);
      });
    });

    group('getErasByCountry', () {
      test('returns eras filtered by country id', () async {
        // Arrange
        const countryId = 'korea';

        // Act
        final eras = await repository.getErasByCountry(countryId);

        // Assert
        expect(eras, isA<List<Era>>());
        for (final era in eras) {
          expect(era.countryId, equals(countryId));
        }
      });

      test('returns empty list for non-existent country', () async {
        // Arrange
        const countryId = 'non_existent_country_xyz';

        // Act
        final eras = await repository.getErasByCountry(countryId);

        // Assert
        expect(eras, isEmpty);
      });

      test('filters correctly for japan country', () async {
        // Arrange
        const countryId = 'japan';

        // Act
        final eras = await repository.getErasByCountry(countryId);

        // Assert - all returned eras should belong to japan
        for (final era in eras) {
          expect(era.countryId, equals(countryId));
        }
      });

      test('filters correctly for china country', () async {
        // Arrange
        const countryId = 'china';

        // Act
        final eras = await repository.getErasByCountry(countryId);

        // Assert - all returned eras should belong to china
        for (final era in eras) {
          expect(era.countryId, equals(countryId));
        }
      });
    });

    group('getEraById', () {
      test('returns era for valid id', () async {
        // Arrange - first get all eras to find a valid id
        final allEras = await repository.getAllEras();
        expect(allEras, isNotEmpty, reason: 'Need at least one era for test');
        final validId = allEras.first.id;

        // Act
        final era = await repository.getEraById(validId);

        // Assert
        expect(era, isNotNull);
        expect(era!.id, equals(validId));
      });

      test('returns null for non-existent id', () async {
        // Arrange
        const invalidId = 'non_existent_era_id_xyz';

        // Act
        final era = await repository.getEraById(invalidId);

        // Assert
        expect(era, isNull);
      });

      test('returns correct era data', () async {
        // Arrange - get first era
        final allEras = await repository.getAllEras();
        final targetEra = allEras.first;

        // Act
        final era = await repository.getEraById(targetEra.id);

        // Assert
        expect(era, isNotNull);
        expect(era!.id, equals(targetEra.id));
        expect(era.name, equals(targetEra.name));
        expect(era.nameKorean, equals(targetEra.nameKorean));
        expect(era.countryId, equals(targetEra.countryId));
      });
    });

    group('unlockEra', () {
      test('unlocks a locked era', () async {
        // Arrange - find a locked era
        final allEras = await repository.getAllEras();
        final lockedEra = allEras.where((e) => e.status == ContentStatus.locked).firstOrNull;
        
        if (lockedEra == null) {
          // Skip if no locked era exists (all are available)
          return;
        }

        // Act
        await repository.unlockEra(lockedEra.id);
        final updatedEra = await repository.getEraById(lockedEra.id);

        // Assert
        expect(updatedEra, isNotNull);
        expect(updatedEra!.status, equals(ContentStatus.available));
      });

      test('does not throw for non-existent id', () async {
        // Arrange
        const invalidId = 'non_existent_era_id_xyz';

        // Act & Assert - should not throw
        await expectLater(
          repository.unlockEra(invalidId),
          completes,
        );
      });

      test('unlocking already unlocked era does not cause issues', () async {
        // Arrange - find an available era
        final allEras = await repository.getAllEras();
        final availableEra = allEras.where((e) => e.status == ContentStatus.available).firstOrNull;
        
        if (availableEra == null) {
          return;
        }

        // Act & Assert - should not throw
        await expectLater(
          repository.unlockEra(availableEra.id),
          completes,
        );

        // Verify status is still available
        final updatedEra = await repository.getEraById(availableEra.id);
        expect(updatedEra?.status, equals(ContentStatus.available));
      });
    });

    group('data integrity', () {
      test('all eras have required fields', () async {
        // Act
        final eras = await repository.getAllEras();

        // Assert
        for (final era in eras) {
          expect(era.id, isNotEmpty, reason: 'Era ID should not be empty');
          expect(era.name, isNotEmpty, reason: 'Era name should not be empty');
          expect(era.nameKorean, isNotEmpty, reason: 'Era Korean name should not be empty');
          expect(era.countryId, isNotEmpty, reason: 'Era countryId should not be empty');
          expect(era.period, isNotEmpty, reason: 'Era period should not be empty');
          expect(era.thumbnailAsset, isNotEmpty, reason: 'Era thumbnail should not be empty');
        }
      });

      test('all eras have valid year range', () async {
        // Act
        final eras = await repository.getAllEras();

        // Assert
        for (final era in eras) {
          // startYear can be negative (BC), but should be less than or equal to endYear
          expect(
            era.startYear <= era.endYear,
            isTrue,
            reason: 'Era ${era.id}: startYear (${era.startYear}) should be <= endYear (${era.endYear})',
          );
        }
      });

      test('all eras have valid theme', () async {
        // Act
        final eras = await repository.getAllEras();

        // Assert
        for (final era in eras) {
          expect(era.theme, isNotNull, reason: 'Era ${era.id} should have a theme');
          expect(era.theme.primaryColor, isNotNull);
          expect(era.theme.secondaryColor, isNotNull);
          expect(era.theme.accentColor, isNotNull);
          expect(era.theme.backgroundColor, isNotNull);
          expect(era.theme.textColor, isNotNull);
        }
      });
    });

    group('async behavior', () {
      test('getAllEras simulates async delay', () async {
        // This test verifies that the repository simulates network delay
        final stopwatch = Stopwatch()..start();
        await repository.getAllEras();
        stopwatch.stop();

        // Should have some delay (at least 100ms, since mock has 300ms delay)
        expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));
      });

      test('concurrent calls work correctly', () async {
        // Act - make concurrent calls
        final futures = List.generate(3, (_) => repository.getAllEras());
        final results = await Future.wait(futures);

        // Assert - all should return same data
        expect(results.length, equals(3));
        expect(results[0].length, equals(results[1].length));
        expect(results[1].length, equals(results[2].length));
      });
    });
  });
}
