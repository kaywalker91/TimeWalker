#!/usr/bin/env python3
"""
Script to transform dialogues.json into i18n-compatible format.
"""

import json

def transform_dialogues():
    with open('assets/data/dialogues.json', 'r', encoding='utf-8') as f:
        dialogues = json.load(f)
    
    main_data = []
    ko_content = {}
    en_content = {}
    
    for dlg in dialogues:
        dlg_id = dlg['id']
        
        # Main structure with embedded short text
        main_dlg = {
            'id': dlg_id,
            'characterId': dlg.get('characterId', ''),
            'title': {
                'ko': dlg.get('titleKorean', dlg.get('title', '')),
                'en': dlg.get('title', dlg.get('titleKorean', ''))
            },
            'estimatedMinutes': dlg.get('estimatedMinutes', 5),
            'rewards': dlg.get('rewards', [])
        }
        
        main_data.append(main_dlg)
        
        # i18n content - description and nodes
        ko_content[dlg_id] = {
            'description': dlg.get('description', ''),
            'nodes': dlg.get('nodes', [])
        }
        
        # For English, copy nodes structure (needs translation)
        en_content[dlg_id] = {
            'description': dlg.get('description', ''),  # TODO: Translate
            'nodes': dlg.get('nodes', [])  # TODO: Translate all text and choice fields
        }
    
    # Write files
    with open('assets/data/dialogues_new.json', 'w', encoding='utf-8') as f:
        json.dump(main_data, f, ensure_ascii=False, indent=4)
    
    with open('assets/data/i18n/ko/dialogues.json', 'w', encoding='utf-8') as f:
        json.dump(ko_content, f, ensure_ascii=False, indent=4)
    
    with open('assets/data/i18n/en/dialogues.json', 'w', encoding='utf-8') as f:
        json.dump(en_content, f, ensure_ascii=False, indent=4)
    
    print(f"Transformed {len(dialogues)} dialogues")

if __name__ == '__main__':
    transform_dialogues()
