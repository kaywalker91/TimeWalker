import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:time_walker/data/models/user_progress_hive_model.dart';

/// Hive TypeAdapter 등록 유틸리티
///
/// data 레이어에서 TypeAdapter를 등록하여
/// core 레이어의 HiveService가 data/models에 의존하지 않도록 합니다.
class HiveAdapters {
  HiveAdapters._();

  /// 모든 Hive TypeAdapter 등록
  ///
  /// HiveService.initialize() 이후 호출해야 합니다.
  static void registerAll() {
    // UserProgressHiveModel Adapter (typeId: 0)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProgressHiveModelAdapter());
      debugPrint('[HiveAdapters] Registered UserProgressHiveModelAdapter');
    }

    // 향후 추가될 다른 모델들의 Adapter도 여기에 등록
    // if (!Hive.isAdapterRegistered(1)) {
    //   Hive.registerAdapter(SomeOtherModelAdapter());
    // }
  }
}
