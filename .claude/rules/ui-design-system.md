---
paths:
  - "lib/presentation/screens/**"
  - "lib/presentation/widgets/**"
  - "lib/presentation/themes/**"
---

# UI Design System

## Color System

- **ALWAYS** use `AppColors` from `lib/core/themes/app_colors.dart`
- **NEVER** hardcode color values (`Color(0xFF...)` or `Colors.xxx`)
- Dark theme is primary design target

### Key Colors
```dart
AppColors.primary        // Main accent
AppColors.background     // Screen backgrounds
AppColors.surface        // Card/container surfaces
AppColors.text           // Primary text
AppColors.textSecondary  // Secondary text
AppColors.eraXxx         // Era-specific themed colors
```

## Screen Structure

```dart
class XxxScreen extends ConsumerWidget {
  const XxxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: // content
      ),
    );
  }
}
```

### Screen Organization
```
lib/presentation/screens/{feature}/
  {feature}_screen.dart        # Main screen widget
  widgets/                     # Screen-specific widgets
    {widget_name}.dart
```

## Animation Guidelines

- Use `simple_animations` for custom animations
- Use `flutter_staggered_animations` for list entry animations
- Use `shimmer` for loading states
- Keep animations under 500ms for UI responsiveness
- Respect `MediaQuery.disableAnimations` for accessibility

### Common Animation Widgets
- `GlowEffects` - Glow animations (`lib/presentation/widgets/common/animations/glow_effects.dart`)
- `Loaders` - Loading indicators (`lib/presentation/widgets/common/animations/loaders.dart`)
- `Particles` - Particle effects (`lib/presentation/widgets/common/animations/particles.dart`)

## Widget Hierarchy

```
lib/presentation/widgets/
  common/
    animations/    # Reusable animation widgets
    cards/         # Card components (era_card, encyclopedia_entry_card)
  dialogue/        # Dialogue system widgets
```

## Responsive Design

- Use `MediaQuery` for screen-size-aware layouts
- Support both portrait and landscape where applicable
- Minimum touch target: 48x48dp
- Use `Expanded`/`Flexible` over fixed sizes where possible

## Accessibility

- Provide `Semantics` labels for interactive elements
- Ensure sufficient color contrast (4.5:1 for text)
- Support dynamic text scaling
- Keyboard navigation for desktop targets

## Asset Usage

- SVG: Use `flutter_svg` with `SvgPicture.asset()`
- Network images: Use `cached_network_image` with placeholder
- Register all assets in `pubspec.yaml`
