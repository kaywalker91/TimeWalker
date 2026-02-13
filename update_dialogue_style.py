import json
import os
import shutil

# File paths
DIALOGUES_FILE = 'assets/data/dialogues.json'
BACKUP_FILE = 'assets/data/dialogues_backup_style_update.json'

def update_dialogues():
    # 1. Backup
    if not os.path.exists(DIALOGUES_FILE):
        print(f"Error: {DIALOGUES_FILE} not found.")
        return

    shutil.copy(DIALOGUES_FILE, BACKUP_FILE)
    print(f"Backed up to {BACKUP_FILE}")

    # 2. Load Data
    with open(DIALOGUES_FILE, 'r', encoding='utf-8') as f:
        dialogues = json.load(f)

    updated_count = 0
    
    for dialogue in dialogues:
        nodes = dialogue.get('nodes', [])
        new_nodes = []
        
        # We need to process nodes and potentially insert new ones
        # Use a while loop or just build a new list
        
        for node in nodes:
            node_id = node.get('id')
            node_type = node.get('type')
            speaker = node.get('speaker') or node.get('speakerId')
            choices = node.get('choices', [])
            
            # Condition to split:
            # 1. Has choices
            # 2. Speaker is NOT 'player' (it's an NPC)
            # 3. Not already a 'choice' only node (though type might be 'choice', if it has text it's a mix)
            # Actually, standard is: type='choice' usually implies it has text AND choices.
            # We want to change it to:
            # Node 1 (NPC): type='dialogue', text=Original, nextNode=Node 2
            # Node 2 (Player): type='choice', text='...', choices=Original, speaker='player'
            
            is_npc = speaker and speaker != 'player'
            has_choices = len(choices) > 0
            has_text = False
            text_obj = node.get('text')
            
            if isinstance(text_obj, str) and text_obj.strip():
                has_text = True
            elif isinstance(text_obj, dict):
                # Check if any localized text exists
                if any(v.strip() for v in text_obj.values() if isinstance(v, str)):
                    has_text = True
            
            if is_npc and has_choices and has_text:
                # SPLIT THIS NODE
                print(f"Splitting node {node_id} in dialogue {dialogue['id']}")
                updated_count += 1
                
                # 1. Create NPC Node (The one user reads first)
                npc_node = node.copy()
                npc_node['type'] = 'dialogue'
                npc_node['choices'] = [] # Remove choices
                
                # Determine new choice node ID
                choice_node_id = f"{node_id}_choice"
                npc_node['nextNodeId'] = choice_node_id
                
                # 2. Create Player Choice Node
                choice_node = {
                    "id": choice_node_id,
                    "type": "choice",
                    "speaker": "player", # Explicitly set player
                    "emotion": "neutral",
                    "text": { # Placeholder text
                        "ko": "...",
                        "en": "..."
                    },
                    "choices": choices # Moved choices here
                }
                
                new_nodes.append(npc_node)
                new_nodes.append(choice_node)
                
            else:
                # Keep original
                new_nodes.append(node)
        
        dialogue['nodes'] = new_nodes

    # 3. Save Data
    with open(DIALOGUES_FILE, 'w', encoding='utf-8') as f:
        json.dump(dialogues, f, indent=4, ensure_ascii=False)

    print(f"Update complete. {updated_count} nodes split.")

if __name__ == '__main__':
    update_dialogues()
