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

  factory EncyclopediaEntry.fromJson(Map<String, dynamic> json) {
    return EncyclopediaEntry(
      id: json['id'] as String,
      type: EntryType.values.firstWhere(
        (e) => e.name == (json['type'] as String),
        orElse: () => EntryType.term,
      ),
      title: json['title'] as String,
      titleKorean: json['titleKorean'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      thumbnailAsset: json['thumbnailAsset'] as String,
      imageAsset: json['imageAsset'] as String?,
      eraId: json['eraId'] as String,
      relatedEntryIds: List<String>.from(json['relatedEntryIds'] as List? ?? []),
      tags: List<String>.from(json['tags'] as List? ?? []),
      isDiscovered: json['isDiscovered'] as bool? ?? false,
      discoveredAt: json['discoveredAt'] != null
          ? DateTime.parse(json['discoveredAt'] as String)
          : null,
      discoverySource: json['discoverySource'] as String?,
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
