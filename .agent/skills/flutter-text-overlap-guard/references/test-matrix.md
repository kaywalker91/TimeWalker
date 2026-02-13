# Responsive Test Matrix

## Dimensions

- Width: `320`, `360`, `390`, `412`
- Text scale: `1.0`, `1.15`, `1.3`
- Locale: `ko`, `en`

## Required Assertions

- `tester.takeException()` is `null`.
- No overlap:
  - `location_story_title` vs `location_story_status_badge`
  - `location_story_description` vs `location_story_status_badge`
  - `location_story_title` vs `location_story_year_badge`
  - `location_story_description` vs `location_story_year_badge`
- Compact controls keep one-line labels with ellipsis.
- Minimum touch target constraints remain `>= 48dp`.

## Target Tests

- `test/presentation/screens/era_exploration/location_story_card_layout_test.dart`
- `test/presentation/screens/era_exploration/era_hud_panel_layout_test.dart`
- `test/presentation/screens/era_exploration/enhanced_kingdom_tabs_layout_test.dart`
