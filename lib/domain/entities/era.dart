import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:time_walker/core/constants/exploration_config.dart';
import 'package:time_walker/core/utils/map_projection.dart';

/// 시대 엔티티
/// 예: 삼국시대, 고려시대, 조선시대
class Era extends Equatable {
  final String id;
  final String countryId;
  final String name;
  final String nameKorean;
  final String period; // "57 BC - 668 AD"
  final int startYear;
  final int endYear;
  final String description;
  final String thumbnailAsset;
  final String backgroundAsset;
  final String bgmAsset;
  final EraTheme theme;
  final List<String> chapterIds;
  final List<String> characterIds;
  final List<String> locationIds;
  final ContentStatus status;
  final double progress;
  final int estimatedMinutes;
  final UnlockCondition unlockCondition;
  final MapBounds? mapBounds;

  const Era({
    required this.id,
    required this.countryId,
    required this.name,
    required this.nameKorean,
    required this.period,
    required this.startYear,
    required this.endYear,
    required this.description,
    required this.thumbnailAsset,
    required this.backgroundAsset,
    required this.bgmAsset,
    required this.theme,
    required this.chapterIds,
    required this.characterIds,
    required this.locationIds,
    this.status = ContentStatus.locked,
    this.progress = 0.0,
    this.estimatedMinutes = 30,
    this.unlockCondition = const UnlockCondition(),
    this.mapBounds,
  });

  Era copyWith({
    String? id,
    String? countryId,
    String? name,
    String? nameKorean,
    String? period,
    int? startYear,
    int? endYear,
    String? description,
    String? thumbnailAsset,
    String? backgroundAsset,
    String? bgmAsset,
    EraTheme? theme,
    List<String>? chapterIds,
    List<String>? characterIds,
    List<String>? locationIds,
    ContentStatus? status,
    double? progress,
    int? estimatedMinutes,
    UnlockCondition? unlockCondition,
    MapBounds? mapBounds,
  }) {
    return Era(
      id: id ?? this.id,
      countryId: countryId ?? this.countryId,
      name: name ?? this.name,
      nameKorean: nameKorean ?? this.nameKorean,
      period: period ?? this.period,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      description: description ?? this.description,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
      bgmAsset: bgmAsset ?? this.bgmAsset,
      theme: theme ?? this.theme,
      chapterIds: chapterIds ?? this.chapterIds,
      characterIds: characterIds ?? this.characterIds,
      locationIds: locationIds ?? this.locationIds,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      unlockCondition: unlockCondition ?? this.unlockCondition,
      mapBounds: mapBounds ?? this.mapBounds,
    );
  }

  /// 진행률 백분율 (0-100)
  int get progressPercent => (progress * 100).round();

  /// 접근 가능 여부
  bool get isAccessible => status.isAccessible;

  /// 완료 여부
  bool get isCompleted => status == ContentStatus.completed;

  /// 기간 (년 수)
  int get durationYears => endYear - startYear;

  /// 인물 수
  int get characterCount => characterIds.length;

  /// 장소 수
  int get locationCount => locationIds.length;

  @override
  List<Object?> get props => [
    id,
    countryId,
    name,
    nameKorean,
    period,
    startYear,
    endYear,
    description,
    thumbnailAsset,
    backgroundAsset,
    bgmAsset,
    theme,
    chapterIds,
    characterIds,
    locationIds,
    status,
    progress,
    estimatedMinutes,
    unlockCondition,
    mapBounds,
  ];

  @override
  String toString() => 'Era(id: $id, name: $nameKorean, status: $status)';
}

/// 시대 테마 (색상, 분위기)
class EraTheme extends Equatable {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final String fontFamily;

  const EraTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    this.fontFamily = 'NotoSansKR',
  });

  @override
  List<Object?> get props => [
    primaryColor,
    secondaryColor,
    accentColor,
    backgroundColor,
    textColor,
    fontFamily,
  ];
}

/// 해금 조건
class UnlockCondition extends Equatable {
  final String? previousEraId; // 이전 시대 ID
  final double requiredProgress; // 필요 진행률 (0.0 ~ 1.0)
  final int? requiredLevel; // 필요 탐험가 레벨
  final bool isPremium; // 프리미엄 구매 필요 여부

  const UnlockCondition({
    this.previousEraId,
    this.requiredProgress = 0.3,
    this.requiredLevel,
    this.isPremium = false,
  });

  @override
  List<Object?> get props => [
    previousEraId,
    requiredProgress,
    requiredLevel,
    isPremium,
  ];
}


