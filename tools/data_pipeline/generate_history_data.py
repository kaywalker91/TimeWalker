import urllib.request
import urllib.parse
import json
import os
from datetime import datetime
import time

# Wikidata SPARQL Endpoint
WIKIDATA_ENDPOINT = "https://query.wikidata.org/sparql"

# Game Era ID mapping
# Game Era ID mapping
ERA_ID_RENAISSANCE = "europe_renaissance"
ERA_ID_THREE_KINGDOMS = "korea_three_kingdoms"

# Directory to save generated JSONs
# Script is in tools/data_pipeline, so we go up two levels to root, then into assets/data
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "assets/data/generated")

def fetch_data(query):
    """Fetches data from Wikidata using SPARQL via urllib."""
    try:
        params = urllib.parse.urlencode({'format': 'json', 'query': query})
        url = f"{WIKIDATA_ENDPOINT}?{params}"
        req = urllib.request.Request(url)
        req.add_header('User-Agent', 'TimeWalkerGameContentBot/1.0 (kaywalker@example.com)')
        
        with urllib.request.urlopen(req) as response:
            if response.status == 200:
                return json.loads(response.read().decode('utf-8'))
            else:
                print(f"Error fetching data: Status {response.status}")
                return None
    except Exception as e:
        print(f"Error fetching data: {e}")
        return None

def generate_three_kingdoms_characters():
    """Generates character data for the Three Kingdoms era (Goguryeo, Baekje, Silla)."""
    print("Fetching Three Kingdoms Characters...")
    
    kingdoms = [
        {"id": "Q28303", "name": "Goguryeo"},
        {"id": "Q28402", "name": "Baekje"},
        {"id": "Q28454", "name": "Silla"}
    ]
    
    characters = []
    
    for kingdom in kingdoms:
        kid = kingdom["id"]
        print(f"Fetching for {kingdom['name']} ({kid})...")
        
        # Simple query per kingdom
        query = f"""
        SELECT DISTINCT ?item ?itemLabel ?itemDescription ?image WHERE {{
          ?item wdt:P27 wd:{kid}.
          ?item wdt:P31 wd:Q5.
          OPTIONAL {{ ?item wdt:P18 ?image. }}
          SERVICE wikibase:label {{ bd:serviceParam wikibase:language "ko,en". }}
        }}
        LIMIT 5
        """
        
        data = fetch_data(query)
        if not data:
            continue
            
        bindings = data.get('results', {}).get('bindings', [])
        for result in bindings:
            try:
                wiki_id = result['item']['value'].split('/')[-1]
                name = result['itemLabel']['value']
                # Description fallback
                description = result.get('itemDescription', {}).get('value', f'{kingdom["name"]}의 인물')
                image_url = result.get('image', {}).get('value')
                
                stats = {"leadership": 70, "strength": 60, "intelligence": 60, "politics": 50, "charm": 50}

                char_entry = {
                    "id": f"char_{wiki_id}",
                    "eraId": ERA_ID_THREE_KINGDOMS,
                    "name": name,
                    "nameKorean": name,
                    "description": description,
                    "thumbnailAsset": "assets/images/characters/placeholder.png",
                    "imageUrl": image_url,
                    "dialogueId": "dialogue_default",
                    "isUnlocked": False,
                    "stats": stats
                }
                characters.append(char_entry)
            except Exception as e:
                continue
                
    return characters

            
    return characters

