List<String> stringList(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  return const [];
}

List<dynamic> dynamicList(dynamic value) {
  if (value is List) {
    return value;
  }
  return const [];
}

int? intOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? doubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? stringOrNull(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

String? isoStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is DateTime) return value.toIso8601String();
  return value.toString();
}
