import 'package:equatable/equatable.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/domain/entities/region.dart';

/// 국가/문명 엔티티
/// 예: 한반도, 중국, 일본, 그리스, 로마
class Country extends Equatable {
  final String id;
  final String regionId;
  final String name;
  final String nameKorean;
  final String description;
  final String thumbnailAsset;
  final String backgroundAsset;
  final MapCoordinates position;
  final List<String> eraIds;
  final ContentStatus status;
  final double progress;

  const Country({
    required this.id,
    required this.regionId,
    required this.name,
    required this.nameKorean,
    required this.description,
    required this.thumbnailAsset,
    required this.backgroundAsset,
    required this.position,
    required this.eraIds,
    this.status = ContentStatus.locked,
    this.progress = 0.0,
  });

  Country copyWith({
    String? id,
    String? regionId,
    String? name,
    String? nameKorean,
    String? description,
    String? thumbnailAsset,
    String? backgroundAsset,
    MapCoordinates? position,
    List<String>? eraIds,
    ContentStatus? status,
    double? progress,
  }) {
    return Country(
      id: id ?? this.id,
      regionId: regionId ?? this.regionId,
      name: name ?? this.name,
      nameKorean: nameKorean ?? this.nameKorean,
      description: description ?? this.description,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
      position: position ?? this.position,
      eraIds: eraIds ?? this.eraIds,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }

  /// 진행률 백분율 (0-100)
  int get progressPercent => (progress * 100).round();

  /// 접근 가능 여부
  bool get isAccessible => status.isAccessible;

  /// 완료 여부
  bool get isCompleted => status == ContentStatus.completed;

  /// 시대 수
  int get eraCount => eraIds.length;

  @override
  List<Object?> get props => [
    id,
    regionId,
    name,
    nameKorean,
    description,
    thumbnailAsset,
    backgroundAsset,
    position,
    eraIds,
    status,
    progress,
  ];

  @override
  String toString() => 'Country(id: $id, name: $nameKorean, status: $status)';
}


