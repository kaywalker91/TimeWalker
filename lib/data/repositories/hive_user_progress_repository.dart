import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_walker/core/constants/app_constants.dart';
import 'package:time_walker/core/errors/app_exceptions.dart';
import 'package:time_walker/data/models/user_progress_hive_model.dart';
import 'package:time_walker/data/seeds/user_progress_seed.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';

/// Hive를 사용한 UserProgress 저장소 구현
/// 
/// 앱 종료 후에도 사용자 진행 상태를 유지합니다.
/// P0 FIX: HiveAesCipher를 사용한 암호화 적용
class HiveUserProgressRepository implements UserProgressRepository {
  static const String _boxName = AppConstants.progressBoxName;
  static const String _encryptionKeyAlias = 'user_progress_encryption_key';
  
  Box<UserProgressHiveModel>? _box;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  /// P0 FIX: 암호화 키 가져오기 (최초 생성 또는 저장된 키 사용)
  Future<List<int>> _getEncryptionKey() async {
    try {
      // 저장된 키 조회
      String? keyString = await _secureStorage.read(key: _encryptionKeyAlias);
      
      if (keyString == null) {
        // 키가 없으면 새로 생성
        final key = Hive.generateSecureKey();
        keyString = base64Encode(key);
        await _secureStorage.write(key: _encryptionKeyAlias, value: keyString);
        debugPrint('[HiveUserProgressRepository] Generated new encryption key');
        return key;
      }
      
      // 저장된 키 디코딩
      return base64Decode(keyString);
    } catch (e) {
      debugPrint('[HiveUserProgressRepository] Error getting encryption key: $e');
      // Fallback: 고정 키 사용 (보안상 이상적이지 않지만 앱 동작은 보장)
      rethrow;
    }
  }
  
  /// Box 가져오기 (lazy initialization with encryption)
  /// P0 FIX: HiveAesCipher 적용
  Future<Box<UserProgressHiveModel>> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    
    try {
      final encryptionKey = await _getEncryptionKey();
      _box = await Hive.openBox<UserProgressHiveModel>(
        _boxName,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
      debugPrint('[HiveUserProgressRepository] Opened encrypted box');
      return _box!;
    } on HiveError catch (e) {
      // 암호화된 Box를 열 수 없는 경우 (키 변경 등)
      debugPrint('[HiveUserProgressRepository] Failed to open encrypted box: $e');
      
      // 기존 Box 삭제 후 재생성 (데이터 손실 발생)
      await Hive.deleteBoxFromDisk(_boxName);
      debugPrint('[HiveUserProgressRepository] Deleted corrupted box, recreating...');
      
      // 새 암호화 키로 재생성
      await _secureStorage.delete(key: _encryptionKeyAlias);
      final newKey = await _getEncryptionKey();
      _box = await Hive.openBox<UserProgressHiveModel>(
        _boxName,
        encryptionCipher: HiveAesCipher(newKey),
      );
      return _box!;
    }
  }

  @override
  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      final box = await _getBox();
      final hiveModel = box.get(userId);
      
      if (hiveModel != null) {
        // P0 FIX: 프로덕션 환경에서는 PII 로깅 제거
        if (kDebugMode) {
          debugPrint('[HiveUserProgressRepository] Loaded progress for $userId');
        }
        return hiveModel.toEntity();
      }
      
      // 저장된 데이터가 없으면 기본값 생성 및 저장
      if (kDebugMode) {
        debugPrint('[HiveUserProgressRepository] No saved progress for $userId, creating default');
      }
      final defaultProgress = UserProgressSeed.initial(userId);
      await saveUserProgress(defaultProgress);
      return defaultProgress;
    } on HiveError catch (e) {
      // P0 FIX: HiveError는 데이터 손상 등 심각한 문제 - 적절한 예외 발생
      debugPrint('[HiveUserProgressRepository] HiveError loading progress: $e');
      // TODO: Firebase Crashlytics에 보고
      throw DataException.loadFailed(
        message: '사용자 진행 상태를 불러올 수 없습니다.',
        originalError: e,
      );
    } catch (e) {
      // P0 FIX: 예상치 못한 에러도 로깅 후 예외 발생 (Silent failure 제거)
      debugPrint('[HiveUserProgressRepository] Unexpected error loading progress: $e');
      // 데이터 파싱 에러 등
      throw DataException.loadFailed(
        message: '진행 상태 로드 중 오류가 발생했습니다.',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      final box = await _getBox();
      final hiveModel = UserProgressHiveModel.fromEntity(progress);
      await box.put(progress.userId, hiveModel);
      
      // P0 FIX: 프로덕션 환경에서는 PII 로깅 제거
      if (kDebugMode) {
        debugPrint('[HiveUserProgressRepository] Saved progress for ${progress.userId}');
        debugPrint('  - totalKnowledge: ${progress.totalKnowledge}');
        debugPrint('  - completedDialogues: ${progress.completedDialogueIds.length}');
        debugPrint('  - unlockedCharacters: ${progress.unlockedCharacterIds.length}');
        debugPrint('  - discoveredEncyclopedia: ${progress.discoveredEncyclopediaIds.length}');
      }
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
