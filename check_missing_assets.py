
import json
import os

def check_missing_assets():
    base_path = '/Users/kaywalker/AndroidStudioProjects/time_walker'
    
    # Load JSON data
    with open(os.path.join(base_path, 'assets/data/characters.json'), 'r') as f:
        characters = json.load(f)
    
    with open(os.path.join(base_path, 'assets/data/locations.json'), 'r') as f:
        locations = json.load(f)

    missing_assets = {
        'characters': [],
        'character_emotions': [],
        'locations': [],
        'location_thumbnails': []
    }

    # Check characters
    for char in characters:
        char_id = char.get('id')
        portrait = char.get('portraitAsset')
        if portrait:
            full_path = os.path.join(base_path, portrait)
            if not os.path.exists(full_path):
                missing_assets['characters'].append({'id': char_id, 'path': portrait})
        
        emotions = char.get('emotionAssets', [])
        for emo_path in emotions:
            full_path = os.path.join(base_path, emo_path)
            if not os.path.exists(full_path):
                missing_assets['character_emotions'].append({'id': char_id, 'path': emo_path})

    # Check locations
    for loc in locations:
        loc_id = loc.get('id')
        bg = loc.get('backgroundAsset')
        if bg:
            full_path = os.path.join(base_path, bg)
            if not os.path.exists(full_path):
                missing_assets['locations'].append({'id': loc_id, 'path': bg})
        
        thumb = loc.get('thumbnailAsset')
        if thumb:
            full_path = os.path.join(base_path, thumb)
            if not os.path.exists(full_path):
                missing_assets['location_thumbnails'].append({'id': loc_id, 'path': thumb})

    # Output results
    print("--- MISSING ASSETS REPORT ---")
    
    print(f"\nMissing Character Portraits ({len(missing_assets['characters'])}):")
    for item in missing_assets['characters']:
        print(f"  - {item['id']}: {item['path']}")

    print(f"\nMissing Character Emotions ({len(missing_assets['character_emotions'])}):")
    for item in missing_assets['character_emotions']:
        print(f"  - {item['id']}: {item['path']}")

    print(f"\nMissing Location Backgrounds ({len(missing_assets['locations'])}):")
    for item in missing_assets['locations']:
        print(f"  - {item['id']}: {item['path']}")

    print(f"\nMissing Location Thumbnails ({len(missing_assets['location_thumbnails'])}):")
    for item in missing_assets['location_thumbnails']:
        print(f"  - {item['id']}: {item['path']}")

if __name__ == "__main__":
    check_missing_assets()
