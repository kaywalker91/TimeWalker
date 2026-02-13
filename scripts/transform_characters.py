#!/usr/bin/env python3
"""
Script to transform characters.json into i18n-compatible format.
Hybrid approach: short text embedded, long text in separate i18n files.
"""

import json
from pathlib import Path

def transform_characters():
    # Read original characters.json
    with open('assets/data/characters.json', 'r', encoding='utf-8') as f:
        characters = json.load(f)
    
    # Prepare structures
    main_data = []
    ko_content = {}
    en_content = {}
    
    for char in characters:
        # Extract data
        char_id = char['id']
        
        # Build main structure with embedded short text
        main_char = {
            'id': char_id,
            'eraId': char['eraId'],
            'name': {
                'ko': char.get('nameKorean', char.get('name', '')),
                'en': char.get('name', char.get('nameKorean', ''))
            },
            'title': {
                'ko': char.get('title', ''),
                'en': char.get('title', '')  # TODO: Translate
            },
            'birth': char.get('birth', ''),
            'death': char.get('death', ''),
            'portraitAsset': char.get('portraitAsset', ''),
            'emotionAssets': char.get('emotionAssets', []),
            'dialogueIds': char.get('dialogueIds', []),
            'relatedCharacterIds': char.get('relatedCharacterIds', []),
            'relatedLocationIds': char.get('relatedLocationIds', []),
            'status': char.get('status', 'locked')
        }
        
        main_data.append(main_char)
        
        # Build Korean i18n content
        ko_content[char_id] = {
            'biography': char.get('biography', ''),
            'fullBiography': char.get('fullBiography', ''),
            'achievements': char.get('achievements', [])
        }
        
        # Build English i18n content (placeholder, needs translation)
        en_content[char_id] = {
            'biography': char.get('biography', ''),  # TODO: Translate
            'fullBiography': char.get('fullBiography', ''),  # TODO: Translate
            'achievements': char.get('achievements', [])  # TODO: Translate
        }
    
    # Write files
    # Main file
    with open('assets/data/characters_new.json', 'w', encoding='utf-8') as f:
        json.dump(main_data, f, ensure_ascii=False, indent=4)
    
    # Korean i18n
    with open('assets/data/i18n/ko/characters.json', 'w', encoding='utf-8') as f:
        json.dump(ko_content, f, ensure_ascii=False, indent=4)
    
    # English i18n (needs translation)
    with open('assets/data/i18n/en/characters.json', 'w', encoding='utf-8') as f:
        json.dump(en_content, f, ensure_ascii=False, indent=4)
    
    print(f"Transformed {len(characters)} characters")
    print("Files created:")
    print("  - assets/data/characters_new.json (main structure with embedded short text)")
    print("  - assets/data/i18n/ko/characters.json (Korean long content)")
    print("  - assets/data/i18n/en/characters.json (English placeholders - needs translation)")

if __name__ == '__main__':
    transform_characters()
