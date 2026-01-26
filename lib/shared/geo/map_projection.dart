import 'package:time_walker/shared/geo/map_bounds.dart';
import 'package:time_walker/shared/geo/map_coordinates.dart';

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
