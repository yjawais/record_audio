import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pesuvl/screens/recording_screen.dart';

void main() {
  testWidgets('RecordingScreen shows start button when not recording', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RecordingScreen()));

    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Stop'), findsNothing);
  });

  testWidgets('RecordingScreen toggles button text when pressed', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RecordingScreen()));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
  });
}