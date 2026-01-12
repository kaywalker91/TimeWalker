import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_walker/core/constants/app_constants.dart';
import 'package:time_walker/data/models/user_progress_hive_model.dart';
import 'package:time_walker/data/seeds/user_progress_seed.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';

/// Hive를 사용한 UserProgress 저장소 구현
/// 
/// 앱 종료 후에도 사용자 진행 상태를 유지합니다.
class HiveUserProgressRepository implements UserProgressRepository {
  static const String _boxName = AppConstants.progressBoxName;
  
  Box<UserProgressHiveModel>? _box;
  
  /// Box 가져오기 (lazy initialization)
  Future<Box<UserProgressHiveModel>> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    _box = await Hive.openBox<UserProgressHiveModel>(_boxName);
    return _box!;
  }

  @override
  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      final box = await _getBox();
      final hiveModel = box.get(userId);
      
      if (hiveModel != null) {
        debugPrint('[HiveUserProgressRepository] Loaded progress for $userId');
        return hiveModel.toEntity();
      }
      
      // 저장된 데이터가 없으면 기본값 생성 및 저장
      debugPrint('[HiveUserProgressRepository] No saved progress for $userId, creating default');
      final defaultProgress = UserProgressSeed.initial(userId);
      await saveUserProgress(defaultProgress);
      return defaultProgress;
    } catch (e) {
      debugPrint('[HiveUserProgressRepository] Error loading progress: $e');
      // 오류 발생 시 기본값 반환
      return UserProgressSeed.initial(userId);
    }
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      final box = await _getBox();
      final hiveModel = UserProgressHiveModel.fromEntity(progress);
      await box.put(progress.userId, hiveModel);
      debugPrint('[HiveUserProgressRepository] Saved progress for ${progress.userId}');
      debugPrint('  - totalKnowledge: ${progress.totalKnowledge}');
      debugPrint('  - completedDialogues: ${progress.completedDialogueIds.length}');
      debugPrint('  - unlockedCharacters: ${progress.unlockedCharacterIds.length}');
      debugPrint('  - discoveredEncyclopedia: ${progress.discoveredEncyclopediaIds.length}');
    } catch (e) {
      debugPrint('[HiveUserProgressRepository] Error saving progress: $e');
      rethrow;
    }
  }
  
  /// 특정 사용자 데이터 삭제
  Future<void> deleteUserProgress(String userId) async {
    try {
      final box = await _getBox();
      await box.delete(userId);
      debugPrint('[HiveUserProgressRepository] Deleted progress for $userId');
    } catch (e) {
      debugPrint('[HiveUserProgressRepository] Error deleting progress: $e');
    }
  }
  
  /// 모든 데이터 삭제 (초기화용)
  Future<void> clearAll() async {
    try {
      final box = await _getBox();
      await box.clear();
      debugPrint('[HiveUserProgressRepository] Cleared all progress data');
    } catch (e) {
      debugPrint('[HiveUserProgressRepository] Error clearing data: $e');
    }
  }
  
  /// Box 닫기 (앱 종료 시)
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
      _box = null;
    }
  }
}
