import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// 문명 엔티티
/// 
/// 시공의 회랑에서 표시되는 5대 문명을 나타냅니다.
/// 기존 Region 데이터를 래핑하여 추가적인 시각적 정보를 제공합니다.
class Civilization extends Equatable {
  final String id;
  final String name;
  final String nameEnglish;
  final String description;
  final String iconAsset;
  final Color portalColor;
  final Color glowColor;
  final List<String> countryIds;
  final Offset position;  // 화면상 정규화된 위치 (0.0 ~ 1.0)
  final int unlockLevel;
  final CivilizationStatus status;
  final double progress;

  const Civilization({
    required this.id,
    required this.name,
    required this.nameEnglish,
    required this.description,
    required this.iconAsset,
    required this.portalColor,
    required this.glowColor,
    required this.countryIds,
    required this.position,
    this.unlockLevel = 0,
    this.status = CivilizationStatus.locked,
    this.progress = 0.0,
  });

  Civilization copyWith({
    String? id,
    String? name,
    String? nameEnglish,
    String? description,
    String? iconAsset,
    Color? portalColor,
    Color? glowColor,
    List<String>? countryIds,
    Offset? position,
    int? unlockLevel,
    CivilizationStatus? status,
    double? progress,
  }) {
    return Civilization(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      description: description ?? this.description,
      iconAsset: iconAsset ?? this.iconAsset,
      portalColor: portalColor ?? this.portalColor,
      glowColor: glowColor ?? this.glowColor,
      countryIds: countryIds ?? this.countryIds,
      position: position ?? this.position,
      unlockLevel: unlockLevel ?? this.unlockLevel,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }

  /// 진행률 백분율 (0-100)
  int get progressPercent => (progress * 100).round();

  /// 접근 가능 여부
  bool get isAccessible => status != CivilizationStatus.locked;

  /// 해금됨 여부
  bool get isUnlocked => status == CivilizationStatus.available || 
                         status == CivilizationStatus.inProgress ||
                         status == CivilizationStatus.completed;

  @override
  List<Object?> get props => [
    id,
    name,
    nameEnglish,
    description,
    iconAsset,
    portalColor,
    glowColor,
    countryIds,
    position,
    unlockLevel,
    status,
    progress,
  ];

  @override
  String toString() => 'Civilization(id: $id, name: $name, status: $status)';
}

/// 문명 상태
enum CivilizationStatus {
  /// 잠금됨 (레벨 부족)
  locked,
  
  /// 해금 가능 (레벨 충족, 아직 시작 안 함)
  available,
  
  /// 탐험 중
  inProgress,
  
  /// 완료됨
  completed,
}

/// 문명 상태 확장
extension CivilizationStatusExtension on CivilizationStatus {
  bool get isAccessible => this != CivilizationStatus.locked;
  
  String get displayName {
    switch (this) {
      case CivilizationStatus.locked:
        return '잠금됨';
      case CivilizationStatus.available:
        return '탐험 가능';
      case CivilizationStatus.inProgress:
        return '탐험 중';
      case CivilizationStatus.completed:
        return '완료';
    }
  }
}
