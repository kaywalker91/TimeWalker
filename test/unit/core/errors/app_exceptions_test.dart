import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/errors/errors.dart';

void main() {
  group('AppExceptions', () {
    // =========================================================
    // NetworkException 테스트
    // =========================================================
    group('NetworkException', () {
      test('기본 생성', () {
        // Given
        const exception = NetworkException(
          message: '네트워크 오류',
          code: 'NET_001',
          statusCode: 500,
        );

        // Then
        expect(exception.message, equals('네트워크 오류'));
        expect(exception.code, equals('NET_001'));
        expect(exception.statusCode, equals(500));
      });

      test('timeout 팩토리', () {
        // When
        final exception = NetworkException.timeout();

        // Then
        expect(exception.code, equals('NETWORK_TIMEOUT'));
        expect(exception.message, contains('시간이 초과'));
      });

      test('noConnection 팩토리', () {
        // When
        final exception = NetworkException.noConnection();

        // Then
        expect(exception.code, equals('NO_CONNECTION'));
        expect(exception.message, contains('인터넷'));
      });

      test('serverError 팩토리', () {
        // When
        final exception = NetworkException.serverError(statusCode: 503);

        // Then
        expect(exception.code, equals('SERVER_ERROR'));
        expect(exception.statusCode, equals(503));
      });
    });

    // =========================================================
    // DataException 테스트
    // =========================================================
    group('DataException', () {
      test('parsingFailed 팩토리', () {
        // When
        final exception = DataException.parsingFailed(dataType: 'JSON');

        // Then
        expect(exception.code, equals('PARSING_FAILED'));
        expect(exception.message, contains('JSON'));
      });

      test('notFound 팩토리', () {
        // When
        final exception = DataException.notFound(resourceName: '사용자');

        // Then
        expect(exception.code, equals('NOT_FOUND'));
        expect(exception.message, contains('사용자'));
        expect(exception.message, contains('찾을 수 없습니다'));
      });

      test('saveFailed 팩토리', () {
        // When
        final exception = DataException.saveFailed();

        // Then
        expect(exception.code, equals('SAVE_FAILED'));
      });

      test('loadFailed 팩토리', () {
        // When
        final exception = DataException.loadFailed(
          message: '커스텀 메시지',
        );

        // Then
        expect(exception.code, equals('LOAD_FAILED'));
        expect(exception.message, equals('커스텀 메시지'));
      });
    });

    // =========================================================
    // GameLogicException 테스트
    // =========================================================
    group('GameLogicException', () {
      test('notUnlocked 팩토리', () {
        // When
        final exception = GameLogicException.notUnlocked(resourceName: '조선 시대');

        // Then
        expect(exception.code, equals('NOT_UNLOCKED'));
        expect(exception.message, contains('조선 시대'));
        expect(exception.message, contains('해금'));
      });

      test('conditionNotMet 팩토리', () {
        // When
        final exception = GameLogicException.conditionNotMet(
          condition: '최소 레벨 5',
        );

        // Then
        expect(exception.code, equals('CONDITION_NOT_MET'));
        expect(exception.message, contains('최소 레벨 5'));
      });

      test('invalidState 팩토리', () {
        // When
        final exception = GameLogicException.invalidState(
          description: '잘못된 게임 상태',
        );

        // Then
        expect(exception.code, equals('INVALID_STATE'));
      });
    });

    // =========================================================
    // AuthException 테스트
    // =========================================================
    group('AuthException', () {
      test('unauthenticated 팩토리', () {
        // When
        final exception = AuthException.unauthenticated();

        // Then
        expect(exception.code, equals('UNAUTHENTICATED'));
        expect(exception.message, contains('로그인'));
      });

      test('unauthorized 팩토리', () {
        // When
        final exception = AuthException.unauthorized();

        // Then
        expect(exception.code, equals('UNAUTHORIZED'));
        expect(exception.message, contains('권한'));
      });

      test('sessionExpired 팩토리', () {
        // When
        final exception = AuthException.sessionExpired();

        // Then
        expect(exception.code, equals('SESSION_EXPIRED'));
        expect(exception.message, contains('만료'));
      });
    });

    // =========================================================
    // ValidationException 테스트
    // =========================================================
    group('ValidationException', () {
      test('field 팩토리', () {
        // When
        final exception = ValidationException.field(
          fieldName: '이메일',
          reason: '형식이 올바르지 않습니다',
        );

        // Then
        expect(exception.code, equals('FIELD_VALIDATION'));
        expect(exception.fieldErrors?['이메일'], contains('형식'));
      });

      test('multiple 팩토리', () {
        // When
        final exception = ValidationException.multiple(
          errors: {
            '이름': '필수 항목입니다',
            '나이': '숫자만 입력하세요',
          },
        );

        // Then
        expect(exception.code, equals('MULTIPLE_VALIDATION'));
        expect(exception.fieldErrors?.length, equals(2));
      });
    });

    // =========================================================
    // UnexpectedException 테스트
    // =========================================================
    group('UnexpectedException', () {
      test('기본 생성', () {
        // Given
        const exception = UnexpectedException();

        // Then
        expect(exception.code, equals('UNEXPECTED'));
        expect(exception.message, contains('예상치 못한'));
      });

      test('from 팩토리', () {
        // Given
        final originalError = Exception('Original error');

        // When
        final exception = UnexpectedException.from(originalError);

        // Then
        expect(exception.originalError, equals(originalError));
      });
    });
  });

  // =========================================================
  // ErrorHandler 테스트
  // =========================================================
  group('ErrorHandler', () {
    test('toUserMessage - AppException 처리', () {
      // Given
      const exception = DataException(message: '사용자 메시지');

      // When
      final message = ErrorHandler.toUserMessage(exception);

      // Then
      expect(message, equals('사용자 메시지'));
    });

    test('toUserMessage - 일반 Exception 처리', () {
      // Given
      final exception = Exception('Unknown error');

      // When
      final message = ErrorHandler.toUserMessage(exception);

      // Then
      expect(message, contains('오류'));
    });

    test('toAppException - AppException은 그대로 반환', () {
      // Given
      const exception = NetworkException(message: 'Test');

      // When
      final result = ErrorHandler.toAppException(exception);

      // Then
      expect(result, same(exception));
    });

    test('toAppException - 일반 Exception을 변환', () {
      // Given
      final exception = Exception('Unknown');

      // When
      final result = ErrorHandler.toAppException(exception);

      // Then
      expect(result, isA<UnexpectedException>());
    });

    test('getErrorIcon - 예외 타입에 따른 아이콘', () {
      expect(
        ErrorHandler.getErrorIcon(const NetworkException(message: '')),
        equals('🌐'),
      );
      expect(
        ErrorHandler.getErrorIcon(const DataException(message: '')),
        equals('📁'),
      );
      expect(
        ErrorHandler.getErrorIcon(const GameLogicException(message: '')),
        equals('🎮'),
      );
    });

    test('isRetryable - 재시도 가능 판단', () {
      expect(
        ErrorHandler.isRetryable(const NetworkException(message: '')),
        isTrue,
      );
      expect(
        ErrorHandler.isRetryable(DataException.loadFailed()),
        isTrue,
      );
      expect(
        ErrorHandler.isRetryable(const AuthException(message: '')),
        isFalse,
      );
    });
  });
}
