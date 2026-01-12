import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/errors/errors.dart';

void main() {
  group('Result', () {
    // =========================================================
    // Success 테스트
    // =========================================================
    group('Success', () {
      test('값을 정상적으로 담아야 함', () {
        // Given
        const result = Success(42);

        // Then
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.valueOrNull, equals(42));
        expect(result.errorOrNull, isNull);
      });

      test('when - success 콜백이 호출되어야 함', () {
        // Given
        const result = Success('hello');
        var callbackCalled = false;

        // When
        final output = result.when(
          success: (value) {
            callbackCalled = true;
            return value.toUpperCase();
          },
          failure: (error) => 'error',
        );

        // Then
        expect(callbackCalled, isTrue);
        expect(output, equals('HELLO'));
      });

      test('map - 값을 변환해야 함', () {
        // Given
        const result = Success(10);

        // When
        final mapped = result.map((value) => value * 2);

        // Then
        expect(mapped.valueOrNull, equals(20));
      });

      test('flatMap - 새로운 Result를 반환해야 함', () {
        // Given
        const result = Success(5);

        // When
        final flatMapped = result.flatMap((value) => Success(value.toString()));

        // Then
        expect(flatMapped.valueOrNull, equals('5'));
      });

      test('getOrElse - 원래 값을 반환해야 함', () {
        // Given
        const result = Success(100);

        // When
        final value = result.getOrElse(0);

        // Then
        expect(value, equals(100));
      });

      test('getOrThrow - 원래 값을 반환해야 함', () {
        // Given
        const result = Success('success');

        // When
        final value = result.getOrThrow();

        // Then
        expect(value, equals('success'));
      });
    });

    // =========================================================
    // Failure 테스트
    // =========================================================
    group('Failure', () {
      test('에러를 정상적으로 담아야 함', () {
        // Given
        const error = DataException(message: 'Test error', code: 'TEST');
        const result = Failure<int>(error);

        // Then
        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.valueOrNull, isNull);
        expect(result.errorOrNull, equals(error));
      });

      test('when - failure 콜백이 호출되어야 함', () {
        // Given
        const error = NetworkException(message: 'Network error');
        const result = Failure<String>(error);
        var callbackCalled = false;

        // When
        final output = result.when(
          success: (value) => 'success',
          failure: (e) {
            callbackCalled = true;
            return 'failed: ${e.message}';
          },
        );

        // Then
        expect(callbackCalled, isTrue);
        expect(output, equals('failed: Network error'));
      });

      test('map - 에러가 유지되어야 함', () {
        // Given
        const error = DataException(message: 'Error');
        const result = Failure<int>(error);

        // When
        final mapped = result.map((value) => value * 2);

        // Then
        expect(mapped.isFailure, isTrue);
        expect(mapped.errorOrNull?.message, equals('Error'));
      });

      test('flatMap - 에러가 유지되어야 함', () {
        // Given
        const error = GameLogicException(message: 'Logic error');
        const result = Failure<int>(error);

        // When
        final flatMapped = result.flatMap((value) => Success(value.toString()));

        // Then
        expect(flatMapped.isFailure, isTrue);
      });

      test('getOrElse - 기본값을 반환해야 함', () {
        // Given
        const error = AuthException(message: 'Auth error');
        const result = Failure<int>(error);

        // When
        final value = result.getOrElse(999);

        // Then
        expect(value, equals(999));
      });

      test('getOrThrow - 예외를 던져야 함', () {
        // Given
        const error = ValidationException(message: 'Validation error');
        const result = Failure<String>(error);

        // Then
        expect(() => result.getOrThrow(), throwsA(isA<AppException>()));
      });

      test('mapError - 에러를 변환해야 함', () {
        // Given
        const originalError = DataException(message: 'Original');
        const result = Failure<int>(originalError);

        // When
        final mapped = result.mapError(
          (e) => const GameLogicException(message: 'Transformed'),
        );

        // Then
        expect(mapped.errorOrNull, isA<GameLogicException>());
      });
    });

    // =========================================================
    // onSuccess / onFailure 테스트
    // =========================================================
    group('Side effects', () {
      test('onSuccess - 성공 시 부수 효과 실행', () {
        // Given
        const result = Success(42);
        var sideEffect = 0;

        // When
        result.onSuccess((value) => sideEffect = value);

        // Then
        expect(sideEffect, equals(42));
      });

      test('onFailure - 실패 시 부수 효과 실행', () {
        // Given
        const error = DataException(message: 'Test');
        const result = Failure<int>(error);
        String? capturedMessage;

        // When
        result.onFailure((e) => capturedMessage = e.message);

        // Then
        expect(capturedMessage, equals('Test'));
      });
    });
  });

  // =========================================================
  // runCatching 테스트
  // =========================================================
  group('runCatching', () {
    test('성공 시 Success 반환', () async {
      // When
      final result = await runCatching(() async => 'hello');

      // Then
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, equals('hello'));
    });

    test('실패 시 Failure 반환', () async {
      // When
      final result = await runCatching<String>(() async {
        throw const DataException(message: 'Test error');
      });

      // Then
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull?.message, equals('Test error'));
    });

    test('일반 Exception도 처리', () async {
      // When
      final result = await runCatching<String>(() async {
        throw Exception('Generic error');
      });

      // Then
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<UnexpectedException>());
    });

    test('onError 콜백으로 커스텀 에러 생성', () async {
      // When
      final result = await runCatching<String>(
        () async => throw Exception('Original'),
        onError: (e, st) => const NetworkException(message: 'Custom'),
      );

      // Then
      expect(result.errorOrNull, isA<NetworkException>());
      expect(result.errorOrNull?.message, equals('Custom'));
    });
  });

  // =========================================================
  // combine 테스트
  // =========================================================
  group('combine', () {
    test('모든 Success면 Success 리스트 반환', () {
      // Given
      final results = [
        const Success(1),
        const Success(2),
        const Success(3),
      ];

      // When
      final combined = results.combine();

      // Then
      expect(combined.isSuccess, isTrue);
      expect(combined.valueOrNull, equals([1, 2, 3]));
    });

    test('하나라도 Failure면 첫 번째 Failure 반환', () {
      // Given
      final results = <Result<int>>[
        const Success(1),
        const Failure(DataException(message: 'Error')),
        const Success(3),
      ];

      // When
      final combined = results.combine();

      // Then
      expect(combined.isFailure, isTrue);
      expect(combined.errorOrNull?.message, equals('Error'));
    });
  });
}
