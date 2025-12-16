import 'package:equatable/equatable.dart';

/// 역사 인물 엔티티
class Character extends Equatable {
  final String id;
  final String eraId;
  final String name;
  final String nameKorean;
  final String title; // 칭호 (예: "조선 제4대 국왕")
  final String birth;
  final String death;
  final String biography; // 짧은 소개
  final String fullBiography; // 상세 소개
  final String portraitAsset;
  final List<String> emotionAssets; // 표정별 에셋
  final List<String> dialogueIds;
  final List<String> relatedCharacterIds;
  final List<String> relatedLocationIds;
  final List<String> achievements; // 업적/공적
  final CharacterStatus status;
  final bool isHistorical; // 실존 인물 여부

  const Character({
    required this.id,
    required this.eraId,
    required this.name,
    required this.nameKorean,
    required this.title,
    required this.birth,
    required this.death,
    required this.biography,
    required this.fullBiography,
    required this.portraitAsset,
    required this.emotionAssets,
    required this.dialogueIds,
    this.relatedCharacterIds = const [],
    this.relatedLocationIds = const [],
    this.achievements = const [],
    this.status = CharacterStatus.locked,
    this.isHistorical = true,
  });

  Character copyWith({
    String? id,
    String? eraId,
    String? name,
    String? nameKorean,
    String? title,
    String? birth,
    String? death,
    String? biography,
    String? fullBiography,
    String? portraitAsset,
    List<String>? emotionAssets,
    List<String>? dialogueIds,
    List<String>? relatedCharacterIds,
    List<String>? relatedLocationIds,
    List<String>? achievements,
    CharacterStatus? status,
    bool? isHistorical,
  }) {
    return Character(
      id: id ?? this.id,
      eraId: eraId ?? this.eraId,
      name: name ?? this.name,
      nameKorean: nameKorean ?? this.nameKorean,
      title: title ?? this.title,
      birth: birth ?? this.birth,
      death: death ?? this.death,
      biography: biography ?? this.biography,
      fullBiography: fullBiography ?? this.fullBiography,
      portraitAsset: portraitAsset ?? this.portraitAsset,
      emotionAssets: emotionAssets ?? this.emotionAssets,
      dialogueIds: dialogueIds ?? this.dialogueIds,
      relatedCharacterIds: relatedCharacterIds ?? this.relatedCharacterIds,
      relatedLocationIds: relatedLocationIds ?? this.relatedLocationIds,
      achievements: achievements ?? this.achievements,
      status: status ?? this.status,
      isHistorical: isHistorical ?? this.isHistorical,
    );
  }

  /// 접근 가능 여부
  bool get isAccessible =>
      status == CharacterStatus.available ||
      status == CharacterStatus.inProgress ||
      status == CharacterStatus.completed;

  /// 완료 여부
  bool get isCompleted => status == CharacterStatus.completed;

  /// 생몰년 문자열
  String get lifespan => '$birth - $death';

  /// 대화 수
  int get dialogueCount => dialogueIds.length;

  @override
  List<Object?> get props => [
    id,
    eraId,
    name,
    nameKorean,
    title,
    birth,
    death,
    biography,
    fullBiography,
    portraitAsset,
    emotionAssets,
    dialogueIds,
    relatedCharacterIds,
    relatedLocationIds,
    achievements,
    status,
    isHistorical,
  ];

  @override
  String toString() => 'Character(id: $id, name: $nameKorean, status: $status)';
}

/// 인물 상태
enum CharacterStatus {
  locked, // 미해금
  available, // 만날 수 있음
  inProgress, // 대화 진행 중
  completed, // 모든 대화 완료
}

/// 인물 감정/표정
enum CharacterEmotion {
  neutral,
  happy,
  sad,
  angry,
  surprised,
  thoughtful,
  determined,
  worried,
  joyful,
  serious,
}

/// 인물 감정 확장
extension CharacterEmotionExtension on CharacterEmotion {
  String get displayName {
    switch (this) {
      case CharacterEmotion.neutral:
        return '평온';
      case CharacterEmotion.happy:
        return '기쁨';
      case CharacterEmotion.sad:
        return '슬픔';
      case CharacterEmotion.angry:
        return '분노';
      case CharacterEmotion.surprised:
        return '놀람';
      case CharacterEmotion.thoughtful:
        return '사색';
      case CharacterEmotion.determined:
        return '결연';
      case CharacterEmotion.worried:
        return '걱정';
      case CharacterEmotion.joyful:
        return '환희';
      case CharacterEmotion.serious:
        return '진지';
    }
  }

  String get assetSuffix {
    switch (this) {
      case CharacterEmotion.neutral:
        return 'neutral';
      case CharacterEmotion.happy:
        return 'happy';
      case CharacterEmotion.sad:
        return 'sad';
      case CharacterEmotion.angry:
        return 'angry';
      case CharacterEmotion.surprised:
        return 'surprised';
      case CharacterEmotion.thoughtful:
        return 'thoughtful';
      case CharacterEmotion.determined:
        return 'determined';
      case CharacterEmotion.worried:
        return 'worried';
      case CharacterEmotion.joyful:
        return 'joyful';
      case CharacterEmotion.serious:
        return 'serious';
    }
  }
}

/// 기본 인물 데이터 (MVP - 조선시대)
class CharacterData {
  CharacterData._();

