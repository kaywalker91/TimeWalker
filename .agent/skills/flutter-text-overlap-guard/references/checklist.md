# Text Overlap Checklist

## Detection

- Confirm if overlap occurs in `Stack`, fixed-height card, or dense `Row`.
- Check if text widgets lack `maxLines`/`overflow`.
- Check if large `textScaler` or long localization strings trigger breakage.

## Fix Rules

- Apply `Flexible/Expanded` to row labels.
- Apply `maxLines: 1` with `TextOverflow.ellipsis` to compact controls.
- For titles/descriptions in cards, set explicit `maxLines` by text scale bands.
- For overlay cards, reserve top safe inset for badge/year areas.
- Add stable keys for title/description/status/year blocks.

## Accessibility

- Verify min touch target `>= 48dp`.
- Reduce or disable motion when `disableAnimations` is true.

## Validation

- Run matrix tests (width + scale + locale).
- Assert no framework exceptions (`tester.takeException()`).
- Assert key regions do not overlap (title/description vs status/year).
