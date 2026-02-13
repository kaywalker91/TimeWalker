#!/usr/bin/env python3
"""
Script to transform quizzes.json into i18n-compatible format.
"""

import json

def transform_quizzes():
    with open('assets/data/quizzes.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    categories = data.get('categories', [])
    main_data = {'categories': []}
    ko_content = {}
    en_content = {}
    
    for cat in categories:
        cat_id = cat['id']
        
        # Main category structure
        main_cat = {
            'id': cat_id,
            'title': {
                'ko': cat.get('title', ''),
                'en': cat.get('title', '')  # TODO: Translate
            },
            'quizzes': []
        }
        
        # Category description in i18n
        ko_content[f'category_{cat_id}'] = {
            'description': cat.get('description', '')
        }
        en_content[f'category_{cat_id}'] = {
            'description': cat.get('description', '')  # TODO: Translate
        }
        
        # Process quizzes
        for quiz in cat.get('quizzes', []):
            quiz_id = quiz['id']
            
            # Main quiz structure (metadata only)
            main_quiz = {
                'id': quiz_id,
                'type': quiz.get('type', 'multipleChoice'),
                'difficulty': quiz.get('difficulty', 'medium'),
                'correctAnswer': quiz.get('correctAnswer', ''),
                'eraId': quiz.get('eraId', ''),
                'relatedFactId': quiz.get('relatedFactId', ''),
                'relatedDialogueId': quiz.get('relatedDialogueId', ''),
                'basePoints': quiz.get('basePoints', 10),
                'timeLimitSeconds': quiz.get('timeLimitSeconds', 30)
            }
            
            main_cat['quizzes'].append(main_quiz)
            
            # Quiz text content in i18n
            ko_content[quiz_id] = {
                'question': quiz.get('question', ''),
                'options': quiz.get('options', []),
                'explanation': quiz.get('explanation', '')
            }
            
            en_content[quiz_id] = {
                'question': quiz.get('question', ''),  # TODO: Translate
                'options': quiz.get('options', []),  # TODO: Translate
                'explanation': quiz.get('explanation', '')  # TODO: Translate
            }
        
        main_data['categories'].append(main_cat)
    
    # Write files
    with open('assets/data/quizzes_new.json', 'w', encoding='utf-8') as f:
        json.dump(main_data, f, ensure_ascii=False, indent=4)
    
    with open('assets/data/i18n/ko/quizzes.json', 'w', encoding='utf-8') as f:
        json.dump(ko_content, f, ensure_ascii=False, indent=4)
    
    with open('assets/data/i18n/en/quizzes.json', 'w', encoding='utf-8') as f:
        json.dump(en_content, f, ensure_ascii=False, indent=4)
    
    total_quizzes = sum(len(cat['quizzes']) for cat in main_data['categories'])
    print(f"Transformed {len(categories)} categories with {total_quizzes} total quizzes")

if __name__ == '__main__':
    transform_quizzes()
