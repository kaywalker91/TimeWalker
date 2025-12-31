import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/atmosphere_overlay.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/floating_particles.dart';
import 'package:time_walker/presentation/screens/location_exploration/widgets/location_background.dart';

void main() {
  group('LocationBackground Widget Tests', () {
    testWidgets('renders background image', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LocationBackground(
              backgroundAsset: 'assets/images/locations/three_kingdoms_bg.png',
              fallbackAsset: 'assets/images/locations/three_kingdoms_bg_2.png',
            ),
          ),
        ),
      );

      // Stack이 렌더링되는지 확인
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('applies overlay when color provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationBackground(
              backgroundAsset: 'assets/images/locations/three_kingdoms_bg.png',
              fallbackAsset: 'assets/images/locations/three_kingdoms_bg_2.png',
              overlayColor: Colors.brown,
              overlayOpacity: 0.3,
            ),
          ),
        ),
      );

      expect(find.byType(Stack), findsWidgets);
    });
  });

  group('AtmosphereOverlay Widget Tests', () {
    testWidgets('renders with goguryeo kingdom', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AtmosphereOverlay(
              kingdom: 'goguryeo',
              opacity: 0.15,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders with baekje kingdom', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AtmosphereOverlay(
              kingdom: 'baekje',
              opacity: 0.15,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders with silla kingdom', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AtmosphereOverlay(
              kingdom: 'silla',
              opacity: 0.15,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders with gaya kingdom', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AtmosphereOverlay(
              kingdom: 'gaya',
              opacity: 0.15,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders with default color when no kingdom', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AtmosphereOverlay(
              kingdom: null,
              defaultColor: Colors.grey,
              opacity: 0.15,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });
  });

  group('KingdomAtmosphere Tests', () {
    test('fromKingdom returns correct atmosphere for each kingdom', () {
      final goguryeo = KingdomAtmosphere.fromKingdom('goguryeo');
      expect(goguryeo, isNotNull);
      expect(goguryeo!.kingdom, 'goguryeo');
      expect(goguryeo.particleCount, 25);

      final baekje = KingdomAtmosphere.fromKingdom('baekje');
      expect(baekje, isNotNull);
      expect(baekje!.kingdom, 'baekje');
      expect(baekje.particleCount, 35);

      final silla = KingdomAtmosphere.fromKingdom('silla');
      expect(silla, isNotNull);
      expect(silla!.kingdom, 'silla');
      expect(silla.particleCount, 40);

      final gaya = KingdomAtmosphere.fromKingdom('gaya');
      expect(gaya, isNotNull);
      expect(gaya!.kingdom, 'gaya');
      expect(gaya.particleCount, 30);
    });

    test('fromKingdom returns null for unknown kingdom', () {
      final unknown = KingdomAtmosphere.fromKingdom('unknown');
      expect(unknown, isNull);

      final nullKingdom = KingdomAtmosphere.fromKingdom(null);
      expect(nullKingdom, isNull);
    });
  });

  group('FloatingParticles Widget Tests', () {
    testWidgets('renders correctly with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FloatingParticles(),
          ),
        ),
      );

      expect(find.byType(FloatingParticles), findsOneWidget);
    });

    testWidgets('renders with custom particle count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FloatingParticles(
              particleCount: 50,
              particleColor: Colors.amber,
              maxParticleSize: 5.0,
              speedMultiplier: 1.5,
            ),
          ),
        ),
      );

      expect(find.byType(FloatingParticles), findsOneWidget);
    });

    testWidgets('animation runs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FloatingParticles(),
          ),
        ),
      );

      // 애니메이션 진행
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(FloatingParticles), findsOneWidget);
    });
  });
}