  // ============== 조선시대 인물 ==============
  static const Character sejong = Character(
    id: 'sejong',
    eraId: 'korea_joseon',
    name: 'King Sejong the Great',
    nameKorean: '세종대왕',
    title: '조선 제4대 국왕',
    birth: '1397',
    death: '1450',
    biography: '한글을 창제하고 과학과 문화의 황금기를 이끈 성군',
    fullBiography:
        '조선의 제4대 국왕으로, 훈민정음(한글)을 창제하여 백성들이 '
        '쉽게 글을 읽고 쓸 수 있게 하였다. 또한 측우기, 해시계 등 과학 기구를 '
        '발명하게 하고, 집현전을 설치하여 학문을 장려하는 등 조선 역사상 '
        '가장 위대한 업적을 남긴 군주로 평가받는다.',
    portraitAsset: 'assets/images/characters/sejong.png',
    emotionAssets: [
      'assets/images/characters/sejong_neutral.png',
      'assets/images/characters/sejong_happy.png',
      'assets/images/characters/sejong_thoughtful.png',
      'assets/images/characters/sejong_determined.png',
    ],
    dialogueIds: ['sejong_hangul_01', 'sejong_science_01', 'sejong_policy_01'],
    relatedCharacterIds: ['jang_yeongshil', 'choe_manri'],
    relatedLocationIds: ['gyeongbokgung', 'jiphyeonjeon'],
    achievements: ['훈민정음(한글) 창제', '집현전 설치', '측우기, 앙부일구 발명', '4군 6진 개척'],
    status: CharacterStatus.available,
  );

  static const Character yiSunSin = Character(
    id: 'yi_sun_sin',
    eraId: 'korea_joseon',
    name: 'Admiral Yi Sun-sin',
    nameKorean: '이순신',
    title: '삼도수군통제사',
    birth: '1545',
    death: '1598',
    biography: '임진왜란에서 조선을 구한 불멸의 해군 명장',
    fullBiography:
        '임진왜란 당시 거북선을 이용해 일본 수군을 상대로 23전 23승의 '
        '전설적인 전적을 기록한 조선의 해군 명장. 명량해전, 한산도대첩 등 '
        '수많은 해전에서 승리하며 조선의 바다를 지켰다. 노량해전에서 '
        '적의 총탄에 맞아 전사하였으나, 그의 유언 "나의 죽음을 알리지 마라"는 '
        '오늘날까지 전해지고 있다.',
    portraitAsset: 'assets/images/characters/yi_sun_sin.png',
    emotionAssets: [
      'assets/images/characters/yi_sun_sin_neutral.png',
      'assets/images/characters/yi_sun_sin_serious.png',
      'assets/images/characters/yi_sun_sin_determined.png',
    ],
    dialogueIds: ['yi_geobukseon_01', 'yi_battle_01', 'yi_strategy_01'],
    relatedCharacterIds: ['won_gyun'],
    relatedLocationIds: ['geobukseon', 'hansando'],
    achievements: ['거북선 설계 및 건조', '한산도대첩 승리', '명량해전 승리', '23전 23승 불패 기록'],
    status: CharacterStatus.available,
  );

  static const Character jeongYakyong = Character(
    id: 'jeong_yakyong',
    eraId: 'korea_joseon',
    name: 'Jeong Yak-yong (Dasan)',
    nameKorean: '정약용',
    title: '다산, 실학자',
    birth: '1762',
    death: '1836',
    biography: '조선 후기 실학을 집대성한 위대한 학자',
    fullBiography:
        '조선 후기의 대표적인 실학자로, 500권이 넘는 저술을 남겼다. '
        '수원화성 설계에 참여하여 거중기를 고안하는 등 실용적인 학문을 추구했다. '
        '18년간의 유배 생활 중에도 <목민심서>, <경세유표> 등 후세에 '
        '귀감이 되는 저서를 집필하였다.',
    portraitAsset: 'assets/images/characters/jeong_yakyong.png',
    emotionAssets: [
      'assets/images/characters/jeong_yakyong_neutral.png',
      'assets/images/characters/jeong_yakyong_thoughtful.png',
    ],
    dialogueIds: ['jeong_silhak_01', 'jeong_exile_01'],
    relatedCharacterIds: ['jeongjo'],
    relatedLocationIds: ['suwon_hwaseong', 'gangjin'],
    achievements: ['목민심서 저술', '경세유표 저술', '거중기 설계', '실학 집대성'],
    status: CharacterStatus.locked,
  );

  // ============== 삼국시대 인물 ==============
  static const Character gwanggaeto = Character(
    id: 'gwanggaeto',
    eraId: 'korea_three_kingdoms',
    name: 'King Gwanggaeto the Great',
    nameKorean: '광개토대왕',
    title: '고구려 제19대 국왕',
    birth: '374',
    death: '412',
    biography: '고구려 최대 영토를 개척한 정복 군주',
    fullBiography:
        '고구려의 제19대 왕으로, 18세에 즉위하여 39세에 승하할 때까지 '
        '64개의 성과 1,400개의 촌락을 정복하여 고구려 역사상 최대의 영토를 '
        '확보하였다. 광개토대왕릉비에 그의 업적이 새겨져 있다.',
    portraitAsset: 'assets/images/characters/gwanggaeto.png',
    emotionAssets: [
      'assets/images/characters/gwanggaeto_neutral.png',
      'assets/images/characters/gwanggaeto_determined.png',
    ],
    dialogueIds: ['gwanggaeto_conquest_01', 'gwanggaeto_legacy_01'],
    relatedCharacterIds: ['jangsu'],
    relatedLocationIds: ['goguryeo_palace'],
    achievements: ['고구려 최대 영토 확장', '백제 정벌', '신라 구원', '광개토대왕릉비'],
    status: CharacterStatus.available,
  );

  static List<Character> get all => [
    sejong,
    yiSunSin,
    jeongYakyong,
    gwanggaeto,
  ];

  static List<Character> getByEra(String eraId) {
    return all.where((c) => c.eraId == eraId).toList();
  }

  static Character? getById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
