import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/domain/entities/quiz/quiz_entities.dart';

/// 테스트용 Mock 데이터 모음
/// 
/// 여러 테스트에서 공통으로 사용되는 상수 데이터
class MockData {
  MockData._();

  // =====================================================
  // User Progress Mock Data
  // =====================================================
  
  /// 초보자 사용자 (기본 상태)
  static const UserProgress noviceUser = UserProgress(
    userId: 'novice_user',
    totalKnowledge: 500,
    rank: ExplorerRank.novice,
    unlockedRegionIds: ['asia'],
    unlockedCountryIds: ['korea'],
    unlockedEraIds: ['joseon'],
    coins: 1000,
    hasCompletedTutorial: true,
  );

  /// 중급 사용자 (어느 정도 진행)
  static const UserProgress intermediateUser = UserProgress(
    userId: 'intermediate_user',
    totalKnowledge: 3500,
    rank: ExplorerRank.intermediate,
    unlockedRegionIds: ['asia', 'europe'],
    unlockedCountryIds: ['korea', 'china', 'japan'],
    unlockedEraIds: ['joseon', 'three_kingdoms', 'goryeo'],
    completedDialogueIds: ['sejong_intro', 'admiral_yi_intro'],
    completedQuizIds: ['quiz_1', 'quiz_2', 'quiz_3', 'quiz_4', 'quiz_5'],
    achievementIds: ['first_quiz', 'first_dialogue'],
    coins: 5000,
    hasCompletedTutorial: true,
  );

  /// 고급 사용자 (많은 진행)
  static final UserProgress advancedUser = UserProgress(
    userId: 'advanced_user',
    totalKnowledge: 8000,
    rank: ExplorerRank.advanced,
    unlockedRegionIds: const ['asia', 'europe', 'africa'],
    unlockedCountryIds: const ['korea', 'china', 'japan', 'india', 'uk', 'france'],
    unlockedEraIds: const [
      'joseon', 'three_kingdoms', 'goryeo', 'unified_silla',
      'roman_empire', 'renaissance',
    ],
    completedDialogueIds: const [
      'sejong_intro', 'sejong_hangul', 'admiral_yi_intro', 'admiral_yi_battle',
      'gwanggaeto_intro', 'seondeok_intro',
    ],
    completedQuizIds: [
      'quiz_0', 'quiz_1', 'quiz_2', 'quiz_3', 'quiz_4',
      'quiz_5', 'quiz_6', 'quiz_7', 'quiz_8', 'quiz_9',
      'quiz_10', 'quiz_11', 'quiz_12', 'quiz_13', 'quiz_14',
      'quiz_15', 'quiz_16', 'quiz_17', 'quiz_18', 'quiz_19',
    ],
    achievementIds: const ['first_quiz', 'quiz_master_1', 'first_dialogue', 'dialogue_master_1'],
    coins: 15000,
    hasCompletedTutorial: true,
  );

  // =====================================================
  // Quiz Mock Data
  // =====================================================
  
  /// 쉬운 퀴즈 목록
  static final List<Quiz> easyQuizzes = [
    const Quiz(
      id: 'quiz_easy_1',
      question: '훈민정음을 창제한 왕은 누구일까요?',
      type: QuizType.multipleChoice,
      difficulty: QuizDifficulty.easy,
      options: ['세종대왕', '태조 이성계', '정조', '고종'],
      correctAnswer: '세종대왕',
      explanation: '세종대왕은 1443년에 훈민정음을 창제했습니다.',
      eraId: 'joseon',
      basePoints: 10,
    ),
    const Quiz(
      id: 'quiz_easy_2',
      question: '임진왜란에서 거북선을 이끈 장군은?',
      type: QuizType.multipleChoice,
      difficulty: QuizDifficulty.easy,
      options: ['강감찬', '을지문덕', '이순신', '김유신'],
      correctAnswer: '이순신',
      explanation: '이순신 장군은 거북선을 이끌고 임진왜란에서 승리했습니다.',
      eraId: 'joseon',
      basePoints: 10,
    ),
  ];

  /// 중간 퀴즈 목록
  static final List<Quiz> mediumQuizzes = [
    const Quiz(
      id: 'quiz_medium_1',
      question: '고려시대 팔만대장경이 제작된 이유는?',
      type: QuizType.multipleChoice,
      difficulty: QuizDifficulty.medium,
      options: ['불교 전파', '몽골 침입 격퇴 기원', '왕권 강화', '학문 발전'],
      correctAnswer: '몽골 침입 격퇴 기원',
      explanation: '팔만대장경은 몽골 침입을 부처의 힘으로 막고자 제작되었습니다.',
      eraId: 'goryeo',
      basePoints: 15,
    ),
  ];

  // =====================================================
  // Achievement Mock Data
  // =====================================================
  
  /// 테스트용 업적 목록
  static final List<Achievement> testAchievements = [
    const Achievement(
      id: 'first_quiz',
      title: 'First Quiz',
      titleKorean: '첫 번째 퀴즈',
      description: '첫 번째 퀴즈를 맞추세요',
      iconAsset: 'assets/images/achievements/quiz.png',
      condition: AchievementCondition(
        type: AchievementConditionType.completeQuiz,
        targetValue: 1,
      ),
      bonusPoints: 50,
      category: AchievementCategory.knowledge,
      rarity: AchievementRarity.common,
    ),
    const Achievement(
      id: 'quiz_master_5',
      title: 'Quiz Master 5',
      titleKorean: '퀴즈 마스터 5',
      description: '5개의 퀴즈를 맞추세요',
      iconAsset: 'assets/images/achievements/quiz.png',
      condition: AchievementCondition(
        type: AchievementConditionType.completeQuiz,
        targetValue: 5,
      ),
      bonusPoints: 100,
      category: AchievementCategory.knowledge,
      rarity: AchievementRarity.uncommon,
    ),
    const Achievement(
      id: 'quiz_master_10',
      title: 'Quiz Master 10',
      titleKorean: '퀴즈 마스터 10',
      description: '10개의 퀴즈를 맞추세요',
      iconAsset: 'assets/images/achievements/quiz.png',
      condition: AchievementCondition(
        type: AchievementConditionType.completeQuiz,
        targetValue: 10,
      ),
      bonusPoints: 200,
      category: AchievementCategory.knowledge,
      rarity: AchievementRarity.rare,
    ),
    const Achievement(
      id: 'knowledge_1000',
      title: 'Knowledge Seeker',
      titleKorean: '지식 탐구자',
      description: '1000 지식 포인트 달성',
      iconAsset: 'assets/images/achievements/knowledge.png',
      condition: AchievementCondition(
        type: AchievementConditionType.reachKnowledge,
        targetValue: 1000,
      ),
      bonusPoints: 150,
      category: AchievementCategory.exploration,
      rarity: AchievementRarity.rare,
    ),
  ];
}
