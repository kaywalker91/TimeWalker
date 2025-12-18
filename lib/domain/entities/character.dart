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

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      eraId: json['eraId'] as String,
      name: json['name'] as String? ?? json['nameKorean'] as String? ?? 'Unknown',
      nameKorean: json['nameKorean'] as String? ?? json['name'] as String? ?? '알 수 없음',
      title: json['title'] as String? ?? json['description'] as String? ?? '',
      birth: json['birth'] as String? ?? '?',
      death: json['death'] as String? ?? '?',
      biography: json['biography'] as String? ?? json['description'] as String? ?? '',
      fullBiography: json['fullBiography'] as String? ?? json['description'] as String? ?? '',
      portraitAsset: json['portraitAsset'] as String? ?? json['thumbnailAsset'] as String? ?? 'assets/images/characters/placeholder.png',
      emotionAssets: List<String>.from(json['emotionAssets'] as List? ?? []),
      dialogueIds: List<String>.from(json['dialogueIds'] as List? ?? []),
      relatedCharacterIds: List<String>.from(json['relatedCharacterIds'] as List? ?? []),
      relatedLocationIds: List<String>.from(json['relatedLocationIds'] as List? ?? []),
      achievements: List<String>.from(json['achievements'] as List? ?? []),
      status: CharacterStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'locked'),
        orElse: () => CharacterStatus.locked,
      ),
      isHistorical: json['isHistorical'] as bool? ?? true,
    );
  }

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


