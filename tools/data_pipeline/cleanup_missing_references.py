import argparse
import json
from pathlib import Path


def load_json(path: Path):
    return json.loads(path.read_text(encoding='utf-8'))


def write_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding='utf-8')


def dedupe(values):
    seen = set()
    out = []
    for value in values:
        if value not in seen:
            out.append(value)
            seen.add(value)
    return out


def clean_ref_list(obj, field, valid_set):
    values = obj.get(field) or []
    cleaned = [value for value in values if value in valid_set]
    cleaned = dedupe(cleaned)
    removed = len(values) - len(cleaned)
    if removed:
        obj[field] = cleaned
    return removed


def clean_ref_field(obj, field, valid_set):
    value = obj.get(field)
    if value is not None and value not in valid_set:
        obj[field] = None
        return 1
    return 0


def main():
    parser = argparse.ArgumentParser(description='Clean missing reference IDs in content JSON.')
    parser.add_argument('--input-dir', default='assets/data', help='Input directory')
    parser.add_argument('--output-dir', default='tools/data_pipeline/cleaned', help='Output directory')
    args = parser.parse_args()

    input_dir = Path(args.input_dir)
    output_dir = Path(args.output_dir)

    characters = load_json(input_dir / 'characters.json')
    dialogues = load_json(input_dir / 'dialogues.json')
    locations = load_json(input_dir / 'locations.json')
    encyclopedia = load_json(input_dir / 'encyclopedia.json')
    quizzes_data = load_json(input_dir / 'quizzes.json')

    character_ids = {c['id'] for c in characters}
    dialogue_ids = {d['id'] for d in dialogues}
    location_ids = {l['id'] for l in locations}
    entry_ids = {e['id'] for e in encyclopedia}

    removed_counts = {
        'characters.dialogueIds': 0,
        'characters.relatedCharacterIds': 0,
        'characters.relatedLocationIds': 0,
        'locations.characterIds': 0,
        'locations.eventIds': 0,
        'encyclopedia.relatedEntryIds': 0,
        'quizzes.relatedFactId': 0,
        'quizzes.relatedDialogueId': 0,
        'quizzes.relatedCharacterId': 0,
        'quizzes.relatedLocationId': 0,
    }

    for character in characters:
        removed_counts['characters.dialogueIds'] += clean_ref_list(
            character, 'dialogueIds', dialogue_ids
        )
        removed_counts['characters.relatedCharacterIds'] += clean_ref_list(
            character, 'relatedCharacterIds', character_ids
        )
        removed_counts['characters.relatedLocationIds'] += clean_ref_list(
            character, 'relatedLocationIds', location_ids
        )

    for location in locations:
        removed_counts['locations.characterIds'] += clean_ref_list(
            location, 'characterIds', character_ids
        )
        removed_counts['locations.eventIds'] += clean_ref_list(
            location, 'eventIds', entry_ids
        )

    for entry in encyclopedia:
        removed_counts['encyclopedia.relatedEntryIds'] += clean_ref_list(
            entry, 'relatedEntryIds', entry_ids
        )

    if isinstance(quizzes_data, dict) and 'categories' in quizzes_data:
        for category in quizzes_data['categories']:
            for quiz in category.get('quizzes', []):
                removed_counts['quizzes.relatedFactId'] += clean_ref_field(
                    quiz, 'relatedFactId', entry_ids
                )
                removed_counts['quizzes.relatedDialogueId'] += clean_ref_field(
                    quiz, 'relatedDialogueId', dialogue_ids
                )
                removed_counts['quizzes.relatedCharacterId'] += clean_ref_field(
                    quiz, 'relatedCharacterId', character_ids
                )
                removed_counts['quizzes.relatedLocationId'] += clean_ref_field(
                    quiz, 'relatedLocationId', location_ids
                )

    write_json(output_dir / 'characters.json', characters)
    write_json(output_dir / 'dialogues.json', dialogues)
    write_json(output_dir / 'locations.json', locations)
    write_json(output_dir / 'encyclopedia.json', encyclopedia)
    write_json(output_dir / 'quizzes.json', quizzes_data)

    print('Removed counts:')
    for key, value in removed_counts.items():
        print(f'- {key}: {value}')


if __name__ == '__main__':
    main()
