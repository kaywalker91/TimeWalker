/// TimeWalker 앱 예외 클래스 체계
/// 
/// 앱 전체에서 사용되는 예외를 정의합니다.
/// sealed class를 사용하여 예외 타입을 명확히 구분합니다.
library;

/// 앱 기본 예외 클래스
/// 
/// 모든 커스텀 예외의 기반 클래스입니다.
/// sealed class로 선언하여 패턴 매칭을 지원합니다.
sealed class AppException implements Exception {
  /// 사용자에게 표시할 메시지
  final String message;
  
  /// 개발자용 기술적 에러 코드 (선택적)
  final String? code;
  
  /// 원본 에러 (디버깅용)
  final Object? originalError;
  
  /// 스택 트레이스 (디버깅용)
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// 네트워크 관련 예외
/// 
/// API 호출, 인터넷 연결 등의 문제
class NetworkException extends AppException {
  /// HTTP 상태 코드 (있는 경우)
  final int? statusCode;

  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.statusCode,
  });

  /// 타임아웃 예외 생성
  factory NetworkException.timeout({String? code}) {
    return NetworkException(
      message: '서버 응답 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.',
      code: code ?? 'NETWORK_TIMEOUT',
    );
  }

  /// 네트워크 연결 불가 예외 생성
  factory NetworkException.noConnection({String? code}) {
    return NetworkException(
      message: '인터넷 연결을 확인해주세요.',
      code: code ?? 'NO_CONNECTION',
    );
  }

  /// 서버 에러 예외 생성
  factory NetworkException.serverError({int? statusCode, String? code}) {
    return NetworkException(
      message: '서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요.',
      code: code ?? 'SERVER_ERROR',
      statusCode: statusCode,
    );
  }

  @override
  String toString() => 'NetworkException: $message (status: $statusCode, code: $code)';
}

/// 데이터 관련 예외
/// 
/// 데이터 파싱, 저장, 로드 등의 문제
class DataException extends AppException {
  const DataException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// 데이터 파싱 실패
  factory DataException.parsingFailed({
    required String dataType,
    Object? originalError,
    StackTrace? stackTrace,
  }) {
    return DataException(
      message: '$dataType 데이터를 불러오는데 실패했습니다.',
      code: 'PARSING_FAILED',
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  /// 데이터 없음
  factory DataException.notFound({required String resourceName}) {
    return DataException(
      message: '$resourceName을(를) 찾을 수 없습니다.',
      code: 'NOT_FOUND',
    );
  }

  /// 저장 실패
  factory DataException.saveFailed({
    String? message,
    Object? originalError,
  }) {
    return DataException(
      message: message ?? '데이터 저장에 실패했습니다.',
      code: 'SAVE_FAILED',
      originalError: originalError,
    );
  }

  /// 로드 실패
  factory DataException.loadFailed({
    String? message,
    Object? originalError,
  }) {
    return DataException(
      message: message ?? '데이터 불러오기에 실패했습니다.',
      code: 'LOAD_FAILED',
      originalError: originalError,
    );
  }

  @override
  String toString() => 'DataException: $message (code: $code)';
}

/// 게임 로직 관련 예외
/// 
/// 게임 규칙 위반, 조건 불충족 등
class GameLogicException extends AppException {
  const GameLogicException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// 해금 조건 미충족
  factory GameLogicException.notUnlocked({required String resourceName}) {
    return GameLogicException(
      message: '$resourceName이(가) 아직 해금되지 않았습니다.',
      code: 'NOT_UNLOCKED',
    );
  }

  /// 조건 불충족
  factory GameLogicException.conditionNotMet({required String condition}) {
    return GameLogicException(
      message: '$condition 조건을 충족하지 않습니다.',
      code: 'CONDITION_NOT_MET',
    );
  }

  /// 진행 불가
  factory GameLogicException.cannotProceed({required String reason}) {
    return GameLogicException(
      message: reason,
      code: 'CANNOT_PROCEED',
    );
  }

  /// 잘못된 상태
  factory GameLogicException.invalidState({required String description}) {
    return GameLogicException(
      message: description,
      code: 'INVALID_STATE',
    );
  }

  @override
  String toString() => 'GameLogicException: $message (code: $code)';
}

/// 인증 관련 예외
/// 
/// 로그인, 권한 등의 문제
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// 미인증 상태
  factory AuthException.unauthenticated() {
    return const AuthException(
      message: '로그인이 필요합니다.',
      code: 'UNAUTHENTICATED',
    );
  }

  /// 권한 없음
  factory AuthException.unauthorized() {
    return const AuthException(
      message: '접근 권한이 없습니다.',
      code: 'UNAUTHORIZED',
    );
  }

  /// 세션 만료
  factory AuthException.sessionExpired() {
    return const AuthException(
      message: '세션이 만료되었습니다. 다시 로그인해주세요.',
      code: 'SESSION_EXPIRED',
    );
  }

  @override
  String toString() => 'AuthException: $message (code: $code)';
}

/// 유효성 검사 예외
/// 
/// 입력값 검증 실패 등
class ValidationException extends AppException {
  /// 검증 실패한 필드 목록
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.fieldErrors,
  });

  /// 필드 검증 실패
  factory ValidationException.field({
    required String fieldName,
    required String reason,
  }) {
    return ValidationException(
      message: '$fieldName: $reason',
      code: 'FIELD_VALIDATION',
      fieldErrors: {fieldName: reason},
    );
  }

  /// 다중 필드 검증 실패
  factory ValidationException.multiple({
    required Map<String, String> errors,
  }) {
    final messages = errors.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    return ValidationException(
      message: messages,
      code: 'MULTIPLE_VALIDATION',
      fieldErrors: errors,
    );
  }

  @override
  String toString() => 'ValidationException: $message (fields: $fieldErrors)';
}

/// 예상치 못한 예외
/// 
/// 분류되지 않은 에러를 래핑
class UnexpectedException extends AppException {
  const UnexpectedException({
    super.message = '예상치 못한 오류가 발생했습니다.',
    super.code = 'UNEXPECTED',
    super.originalError,
    super.stackTrace,
  });

  /// 원본 에러로부터 생성
  factory UnexpectedException.from(Object error, [StackTrace? stackTrace]) {
    return UnexpectedException(
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() => 'UnexpectedException: $message (original: $originalError)';
}
