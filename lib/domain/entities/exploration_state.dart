import 'package:equatable/equatable.dart';

/// 탐험 진행 상태 엔티티
///
/// UserProgress에서 분리된 탐험 진행 관련 정보를 담는 엔티티입니다.
/// 지역/국가/시대별 진행률과 총 역사 이해도를 관리합니다.
///
/// ## 포함 정보
/// - 지역별 진행률 (regionProgress)
/// - 국가별 진행률 (countryProgress)
/// - 시대별 진행률 (eraProgress)
/// - 총 역사 이해도 (totalKnowledge)
///
/// ## 사용 예시
/// ```dart
/// final state = ExplorationState(
///   regionProgress: {'asia': 0.5, 'europe': 0.3},
///   eraProgress: {'ancient': 1.0, 'medieval': 0.5},
///   totalKnowledge: 500,
/// );
///
/// print(state.getRegionProgress('asia')); // 0.5
/// print(state.overallProgress); // 계산된 전체 진행률
/// ```
class ExplorationState extends Equatable {
  /// 지역별 진행률 (0.0 ~ 1.0)
  final Map<String, double> regionProgress;

  /// 국가별 진행률 (0.0 ~ 1.0)
  final Map<String, double> countryProgress;

  /// 시대별 진행률 (0.0 ~ 1.0)
  final Map<String, double> eraProgress;

  /// 총 역사 이해도 포인트
  final int totalKnowledge;

  const ExplorationState({
    this.regionProgress = const {},
    this.countryProgress = const {},
    this.eraProgress = const {},
    this.totalKnowledge = 0,
  });

  /// 복사본 생성
  ExplorationState copyWith({
    Map<String, double>? regionProgress,
    Map<String, double>? countryProgress,
    Map<String, double>? eraProgress,
    int? totalKnowledge,
  }) {
    return ExplorationState(
      regionProgress: regionProgress ?? this.regionProgress,
      countryProgress: countryProgress ?? this.countryProgress,
      eraProgress: eraProgress ?? this.eraProgress,
      totalKnowledge: totalKnowledge ?? this.totalKnowledge,
    );
  }

  /// 지역 진행률 가져오기
  double getRegionProgress(String regionId) {
    return regionProgress[regionId] ?? 0.0;
  }

  /// 국가 진행률 가져오기
  double getCountryProgress(String countryId) {
    return countryProgress[countryId] ?? 0.0;
  }

  /// 시대 진행률 가져오기
  double getEraProgress(String eraId) {
    return eraProgress[eraId] ?? 0.0;
  }

  /// 전체 진행률 계산 (시대 기준)
  double get overallProgress {
    if (eraProgress.isEmpty) return 0.0;
    final total = eraProgress.values.fold(0.0, (sum, p) => sum + p);
    return total / eraProgress.length;
  }

  /// 지역 진행률 업데이트
  ExplorationState updateRegionProgress(String regionId, double progress) {
    final updated = Map<String, double>.from(regionProgress);
    updated[regionId] = progress.clamp(0.0, 1.0);
    return copyWith(regionProgress: updated);
  }

  /// 국가 진행률 업데이트
  ExplorationState updateCountryProgress(String countryId, double progress) {
    final updated = Map<String, double>.from(countryProgress);
    updated[countryId] = progress.clamp(0.0, 1.0);
    return copyWith(countryProgress: updated);
  }

  /// 시대 진행률 업데이트
  ExplorationState updateEraProgress(String eraId, double progress) {
    final updated = Map<String, double>.from(eraProgress);
    updated[eraId] = progress.clamp(0.0, 1.0);
    return copyWith(eraProgress: updated);
  }

  /// 지식 포인트 추가
  ExplorationState addKnowledge(int points) {
    return copyWith(totalKnowledge: totalKnowledge + points);
  }

  @override
  List<Object?> get props => [
        regionProgress,
        countryProgress,
        eraProgress,
        totalKnowledge,
      ];

  @override
  String toString() =>
      'ExplorationState(totalKnowledge: $totalKnowledge, overallProgress: ${(overallProgress * 100).toStringAsFixed(1)}%)';
}
