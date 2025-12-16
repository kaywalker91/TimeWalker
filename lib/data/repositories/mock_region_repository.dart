import 'package:time_walker/core/constants/exploration_config.dart';
import '../../domain/entities/region.dart';
import '../../domain/repositories/region_repository.dart';

/// 지역 데이터 Mock 저장소
class MockRegionRepository implements RegionRepository {
  // 인메모리 캐시 (실제 앱에서는 DB나 Remote에서 가져옴)
  final List<Region> _regions = [...RegionData.all];

  @override
  Future<List<Region>> getAllRegions() async {
    // 네트워크 딜레이 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 300));
    return _regions;
  }

  @override
  Future<Region?> getRegionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _regions.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> unlockRegion(String id) async {
    final index = _regions.indexWhere((r) => r.id == id);
    if (index != -1) {
      final region = _regions[index];
      _regions[index] = region.copyWith(status: ContentStatus.available);
    }
  }
}
