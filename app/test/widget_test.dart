import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  testWidgets('App starts', (tester) async {
    await tester.pumpWidget(const TwentyOneKurdApp());
    expect(find.byType(TwentyOneKurdApp), findsOneWidget);
  });
}
