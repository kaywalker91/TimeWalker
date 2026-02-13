import json
import os

PROJECT_ROOT = '/Users/kaywalker/AndroidStudioProjects/time_walker'
CHARACTERS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/characters.json')
LOCATIONS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/locations.json')

# Aliases: SOURCE -> TARGET
# References to SOURCE will be changed to TARGET.
# SOURCE locations will be REMOVED if they exist.
LOCATION_ALIASES = {
    'hanyang': 'hanyang_market', 
    'kaesong': 'manwoldae', 
    'gyeongju': 'gyeongju_palace',
    'changan': 'luoyang_wei', # Map Changan to Luoyang if Changan not fully supported or merge them? Actually both exist in list. Let's keep both. remove this line.
    'chibi': 'chibi_red_cliffs', # Does not exist, reference will be removed if target doesn't exist
    'chengdu': 'chengdu_palace', # Does not exist
    'jianye': 'jianye_city', # Does not exist
    'deoksugung': 'deoksugung_palace', # Merge
    'shanghai_provisional': 'shanghai_provisional_govt' # Merge
}

CHARACTER_ALIASES = {
    'kim_koo': 'kim_gu',
    'ahn_junggeun': 'an_junggeun',
    'won_gyun': 'yi_sun_sin' # Temporary fallback? No, better remove if not exists.
}

# New Links to Add: Character ID -> [Location IDs]
NEW_LINKS = {
    'jang_yeongshil': ['gyeongbokgung'],
    'heo_jun': ['hanyang_market'],
    'seohee': ['manwoldae'],
    'gangamchan': ['manwoldae', 'gaegyeong_market'],
    'yu_gwansun': ['seodaemun_prison', 'tapgol_park'],
    'kim_gu': ['shanghai_provisional_govt', 'busan_provisional_capital'], # Extended
    'ahn_changho': ['shanghai_provisional_govt'],
    'yeo_unhyeong': ['hanyang_market'], # Contemporary context?
    'syngman_rhee': ['gyeongbu_expressway'], # Maybe not appropriate? Let's check locations. 'seoul_expressway' exists.
    'yi_seong_gye': ['manwoldae', 'hanyang_market'],
    'jeong_mongju': ['manwoldae']
}

def load_json(filepath):
    if os.path.exists(filepath):
        with open(filepath, 'r') as f:
            return json.load(f)
    return []

def save_json(filepath, data):
    with open(filepath, 'w') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

def fix_metadata():
    print("Fixing metadata gaps (Round 2)...")
    
    characters = load_json(CHARACTERS_JSON)
    locations = load_json(LOCATIONS_JSON)

    # 1. Merge Duplicate Locations
    # If a location ID is in LOCATION_ALIASES as a key, remove it from the list
    locations_to_remove = [k for k in LOCATION_ALIASES.keys()]
    locations = [l for l in locations if l['id'] not in locations_to_remove]
    print(f"Removed superseded locations: {locations_to_remove}")

    # 2. Add Missing Links (Populate fields)
    for char_id, loc_ids in NEW_LINKS.items():
        char = next((c for c in characters if c['id'] == char_id), None)
        if char:
            if 'relatedLocationIds' not in char:
                char['relatedLocationIds'] = []
            
            for loc_id in loc_ids:
                # Resolve alias first
                if loc_id in LOCATION_ALIASES:
                    loc_id = LOCATION_ALIASES[loc_id]
                
                if loc_id not in char['relatedLocationIds']:
                    char['relatedLocationIds'].append(loc_id)
                    print(f"Manually added link: Character {char_id} -> Location {loc_id}")

    # 3. Standard Fixes (Validation & Reciprocity)
    char_ids = {c['id'] for c in characters}
    loc_ids = {l['id'] for l in locations}
    
    # Fix Character References
    for char in characters:
        if 'relatedLocationIds' in char:
            new_loc_ids = []
            for loc_id in char['relatedLocationIds']:
                if loc_id in LOCATION_ALIASES:
                    loc_id = LOCATION_ALIASES[loc_id]
                if loc_id in loc_ids:
                    new_loc_ids.append(loc_id)
            char['relatedLocationIds'] = list(set(new_loc_ids))

        if 'relatedCharacterIds' in char:
            new_char_ids = []
            for cid in char['relatedCharacterIds']:
                if cid in CHARACTER_ALIASES:
                    cid = CHARACTER_ALIASES[cid]
                if cid in char_ids:
                    new_char_ids.append(cid)
            char['relatedCharacterIds'] = list(set(new_char_ids))

    # Fix Location References
    for loc in locations:
        if 'characterIds' in loc:
            new_char_ids = []
            for cid in loc['characterIds']:
                if cid in CHARACTER_ALIASES:
                    cid = CHARACTER_ALIASES[cid]
                if cid in char_ids:
                    new_char_ids.append(cid)
            loc['characterIds'] = list(set(new_char_ids))

    # Enforce Reciprocity
    for char in characters:
        cid = char['id']
        if 'relatedLocationIds' in char:
            for loc_id in char['relatedLocationIds']:
                loc = next((l for l in locations if l['id'] == loc_id), None)
                if loc:
                    if 'characterIds' not in loc:
                        loc['characterIds'] = []
                    if cid not in loc['characterIds']:
                        loc['characterIds'].append(cid)
                        # print(f"Reciprocal: Loc {loc_id} -> Char {cid}")

    for loc in locations:
        loc_id = loc['id']
        if 'characterIds' in loc:
            for cid in loc['characterIds']:
                char = next((c for c in characters if c['id'] == cid), None)
                if char:
                    if 'relatedLocationIds' not in char:
                        char['relatedLocationIds'] = []
                    if loc_id not in char['relatedLocationIds']:
                        char['relatedLocationIds'].append(loc_id)
                        # print(f"Reciprocal: Char {cid} -> Loc {loc_id}")

    save_json(CHARACTERS_JSON, characters)
    save_json(LOCATIONS_JSON, locations)
    print("Metadata fixed and saved.")

if __name__ == "__main__":
    fix_metadata()
