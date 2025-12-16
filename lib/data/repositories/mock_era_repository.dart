import 'package:time_walker/core/constants/exploration_config.dart';
import '../../domain/entities/era.dart';
import '../../domain/repositories/era_repository.dart';

/// 시대 데이터 Mock 저장소
class MockEraRepository implements EraRepository {
  // 인메모리 캐시
  final List<Era> _eras = [...EraData.all];

  @override
  Future<List<Era>> getAllEras() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _eras;
  }

  @override
  Future<List<Era>> getErasByCountry(String countryId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _eras.where((e) => e.countryId == countryId).toList();
  }

  @override
  Future<Era?> getEraById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _eras.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> unlockEra(String id) async {
    final index = _eras.indexWhere((e) => e.id == id);
    if (index != -1) {
      final era = _eras[index];
      _eras[index] = era.copyWith(status: ContentStatus.available);
    }
  }
}
