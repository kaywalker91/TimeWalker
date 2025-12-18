import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/usecases/era_usecases.dart';
import 'package:time_walker/domain/usecases/user_progress_usecases.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============================================================================
// UseCase Providers
// ============================================================================
// Clean Architecture의 UseCase 레이어를 Riverpod Provider로 제공합니다.
// 각 UseCase는 해당 Repository를 주입받아 비즈니스 로직을 캡슐화합니다.
// ============================================================================

// ============== Era UseCases ==============

/// 국가별 시대 목록 조회 UseCase Provider
final getErasByCountryUseCaseProvider = Provider<GetErasByCountryUseCase>((ref) {
  final repository = ref.watch(eraRepositoryProvider);
  return GetErasByCountryUseCase(repository);
});

/// 시대 상세 조회 UseCase Provider
final getEraByIdUseCaseProvider = Provider<GetEraByIdUseCase>((ref) {
  final repository = ref.watch(eraRepositoryProvider);
  return GetEraByIdUseCase(repository);
});

// ============== User Progress UseCases ==============

/// 사용자 진행 상태 조회 UseCase Provider
final getUserProgressUseCaseProvider = Provider<GetUserProgressUseCase>((ref) {
  final repository = ref.watch(userProgressRepositoryProvider);
  return GetUserProgressUseCase(repository);
});

/// 사용자 진행 상태 업데이트 UseCase Provider
final updateUserProgressUseCaseProvider = Provider<UpdateUserProgressUseCase>((ref) {
  final repository = ref.watch(userProgressRepositoryProvider);
  final progressionService = ref.watch(progressionServiceProvider);
  return UpdateUserProgressUseCase(repository, progressionService);
});

/// 지식 포인트 추가 UseCase Provider
final addKnowledgePointsUseCaseProvider = Provider<AddKnowledgePointsUseCase>((ref) {
  final updateUseCase = ref.watch(updateUserProgressUseCaseProvider);
  return AddKnowledgePointsUseCase(updateUseCase);
});
