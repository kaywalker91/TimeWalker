/// TimeWalker 에러 핸들링 라이브러리
/// 
/// 앱 전체에서 사용되는 에러 핸들링 유틸리티를 제공합니다.
/// 
/// 사용 예시:
/// ```dart
/// import 'package:time_walker/core/errors/errors.dart';
/// 
/// // Result 패턴 사용
/// Future<Result<User>> getUser(String id) async {
///   return runCatching(() async {
///     final data = await api.fetch(id);
///     return User.fromJson(data);
///   });
/// }
/// 
/// // 결과 처리
/// final result = await getUser('123');
/// result.when(
///   success: (user) => showUser(user),
///   failure: (error) => showError(error.message),
/// );
/// ```
library;

export 'app_exceptions.dart';
export 'result.dart';
export 'error_handler.dart';
