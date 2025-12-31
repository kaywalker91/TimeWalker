import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/domain/entities/quiz_category.dart';
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

/// 퀴즈 카테고리 목록 불러오기
final quizCategoryListProvider = FutureProvider<List<QuizCategory>>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizCategories();
});

/// 카테고리별 퀴즈 목록 불러오기
final quizListByCategoryProvider =
    FutureProvider.family<List<Quiz>, String>((ref, categoryId) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizzesByCategory(categoryId);
});

/// 대화 ID 연관 퀴즈 목록 불러오기 (대화 후 퀴즈용)
final quizListByDialogueProvider =
    FutureProvider.family<List<Quiz>, String>((ref, dialogueId) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizzesByDialogueId(dialogueId);
});

// ============== Shop Providers ==============

/// 모든 상점 아이템 불러오기
final shopItemListProvider = FutureProvider<List<ShopItem>>((ref) async {
  final repository = ref.watch(shopRepositoryProvider);
  return repository.getShopItems();
});
