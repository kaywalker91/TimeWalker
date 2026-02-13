import json
import os

PROJECT_ROOT = '/Users/kaywalker/AndroidStudioProjects/time_walker'
CHARACTERS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/characters.json')
LOCATIONS_JSON = os.path.join(PROJECT_ROOT, 'assets/data/locations.json')

def check_metadata_gaps():
    print("Checking for metadata gaps...")
    
    characters = []
    locations = []
    
    if os.path.exists(CHARACTERS_JSON):
        with open(CHARACTERS_JSON, 'r') as f:
            characters = json.load(f)
            
    if os.path.exists(LOCATIONS_JSON):
        with open(LOCATIONS_JSON, 'r') as f:
            locations = json.load(f)

    # Create lookups for validation
    char_ids = {c['id'] for c in characters}
    loc_ids = {l['id'] for l in locations}

    gaps = []

    # Check Characters
    for char in characters:
        char_id = char['id']
        
        # Check relatedLocationIds
        if 'relatedLocationIds' not in char or not char['relatedLocationIds']:
            gaps.append(f"Character '{char_id}' has empty relatedLocationIds")
        else:
            # Validate IDs
            for loc_id in char['relatedLocationIds']:
                if loc_id not in loc_ids:
                    gaps.append(f"Character '{char_id}' references unknown location '{loc_id}'")

        # Check relatedCharacterIds
        if 'relatedCharacterIds' not in char or not char['relatedCharacterIds']:
             # Note: Some characters might legitimately not have relations, but worth checking
            gaps.append(f"Character '{char_id}' has empty relatedCharacterIds")
        else:
             for cid in char['relatedCharacterIds']:
                if cid not in char_ids:
                    gaps.append(f"Character '{char_id}' references unknown character '{cid}'")

    # Check Locations
    for loc in locations:
        loc_id = loc['id']
        
        # Check characterIds (Characters at this location)
        if 'characterIds' not in loc or not loc['characterIds']:
            gaps.append(f"Location '{loc_id}' has empty characterIds")
        else:
             for cid in loc['characterIds']:
                if cid not in char_ids:
                    gaps.append(f"Location '{loc_id}' references unknown character '{cid}'")

    # Write report
    with open('metadata_gaps_report.txt', 'w') as f:
        if gaps:
            f.write(f"Found {len(gaps)} metadata gaps:\n")
            for gap in gaps:
                f.write(gap + '\n')
            print(f"Found {len(gaps)} gaps. Report saved to metadata_gaps_report.txt")
        else:
            f.write("No metadata gaps found.\n")
            print("No metadata gaps found.")

if __name__ == "__main__":
    check_metadata_gaps()
