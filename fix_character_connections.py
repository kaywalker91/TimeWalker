import json
import os

def load_json(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_json(filepath, data):
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

def main():
    base_dir = '/Users/kaywalker/AndroidStudioProjects/time_walker/assets/data'
    characters_path = os.path.join(base_dir, 'characters.json')
    
    if not os.path.exists(characters_path):
        print(f"Error: {characters_path} not found.")
        return

    characters = load_json(characters_path)
    
    # 1. Map Dialogue ID -> Set of Character IDs
    dialogue_to_characters = {}
    
    # Create a lookup for character objects by ID for easy access
    char_map = {char['id']: char for char in characters}
    
    for char in characters:
        char_id = char['id']
        # Ensure relatedCharacterIds exists
        if 'relatedCharacterIds' not in char:
            char['relatedCharacterIds'] = []
            
        dialogue_ids = char.get('dialogueIds', [])
        for d_id in dialogue_ids:
            if d_id not in dialogue_to_characters:
                dialogue_to_characters[d_id] = set()
            dialogue_to_characters[d_id].add(char_id)

    # 2. Identify and Add Missing Relations
    added_count = 0
    
    for d_id, char_ids in dialogue_to_characters.items():
        # If a dialogue is shared by 2 or more characters, they are related
        if len(char_ids) >= 2:
            sorted_ids = sorted(list(char_ids))
            print(f"Dialogue '{d_id}' is shared by: {sorted_ids}")
            
            # Connect everyone with everyone else in this group
            for char_id_a in sorted_ids:
                char_a = char_map[char_id_a]
                current_relations = set(char_a.get('relatedCharacterIds', []))
                
                for char_id_b in sorted_ids:
                    if char_id_a == char_id_b:
                        continue
                        
                    if char_id_b not in current_relations:
                        print(f"  [+] Adding '{char_id_b}' to '{char_id_a}' (shared: {d_id})")
                        char_a['relatedCharacterIds'].append(char_id_b)
                        added_count += 1

    # 3. Sort and dedup for cleanliness
    for char in characters:
        if 'relatedCharacterIds' in char:
            # Remove duplicates and sort
            unique_relations = sorted(list(set(char['relatedCharacterIds'])))
            char['relatedCharacterIds'] = unique_relations

    # 4. Save
    if added_count > 0:
        save_json(characters_path, characters)
        print(f"\nSuccess! Added {added_count} missing connections.")
    else:
        print("\nNo missing connections found. Data is already consistent.")

if __name__ == "__main__":
    main()
