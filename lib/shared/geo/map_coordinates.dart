import 'package:equatable/equatable.dart';

class MapCoordinates extends Equatable {
  final double x;
  final double y;

  const MapCoordinates({required this.x, required this.y});

  MapCoordinates copyWith({double? x, double? y}) {
    return MapCoordinates(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => 'MapCoordinates(x: $x, y: $y)';
}
