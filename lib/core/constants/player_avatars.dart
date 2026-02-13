/// 플레이어 프리셋 아바타 및 기본 프로필 상수
class PlayerAvatars {
  PlayerAvatars._();

  /// 기본 플레이어 이름
  static const String defaultName = '시간 여행자';
  static const String defaultNameEn = 'Time Traveler';

  /// 프리셋 아바타 에셋 경로 목록
  static const List<String> presets = [
    'assets/images/player/avatar_01.png',
    'assets/images/player/avatar_02.png',
    'assets/images/player/avatar_03.png',
    'assets/images/player/avatar_04.png',
    'assets/images/player/avatar_05.png',
    'assets/images/player/avatar_06.png',
  ];

  /// 아바타별 설명 (아바타 선택 UI에서 사용)
  static const List<String> labels = [
    '탐험가',
    '학자',
    '전사',
    '외교관',
    '예술가',
    '수호자',
  ];

  /// 안전한 아바타 경로 반환 (범위 체크)
  static String getAvatarPath(int index) {
    final safeIndex = index.clamp(0, presets.length - 1);
    return presets[safeIndex];
  }

  /// 프리셋 개수
  static int get count => presets.length;
}
