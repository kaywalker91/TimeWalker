// 오디오 관련 상수 정의
// BGM 트랙명, 시대별 BGM 매핑, 효과음 상수 등

/// 오디오 상수 클래스
class AudioConstants {
  AudioConstants._();

  // ============== BGM 경로 (assets/audio/bgm/) ==============
  static const String bgmBasePath = 'bgm/';
  
  // BGM 트랙 파일명
  static const String bgmMainMenu = 'main_menu.mp3';
  static const String bgmWorldMap = 'world_map.mp3';
  static const String bgmDialogue = 'dialogue.mp3';
  static const String bgmQuiz = 'quiz.mp3';
  static const String bgmEncyclopedia = 'encyclopedia.mp3';
  static const String bgmVictory = 'victory.mp3';
  
  // 시대별 BGM
  static const String bgmEraJoseon = 'era_joseon.mp3';
  static const String bgmEraThreeKingdoms = 'era_three_kingdoms.mp3';
  static const String bgmEraGoryeo = 'era_goryeo.mp3';
  static const String bgmEraGaya = 'era_gaya.mp3';
  static const String bgmEraRenaissance = 'era_renaissance.mp3';
  
  // 시대 ID -> BGM 파일명 매핑
  static const Map<String, String> eraBGM = {
    'korea_joseon': bgmEraJoseon,
    'korea_three_kingdoms': bgmEraThreeKingdoms,
    'korea_goryeo': bgmEraGoryeo,
    'korea_gaya': bgmEraGaya,
    'europe_renaissance': bgmEraRenaissance,
  };

  // ============== SFX 경로 (assets/audio/sfx/) ==============
  static const String sfxBasePath = 'sfx/';
  
  // 효과음 파일명
  static const String sfxButtonClick = 'button_click.mp3';
  static const String sfxDialogueAdvance = 'dialogue_advance.mp3';
  static const String sfxQuizCorrect = 'quiz_correct.mp3';
  static const String sfxQuizWrong = 'quiz_wrong.mp3';
  static const String sfxUnlock = 'unlock.mp3';
  static const String sfxDiscovery = 'discovery.mp3';
  static const String sfxLevelUp = 'level_up.mp3';
  static const String sfxCoinCollect = 'coin_collect.mp3';

  // ============== 기본 설정 ==============
  static const double defaultBgmVolume = 0.6;
  static const double defaultSfxVolume = 0.8;
  static const Duration fadeInDuration = Duration(milliseconds: 500);
  static const Duration fadeOutDuration = Duration(milliseconds: 300);
  static const Duration crossFadeDuration = Duration(milliseconds: 800);

  /// 시대 ID에 맞는 BGM 파일명 반환
  /// 매핑이 없으면 기본 월드맵 BGM 반환
  static String getBGMForEra(String eraId) {
    return eraBGM[eraId] ?? bgmWorldMap;
  }
}
