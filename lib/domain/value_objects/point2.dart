import 'package:equatable/equatable.dart';

class Point2 extends Equatable {
  final double x;
  final double y;

  const Point2({required this.x, required this.y});

  Point2 copyWith({double? x, double? y}) {
    return Point2(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  List<Object?> get props => [x, y];
}
