import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_walker/data/models/user_progress_hive_model.dart';

/// Hive 데이터베이스 초기화 서비스
/// 
/// 앱 시작 시 Hive를 초기화하고 필요한 TypeAdapter를 등록합니다.
class HiveService {
  static bool _isInitialized = false;
  
  /// Hive 초기화
  /// 
  /// 앱 시작 시 한 번만 호출해야 합니다.
  static Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('[HiveService] Already initialized');
      return;
    }
    
    try {
      // Hive Flutter 초기화
      await Hive.initFlutter();
      debugPrint('[HiveService] Hive initialized');
      
      // TypeAdapter 등록
      _registerAdapters();
      
      _isInitialized = true;
      debugPrint('[HiveService] Initialization complete');
    } catch (e) {
      debugPrint('[HiveService] Initialization error: $e');
      rethrow;
    }
  }
  
  /// TypeAdapter 등록
  static void _registerAdapters() {
    // UserProgressHiveModel Adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProgressHiveModelAdapter());
      debugPrint('[HiveService] Registered UserProgressHiveModelAdapter');
    }
    
    // 향후 추가될 다른 모델들의 Adapter도 여기에 등록
    // if (!Hive.isAdapterRegistered(1)) {
    //   Hive.registerAdapter(SomeOtherModelAdapter());
    // }
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
