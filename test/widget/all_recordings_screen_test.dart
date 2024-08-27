import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:pesuvl/models/recording_model.dart';
import 'package:pesuvl/screens/all_recording_screen.dart';
import 'package:pesuvl/services/file_service.dart';

class MockFileService extends Mock implements FileService {}

void main() {
  late MockFileService mockFileService;

  setUp(() {
    mockFileService = MockFileService();
  });

  testWidgets('AllRecordingsScreen displays recordings', (WidgetTester tester) async {
    when(mockFileService.getRecordings()).thenAnswer((_) async => [
      Recording(name: 'Test Recording', date: DateTime.now(), filePath: 'path/to/file'),
    ]);

    await tester.pumpWidget(MaterialApp(home: AllRecordingsScreen()));

    expect(find.text('Test Recording'), findsOneWidget);
  });

  testWidgets('AllRecordingsScreen has a FloatingActionButton', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AllRecordingsScreen()));

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}