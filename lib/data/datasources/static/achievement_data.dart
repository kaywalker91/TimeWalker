import '../../../domain/entities/achievement.dart';

/// 기본 업적 데이터
class AchievementData {
  AchievementData._();

  static const Achievement firstStep = Achievement(
    id: 'first_step',
    title: 'First Step',
    titleKorean: '첫 발걸음',
    description: '첫 번째 역사 인물과 대화를 나누다',
    iconAsset: 'assets/images/achievements/first_step.png',
    category: AchievementCategory.dialogue,
    rarity: AchievementRarity.common,
    condition: AchievementCondition(
      type: AchievementConditionType.completeDialogues,
      targetValue: 1,
    ),
  );

  static const Achievement timeExplorer = Achievement(
    id: 'time_explorer',
    title: 'Time Explorer',
    titleKorean: '시간 탐험가',
    description: '첫 번째 시대를 완료하다',
    iconAsset: 'assets/images/achievements/time_explorer.png',
    category: AchievementCategory.exploration,
    rarity: AchievementRarity.uncommon,
    condition: AchievementCondition(
      type: AchievementConditionType.completeEra,
      targetValue: 1,
    ),
  );

  static const Achievement sejongFriend = Achievement(
    id: 'sejong_friend',
    title: 'Friend of Sejong',
    titleKorean: '세종대왕의 벗',
    description: '세종대왕의 모든 대화를 완료하다',
    iconAsset: 'assets/images/achievements/sejong_friend.png',
    category: AchievementCategory.dialogue,
    rarity: AchievementRarity.rare,
    bonusPoints: 50,
    condition: AchievementCondition(
      type: AchievementConditionType.completeDialogues,
      targetValue: 3,
      targetId: 'sejong',
    ),
  );

  static const Achievement historyMaster = Achievement(
    id: 'history_master',
    title: 'History Master',
    titleKorean: '역사 마스터',
    description: '역사 마스터 등급에 도달하다',
    iconAsset: 'assets/images/achievements/history_master.png',
    category: AchievementCategory.knowledge,
    rarity: AchievementRarity.legendary,
    bonusPoints: 200,
    condition: AchievementCondition(
      type: AchievementConditionType.reachKnowledge,
      targetValue: 12000,
    ),
  );

  static const Achievement secretOfHangul = Achievement(
    id: 'secret_of_hangul',
    title: 'Secret of Hangul',
    titleKorean: '한글의 비밀',
    description: '훈민정음 창제의 비밀을 발견하다',
    iconAsset: 'assets/images/achievements/secret_of_hangul.png',
    category: AchievementCategory.special,
    rarity: AchievementRarity.epic,
    bonusPoints: 100,
    isSecret: true,
    condition: AchievementCondition(
      type: AchievementConditionType.specialEvent,
      targetValue: 1,
      targetId: 'sejong_hangul_secret',
    ),
  );

  // ============== 퀴즈 업적 ==============

  /// 첫 번째 퀴즈 정답
  static const Achievement quizNovice = Achievement(
    id: 'quiz_novice',
    title: 'Quiz Novice',
    titleKorean: '퀴즈 도전자',
    description: '첫 번째 역사 퀴즈를 정답으로 맞추다',
    iconAsset: 'assets/images/achievements/quiz_novice.png',
    category: AchievementCategory.knowledge,
    rarity: AchievementRarity.common,
    condition: AchievementCondition(
      type: AchievementConditionType.completeQuiz,
      targetValue: 1,
    ),
  );

  /// 5개 퀴즈 정답
  static const Achievement quizEnthusiast = Achievement(
    id: 'quiz_enthusiast',
    title: 'Quiz Enthusiast',
    titleKorean: '퀴즈 애호가',
    description: '5개의 퀴즈를 정답으로 맞추다',
    iconAsset: 'assets/images/achievements/quiz_enthusiast.png',
    category: AchievementCategory.knowledge,
    rarity: AchievementRarity.uncommon,
    bonusPoints: 20,
    condition: AchievementCondition(
      type: AchievementConditionType.completeQuiz,
      targetValue: 5,
    ),
  );

  /// 10개 퀴즈 정답
  static const Achievement quizExpert = Achievement(
    id: 'quiz_expert',
    title: 'Quiz Expert',
    titleKorean: '퀴즈 전문가',
    description: '10개의 퀴즈를 정답으로 맞추다',
    iconAsset: 'assets/images/achievements/quiz_expert.png',
    category: AchievementCategory.knowledge,
    rarity: AchievementRarity.rare,
    bonusPoints: 50,
    condition: AchievementCondition(
      type: AchievementConditionType.completeQuiz,
      targetValue: 10,
    ),
  );

  /// 30개 퀴즈 정답
  static const Achievement quizMaster = Achievement(
    id: 'quiz_master',
    title: 'Quiz Master',
    titleKorean: '퀴즈 마스터',
    description: '30개의 퀴즈를 정답으로 맞추다',
    iconAsset: 'assets/images/achievements/quiz_master.png',
    category: AchievementCategory.knowledge,
    rarity: AchievementRarity.epic,
    bonusPoints: 100,
    condition: AchievementCondition(
      type: AchievementConditionType.completeQuiz,
      targetValue: 30,
    ),
  );

  /// 아시아 역사 퀴즈 10개 정답
  static const Achievement asiaHistorian = Achievement(
    id: 'asia_historian',
    title: 'Asia Historian',
    titleKorean: '아시아 역사가',
    description: '아시아 카테고리 퀴즈 10개를 정답으로 맞추다',
    iconAsset: 'assets/images/achievements/asia_historian.png',
    category: AchievementCategory.knowledge,
    rarity: AchievementRarity.rare,
    bonusPoints: 50,
    condition: AchievementCondition(
      type: AchievementConditionType.completeQuiz,
      targetValue: 10,
      targetId: 'asia', // 카테고리 ID
    ),
  );

  /// 유럽 역사 퀴즈 5개 정답
  static const Achievement europeHistorian = Achievement(
    id: 'europe_historian',
    title: 'Europe Historian',
    titleKorean: '유럽 역사가',
    description: '유럽 카테고리 퀴즈 5개를 정답으로 맞추다',
    iconAsset: 'assets/images/achievements/europe_historian.png',
    category: AchievementCategory.knowledge,
    rarity: AchievementRarity.uncommon,
    bonusPoints: 30,
    condition: AchievementCondition(
      type: AchievementConditionType.completeQuiz,
      targetValue: 5,
      targetId: 'europe', // 카테고리 ID
    ),
  );

  /// 모든 업적 목록
  static List<Achievement> get all => [
    // 기존 업적
    firstStep,
    timeExplorer,
    sejongFriend,
    historyMaster,
    secretOfHangul,
    // 퀴즈 업적
    quizNovice,
    quizEnthusiast,
    quizExpert,
    quizMaster,
    asiaHistorian,
    europeHistorian,
  ];

  /// 퀴즈 관련 업적만 가져오기
  static List<Achievement> get quizAchievements => [
    quizNovice,
    quizEnthusiast,
    quizExpert,
    quizMaster,
    asiaHistorian,
    europeHistorian,
  ];

  static List<Achievement> getByCategory(AchievementCategory category) {
    return all.where((a) => a.category == category).toList();
  }

  static Achievement? getById(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
