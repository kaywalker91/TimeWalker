import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/domain/entities/quiz/quiz_entities.dart';

// Mock 클래스 export
export '../mocks/mock_audio_service.dart';
export '../mocks/mock_providers.dart';

/// 테스트용 ProviderContainer 생성
/// 
/// [overrides]를 통해 특정 provider를 mock으로 대체 가능
ProviderContainer createTestContainer({
  List<Override> overrides = const [],
}) {
  return ProviderContainer(overrides: overrides);
}

/// Mock UserProgress 생성
/// 
/// 테스트 시나리오에 맞게 필요한 필드만 설정하여 사용
UserProgress createMockUserProgress({
  String userId = 'test_user',
  int totalKnowledge = 1000,
  ExplorerRank rank = ExplorerRank.novice,
  List<String> completedDialogueIds = const [],
  List<String> unlockedRegionIds = const ['asia'],
  List<String> unlockedCountryIds = const ['korea'],
  List<String> unlockedEraIds = const ['joseon'],
  List<String> unlockedCharacterIds = const [],
  List<String> unlockedFactIds = const [],
  List<String> achievementIds = const [],
  List<String> completedQuizIds = const [],
  Map<String, double> eraProgress = const {},
  int coins = 1000,
  bool hasCompletedTutorial = true,
}) {
  return UserProgress(
    userId: userId,
    totalKnowledge: totalKnowledge,
    rank: rank,
    completedDialogueIds: completedDialogueIds,
    unlockedRegionIds: unlockedRegionIds,
    unlockedCountryIds: unlockedCountryIds,
    unlockedEraIds: unlockedEraIds,
    unlockedCharacterIds: unlockedCharacterIds,
    unlockedFactIds: unlockedFactIds,
    achievementIds: achievementIds,
    completedQuizIds: completedQuizIds,
    eraProgress: eraProgress,
    coins: coins,
    hasCompletedTutorial: hasCompletedTutorial,
  );
}

/// Mock Achievement 생성 (퀴즈 완료 조건)
Achievement createMockQuizAchievement({
  required String id,
  required String title,
  required int targetValue,
  String? targetId,
  int bonusPoints = 100,
  AchievementRarity rarity = AchievementRarity.common,
}) {
  return Achievement(
    id: id,
    title: title,
    titleKorean: title, // 테스트용으로 동일하게 설정
    description: 'Test achievement for $title',
    iconAsset: 'assets/images/achievements/test.png',
    condition: AchievementCondition(
      type: AchievementConditionType.completeQuiz,
      targetValue: targetValue,
      targetId: targetId,
    ),
    bonusPoints: bonusPoints,
    category: AchievementCategory.knowledge, // quiz -> knowledge로 변경
    rarity: rarity,
  );
}

/// Mock Quiz 생성
Quiz createMockQuiz({
  String id = 'quiz_test_1',
  String question = 'Test question?',
  QuizType type = QuizType.multipleChoice,
  QuizDifficulty difficulty = QuizDifficulty.easy,
  List<String> options = const ['A', 'B', 'C', 'D'],
  String correctAnswer = 'A',
  String explanation = 'Test explanation',
  String eraId = 'joseon',
  int basePoints = 10,
  String? categoryId,
}) {
  return Quiz(
    id: id,
    question: question,
    type: type,
    difficulty: difficulty,
    options: options,
    correctAnswer: correctAnswer,
    explanation: explanation,
    eraId: eraId,
    basePoints: basePoints,
  );
}

/// 테스트용 MaterialApp 래퍼
/// 
/// 위젯 테스트 시 필요한 기본 환경 제공
Widget createTestableWidget({
  required Widget child,
  List<Override> providerOverrides = const [],
}) {
  return ProviderScope(
    overrides: providerOverrides,
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

/// 비동기 작업 완료 대기를 위한 유틸리티
/// 
/// pump()를 여러 번 호출하여 비동기 상태 변화 반영
Future<void> pumpUntilSettled(WidgetTester tester, {int maxIterations = 10}) async {
  int iteration = 0;
  while (iteration < maxIterations) {
    await tester.pump(const Duration(milliseconds: 100));
    iteration++;
  }
}
