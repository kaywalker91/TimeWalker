/// 에러 핸들링 유틸리티
/// 
/// 에러 로깅, 사용자 메시지 변환 등의 유틸리티
library;

import 'package:flutter/foundation.dart';
import 'package:time_walker/core/errors/app_exceptions.dart';

/// 에러 핸들러 - 에러 로깅 및 변환
class ErrorHandler {
  const ErrorHandler._();

  /// 에러 로그 기록
  /// 
  /// Debug 모드에서는 콘솔에, Release 모드에서는 Crashlytics에 기록
  static void logError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? extra,
  }) {
    final message = _formatError(error, context: context, extra: extra);
    
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('🚨 ERROR LOG');
      debugPrint(message);
      if (stackTrace != null) {
        debugPrint('Stack trace:');
        debugPrint(stackTrace.toString());
      }
      debugPrint('═══════════════════════════════════════');
    }
    
    // TODO: Release 모드에서는 Firebase Crashlytics에 전송
    // if (!kDebugMode) {
    //   FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // }
  }

  /// 에러를 사용자 친화적 메시지로 변환
  static String toUserMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }
    
    // 일반 Exception 처리
    if (error is Exception) {
      final message = error.toString();
      // 일반적인 에러 메시지 변환
      if (message.contains('SocketException') || 
          message.contains('ClientException')) {
        return '인터넷 연결을 확인해주세요.';
      }
      if (message.contains('TimeoutException')) {
        return '서버 응답 시간이 초과되었습니다.';
      }
      if (message.contains('FormatException')) {
        return '데이터 형식이 올바르지 않습니다.';
      }
    }
    
    return '오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
  }

  /// 에러를 AppException으로 변환
  static AppException toAppException(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error;
    }
    
    // 일반 Exception을 AppException으로 래핑
    final message = error.toString();
    
    if (message.contains('SocketException') || 
        message.contains('ClientException')) {
      return NetworkException.noConnection();
    }
    
    if (message.contains('TimeoutException')) {
      return NetworkException.timeout();
    }
    
    if (message.contains('FormatException')) {
      return DataException.parsingFailed(
        dataType: 'Unknown',
        originalError: error,
        stackTrace: stackTrace,
      );
    }
    
    return UnexpectedException.from(error, stackTrace);
  }

  /// 에러 포맷팅 (로깅용)
  static String _formatError(
    Object error, {
    String? context,
    Map<String, dynamic>? extra,
  }) {
    final buffer = StringBuffer();
    
    if (context != null) {
      buffer.writeln('Context: $context');
    }
    
    buffer.writeln('Error Type: ${error.runtimeType}');
    
    if (error is AppException) {
      buffer.writeln('Message: ${error.message}');
      buffer.writeln('Code: ${error.code}');
      if (error.originalError != null) {
        buffer.writeln('Original: ${error.originalError}');
      }
    } else {
      buffer.writeln('Details: $error');
    }
    
    if (extra != null && extra.isNotEmpty) {
      buffer.writeln('Extra: $extra');
    }
    
    return buffer.toString();
  }

  /// 에러 코드로 아이콘 선택
  static String getErrorIcon(AppException error) {
    return switch (error) {
      NetworkException() => '🌐',
      DataException() => '📁',
      GameLogicException() => '🎮',
      AuthException() => '🔐',
      ValidationException() => '⚠️',
      UnexpectedException() => '❌',
    };
  }

  /// 재시도 가능 여부 판단
  static bool isRetryable(AppException error) {
    return switch (error) {
      NetworkException() => true,
      DataException(:final code) => code == 'LOAD_FAILED',
      _ => false,
    };
  }
}

/// 에러를 안전하게 처리하는 래퍼 함수
/// 
/// 에러 발생 시 로깅하고 null 반환
Future<T?> safeCall<T>(
  Future<T> Function() action, {
  String? context,
  void Function(AppException error)? onError,
}) async {
  try {
    return await action();
  } catch (e, st) {
    ErrorHandler.logError(e, stackTrace: st, context: context);
    final appException = ErrorHandler.toAppException(e, st);
    onError?.call(appException);
    return null;
  }
}

/// 동기 버전의 안전한 호출
T? safeCallSync<T>(
  T Function() action, {
  String? context,
  void Function(AppException error)? onError,
}) {
  try {
    return action();
  } catch (e, st) {
    ErrorHandler.logError(e, stackTrace: st, context: context);
    final appException = ErrorHandler.toAppException(e, st);
    onError?.call(appException);
    return null;
  }
}
