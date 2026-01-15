import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_walker/domain/entities/encyclopedia_entry.dart';
import 'package:time_walker/domain/repositories/encyclopedia_repository.dart';
import 'package:time_walker/domain/repositories/quiz_repository.dart';
import 'package:time_walker/domain/repositories/shop_repository.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';

@GenerateNiceMocks([
  MockSpec<EncyclopediaRepository>(),
  MockSpec<QuizRepository>(),
  MockSpec<ShopRepository>(),
])
import 'content_providers_test.mocks.dart';

void main() {
  late MockEncyclopediaRepository mockEncyclopediaRepo;
  late MockQuizRepository mockQuizRepo;
  late MockShopRepository mockShopRepo;

  setUp(() {
    mockEncyclopediaRepo = MockEncyclopediaRepository();
    mockQuizRepo = MockQuizRepository();
    mockShopRepo = MockShopRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        encyclopediaRepositoryProvider.overrideWithValue(mockEncyclopediaRepo),
        quizRepositoryProvider.overrideWithValue(mockQuizRepo),
        shopRepositoryProvider.overrideWithValue(mockShopRepo),
      ],
    );
  }

  group('Encyclopedia Providers', () {
    test('encyclopediaListProvider가 모든 항목을 반환한다', () async {
      final container = createContainer();
      when(mockEncyclopediaRepo.getAllEntries()).thenAnswer((_) async => []);
      final result = await container.read(encyclopediaListProvider.future);
      expect(result, equals([]));
    });

    test('encyclopediaListByTypeProvider가 타입별 항목을 반환한다', () async {
      final container = createContainer();
      when(mockEncyclopediaRepo.getEntriesByType(EntryType.character)).thenAnswer((_) async => []);
      final result = await container.read(encyclopediaListByTypeProvider(EntryType.character).future);
      expect(result, equals([]));
    });
  });

  group('Quiz Providers', () {
    test('quizListProvider가 모든 퀴즈를 반환한다', () async {
      final container = createContainer();
      when(mockQuizRepo.getAllQuizzes()).thenAnswer((_) async => []);
      final result = await container.read(quizListProvider.future);
      expect(result, equals([]));
    });

    test('quizCategoryListProvider가 카테고리 목록을 반환한다', () async {
      final container = createContainer();
      when(mockQuizRepo.getQuizCategories()).thenAnswer((_) async => []);
      final result = await container.read(quizCategoryListProvider.future);
      expect(result, equals([]));
    });
  });

  group('Shop Providers', () {
    test('shopItemListProvider가 상점 아이템 목록을 반환한다', () async {
      final container = createContainer();
      when(mockShopRepo.getShopItems()).thenAnswer((_) async => []);
      final result = await container.read(shopItemListProvider.future);
      expect(result, equals([]));
    });
  });
}
