/// Result 패턴 - 성공/실패를 명시적으로 처리
/// 
/// Either 패턴의 Dart 구현으로, 비동기 작업의 결과를 
/// 예외 없이 안전하게 처리할 수 있습니다.
library;

import 'package:time_walker/core/errors/app_exceptions.dart';

/// Result 타입 - 성공(Success) 또는 실패(Failure)
/// 
/// 사용 예시:
/// ```dart
/// Future<Result<User>> fetchUser(String id) async {
///   try {
///     final user = await api.getUser(id);
///     return Success(user);
///   } catch (e, st) {
///     return Failure(DataException.loadFailed(originalError: e));
///   }
/// }
/// 
/// // 사용
/// final result = await fetchUser('123');
/// result.when(
///   success: (user) => print('User: ${user.name}'),
///   failure: (error) => print('Error: ${error.message}'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// 성공 여부
  bool get isSuccess => this is Success<T>;

  /// 실패 여부
  bool get isFailure => this is Failure<T>;

  /// 값 가져오기 (실패 시 null)
  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };

  /// 에러 가져오기 (성공 시 null)
  AppException? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };

  /// 패턴 매칭 - 성공/실패에 따라 다른 처리
  R when<R>({
    required R Function(T value) success,
    required R Function(AppException error) failure,
  }) {
    return switch (this) {
      Success(:final value) => success(value),
      Failure(:final error) => failure(error),
    };
  }

  /// 성공 값 변환
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(:final value) => Success(transform(value)),
      Failure(:final error) => Failure(error),
    };
  }

  /// 성공 시 새로운 Result 반환
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return switch (this) {
      Success(:final value) => transform(value),
      Failure(:final error) => Failure(error),
    };
  }

  /// 실패 시 기본값 반환
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(:final value) => value,
      Failure() => defaultValue,
    };
  }

  /// 실패 시 콜백으로 기본값 생성
  T getOrElseGet(T Function(AppException error) defaultProvider) {
    return switch (this) {
      Success(:final value) => value,
      Failure(:final error) => defaultProvider(error),
    };
  }

  /// 실패 시 예외 던지기 (레거시 코드 호환용)
  T getOrThrow() {
    return switch (this) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }

  /// 에러 변환
  Result<T> mapError(AppException Function(AppException error) transform) {
    return switch (this) {
      Success() => this,
      Failure(:final error) => Failure(transform(error)),
    };
  }

  /// 성공 시 부수 효과 실행
  Result<T> onSuccess(void Function(T value) action) {
    if (this is Success<T>) {
      action((this as Success<T>).value);
    }
    return this;
  }

  /// 실패 시 부수 효과 실행
  Result<T> onFailure(void Function(AppException error) action) {
    if (this is Failure<T>) {
      action((this as Failure<T>).error);
    }
    return this;
  }

  /// 비동기 값 변환
  Future<Result<R>> mapAsync<R>(Future<R> Function(T value) transform) async {
    return switch (this) {
      Success(:final value) => Success(await transform(value)),
      Failure(:final error) => Failure(error),
    };
  }

  /// 비동기 flatMap
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T value) transform,
  ) async {
    return switch (this) {
      Success(:final value) => await transform(value),
      Failure(:final error) => Failure(error),
    };
  }
}

/// 성공 결과
class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// 실패 결과
class Failure<T> extends Result<T> {
  final AppException error;

  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && runtimeType == other.runtimeType && error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

/// Result 생성 헬퍼 함수들
extension ResultHelpers on Never {
  /// try-catch를 Result로 래핑
  static Future<Result<T>> tryAsync<T>(
    Future<T> Function() action, {
    AppException Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      return Success(await action());
    } catch (e, st) {
      if (onError != null) {
        return Failure(onError(e, st));
      }
      if (e is AppException) {
        return Failure(e);
      }
      return Failure(UnexpectedException.from(e, st));
    }
  }

  /// 동기 작업을 Result로 래핑
  static Result<T> trySync<T>(
    T Function() action, {
    AppException Function(Object error, StackTrace stackTrace)? onError,
  }) {
    try {
      return Success(action());
    } catch (e, st) {
      if (onError != null) {
        return Failure(onError(e, st));
      }
      if (e is AppException) {
        return Failure(e);
      }
      return Failure(UnexpectedException.from(e, st));
    }
  }
}

/// 비동기 작업을 Result로 래핑하는 유틸리티
Future<Result<T>> runCatching<T>(
  Future<T> Function() action, {
  AppException Function(Object error, StackTrace stackTrace)? onError,
}) async {
  try {
    return Success(await action());
  } catch (e, st) {
    if (onError != null) {
      return Failure(onError(e, st));
    }
    if (e is AppException) {
      return Failure(e);
    }
    return Failure(UnexpectedException.from(e, st));
  }
}

/// 동기 작업을 Result로 래핑하는 유틸리티
Result<T> runCatchingSync<T>(
  T Function() action, {
  AppException Function(Object error, StackTrace stackTrace)? onError,
}) {
  try {
    return Success(action());
  } catch (e, st) {
    if (onError != null) {
      return Failure(onError(e, st));
    }
    if (e is AppException) {
      return Failure(e);
    }
    return Failure(UnexpectedException.from(e, st));
  }
}

/// 여러 Result를 결합
extension ResultCombine<T> on List<Result<T>> {
  /// 모든 Result가 성공이면 `Success(List<T>)`, 하나라도 실패면 첫 번째 Failure 반환
  Result<List<T>> combine() {
    final values = <T>[];
    for (final result in this) {
      switch (result) {
        case Success(:final value):
          values.add(value);
        case Failure(:final error):
          return Failure(error);
      }
    }
    return Success(values);
  }
}
