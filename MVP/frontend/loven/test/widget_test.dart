import 'package:flutter_test/flutter_test.dart';
import 'package:loven/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const LovenApp());

    expect(find.byType(LovenApp), findsOneWidget);
  });
}
