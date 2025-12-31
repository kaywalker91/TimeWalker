/// UseCase 기본 인터페이스
library;

/// UseCase 기본 인터페이스
/// 
/// 모든 UseCase는 이 인터페이스를 구현합니다.
/// - Input: 입력 파라미터 타입
/// - Output: 출력 결과 타입
abstract class UseCase<Input, Output> {
  Future<Output> call(Input params);
}

/// 입력 파라미터가 없는 UseCase
abstract class NoParamsUseCase<Output> {
  Future<Output> call();
}

/// 결과를 감싸는 Result 클래스
/// Either 패턴의 간소화된 구현
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  AppFailure? get failure => isFailure ? (this as Failure<T>).failure : null;

  /// Result를 처리하는 fold 메서드
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as Failure<T>).failure);
    }
  }
}

/// 성공 결과
class Success<T> extends Result<T> {
  @override
  final T data;

  const Success(this.data);
}

/// 실패 결과
class Failure<T> extends Result<T> {
  @override
  final AppFailure failure;

  const Failure(this.failure);
}

/// 앱 에러 타입
sealed class AppFailure {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppFailure({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppFailure(code: $code, message: $message)';
}

/// 네트워크 에러
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message = '네트워크 연결을 확인해주세요.',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

/// 서버 에러
class ServerFailure extends AppFailure {
  const ServerFailure({
    super.message = '서버 오류가 발생했습니다.',
    super.code = 'SERVER_ERROR',
    super.originalError,
  });
}

/// 데이터를 찾을 수 없음
class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    super.message = '요청한 데이터를 찾을 수 없습니다.',
    super.code = 'NOT_FOUND',
    super.originalError,
  });
}

/// 권한 없음
class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure({
    super.message = '접근 권한이 없습니다.',
    super.code = 'UNAUTHORIZED',
    super.originalError,
  });
}

/// 잠금된 콘텐츠
class LockedContentFailure extends AppFailure {
  final String contentId;
  final String contentType;
  final int? requiredLevel;

  const LockedContentFailure({
    required this.contentId,
    required this.contentType,
    this.requiredLevel,
    super.message = '콘텐츠가 잠겨 있습니다.',
    super.code = 'LOCKED_CONTENT',
    super.originalError,
  });
}

/// 캐시 에러
class CacheFailure extends AppFailure {
  const CacheFailure({
    super.message = '로컬 데이터 처리 중 오류가 발생했습니다.',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

/// 알 수 없는 에러
class UnknownFailure extends AppFailure {
  const UnknownFailure({
    super.message = '알 수 없는 오류가 발생했습니다.',
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
  });
}

/// 에러를 AppFailure로 변환하는 유틸리티
AppFailure mapExceptionToFailure(dynamic error) {
  if (error is AppFailure) return error;
  
  final errorString = error.toString().toLowerCase();
  
  if (errorString.contains('socket') || 
      errorString.contains('network') ||
      errorString.contains('connection')) {
    return NetworkFailure(originalError: error);
  }
  
  if (errorString.contains('not found') || 
      errorString.contains('404')) {
    return NotFoundFailure(originalError: error);
  }
  
  if (errorString.contains('unauthorized') || 
      errorString.contains('401') ||
      errorString.contains('403')) {
    return UnauthorizedFailure(originalError: error);
  }
  
  return UnknownFailure(message: error.toString(), originalError: error);
}
