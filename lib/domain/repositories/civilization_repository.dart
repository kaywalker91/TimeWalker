import 'package:time_walker/domain/entities/civilization.dart';

/// Civilization Repository 인터페이스
///
/// 문명 데이터 접근을 위한 계약을 정의합니다.
abstract class CivilizationRepository {
  /// 모든 문명 목록 조회
  List<Civilization> getAll();

  /// ID로 문명 조회
  Civilization? getById(String id);

  /// 해금된 문명 목록 조회
  List<Civilization> getUnlocked(int userLevel);
}
