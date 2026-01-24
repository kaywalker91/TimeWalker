---
paths:
  - "assets/data/**"
  - "lib/data/datasources/static/**"
  - "lib/data/seeds/**"
---

# Content Data Rules

## ID Conventions

```
{type}_{region}_{country}_{era}_{name}
```

Examples:
- Region: `region_east_asia`
- Country: `country_korea`
- Era: `era_korea_joseon`
- Character: `char_korea_joseon_sejong`
- Location: `loc_korea_joseon_gyeongbok`

## Bilingual Content

All user-facing content must include both languages:

```json
{
  "id": "era_korea_joseon",
  "name": "Joseon Dynasty",
  "nameKo": "조선시대",
  "description": "The last dynasty of Korea",
  "descriptionKo": "한국의 마지막 왕조"
}
```

## JSON Structure (`assets/data/`)

### characters.json
```json
{
  "characters": [
    {
      "id": "char_xxx",
      "name": "...",
      "nameKo": "...",
      "eraId": "era_xxx",
      "role": "...",
      "dialogueIds": ["dlg_xxx"]
    }
  ]
}
```

### locations.json
```json
{
  "locations": [
    {
      "id": "loc_xxx",
      "name": "...",
      "nameKo": "...",
      "eraId": "era_xxx",
      "type": "palace|temple|fortress|...",
      "coordinates": {"lat": 0.0, "lng": 0.0}
    }
  ]
}
```

## Static DataSource Pattern (`lib/data/datasources/static/`)

```dart
class XxxData {
  static List<XxxModel> getAll() => [
    XxxModel(id: 'xxx_001', name: '...', nameKo: '...'),
    // ...
  ];

  static XxxModel? getById(String id) =>
    getAll().firstWhereOrNull((e) => e.id == id);
}
```

## Seed Data (`lib/data/seeds/`)

- Default factory classes for initial user state
- Used when no remote/cached data available
- Pattern: `Default{Entity}Factory`

## Rules

- IDs are immutable once published
- Always provide Korean translations
- Validate JSON structure matches entity fields
- Keep coordinates as `double` (latitude/longitude)
- Era dates: use `startYear`/`endYear` as integers (negative for BCE)
- Sort entries by chronological order within arrays
- New content must include all required fields (no partial entries)
