import 'dart:convert';
import 'dart:io';

/// Validates that every location has timelineOrder and displayYear,
/// and reports gaps/duplicates per era.
///
/// Run: dart run tools/validate_timeline_order.dart
void main(List<String> args) async {
  final file = File('assets/data/locations.json');
  if (!await file.exists()) {
    stderr.writeln('assets/data/locations.json not found.');
    exitCode = 1;
    return;
  }

  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString) as List<dynamic>;

  final byEra = <String, List<Map<String, dynamic>>>{};
  for (final raw in data) {
    final map = raw as Map<String, dynamic>;
    final eraId = map['eraId'] as String? ?? 'unknown';
    byEra.putIfAbsent(eraId, () => []).add(map);
  }

  var hasError = false;

  for (final entry in byEra.entries) {
    final eraId = entry.key;
    final locations = entry.value;
    final missingOrder = locations.where((m) => !m.containsKey('timelineOrder')).toList();
    final missingYear = locations.where((m) => !m.containsKey('displayYear')).toList();

    final orderValues = <int, List<String>>{};
    for (final loc in locations) {
      final order = loc['timelineOrder'];
      if (order is int) {
        orderValues.putIfAbsent(order, () => []).add(loc['id'] as String);
      }
    }

    final duplicates = orderValues.entries.where((e) => e.value.length > 1).toList();

    if (missingOrder.isEmpty && missingYear.isEmpty && duplicates.isEmpty) {
      stdout.writeln('✅ $eraId: OK (${locations.length} locations)');
      continue;
    }

    hasError = true;
    stderr.writeln('⚠️  $eraId issues:');
    if (missingOrder.isNotEmpty) {
      stderr.writeln('  - Missing timelineOrder: ${missingOrder.map((m) => m['id']).join(', ')}');
    }
    if (missingYear.isNotEmpty) {
      stderr.writeln('  - Missing displayYear: ${missingYear.map((m) => m['id']).join(', ')}');
    }
    if (duplicates.isNotEmpty) {
      for (final dup in duplicates) {
        stderr.writeln('  - Duplicate timelineOrder=${dup.key}: ${dup.value.join(', ')}');
      }
    }
  }

  if (hasError) {
    stderr.writeln('\nValidation failed. Please fix the above issues.');
    exitCode = 1;
  } else {
    stdout.writeln('\nAll eras passed validation.');
  }
}
