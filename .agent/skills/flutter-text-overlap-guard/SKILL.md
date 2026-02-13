---
name: flutter-text-overlap-guard
description: Fix and prevent Flutter text overlap/overflow issues in dense UI by applying deterministic layout rules, responsive matrix testing, and non-breaking visual polish.
---

# Flutter Text Overlap Guard

Use this skill when a user reports text overlap, clipped labels, or RenderFlex overflow in Flutter UI.

## Scope

- Flutter presentation layer only (`lib/presentation/**`, shared UI utils).
- Preserve current visual direction and business logic.
- Prefer minimal, deterministic layout changes over redesign.

## Workflow

1. Locate risk points.
Search for: fixed heights, `Stack` overlays, dense `Row`, unconstrained `Text`.

2. Apply guard rules.
- Fixed-height card + rich text: use hybrid height with clamp.
- Overlay text blocks: use `Positioned.fill` + top safe inset.
- Dense rows: use `Expanded/Flexible` + `maxLines: 1` + `TextOverflow.ellipsis`.
- Keep touch targets at least `48dp`.
- Add stable widget keys for collision validation.

3. Motion/accessibility guard.
- If `MediaQuery.disableAnimations == true`, reduce glow/hover/splash intensity.

4. Validate with responsive matrix.
- Widths: `320, 360, 390, 412`.
- Text scale: `1.0, 1.15, 1.3`.
- Locale: `ko, en`.
- No `tester.takeException()`.
- No overlap between key text regions and badge regions.

## Checklists and Matrix

- Overlap checklist: `references/checklist.md`
- Test matrix details: `references/test-matrix.md`
- Batch runner: `scripts/run_responsive_matrix.sh`

## Guardrails

- Keep `AppColors` usage; no hardcoded new theme direction.
- No domain/data contract changes for UI-only fixes.
- Avoid introducing new dependencies for layout patches.
