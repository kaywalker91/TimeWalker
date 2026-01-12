import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/achievement.dart';
import 'package:time_walker/domain/entities/user_progress.dart';
import 'package:time_walker/domain/entities/quiz.dart';
import 'package:time_walker/data/datasources/static/achievement_data.dart';


/// 업적 달성 결과를 담는 데이터 클래스
/// 
/// 업적 달성 시 UI에 표시하거나 진행 상태를 업데이트할 때 사용합니다.
class AchievementUnlockResult {
  /// 달성한 업적
  final Achievement achievement;
  
  /// 보너스 포인트 (희귀도 + 추가 보너스)
  final int bonusPoints;
  
  /// 달성 시각
  final DateTime unlockedAt;

  const AchievementUnlockResult({
    required this.achievement,
    required this.bonusPoints,
    required this.unlockedAt,
  });
}

/// 업적 달성 체크 서비스
/// 
/// 사용자의 활동(퀴즈 정답, 대화 완료, 지식 획득 등)에 따라
/// 달성 가능한 업적을 확인하고 결과를 반환합니다.
/// 
/// ## 사용 예시
/// ```dart
/// final service = ref.read(achievementServiceProvider);
/// 
/// // 퀴즈 정답 후 업적 체크
/// final achievements = service.checkAllAfterQuiz(
///   userProgress: currentProgress,
///   completedQuiz: quiz,
/// );
/// 
/// // 달성한 업적이 있으면 알림 표시
/// if (achievements.isNotEmpty) {
///   ref.read(achievementNotifierProvider.notifier)
///       .addUnlockedAchievements(achievements);
/// }
/// ```
/// 
/// ## 주요 메서드
/// - [checkQuizAchievements] - 퀴즈 관련 업적 체크
/// - [checkDialogueAchievements] - 대화 관련 업적 체크
/// - [checkKnowledgeAchievements] - 지식 포인트 업적 체크
/// - [checkAllAfterQuiz] - 퀴즈 후 종합 체크
/// 
/// See also:
/// - [Achievement] - 업적 엔티티
/// - [AchievementNotifier] - 업적 달성 알림 상태 관리
class AchievementService {
  /// 퀴즈 정답 후 업적 조건 확인
  /// 
  /// [userProgress]: 현재 사용자 진행 상태
  /// [newlyCompletedQuizId]: 방금 정답을 맞춘 퀴즈 ID
  /// [quizCategory]: 해당 퀴즈의 카테고리 ID (asia, europe 등)
  /// 
  /// 반환: 새로 달성한 업적 목록
  List<Achievement> checkQuizAchievements({
    required UserProgress userProgress,
    required String newlyCompletedQuizId,
    String? quizCategory,
  }) {
    final unlockedAchievements = <Achievement>[];
    final completedCount = userProgress.completedQuizIds.length;
    final alreadyUnlocked = userProgress.achievementIds;

    for (final achievement in AchievementData.quizAchievements) {
      // 이미 달성한 업적은 스킵
      if (alreadyUnlocked.contains(achievement.id)) continue;

      final condition = achievement.condition;
      
      // 조건 타입이 completeQuiz가 아니면 스킵
      if (condition.type != AchievementConditionType.completeQuiz) continue;

      // 카테고리 특정 업적인 경우
      if (condition.targetId != null) {
        // 현재 퀴즈가 해당 카테고리가 아니면 스킵
        if (quizCategory != condition.targetId) continue;
        
        // 해당 카테고리 퀴즈 개수 계산 필요 (간단화: 전체 개수로 체크)
        // TODO: 카테고리별 퀴즈 개수 추적 필요
        // 현재는 전체 개수로 대체
        if (completedCount >= condition.targetValue) {
          unlockedAchievements.add(achievement);
        }
      } else {
        // 일반 퀴즈 개수 업적
        if (completedCount >= condition.targetValue) {
          unlockedAchievements.add(achievement);
        }
      }
    }

    return unlockedAchievements;
  }

