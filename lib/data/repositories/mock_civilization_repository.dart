import 'package:time_walker/data/datasources/static/civilization_data.dart';
import 'package:time_walker/domain/entities/civilization.dart';
import 'package:time_walker/domain/repositories/civilization_repository.dart';

/// Civilization Repository Mock 구현
///
/// 정적 데이터(CivilizationData)를 래핑하여 repository 인터페이스를 제공합니다.
class MockCivilizationRepository implements CivilizationRepository {
  @override
  List<Civilization> getAll() {
    return CivilizationData.all;
  }

  @override
  Civilization? getById(String id) {
    return CivilizationData.getById(id);
  }

  @override
  List<Civilization> getUnlocked(int userLevel) {
    return CivilizationData.getUnlocked(userLevel);
  }
}
