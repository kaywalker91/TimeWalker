#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$ROOT_DIR"

echo "[matrix] Running text-overlap layout tests..."
flutter test test/presentation/screens/era_exploration/location_story_card_layout_test.dart
flutter test test/presentation/screens/era_exploration/era_hud_panel_layout_test.dart
flutter test test/presentation/screens/era_exploration/enhanced_kingdom_tabs_layout_test.dart

echo "[matrix] Running focused analyzer checks..."
flutter analyze \
  lib/presentation/screens/era_exploration/widgets/location_story_card.dart \
  lib/presentation/screens/era_exploration/widgets/era_hud_panel.dart \
  lib/presentation/screens/era_exploration/widgets/era_status_bar.dart \
  lib/presentation/screens/era_exploration/widgets/enhanced_kingdom_tabs.dart

echo "[matrix] Completed."
