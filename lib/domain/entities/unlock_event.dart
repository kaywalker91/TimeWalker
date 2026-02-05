import 'package:equatable/equatable.dart';
import 'package:time_walker/domain/entities/country.dart';
import 'package:time_walker/domain/entities/era.dart';
import 'package:time_walker/domain/entities/region.dart';

/// 해금 이벤트 유형
enum UnlockType {
  era,
  country,
  region,
  rank,
  feature,
  encyclopedia, // 역사 도감 항목
  character, // 인물 해금
}

/// 해금 이벤트 데이터
class UnlockEvent extends Equatable {
  final UnlockType type;
  final String id; // Era ID, Region ID, or formatted string for rank
  final String name; // Display name
  final String? message; // Optional message

  const UnlockEvent({
    required this.type,
    required this.id,
    required this.name,
    this.message,
  });

  @override
  List<Object?> get props => [type, id, name, message];
}

/// 해금 계산에 필요한 콘텐츠 데이터
class UnlockContent {
  final List<Era> eras;
  final List<Country> countries;
  final Map<String, Region> regionsById;

  const UnlockContent({
    this.eras = const [],
    this.countries = const [],
    this.regionsById = const {},
  });
}
