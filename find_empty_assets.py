import json
import os

PROJECT_ROOT = '/Users/kaywalker/AndroidStudioProjects/time_walker'
CHARACTERS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/characters.json')
LOCATIONS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/locations.json')

def check_empty_assets():
    empty_assets = []

    # Check characters
    if os.path.exists(CHARACTERS_JSON):
        with open(CHARACTERS_JSON, 'r') as f:
            characters = json.load(f)
            for char in characters:
                # Check for empty or missing portraitAsset
                if 'portraitAsset' not in char or not char['portraitAsset']:
                    empty_assets.append(f"Character {char['id']} has undefined portraitAsset")
                
    # Check locations
    if os.path.exists(LOCATIONS_JSON):
        with open(LOCATIONS_JSON, 'r') as f:
            locations = json.load(f)
            for loc in locations:
                # Check for empty or missing thumbnailAsset
                if 'thumbnailAsset' not in loc or not loc['thumbnailAsset']:
                    empty_assets.append(f"Location {loc['id']} has undefined thumbnailAsset")
                # Check for empty or missing backgroundAsset
                if 'backgroundAsset' not in loc or not loc['backgroundAsset']:
                    empty_assets.append(f"Location {loc['id']} has undefined backgroundAsset")

    print(json.dumps(empty_assets, indent=2))

if __name__ == "__main__":
    check_empty_assets()
