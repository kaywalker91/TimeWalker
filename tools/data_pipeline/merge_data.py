import json
import os

def merge_json_files(main_file_path, generated_file_path):
    try:
        if not os.path.exists(main_file_path):
            print(f"Main file not found: {main_file_path}")
            return
        
        if not os.path.exists(generated_file_path):
            print(f"Generated file not found: {generated_file_path}")
            return

        with open(main_file_path, 'r', encoding='utf-8') as f:
            main_data = json.load(f)
        
        with open(generated_file_path, 'r', encoding='utf-8') as f:
            generated_data = json.load(f)
            
        # Check for duplicates by ID to avoid adding same data twice
        existing_ids = {item['id'] for item in main_data}
        new_items = [item for item in generated_data if item['id'] not in existing_ids]
        
        if new_items:
            main_data.extend(new_items)
            with open(main_file_path, 'w', encoding='utf-8') as f:
                json.dump(main_data, f, ensure_ascii=False, indent=2)
            print(f"Successfully added {len(new_items)} items to {main_file_path}")
        else:
            print(f"No new items to add to {main_file_path} (all IDs exist).")

    except Exception as e:
        print(f"Error merging files: {e}")

def main():
    # Resolve paths relative to this script file
    # Script is in <project_root>/tools/data_pipeline/
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(os.path.dirname(script_dir))
    
    base_dir = os.path.join(project_root, "assets/data")
    generated_dir = os.path.join(project_root, "assets/data/generated")
    
    # Merge Characters
    merge_json_files(
        os.path.join(base_dir, "characters.json"),
        os.path.join(generated_dir, "characters_europe_generated.json")
    )
    
    # Merge Encyclopedia
    merge_json_files(
        os.path.join(base_dir, "encyclopedia.json"),
        os.path.join(generated_dir, "encyclopedia_europe_generated.json")
    )

if __name__ == "__main__":
    main()