  /// 대화 완료 후 업적 조건 확인
  List<Achievement> checkDialogueAchievements({
    required UserProgress userProgress,
    required String completedDialogueId,
    String? characterId,
  }) {
    final unlockedAchievements = <Achievement>[];
    final completedCount = userProgress.completedDialogueIds.length;
    final alreadyUnlocked = userProgress.achievementIds;

    for (final achievement in AchievementData.all) {
      if (alreadyUnlocked.contains(achievement.id)) continue;

      final condition = achievement.condition;

      if (condition.type == AchievementConditionType.completeDialogues) {
        // 특정 캐릭터 대화 조건
        if (condition.targetId != null && condition.targetId == characterId) {
          // 해당 캐릭터 대화 개수 계산 필요
          // TODO: 캐릭터별 대화 개수 추적 필요
          if (completedCount >= condition.targetValue) {
            unlockedAchievements.add(achievement);
          }
        } else if (condition.targetId == null) {
          // 일반 대화 개수 업적
          if (completedCount >= condition.targetValue) {
            unlockedAchievements.add(achievement);
          }
        }
      }
    }

    return unlockedAchievements;
  }

  /// 지식 포인트 달성 업적 확인
  List<Achievement> checkKnowledgeAchievements({
    required UserProgress userProgress,
  }) {
    final unlockedAchievements = <Achievement>[];
    final totalKnowledge = userProgress.totalKnowledge;
    final alreadyUnlocked = userProgress.achievementIds;

    for (final achievement in AchievementData.all) {
      if (alreadyUnlocked.contains(achievement.id)) continue;

      final condition = achievement.condition;

      if (condition.type == AchievementConditionType.reachKnowledge) {
        if (totalKnowledge >= condition.targetValue) {
          unlockedAchievements.add(achievement);
        }
      }
    }

    return unlockedAchievements;
  }

  /// 종합 업적 체크 (퀴즈 + 지식)
  /// 퀴즈 정답 후 호출하는 통합 메서드
  List<Achievement> checkAllAfterQuiz({
    required UserProgress userProgress,
    required Quiz completedQuiz,
    String? quizCategory,
  }) {
    final allUnlocked = <Achievement>[];

    // 퀴즈 관련 업적 체크
    allUnlocked.addAll(checkQuizAchievements(
      userProgress: userProgress,
      newlyCompletedQuizId: completedQuiz.id,
      quizCategory: quizCategory,
    ));

    // 지식 포인트 업적 체크 (퀴즈로 포인트 획득 시)
    allUnlocked.addAll(checkKnowledgeAchievements(
      userProgress: userProgress,
    ));

    return allUnlocked;
  }

  /// 업적 달성 시 보너스 포인트 계산
  int calculateBonusPoints(List<Achievement> achievements) {
    return achievements.fold(0, (sum, a) => sum + a.bonusPoints);
  }

  /// 업적 달성 정보 생성
  List<AchievementUnlockResult> createUnlockResults(List<Achievement> achievements) {
    final now = DateTime.now();
    return achievements.map((a) => AchievementUnlockResult(
      achievement: a,
      bonusPoints: a.bonusPoints,
      unlockedAt: now,
    )).toList();
  }
}

/// AchievementService Provider
final achievementServiceProvider = Provider<AchievementService>((ref) {
  return AchievementService();
});

/// 업적 달성 이벤트를 위한 StateNotifier
class AchievementNotifier extends StateNotifier<List<AchievementUnlockResult>> {
  AchievementNotifier() : super([]);

  /// 새로운 업적 달성 알림 추가
  void addUnlockedAchievements(List<Achievement> achievements) {
    if (achievements.isEmpty) return;
    
    final now = DateTime.now();
    final results = achievements.map((a) => AchievementUnlockResult(
      achievement: a,
      bonusPoints: a.bonusPoints,
      unlockedAt: now,
    )).toList();
    
    state = [...state, ...results];
  }

  /// 알림 처리 완료 (첫 번째 업적 제거)
  void dismissFirst() {
    if (state.isNotEmpty) {
      state = state.sublist(1);
    }
  }

  /// 모든 알림 제거
  void dismissAll() {
    state = [];
  }

  /// 대기 중인 알림 있는지 확인
  bool get hasPending => state.isNotEmpty;
}

/// 업적 달성 알림 Provider
final achievementNotifierProvider = 
    StateNotifierProvider<AchievementNotifier, List<AchievementUnlockResult>>((ref) {
  return AchievementNotifier();
});
