import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/data/datasources/i18n_content_loader.dart';

void main() {
  group('I18nContentLoader', () {
    late I18nContentLoader loader;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      loader = I18nContentLoader();
    });

    group('loadCharacterContent', () {
      test('should load Korean character content', () async {
        // Act
        final content = await loader.loadCharacterContent(const Locale('ko'));

        // Assert
        expect(content, isNotEmpty);
        expect(content, isA<Map<String, dynamic>>());
      });

      test('should load English character content', () async {
        // Act
        final content = await loader.loadCharacterContent(const Locale('en'));

        // Assert
        expect(content, isNotEmpty);
        expect(content, isA<Map<String, dynamic>>());
      });

      test('should include biography and fullBiography fields', () async {
        // Act
        final content = await loader.loadCharacterContent(const Locale('ko'));
        
        // Assert - check structure for at least one character
        if (content.isNotEmpty) {
          final firstCharacter = content.values.first as Map<String, dynamic>;
          expect(firstCharacter.containsKey('biography') || 
                 firstCharacter.containsKey('fullBiography'), isTrue);
        }
      });
    });

    group('loadDialogueContent', () {
      test('should load Korean dialogue content', () async {
        // Act
        final content = await loader.loadDialogueContent(const Locale('ko'));

        // Assert
        expect(content, isNotEmpty);
        expect(content, isA<Map<String, dynamic>>());
      });

      test('should load English dialogue content', () async {
        // Act
        final content = await loader.loadDialogueContent(const Locale('en'));

        // Assert
        expect(content, isNotEmpty);
        expect(content, isA<Map<String, dynamic>>());
      });

      test('should include nodes array in dialogue', () async {
        // Act
        final content = await loader.loadDialogueContent(const Locale('ko'));
        
        // Assert
        if (content.isNotEmpty) {
          final firstDialogue = content.values.first as Map<String, dynamic>;
          expect(firstDialogue.containsKey('nodes'), isTrue);
          expect(firstDialogue['nodes'], isA<List>());
        }
      });
    });

    group('loadQuizContent', () {
      test('should load Korean quiz content', () async {
        // Act
        final content = await loader.loadQuizContent(const Locale('ko'));

        // Assert
        expect(content, isNotEmpty);
        expect(content, isA<Map<String, dynamic>>());
      });

      test('should load English quiz content', () async {
        // Act
        final content = await loader.loadQuizContent(const Locale('en'));

        // Assert
        expect(content, isNotEmpty);
        expect(content, isA<Map<String, dynamic>>());
      });

      test('should include question, options, explanation fields', () async {
        // Act
        final content = await loader.loadQuizContent(const Locale('ko'));
        
        // Assert
        if (content.isNotEmpty) {
          final firstQuiz = content.values.first as Map<String, dynamic>;
          expect(firstQuiz.containsKey('question'), isTrue);
          expect(firstQuiz.containsKey('options'), isTrue);
          expect(firstQuiz.containsKey('explanation'), isTrue);
        }
      });
    });

    group('loadLocationContent', () {
      test('should load Korean location content', () async {
        // Act
        final content = await loader.loadLocationContent(const Locale('ko'));

        // Assert
        expect(content, isNotEmpty);
        expect(content, isA<Map<String, dynamic>>());
      });

      test('should load English location content', () async {
        // Act
        final content = await loader.loadLocationContent(const Locale('en'));

        // Assert
        expect(content, isNotEmpty);
        expect(content, isA<Map<String, dynamic>>());
      });

      test('should include description field', () async {
        // Act
        final content = await loader.loadLocationContent(const Locale('ko'));
        
        // Assert
        if (content.isNotEmpty) {
          final firstLocation = content.values.first as Map<String, dynamic>;
          expect(firstLocation.containsKey('description'), isTrue);
        }
      });
    });

    group('caching behavior', () {
      test('should cache loaded content', () async {
        // Act - Load twice
        final content1 = await loader.loadCharacterContent(const Locale('ko'));
        final content2 = await loader.loadCharacterContent(const Locale('ko'));

        // Assert - Should be same instance (cached)
        expect(identical(content1, content2), isTrue);
      });

      test('should have separate cache for different locales', () async {
        // Act
        final koContent = await loader.loadCharacterContent(const Locale('ko'));
        final enContent = await loader.loadCharacterContent(const Locale('en'));

        // Assert
        expect(identical(koContent, enContent), isFalse);
      });
    });

    group('error handling', () {
      test('should handle missing locale gracefully', () async {
        // Act & Assert
        expect(
          () => loader.loadCharacterContent(const Locale('invalid')),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
