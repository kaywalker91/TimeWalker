import 'package:equatable/equatable.dart';

/// 도감 항목 타입
enum EntryType {
  character, // 인물
  event, // 사건
  location, // 장소
  artifact, // 문화재
  term, // 역사 용어
}

/// 도감 항목 타입 확장
extension EntryTypeExtension on EntryType {
  String get displayName {
    switch (this) {
      case EntryType.character:
        return '인물';
      case EntryType.event:
        return '사건';
      case EntryType.location:
        return '장소';
      case EntryType.artifact:
        return '문화재';
      case EntryType.term:
        return '용어';
    }
  }

  String get icon {
    switch (this) {
      case EntryType.character:
        return '👤';
      case EntryType.event:
        return '📜';
      case EntryType.location:
        return '📍';
      case EntryType.artifact:
        return '🏛️';
      case EntryType.term:
        return '📖';
    }
  }
}

/// 도감 항목 엔티티
class EncyclopediaEntry extends Equatable {
  final String id;
  final EntryType type;
  final String title;
  final String titleKorean;
  final String summary; // 짧은 요약
  final String content; // 상세 내용
  final String thumbnailAsset;
  final String? imageAsset; // 상세 이미지
  final String eraId; // 관련 시대
  final List<String> relatedEntryIds;
  final List<String> tags;
  final bool isDiscovered;
  final DateTime? discoveredAt;
  final String? discoverySource; // 어디서 발견했는지 (대화 ID 등)

  const EncyclopediaEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.titleKorean,
    required this.summary,
    required this.content,
    required this.thumbnailAsset,
    this.imageAsset,
    required this.eraId,
    this.relatedEntryIds = const [],
    this.tags = const [],
    this.isDiscovered = false,
    this.discoveredAt,
    this.discoverySource,
  });

  EncyclopediaEntry copyWith({
    String? id,
    EntryType? type,
    String? title,
    String? titleKorean,
    String? summary,
    String? content,
    String? thumbnailAsset,
    String? imageAsset,
    String? eraId,
    List<String>? relatedEntryIds,
    List<String>? tags,
    bool? isDiscovered,
    DateTime? discoveredAt,
    String? discoverySource,
  }) {
    return EncyclopediaEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      titleKorean: titleKorean ?? this.titleKorean,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      imageAsset: imageAsset ?? this.imageAsset,
      eraId: eraId ?? this.eraId,
      relatedEntryIds: relatedEntryIds ?? this.relatedEntryIds,
      tags: tags ?? this.tags,
      isDiscovered: isDiscovered ?? this.isDiscovered,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      discoverySource: discoverySource ?? this.discoverySource,
    );
  }

  /// 관련 항목 수
  int get relatedCount => relatedEntryIds.length;

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    titleKorean,
    summary,
    content,
    thumbnailAsset,
    imageAsset,
    eraId,
    relatedEntryIds,
    tags,
    isDiscovered,
    discoveredAt,
    discoverySource,
  ];

  @override
  String toString() =>
      'EncyclopediaEntry(id: $id, title: $titleKorean, discovered: $isDiscovered)';
}

/// 도감 통계
class EncyclopediaStats extends Equatable {
  final int totalEntries;
  final int discoveredEntries;
  final Map<EntryType, int> totalByType;
  final Map<EntryType, int> discoveredByType;

  const EncyclopediaStats({
    required this.totalEntries,
    required this.discoveredEntries,
    required this.totalByType,
    required this.discoveredByType,
  });

  /// 전체 발견률 (0.0 ~ 1.0)
  double get discoveryRate {
    if (totalEntries == 0) return 0.0;
    return discoveredEntries / totalEntries;
  }

  /// 발견률 백분율 (0-100)
  int get discoveryPercent => (discoveryRate * 100).round();

  /// 타입별 발견률
  double getTypeDiscoveryRate(EntryType type) {
    final total = totalByType[type] ?? 0;
    if (total == 0) return 0.0;
    final discovered = discoveredByType[type] ?? 0;
    return discovered / total;
  }

  @override
  List<Object?> get props => [
    totalEntries,
    discoveredEntries,
    totalByType,
    discoveredByType,
  ];
}

/// 기본 도감 항목 데이터 (MVP)
class EncyclopediaData {
  EncyclopediaData._();

