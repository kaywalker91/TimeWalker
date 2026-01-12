import 'package:equatable/equatable.dart';

/// 해금 상태 엔티티
///
/// UserProgress에서 분리된 콘텐츠 해금 관련 정보를 담는 엔티티입니다.
/// 지역, 국가, 시대, 인물 등의 해금 상태를 관리합니다.
///
/// ## 포함 정보
/// - 해금된 지역 목록 (unlockedRegionIds)
/// - 해금된 국가 목록 (unlockedCountryIds)
/// - 해금된 시대 목록 (unlockedEraIds)
/// - 해금된 인물 목록 (unlockedCharacterIds)
/// - 해금된 역사 사실 목록 (unlockedFactIds)
///
/// ## 사용 예시
/// ```dart
/// final unlockState = UnlockState(
///   unlockedRegionIds: ['asia', 'europe'],
///   unlockedEraIds: ['ancient'],
/// );
///
/// print(unlockState.isRegionUnlocked('asia')); // true
/// print(unlockState.isEraUnlocked('modern')); // false
/// ```
class UnlockState extends Equatable {
  /// 해금된 지역 ID 목록
  final List<String> unlockedRegionIds;

  /// 해금된 국가 ID 목록
  final List<String> unlockedCountryIds;

  /// 해금된 시대 ID 목록
  final List<String> unlockedEraIds;

  /// 해금된 인물 ID 목록
  final List<String> unlockedCharacterIds;

  /// 해금된 역사 사실 ID 목록
  final List<String> unlockedFactIds;

  const UnlockState({
    this.unlockedRegionIds = const [],
    this.unlockedCountryIds = const [],
    this.unlockedEraIds = const [],
    this.unlockedCharacterIds = const [],
    this.unlockedFactIds = const [],
  });

  /// 복사본 생성
  UnlockState copyWith({
    List<String>? unlockedRegionIds,
    List<String>? unlockedCountryIds,
    List<String>? unlockedEraIds,
    List<String>? unlockedCharacterIds,
    List<String>? unlockedFactIds,
  }) {
    return UnlockState(
      unlockedRegionIds: unlockedRegionIds ?? this.unlockedRegionIds,
      unlockedCountryIds: unlockedCountryIds ?? this.unlockedCountryIds,
      unlockedEraIds: unlockedEraIds ?? this.unlockedEraIds,
      unlockedCharacterIds: unlockedCharacterIds ?? this.unlockedCharacterIds,
      unlockedFactIds: unlockedFactIds ?? this.unlockedFactIds,
    );
  }

  /// 지역이 해금되었는지 확인
  ///
  /// Americas 지역의 경우 north_america 또는 south_america 해금 시
  /// americas도 해금된 것으로 간주합니다.
  bool isRegionUnlocked(String regionId) {
    if (unlockedRegionIds.contains(regionId)) {
      return true;
    }

    // Americas 특수 처리
    if (regionId == 'americas') {
      return unlockedRegionIds.contains('north_america') ||
          unlockedRegionIds.contains('south_america');
    }

    if (regionId == 'north_america' || regionId == 'south_america') {
      return unlockedRegionIds.contains('americas');
    }

    return false;
  }

  /// 국가가 해금되었는지 확인
  bool isCountryUnlocked(String countryId) {
    return unlockedCountryIds.contains(countryId);
  }

  /// 시대가 해금되었는지 확인
  bool isEraUnlocked(String eraId) {
    return unlockedEraIds.contains(eraId);
  }

  /// 인물이 해금되었는지 확인
  bool isCharacterUnlocked(String characterId) {
    return unlockedCharacterIds.contains(characterId);
  }

  /// 역사 사실이 해금되었는지 확인
  bool isFactUnlocked(String factId) {
    return unlockedFactIds.contains(factId);
  }

  /// 지역 해금
  UnlockState unlockRegion(String regionId) {
    if (unlockedRegionIds.contains(regionId)) return this;
    return copyWith(
      unlockedRegionIds: [...unlockedRegionIds, regionId],
    );
  }

  /// 국가 해금
  UnlockState unlockCountry(String countryId) {
    if (unlockedCountryIds.contains(countryId)) return this;
    return copyWith(
      unlockedCountryIds: [...unlockedCountryIds, countryId],
    );
  }

  /// 시대 해금
  UnlockState unlockEra(String eraId) {
    if (unlockedEraIds.contains(eraId)) return this;
    return copyWith(
      unlockedEraIds: [...unlockedEraIds, eraId],
    );
  }

  /// 인물 해금
  UnlockState unlockCharacter(String characterId) {
    if (unlockedCharacterIds.contains(characterId)) return this;
    return copyWith(
      unlockedCharacterIds: [...unlockedCharacterIds, characterId],
    );
  }

  /// 역사 사실 해금
  UnlockState unlockFact(String factId) {
    if (unlockedFactIds.contains(factId)) return this;
    return copyWith(
      unlockedFactIds: [...unlockedFactIds, factId],
    );
  }

  /// 해금된 인물 수
  int get unlockedCharacterCount => unlockedCharacterIds.length;

  /// 해금된 역사 사실 수
  int get unlockedFactCount => unlockedFactIds.length;

  @override
  List<Object?> get props => [
        unlockedRegionIds,
        unlockedCountryIds,
        unlockedEraIds,
        unlockedCharacterIds,
        unlockedFactIds,
      ];

  @override
  String toString() =>
      'UnlockState(regions: ${unlockedRegionIds.length}, countries: ${unlockedCountryIds.length}, eras: ${unlockedEraIds.length})';
}
