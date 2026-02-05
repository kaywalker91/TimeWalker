# Map Location Accuracy Improvement Plan

## 1. Objective
Improve the accuracy of city marker locations on the `EraExplorationScreen` map by migrating from manual relative positioning (x, y) to a real-world coordinate system (Latitude/Longitude) for all eras.

## 2. Current State Analysis
- **Data Source**: `locations.json` contains `position` (x, y) for all locations, but `latitude`/`longitude` are sparsely populated (mainly for `korea_three_kingdoms`).
- **Code Limitation**: `EraExplorationScreen` (specifically `_resolveLocationPosition`) has hardcoded projection logic that only triggers for `korea_three_kingdoms` using a fixed `_threeKingdomsBounds`.
- **Entity Constraint**: The `Era` entity does not support per-era map projection configuration.

## 3. Improvement Strategy

### Phase 1: Architecture Update (Map Bounds)
Eliminate hardcoding by moving map projection configuration into the `Era` data model.

1.  **Update `Era` Entity**: Add a `mapBounds` field to the `Era` model.
    ```dart
    // lib/domain/entities/era.dart
    class Era {
      // ... existing fields
      final MapBounds? mapBounds; // Nullable, fallback to relative positioning if null
    }
    ```
    *Note: `MapBounds` class already exists in `lib/core/utils/map_projection.dart`.*

2.  **Externalize Configuration**: Move the hardcoded `_threeKingdomsBounds` from `EraExplorationScreen.dart` to the `EraTheme.threeKingdoms` or `EraData` static definition for `korea_three_kingdoms`.

### Phase 2: Map Calibration (Defining Bounds)
We have estimated the geographical bounds for the current map assets based on historical territories.

#### ERA 1: Three Kingdoms (Korea)
*Status: Existing Logic (Validation needed)*
- **Bounds**: `minLat: 34.0`, `maxLat: 42.5`, `minLong: 124.0`, `maxLong: 130.8`

#### ERA 2: Joseon Dynasty (Korea)
*Map Context: Korean Peninsula full view*
- **Reference**: Southern tip (Marado/Jeju) ~33°N, Northern tip (Onseong) ~43°N.
- **Proposed Bounds**:
    - `minLatitude`: 33.0
    - `maxLatitude`: 43.1
    - `minLongitude`: 124.0
    - `maxLongitude`: 132.0

#### ERA 3: Renaissance (Europe/Italy)
*Map Context: Italy + surrounding Mediterranean/Alps*
- **Reference**: Sicily South (~36°N) to Alps (~47°N).
- **Proposed Bounds**:
    - `minLatitude`: 35.0
    - `maxLatitude`: 47.5
    - `minLongitude`: 6.0
    - `maxLongitude`: 19.0

### Phase 3: Data Enrichment (Lat/Long Injection)
Update `locations.json` to include precise `latitude` and `longitude` for all cities, removing the reliance on manual `position` {x, y}.

#### Joseon Targets to Update:
- **Gyeongbokgung (Seoul)**: `37.5796° N, 126.9770° E`
- **Suwon Hwaseong**: `37.2851° N, 127.0197° E`
- **Hanyang Market (Jongno)**: `37.5700° N, 126.9900° E`
- **Geobukseon (Yeosu Jinnamgwan/Hansan)**: `34.7500° N, 127.7500° E` (approx operational base)

#### Renaissance Targets to Update:
- **Florence**: `43.7696° N, 11.2558° E`
- **Venice**: `45.4408° N, 12.3155° E`

### Phase 4: Implementation & Verification
1.  **Refactor `Era` & `EraData`**: 
    - Add `MapBounds` field to `Era`.
    - Update `EraData` static instances with the bounds defined in Phase 2.
2.  **Refactor `EraExplorationScreen`**:
    - Remove `_threeKingdomsBounds` constant.
    - Update `_resolveLocationPosition` to check `era.mapBounds` instead of `era.id == 'korea_three_kingdoms'`.
3.  **Update `locations.json`**:
    - Bulk add `latitude` and `longitude` to the target locations.
4.  **Verify**: 
    - Launch app.
    - Check if markers for Joseon and Renaissance appear in sensible locations relative to the map background terrain.

## 4. Execution Plan (Self-Corrected)
1.  **Modify `Era` Entity**: Add `final MapBounds? mapBounds;`.
2.  **Update `EraData`**: Define bounds for Joseon and Renaissance.
3.  **Update `EraExplorationScreen`**: Implement generic projection logic.
4.  **Update `locations.json`**: Inject Lat/Long data.
