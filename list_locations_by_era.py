import json
import os

PROJECT_ROOT = '/Users/kaywalker/AndroidStudioProjects/time_walker'
LOCATIONS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/locations.json')

def list_locations_by_era():
    if not os.path.exists(LOCATIONS_JSON):
        print("locations.json not found")
        return

    with open(LOCATIONS_JSON, 'r') as f:
        locations = json.load(f)

    era_map = {}
    for loc in locations:
        era = loc.get('eraId', 'unknown')
        if era not in era_map:
            era_map[era] = []
        era_map[era].append(loc['id'])

    for era, locs in era_map.items():
        print(f"Era: {era}")
        for loc in sorted(locs):
            print(f"  - {loc}")

if __name__ == "__main__":
    list_locations_by_era()
