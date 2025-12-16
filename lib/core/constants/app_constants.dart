/// 앱 전역 상수
class AppConstants {
  AppConstants._();

  // ============== 앱 정보 ==============
  static const String appName = 'TimeWalker';
  static const String appNameFull = 'TimeWalker: Echoes of the Past';
  static const String appNameKorean = '타임워커: 역사의 메아리';
  static const String appVersion = '1.0.0';
  static const String appTagline = '시간을 걷는 자가 되어 역사를 탐험하세요';

  // ============== 저장소 키 ==============
  static const String userProgressKey = 'user_progress';
  static const String settingsKey = 'settings';
  static const String encyclopediaKey = 'encyclopedia';
  static const String achievementsKey = 'achievements';
  static const String tutorialCompletedKey = 'tutorial_completed';
  static const String lastPlayedEraKey = 'last_played_era';

  // ============== Hive Box 이름 ==============
  static const String userBoxName = 'user_box';
  static const String progressBoxName = 'progress_box';
  static const String contentBoxName = 'content_box';
  static const String settingsBoxName = 'settings_box';

  // ============== 애니메이션 ==============
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  static const Duration dialogueTypingSpeed = Duration(milliseconds: 30);
  static const Duration sceneTransition = Duration(milliseconds: 800);

  // ============== 광고 ==============
  static const int erasBeforeInterstitial = 2;
  static const int maxFreeDialoguesPerDay = 10;

  // ============== 튜토리얼 ==============
  static const int tutorialSteps = 5;
  static const int newUserBonusPoints = 100;
  static const int newUserFreeEras = 1;

  // ============== 게임 플레이 ==============
  static const int baseKnowledgePerDialogue = 10;
  static const int comboThreshold = 5;
  static const double comboMultiplier = 0.1;
  static const int portalDistance = 500; // 시대 변경 기준 거리 (미터)

  // ============== 탐험가 등급 ==============
  static const int noviceThreshold = 0;
  static const int apprenticeThreshold = 1000;
  static const int intermediateThreshold = 3000;
  static const int advancedThreshold = 6000;
  static const int expertThreshold = 9000;
  static const int masterThreshold = 12000;

  // ============== 해금 조건 ==============
  static const double eraUnlockProgress = 0.3; // 이전 시대 30% 완료 시 다음 시대 해금
  static const double regionUnlockProgress = 0.5; // 이전 지역 50% 완료 시 다음 지역 해금

  // ============== API 설정 ==============
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
}
