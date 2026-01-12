import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/region.dart';

/// 탐험 장소 엔티티
class Location extends Equatable {
  final String id;
  final String eraId;
  final String name;
  final String nameKorean;
  final String description;
  final String thumbnailAsset;
  final String backgroundAsset;
  final String? kingdom; // 삼국시대 전용 구분 (고구려/백제/신라/가야)
  final double? latitude;
  final double? longitude;
  final String? displayYear; // UI에 노출할 연대
  final int? timelineOrder; // 시대 내 정렬 우선순위
  final MapCoordinates position; // 탐험 화면에서의 위치
  final List<String> characterIds; // 이 장소에서 만날 수 있는 인물
  final List<String> eventIds; // 이 장소에서 발생하는 이벤트
  final ContentStatus status;
  final bool isHistorical; // 실제 역사적 장소 여부

  const Location({
    required this.id,
    required this.eraId,
    required this.name,
    required this.nameKorean,
    required this.description,
    required this.thumbnailAsset,
    required this.backgroundAsset,
    this.kingdom,
    this.latitude,
    this.longitude,
    this.displayYear,
    this.timelineOrder,
    required this.position,
    this.characterIds = const [],
    this.eventIds = const [],
    this.status = ContentStatus.locked,
    this.isHistorical = true,
  });

  Location copyWith({
    String? id,
    String? eraId,
    String? name,
    String? nameKorean,
    String? description,
    String? thumbnailAsset,
    String? backgroundAsset,
    String? kingdom,
    double? latitude,
    double? longitude,
    String? displayYear,
    int? timelineOrder,
    MapCoordinates? position,
    List<String>? characterIds,
    List<String>? eventIds,
    ContentStatus? status,
    bool? isHistorical,
  }) {
    return Location(
      id: id ?? this.id,
      eraId: eraId ?? this.eraId,
      name: name ?? this.name,
      nameKorean: nameKorean ?? this.nameKorean,
      description: description ?? this.description,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
      kingdom: kingdom ?? this.kingdom,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      displayYear: displayYear ?? this.displayYear,
      timelineOrder: timelineOrder ?? this.timelineOrder,
      position: position ?? this.position,
      characterIds: characterIds ?? this.characterIds,
      eventIds: eventIds ?? this.eventIds,
      status: status ?? this.status,
      isHistorical: isHistorical ?? this.isHistorical,
    );
  }

  /// 접근 가능 여부
  bool get isAccessible => status.isAccessible;

  /// 완료 여부
  bool get isCompleted => status == ContentStatus.completed;

  /// 만날 수 있는 인물 수
  int get characterCount => characterIds.length;

  @override
  List<Object?> get props => [
    id,
    eraId,
    name,
    nameKorean,
    description,
    thumbnailAsset,
    backgroundAsset,
    kingdom,
    latitude,
    longitude,
    displayYear,
    timelineOrder,
    position,
    characterIds,
    eventIds,
    status,
    isHistorical,
  ];

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      eraId: json['eraId'] as String,
      name: json['name'] as String,
      nameKorean: json['nameKorean'] as String,
      description: json['description'] as String,
      thumbnailAsset: json['thumbnailAsset'] as String,
      backgroundAsset: json['backgroundAsset'] as String,
      kingdom: json['kingdom'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ??
          (json['lat'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble() ??
          (json['lon'] as num?)?.toDouble(),
      displayYear: json['displayYear'] as String?,
      timelineOrder: (json['timelineOrder'] as num?)?.toInt(),
      position: MapCoordinates(
        x: (json['position']['x'] as num).toDouble(),
        y: (json['position']['y'] as num).toDouble(),
      ),
      characterIds: List<String>.from(json['characterIds'] as List? ?? []),
      eventIds: List<String>.from(json['eventIds'] as List? ?? []),
      status: ContentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'locked'),
        orElse: () => ContentStatus.locked,
      ),
      isHistorical: json['isHistorical'] as bool? ?? true,
    );
  }

  @override
  String toString() => 'Location(id: $id, name: $nameKorean, status: $status)';
}
