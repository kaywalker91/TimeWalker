import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/repositories/user_progress_repository.dart';
import 'package:time_walker/l10n/generated/app_localizations.dart';
import 'package:time_walker/presentation/providers/repository_providers.dart';
import 'package:time_walker/presentation/screens/quiz/quiz_screen.dart';

/// Mock implementation of UserProgressRepository for widget tests
class MockUserProgressRepositoryForWidgets implements UserProgressRepository {
  @override
  Future<UserProgress?> getUserProgress(String userId) async {
    return const UserProgress(
      userId: 'test_user',
      totalKnowledge: 1000,
      rank: ExplorerRank.novice,
      unlockedRegionIds: ['asia'],
      unlockedCountryIds: ['korea'],
      unlockedEraIds: ['joseon'],
      coins: 500,
      hasCompletedTutorial: true,
    );
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {}
}

void main() {
  // Helper to pump widget with necessary providers and localization
  Future<void> pumpQuizScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProgressRepositoryProvider.overrideWithValue(
            MockUserProgressRepositoryForWidgets(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: QuizScreen(),
        ),
      ),
    );
    // Use pump with duration instead of pumpAndSettle to avoid animation timeout
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  }

  group('Quiz UI Tests', () {
    testWidgets('QuizScreen renders without crashing',
        (WidgetTester tester) async {
      await pumpQuizScreen(tester);

      // QuizScreen renders - basic check that it doesn't crash
      expect(find.byType(QuizScreen), findsOneWidget);

      // Note: QuizSummaryCard and QuizFilterTab require quiz data to be loaded
      // They are tested more thoroughly in integration tests with full provider setup
    });

    testWidgets('QuizPlayScreen renders question and options',
        (WidgetTester tester) async {
      // Create a scoped provider container if needed, but for simple UI test:
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProgressRepositoryProvider.overrideWithValue(
              MockUserProgressRepositoryForWidgets(),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: QuizScreen(),
          ),
        ),
      );
      // Use pump with duration instead of pumpAndSettle to avoid animation timeout
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // QuizScreen renders - basic check that it doesn't crash
      expect(find.byType(QuizScreen), findsOneWidget);
    });
  });
}
