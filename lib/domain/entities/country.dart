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

/// 기본 국가 데이터 (MVP - 한반도)
class CountryData {
  CountryData._();

  // ============== 아시아 ==============
  static const Country korea = Country(
    id: 'korea',
    regionId: 'asia',
    name: 'Korean Peninsula',
    nameKorean: '한반도',
    description: '5000년 역사의 땅, 삼국시대부터 조선까지',
    thumbnailAsset: 'assets/images/map/korea.png',
    backgroundAsset: 'assets/images/locations/korea_bg.png',
    position: MapCoordinates(x: 0.82, y: 0.38),
    eraIds: ['korea_three_kingdoms', 'korea_goryeo', 'korea_joseon'],
    status: ContentStatus.available, // MVP 기본 해금
  );

  static const Country china = Country(
    id: 'china',
    regionId: 'asia',
    name: 'China',
    nameKorean: '중국',
    description: '황하 문명부터 청나라까지, 동아시아 문명의 중심',
    thumbnailAsset: 'assets/images/map/china.png',
    backgroundAsset: 'assets/images/locations/china_bg.png',
    position: MapCoordinates(x: 0.75, y: 0.42),
    eraIds: ['china_three_kingdoms', 'china_tang', 'china_ming'],
    status: ContentStatus.locked,
  );

  static const Country japan = Country(
    id: 'japan',
    regionId: 'asia',
    name: 'Japan',
    nameKorean: '일본',
    description: '사무라이와 쇼군의 나라, 독특한 섬나라 문화',
    thumbnailAsset: 'assets/images/map/japan.png',
    backgroundAsset: 'assets/images/locations/japan_bg.png',
    position: MapCoordinates(x: 0.88, y: 0.40),
    eraIds: ['japan_heian', 'japan_sengoku', 'japan_edo'],
    status: ContentStatus.locked,
  );

  // ============== 유럽 ==============
  static const Country greece = Country(
    id: 'greece',
    regionId: 'europe',
    name: 'Ancient Greece',
    nameKorean: '고대 그리스',
    description: '민주주의와 철학의 발상지',
    thumbnailAsset: 'assets/images/map/greece.png',
    backgroundAsset: 'assets/images/locations/greece_bg.png',
    position: MapCoordinates(x: 0.52, y: 0.40),
    eraIds: ['greece_classical', 'greece_hellenistic'],
    status: ContentStatus.locked,
  );

  static const Country rome = Country(
    id: 'rome',
    regionId: 'europe',
    name: 'Roman Empire',
    nameKorean: '로마 제국',
    description: '유럽을 통일한 거대 제국',
    thumbnailAsset: 'assets/images/map/rome.png',
    backgroundAsset: 'assets/images/locations/rome_bg.png',
    position: MapCoordinates(x: 0.48, y: 0.38),
    eraIds: ['rome_republic', 'rome_empire'],
    status: ContentStatus.locked,
  );

  // ============== 아프리카 ==============
  static const Country egypt = Country(
    id: 'egypt',
    regionId: 'africa',
    name: 'Ancient Egypt',
    nameKorean: '고대 이집트',
    description: '피라미드와 파라오의 땅, 나일강의 축복',
    thumbnailAsset: 'assets/images/map/egypt.png',
    backgroundAsset: 'assets/images/locations/egypt_bg.png',
    position: MapCoordinates(x: 0.52, y: 0.48),
    eraIds: ['egypt_old_kingdom', 'egypt_new_kingdom'],
    status: ContentStatus.locked,
  );

  static List<Country> get all => [korea, china, japan, greece, rome, egypt];

  static List<Country> getByRegion(String regionId) {
    return all.where((c) => c.regionId == regionId).toList();
  }

  static Country? getById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
