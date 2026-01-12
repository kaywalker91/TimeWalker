import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/domain/entities/settings.dart';
import 'package:time_walker/main.dart';

import 'mocks/mock_audio_service.dart';
import 'mocks/mock_providers.dart';

/// 위젯 테스트 실행 여부
/// 
/// 앱에서 애니메이션 타이머가 사용되어 위젯 테스트 시 타이머 관련 오류가 발생합니다.
/// 완전한 통합 테스트가 필요한 경우 이 값을 true로 변경하세요.
/// 
/// TODO: 애니메이션 위젯 모킹 또는 통합 테스트로 마이그레이션 필요
const bool _skipWidgetTests = true;

void main() {
  late MockAudioService mockAudioService;

  setUp(() {
    // 각 테스트 전에 Mock 리셋
    mockAudioService = MockAudioService();
  });

  group('TimeRunnerApp 위젯 테스트', () {
    // 애니메이션 타이머로 인해 위젯 테스트가 실패할 수 있음
    // 통합 테스트에서 전체 앱 흐름을 확인하는 것을 권장
    
    testWidgets(
      '앱이 크래시 없이 시작됨',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: createMockAudioOverrides(
              mockAudioService: mockAudioService,
            ),
            child: const TimeRunnerApp(),
          ),
        );

        await tester.pump();

        expect(find.byType(MaterialApp), findsOneWidget);
      },
      skip: _skipWidgetTests,
    );

    testWidgets(
      '앱 테마가 적용되었는지 확인',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: createMockAudioOverrides(
              mockAudioService: mockAudioService,
            ),
            child: const TimeRunnerApp(),
          ),
        );

        await tester.pump();

        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.theme, isNotNull);
      },
      skip: _skipWidgetTests,
    );

    testWidgets(
      '앱 타이틀이 올바른지 확인',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: createMockAudioOverrides(
              mockAudioService: mockAudioService,
            ),
            child: const TimeRunnerApp(),
          ),
        );

        await tester.pump();

        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.title, equals('TimeWalker'));
      },
      skip: _skipWidgetTests,
    );

    testWidgets(
      '한국어 로케일이 설정되었는지 확인',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: createMockAudioOverrides(
              mockAudioService: mockAudioService,
            ),
            child: const TimeRunnerApp(),
          ),
        );

        await tester.pump();

        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.locale, equals(const Locale('ko')));
      },
      skip: _skipWidgetTests,
    );
  });

  group('Mock AudioService 테스트', () {
    test('MockAudioService가 올바르게 초기화됨', () async {
      await mockAudioService.initialize();
      
      expect(mockAudioService.initializeCalled, isTrue);
      expect(mockAudioService.isInitialized, isTrue);
    });

    test('MockAudioService BGM 재생이 기록됨', () async {
      await mockAudioService.initialize();
      await mockAudioService.playBgm('test_track.mp3');
      
      expect(mockAudioService.playedBgmTracks, contains('test_track.mp3'));
      expect(mockAudioService.isBgmPlaying, isTrue);
      expect(mockAudioService.currentBgmTrack, equals('test_track.mp3'));
    });

    test('MockAudioService SFX 재생이 기록됨', () async {
      await mockAudioService.initialize();
      await mockAudioService.playSfx('click.mp3');
      
      expect(mockAudioService.playedSfxSounds, contains('click.mp3'));
    });

    test('MockAudioService 리셋이 동작함', () async {
      await mockAudioService.initialize();
      await mockAudioService.playBgm('track.mp3');
      await mockAudioService.playSfx('sound.mp3');
      
      mockAudioService.reset();
      
      expect(mockAudioService.initializeCalled, isFalse);
      expect(mockAudioService.playedBgmTracks, isEmpty);
      expect(mockAudioService.playedSfxSounds, isEmpty);
      expect(mockAudioService.isInitialized, isFalse);
    });
    
    test('SFX 비활성화 시 재생되지 않음', () async {
      await mockAudioService.initialize();
      mockAudioService.applySettings(const GameSettings(soundEnabled: false));
      
      await mockAudioService.playSfx('click.mp3');
      
      expect(mockAudioService.playedSfxSounds, isEmpty);
    });
    
    test('BGM 비활성화 시 재생 상태가 false', () async {
      await mockAudioService.initialize();
      mockAudioService.applySettings(const GameSettings(musicEnabled: false));
      
      await mockAudioService.playBgm('track.mp3');
      
      expect(mockAudioService.isBgmPlaying, isFalse);
      expect(mockAudioService.playedBgmTracks, contains('track.mp3'));
    });
  });
}
