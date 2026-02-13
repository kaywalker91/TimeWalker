#!/usr/bin/env python3
"""
Script to transform locations.json into i18n-compatible format.
"""

import json

def transform_locations():
    with open('assets/data/locations.json', 'r', encoding='utf-8') as f:
        locations = json.load(f)
    
    main_data = []
    ko_content = {}
    en_content = {}
    
    for loc in locations:
        loc_id = loc['id']
        
        # Main structure with embedded short text
        main_loc = {
            'id': loc_id,
            'eraId': loc.get('eraId', ''),
            'name': {
                'ko': loc.get('nameKorean', loc.get('name', '')),
                'en': loc.get('name', loc.get('nameKorean', ''))
            },
            'thumbnailAsset': loc.get('thumbnailAsset', ''),
            'backgroundAsset': loc.get('backgroundAsset', ''),
            'kingdom': loc.get('kingdom'),
            'latitude': loc.get('latitude', 0.0),
            'longitude': loc.get('longitude', 0.0),
            'displayYear': loc.get('displayYear', ''),
            'timelineOrder': loc.get('timelineOrder', 0),
            'position': loc.get('position', {}),
            'characterIds': loc.get('characterIds', []),
            'eventIds': loc.get('eventIds', []),
            'status': loc.get('status', 'locked'),
            'isHistorical': loc.get('isHistorical', True)
        }
        
        main_data.append(main_loc)
        
        # i18n content
        ko_content[loc_id] = {
            'description': loc.get('description', '')
        }
        
        en_content[loc_id] = {
            'description': loc.get('description', '')  # TODO: Translate
        }
    
    # Write files
    with open('assets/data/locations_new.json', 'w', encoding='utf-8') as f:
        json.dump(main_data, f, ensure_ascii=False, indent=4)
    
    with open('assets/data/i18n/ko/locations.json', 'w', encoding='utf-8') as f:
        json.dump(ko_content, f, ensure_ascii=False, indent=4)
    
    with open('assets/data/i18n/en/locations.json', 'w', encoding='utf-8') as f:
        json.dump(en_content, f, ensure_ascii=False, indent=4)
    
    print(f"Transformed {len(locations)} locations")

if __name__ == '__main__':
    transform_locations()
