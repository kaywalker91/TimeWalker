import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_walker/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TimeRunnerApp()));

    // 스플래시 화면이 나타나는지 확인
    expect(find.text('TimeRunner'), findsOneWidget);
  });
}