  // ============== 사건 ==============
  static const EncyclopediaEntry hunminjeongeum = EncyclopediaEntry(
    id: 'hunminjeongeum',
    type: EntryType.event,
    title: 'Promulgation of Hunminjeongeum',
    titleKorean: '훈민정음 반포',
    summary: '세종대왕이 백성을 위해 새로운 문자를 만들어 반포한 역사적 사건',
    content:
        '1446년 음력 9월, 세종대왕은 집현전 학자들과 함께 만든 새로운 문자 '
        '훈민정음을 세상에 반포하였다. "백성을 가르치는 바른 소리"라는 뜻을 가진 '
        '이 문자는 누구나 쉽게 배울 수 있도록 과학적 원리에 기반하여 만들어졌다. '
        '오늘날 한글의 시초가 된 이 위대한 문자는 유네스코 세계기록유산으로 등재되어 '
        '그 가치를 전 세계적으로 인정받고 있다.',
    thumbnailAsset: 'assets/images/encyclopedia/hunminjeongeum.png',
    imageAsset: 'assets/images/encyclopedia/hunminjeongeum_detail.png',
    eraId: 'korea_joseon',
    relatedEntryIds: ['sejong_character', 'jiphyeonjeon', 'choe_manri'],
    tags: ['한글', '세종대왕', '문자', '1446년'],
  );

  static const EncyclopediaEntry imjinWar = EncyclopediaEntry(
    id: 'imjin_war',
    type: EntryType.event,
    title: 'Japanese Invasions of Korea',
    titleKorean: '임진왜란',
    summary: '1592년 일본의 조선 침략으로 시작된 7년간의 전쟁',
    content:
        '1592년 4월, 도요토미 히데요시가 이끄는 일본군 15만 명이 조선을 침략하면서 '
        '시작된 전쟁. 불과 20일 만에 한양이 함락되는 등 위기에 처했으나, '
        '이순신 장군의 해전 승리와 전국 각지의 의병 활동으로 전세를 역전시켰다. '
        '1598년 일본군이 철수할 때까지 7년간 이어진 이 전쟁으로 조선은 큰 피해를 입었지만, '
        '민족의 저항 정신을 보여준 역사적 사건으로 기억되고 있다.',
    thumbnailAsset: 'assets/images/encyclopedia/imjin_war.png',
    eraId: 'korea_joseon',
    relatedEntryIds: ['yi_sun_sin_character', 'geobukseon', 'hansando_battle'],
    tags: ['임진왜란', '이순신', '1592년', '전쟁'],
  );

  // ============== 장소 ==============
  static const EncyclopediaEntry gyeongbokgung = EncyclopediaEntry(
    id: 'gyeongbokgung',
    type: EntryType.location,
    title: 'Gyeongbokgung Palace',
    titleKorean: '경복궁',
    summary: '조선 왕조의 법궁(法宮), 서울의 중심에 자리한 조선 최대의 궁궐',
    content:
        '1395년 태조 이성계가 조선 건국 후 처음으로 세운 궁궐로, '
        '"큰 복을 누리라"는 의미를 담고 있다. 근정전, 경회루, 향원정 등 '
        '아름다운 건축물들이 있으며, 조선 500년 역사와 함께해온 상징적인 장소이다. '
        '임진왜란 때 불타 270년간 폐허로 남았다가 고종 때 중건되었다.',
    thumbnailAsset: 'assets/images/encyclopedia/gyeongbokgung.png',
    imageAsset: 'assets/images/encyclopedia/gyeongbokgung_detail.png',
    eraId: 'korea_joseon',
    relatedEntryIds: ['geunjeongjeon', 'gyeonghoeru', 'joseon_founding'],
    tags: ['궁궐', '서울', '조선', '유네스코'],
  );

  // ============== 문화재 ==============
  static const EncyclopediaEntry geobukseon = EncyclopediaEntry(
    id: 'geobukseon',
    type: EntryType.artifact,
    title: 'Geobukseon (Turtle Ship)',
    titleKorean: '거북선',
    summary: '이순신 장군이 설계한 세계 최초의 철갑선',
    content:
        '임진왜란 당시 이순신 장군이 고안한 조선 수군의 주력 전함. '
        '철로 덮인 뾰족한 등판과 용머리 형상의 뱃머리가 특징으로, '
        '적의 총탄과 화살을 막아내며 근접 백병전을 방지했다. '
        '양쪽에 노와 포가 장착되어 있어 기동성과 화력을 겸비한 혁신적인 전함이었다.',
    thumbnailAsset: 'assets/images/encyclopedia/geobukseon.png',
    imageAsset: 'assets/images/encyclopedia/geobukseon_detail.png',
    eraId: 'korea_joseon',
    relatedEntryIds: ['yi_sun_sin_character', 'imjin_war', 'hansando_battle'],
    tags: ['거북선', '이순신', '임진왜란', '전함'],
  );

  static List<EncyclopediaEntry> get all => [
    hunminjeongeum,
    imjinWar,
    gyeongbokgung,
    geobukseon,
  ];

  static List<EncyclopediaEntry> getByType(EntryType type) {
    return all.where((e) => e.type == type).toList();
  }

  static List<EncyclopediaEntry> getByEra(String eraId) {
    return all.where((e) => e.eraId == eraId).toList();
  }

  static EncyclopediaEntry? getById(String id) {
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
