import 'package:time_walker/domain/entities/region.dart';

class MapBounds {
  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;

  const MapBounds({
    required this.minLatitude,
    required this.maxLatitude,
    required this.minLongitude,
    required this.maxLongitude,
  });
}

class MapProjection {
  MapProjection._();

  static MapCoordinates projectNormalized({
    required double latitude,
    required double longitude,
    required MapBounds bounds,
  }) {
    final xRaw = (longitude - bounds.minLongitude) /
        (bounds.maxLongitude - bounds.minLongitude);
    final yRaw = (bounds.maxLatitude - latitude) /
        (bounds.maxLatitude - bounds.minLatitude);

    return MapCoordinates(
      x: _clamp01(xRaw),
      y: _clamp01(yRaw),
    );
  }

  static double _clamp01(double value) {
    return value.clamp(0.0, 1.0);
  }
}
