import json
import os

PROJECT_ROOT = '/Users/kaywalker/AndroidStudioProjects/time_walker'
CHARACTERS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/characters.json')
LOCATIONS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/locations.json')

def check_missing_assets():
    missing_assets = []

    # Check characters
    if os.path.exists(CHARACTERS_JSON):
        with open(CHARACTERS_JSON, 'r') as f:
            characters = json.load(f)
            for char in characters:
                # Check portrait
                if 'portraitAsset' in char and char['portraitAsset']:
                    path = os.path.join(PROJECT_ROOT, char['portraitAsset'])
                    if not os.path.exists(path):
                        missing_assets.append(f"Character {char['id']} missing portrait: {char['portraitAsset']}")
                
                # Check emotion assets
                if 'emotionAssets' in char and char['emotionAssets']:
                    for asset in char['emotionAssets']:
                        path = os.path.join(PROJECT_ROOT, asset)
                        if not os.path.exists(path):
                            missing_assets.append(f"Character {char['id']} missing emotion asset: {asset}")

    # Check locations
    if os.path.exists(LOCATIONS_JSON):
        with open(LOCATIONS_JSON, 'r') as f:
            locations = json.load(f)
            for loc in locations:
                # Check thumbnail
                if 'thumbnailAsset' in loc and loc['thumbnailAsset']:
                    path = os.path.join(PROJECT_ROOT, loc['thumbnailAsset'])
                    if not os.path.exists(path):
                        missing_assets.append(f"Location {loc['id']} missing thumbnail: {loc['thumbnailAsset']}")
                
                # Check background
                if 'backgroundAsset' in loc and loc['backgroundAsset']:
                    path = os.path.join(PROJECT_ROOT, loc['backgroundAsset'])
                    if not os.path.exists(path):
                        missing_assets.append(f"Location {loc['id']} missing background: {loc['backgroundAsset']}")

    if missing_assets:
        with open('missing_assets_report.txt', 'w') as f:
            for asset in missing_assets:
                f.write(asset + '\n')
        print(f"Found {len(missing_assets)} missing assets. Report saved to missing_assets_report.txt")
    else:
        print("No missing assets found.")

if __name__ == "__main__":
    check_missing_assets()
