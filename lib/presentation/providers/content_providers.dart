import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/domain/entities/shop_item.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

// ============== Encyclopedia Providers ==============

/// 모든 도감 항목 불러오기
final encyclopediaListProvider = FutureProvider<List<EncyclopediaEntry>>((ref) async {
  final repository = ref.watch(encyclopediaRepositoryProvider);
  return repository.getAllEntries();
});

/// 타입별 도감 항목 불러오기
final encyclopediaListByTypeProvider =
    FutureProvider.family<List<EncyclopediaEntry>, EntryType>((ref, type) async {
  final repository = ref.watch(encyclopediaRepositoryProvider);
  return repository.getEntriesByType(type);
});

/// 도감 항목 ID로 상세 정보 불러오기
final encyclopediaEntryByIdProvider =
    FutureProvider.family<EncyclopediaEntry?, String>((ref, id) async {
  final repository = ref.watch(encyclopediaRepositoryProvider);
  return repository.getEntryById(id);
});

// ============== Quiz Providers ==============

/// 모든 퀴즈 목록 불러오기
final quizListProvider = FutureProvider<List<Quiz>>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getAllQuizzes();
});

/// 시대별 퀴즈 목록 불러오기
final quizListByEraProvider = FutureProvider.family<List<Quiz>, String>((ref, eraId) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizzesByEra(eraId);
});

/// 퀴즈 ID로 정보 불러오기
final quizByIdProvider = FutureProvider.family<Quiz?, String>((ref, id) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizById(id);
});

// ============== Shop Providers ==============

/// 모든 상점 아이템 불러오기
final shopItemListProvider = FutureProvider<List<ShopItem>>((ref) async {
  final repository = ref.watch(shopRepositoryProvider);
  return repository.getShopItems();
});