def generate_renaissance_characters():
    """Generates character data for the Renaissance era."""
    print("Fetching Renaissance Characters...")
    # ... (existing content) ... (keeping the existing function signature but content is assumed valid)
    # To save tokens I will just call the previous logic or assume it is handled, 
    # but since I am REPLACING the file content partially, I need to be careful.
    # Actually, I will just append the new function and update main.
    
    # Re-pasting the query for Renaissance to ensure the file stays valid
    query = """
    SELECT DISTINCT ?item ?itemLabel ?itemDescription ?image ?birthDate WHERE {
      ?item wdt:P31 wd:Q5. 
      VALUES ?occupation { wd:Q1028181 wd:Q901 wd:Q170790 wd:Q4964182 }
      ?item wdt:P106 ?occupation.
      ?item wdt:P569 ?birthDate.
      FILTER("1450-01-01"^^xsd:dateTime <= ?birthDate && ?birthDate < "1520-01-01"^^xsd:dateTime)
      ?item wdt:P18 ?image.
      SERVICE wikibase:label { bd:serviceParam wikibase:language "ko,en". }
    }
    LIMIT 10
    """
    
    data = fetch_data(query)
    if not data:
        return []

    characters = []
    
    for result in data['results']['bindings']:
        try:
            wiki_id = result['item']['value'].split('/')[-1]
            name = result['itemLabel']['value']
            description = result.get('itemDescription', {}).get('value', '르네상스 시기의 위인')
            image_url = result['image']['value']
            
            stats = {"leadership": 50, "strength": 30, "intelligence": 90, "politics": 60, "charm": 70}

            char_entry = {
                "id": f"char_{wiki_id}",
                "eraId": ERA_ID_RENAISSANCE,
                "name": name,
                "nameKorean": name,
                "description": description,
                "thumbnailAsset": "assets/images/characters/placeholder.png",
                "imageUrl": image_url,
                "dialogueId": "dialogue_default",
                "isUnlocked": False,
                "stats": stats
            }
            characters.append(char_entry)
        except Exception as e:
            continue
    return characters

def generate_encyclopedia_entries(characters):
    """Generates encyclopedia entries based on the fetched characters."""
    entries = []
    for char in characters:
        era_name = "르네상스" if char['eraId'] == ERA_ID_RENAISSANCE else "삼국시대"
        description = char['description']
        
        content = f"{char['nameKorean']}은(는) {description}로 알려진 {era_name}의 인물입니다.\n\n[주요 정보]\n- 시대: {era_name}\n- 설명: {description}\n\n(위키데이터 기반 자동 생성)"

        entry = {
            "id": f"encyclo_{char['id']}",
            "type": "character",
            "title": char['name'], 
            "titleKorean": char['nameKorean'],
            "summary": description,
            "content": content,
            "thumbnailAsset": char['thumbnailAsset'],
            "imageAsset": char.get('imageUrl'),
            "eraId": char['eraId'],
            "relatedEntryIds": [],
            "tags": [era_name, "위인"],
            "isDiscovered": False
        }
        entries.append(entry)
    return entries

def main():
    # Ensure output directory exists
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    # 1. Generate Renaissance Data
    renaissance_chars = generate_renaissance_characters()
    if renaissance_chars:
        # Save Characters
        char_path = os.path.join(OUTPUT_DIR, 'characters_europe_generated.json')
        with open(char_path, 'w', encoding='utf-8') as f:
            json.dump(renaissance_chars, f, ensure_ascii=False, indent=2)
        
        # Save Encyclopedia Entries
        encyclo_entries = generate_encyclopedia_entries(renaissance_chars)
        encyclo_path = os.path.join(OUTPUT_DIR, 'encyclopedia_europe_generated.json')
        with open(encyclo_path, 'w', encoding='utf-8') as f:
            json.dump(encyclo_entries, f, ensure_ascii=False, indent=2)
            
    # 2. Generate Three Kingdoms Data
    three_kingdoms_chars = generate_three_kingdoms_characters()
    if three_kingdoms_chars:
        # Save Characters
        char_path = os.path.join(OUTPUT_DIR, 'characters_asia_generated.json')
        with open(char_path, 'w', encoding='utf-8') as f:
            json.dump(three_kingdoms_chars, f, ensure_ascii=False, indent=2)
        print(f"Saved {len(three_kingdoms_chars)} characters to {char_path}")
        
        # Save Encyclopedia Entries
        encyclo_entries = generate_encyclopedia_entries(three_kingdoms_chars)
        encyclo_path = os.path.join(OUTPUT_DIR, 'encyclopedia_asia_generated.json')
        with open(encyclo_path, 'w', encoding='utf-8') as f:
            json.dump(encyclo_entries, f, ensure_ascii=False, indent=2)
        print(f"Saved {len(encyclo_entries)} encyclopedia entries to {encyclo_path}")

if __name__ == "__main__":
    main()
