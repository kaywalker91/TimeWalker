import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Hive 데이터베이스 초기화 서비스
///
/// 앱 시작 시 Hive를 초기화합니다.
/// TypeAdapter 등록은 data 레이어에서 수행합니다.
class HiveService {
  static bool _isInitialized = false;

  /// Hive 초기화
  ///
  /// 앱 시작 시 한 번만 호출해야 합니다.
  /// TypeAdapter 등록은 별도로 수행해야 합니다.
  ///
  /// [registerAdapters] - Adapter 등록 콜백 (옵션)
  /// data 레이어에서 HiveAdapters.registerAll을 전달합니다.
  static Future<void> initialize({VoidCallback? registerAdapters}) async {
    if (_isInitialized) {
      debugPrint('[HiveService] Already initialized');
      return;
    }

    try {
      // Hive Flutter 초기화
      await Hive.initFlutter();
      debugPrint('[HiveService] Hive initialized');

      // TypeAdapter 등록 (data 레이어에서 제공)
      registerAdapters?.call();

      _isInitialized = true;
      debugPrint('[HiveService] Initialization complete');
    } catch (e) {
      debugPrint('[HiveService] Initialization error: $e');
      rethrow;
    }
  }

  /// 초기화 여부 확인
  static bool get isInitialized => _isInitialized;

  /// 모든 Box 닫기 (앱 종료 시)
  static Future<void> closeAll() async {
    try {
      await Hive.close();
      _isInitialized = false;
      debugPrint('[HiveService] All boxes closed');
    } catch (e) {
      debugPrint('[HiveService] Error closing boxes: $e');
    }
  }
}
