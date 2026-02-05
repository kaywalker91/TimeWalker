import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/civilization.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

/// 모든 문명 목록 Provider
final civilizationListProvider = Provider<List<Civilization>>((ref) {
  final repository = ref.watch(civilizationRepositoryProvider);
  return repository.getAll();
});

/// 사용자 진행도가 반영된 문명 목록 Provider
final civilizationsWithProgressProvider = FutureProvider<List<Civilization>>((ref) async {
  final repository = ref.watch(civilizationRepositoryProvider);
  final civilizations = repository.getAll();
  final userProgressAsyncValue = ref.watch(userProgressProvider);

  // AsyncValue에서 데이터 추출
  final userProgress = userProgressAsyncValue.valueOrNull;
  if (userProgress == null) {
    // 진행도 로딩 중이면 기본 상태로 반환
    return civilizations;
  }

  // 사용자 레벨 (rank index)
  final userLevel = userProgress.rank.index;

  return civilizations.map((civ) {
    // 레벨 조건 충족 또는 명시적 해금 여부 확인 (Admin Mode 지원)
    final isExplicitlyUnlocked = userProgress.unlockedRegionIds.contains(civ.id) ||
                               userProgress.unlockedRegionIds.contains('all');
    final isUnlocked = civ.unlockLevel <= userLevel || isExplicitlyUnlocked;

    // 문명에 속한 지역들의 진행도 계산
    double totalProgress = 0.0;

    for (final countryId in civ.countryIds) {
      final regionProgress = userProgress.getRegionProgress(countryId);
      if (regionProgress > 0) {
        totalProgress += regionProgress;
      }
    }

    // 전체 진행도 계산 (지역 수로 나눔)
    final progress = civ.countryIds.isNotEmpty
        ? totalProgress / civ.countryIds.length
        : 0.0;

    // 상태 결정
    CivilizationStatus status;
    if (!isUnlocked) {
      status = CivilizationStatus.locked;
    } else if (progress >= 1.0) {
      status = CivilizationStatus.completed;
    } else if (progress > 0) {
      status = CivilizationStatus.inProgress;
    } else {
      status = CivilizationStatus.available;
    }

    return civ.copyWith(
      status: status,
      progress: progress,
    );
  }).toList();
});

/// 특정 문명 Provider
final civilizationProvider = Provider.family<Civilization?, String>((ref, id) {
  final repository = ref.watch(civilizationRepositoryProvider);
  return repository.getById(id);
});

/// 현재 탐험 중인 문명 Provider
final currentCivilizationProvider = FutureProvider<Civilization?>((ref) async {
  final civilizations = await ref.watch(civilizationsWithProgressProvider.future);

  // 탐험 중인 문명 찾기
  final inProgress = civilizations.where(
    (c) => c.status == CivilizationStatus.inProgress,
  ).toList();

  if (inProgress.isNotEmpty) {
    // 가장 최근에 탐험한 문명 (진행도가 가장 낮은 것)
    inProgress.sort((a, b) => b.progress.compareTo(a.progress));
    return inProgress.first;
  }

  // 탐험 중인 게 없으면 해금된 첫 번째 문명
  final available = civilizations.where(
    (c) => c.status == CivilizationStatus.available,
  ).toList();

  return available.isNotEmpty ? available.first : null;
});
