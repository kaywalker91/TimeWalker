// 사용자 설정 엔티티

class GameSettings {
  final bool soundEnabled;
  final bool musicEnabled;
  final double soundVolume;
  final double musicVolume;
  final bool vibrationEnabled;
  final String languageCode;
  final AccessibilitySettings accessibility;
  final bool tutorialCompleted;
  final bool adsRemoved;
  final bool developerMode;

  const GameSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.soundVolume = 0.8,
    this.musicVolume = 0.6,
    this.vibrationEnabled = true,
    this.languageCode = 'ko',
    this.accessibility = const AccessibilitySettings(),
    this.tutorialCompleted = false,
    this.adsRemoved = false,
    this.developerMode = false,
  });

  GameSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    double? soundVolume,
    double? musicVolume,
    bool? vibrationEnabled,
    String? languageCode,
    AccessibilitySettings? accessibility,
    bool? tutorialCompleted,
    bool? adsRemoved,
    bool? developerMode,
  }) {
    return GameSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      musicVolume: musicVolume ?? this.musicVolume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      languageCode: languageCode ?? this.languageCode,
      accessibility: accessibility ?? this.accessibility,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      adsRemoved: adsRemoved ?? this.adsRemoved,
      developerMode: developerMode ?? this.developerMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'soundEnabled': soundEnabled,
    'musicEnabled': musicEnabled,
    'soundVolume': soundVolume,
    'musicVolume': musicVolume,
    'vibrationEnabled': vibrationEnabled,
    'languageCode': languageCode,
    'accessibility': accessibility.toJson(),
    'tutorialCompleted': tutorialCompleted,
    'adsRemoved': adsRemoved,
    'developerMode': developerMode,
  };

  factory GameSettings.fromJson(Map<String, dynamic> json) => GameSettings(
    soundEnabled: json['soundEnabled'] ?? true,
    musicEnabled: json['musicEnabled'] ?? true,
    soundVolume: (json['soundVolume'] ?? 0.8).toDouble(),
    musicVolume: (json['musicVolume'] ?? 0.6).toDouble(),
    vibrationEnabled: json['vibrationEnabled'] ?? true,
    languageCode: json['languageCode'] ?? 'ko',
    accessibility: json['accessibility'] != null
        ? AccessibilitySettings.fromJson(json['accessibility'])
        : const AccessibilitySettings(),
    tutorialCompleted: json['tutorialCompleted'] ?? false,
    adsRemoved: json['adsRemoved'] ?? false,
    developerMode: json['developerMode'] ?? false,
  );
}

/// 접근성 설정
class AccessibilitySettings {
  final bool colorBlindMode; // 색맹 모드
  final bool highContrastMode; // 고대비 모드
  final bool subtitlesEnabled; // 자막 (효과음 텍스트)
  final bool oneHandedMode; // 한손 모드

  const AccessibilitySettings({
    this.colorBlindMode = false,
    this.highContrastMode = false,
    this.subtitlesEnabled = false,
    this.oneHandedMode = false,
  });

  AccessibilitySettings copyWith({
    bool? colorBlindMode,
    bool? highContrastMode,
    bool? subtitlesEnabled,
    bool? oneHandedMode,
  }) {
    return AccessibilitySettings(
      colorBlindMode: colorBlindMode ?? this.colorBlindMode,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      subtitlesEnabled: subtitlesEnabled ?? this.subtitlesEnabled,
      oneHandedMode: oneHandedMode ?? this.oneHandedMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'colorBlindMode': colorBlindMode,
    'highContrastMode': highContrastMode,
    'subtitlesEnabled': subtitlesEnabled,
    'oneHandedMode': oneHandedMode,
  };

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) =>
      AccessibilitySettings(
        colorBlindMode: json['colorBlindMode'] ?? false,
        highContrastMode: json['highContrastMode'] ?? false,
        subtitlesEnabled: json['subtitlesEnabled'] ?? false,
        oneHandedMode: json['oneHandedMode'] ?? false,
      );
}
