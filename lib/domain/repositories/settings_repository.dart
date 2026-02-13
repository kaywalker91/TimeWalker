import 'package:time_walker/domain/entities/settings.dart';

/// 사용자 설정 저장소 인터페이스
abstract class SettingsRepository {
  /// 설정 불러오기
  Future<GameSettings> getSettings();

  /// 설정 저장하기
  Future<void> saveSettings(GameSettings settings);
}
