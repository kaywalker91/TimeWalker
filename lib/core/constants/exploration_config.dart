// TimeWalker 탐험 및 대화 시스템 설정
// PRD 기반 탐험 파라미터 및 게임 설정

/// 탐험 시스템 설정
class ExplorationConfig {
  ExplorationConfig._();

  // ============== 지도 설정 ==============
  static const double mapMinZoom = 0.5;
  static const double mapMaxZoom = 3.0;
  static const double mapDefaultZoom = 1.0;
  static const double mapPanSpeed = 1.5;

  // ============== 마커 설정 ==============
  static const double markerIdleScale = 1.0;
  static const double markerHoverScale = 1.2;
  static const double markerBounceHeight = 10.0;
  static const double markerBounceSpeed = 2.0;

  // ============== 탐험 진행 ==============
  static const int minCharactersPerEra = 3;
  static const int maxCharactersPerEra = 10;
  static const int minLocationsPerEra = 3;
  static const int maxLocationsPerEra = 8;

  // ============== 성능 설정 ==============
  static const int targetFps = 60;
  static const int minFps = 30;
  static const int maxMemoryMb = 200;
  static const double coldStartMaxSec = 3.0;
}

/// 대화 시스템 설정
class DialogueConfig {
  DialogueConfig._();

  // ============== 타이핑 애니메이션 ==============
  static const int charsPerSecond = 30;
  static const double pauseOnPunctuation = 0.3; // seconds
  static const double pauseOnComma = 0.15; // seconds

  // ============== 대화 UI ==============
  static const double portraitSize = 200.0;
  static const double bubbleMaxWidth = 0.8; // 화면 너비의 80%
  static const double choiceMinHeight = 60.0;
  static const int maxChoicesVisible = 4;

  // ============== 표정 변화 ==============
  static const double emotionTransitionDuration = 0.3; // seconds
  static const List<String> defaultEmotions = [
    'neutral',
    'happy',
    'sad',
    'angry',
    'surprised',
    'thoughtful',
  ];

  // ============== 보상 설정 ==============
  static const int baseKnowledgePoints = 10;
  static const int choiceKnowledgeMin = 5;
  static const int choiceKnowledgeMax = 30;
  static const int characterCompleteBonus = 50;
  static const int locationCompleteBonus = 30;
  static const int eraCompleteBonus = 200;
}

/// 진행 시스템 설정
class ProgressionConfig {
  ProgressionConfig._();

  // ============== 탐험가 등급 ==============
  static const Map<ExplorerRank, int> rankThresholds = {
    ExplorerRank.novice: 0,
    ExplorerRank.apprentice: 1000,
    ExplorerRank.intermediate: 3000,
    ExplorerRank.advanced: 6000,
    ExplorerRank.expert: 9000,
    ExplorerRank.master: 12000,
  };

  // ============== 해금 조건 ==============
  static const double eraUnlockProgress = 0.3; // 30% 완료 시 다음 시대
  static const double regionUnlockProgress = 0.5; // 50% 완료 시 다음 지역
  static const double premiumSkipProgress = 0.0; // 프리미엄 구매 시 즉시 해금

  // ============== 포인트 획득 ==============
  static const Map<String, int> pointSources = {
    'dialogue_choice': 10, // 대화 선택
    'complete_character': 50, // 인물 대화 완료
    'complete_location': 30, // 장소 탐험 완료
    'complete_era': 200, // 시대 완료
    'quiz_correct': 10, // 퀴즈 정답
    'discover_secret': 100, // 히든 요소 발견
  };

  // ============== 업적 보너스 ==============
  static const double achievementBonusMultiplier = 1.5;
  static const int dailyLoginBonus = 20;
  static const int streakBonusPerDay = 5;
  static const int maxStreakDays = 30;
}

/// 탐험가 등급
enum ExplorerRank {
  novice, // 초보 탐험가 (0-999)
  apprentice, // 견습 역사가 (1000-2999)
  intermediate, // 중급 역사가 (3000-5999)
  advanced, // 고급 역사가 (6000-8999)
  expert, // 역사 전문가 (9000-11999)
  master, // 역사 마스터 (12000+)
}

/// 탐험가 등급 확장
extension ExplorerRankExtension on ExplorerRank {
  String get displayName {
    switch (this) {
      case ExplorerRank.novice:
        return '초보 탐험가';
      case ExplorerRank.apprentice:
        return '견습 역사가';
      case ExplorerRank.intermediate:
        return '중급 역사가';
      case ExplorerRank.advanced:
        return '고급 역사가';
      case ExplorerRank.expert:
        return '역사 전문가';
      case ExplorerRank.master:
        return '역사 마스터';
    }
  }

  String get description {
    switch (this) {
      case ExplorerRank.novice:
        return '역사 탐험을 시작한 초보자';
      case ExplorerRank.apprentice:
        return '기초적인 역사 지식을 갖춘 견습생';
      case ExplorerRank.intermediate:
        return '다양한 시대를 탐험한 역사가';
      case ExplorerRank.advanced:
        return '깊은 역사 이해력을 보유한 전문가';
      case ExplorerRank.expert:
        return '역사의 비밀을 꿰뚫는 전문가';
      case ExplorerRank.master:
        return '시간을 초월한 역사의 마스터';
    }
  }

  List<String> get unlocks {
    switch (this) {
      case ExplorerRank.novice:
        return ['기본 튜토리얼', '첫 번째 시대'];
      case ExplorerRank.apprentice:
        return ['유럽 지역', '힌트 기능'];
      case ExplorerRank.intermediate:
        return ['아프리카 지역', '역사 퀴즈 모드'];
      case ExplorerRank.advanced:
        return ['아메리카 지역', '타임라인 비교'];
      case ExplorerRank.expert:
        return ['중동 지역', '역사 What-If 모드'];
      case ExplorerRank.master:
        return ['히든 시대', '전용 칭호'];
    }
  }
}

/// 콘텐츠 상태
enum ContentStatus {
  locked, // 미해금
  available, // 탐험 가능
  inProgress, // 진행 중
  completed, // 완료
}

/// 콘텐츠 상태 확장
extension ContentStatusExtension on ContentStatus {
  bool get isAccessible =>
      this == ContentStatus.available ||
      this == ContentStatus.inProgress ||
      this == ContentStatus.completed;

  bool get showProgress =>
      this == ContentStatus.inProgress || this == ContentStatus.completed;
}
