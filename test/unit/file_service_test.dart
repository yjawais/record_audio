import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pesuvl/models/recording_model.dart';
import 'package:pesuvl/services/file_service.dart';


void main() {
  late FileService fileService;

  setUp(() {
    fileService = FileService();
  });

  test('getRecordings returns a list of Recordings', () async {
    final recordings = await fileService.getRecordings();
    expect(recordings, isA<List<Recording>>());
  });

  test('saveRecording creates a new file', () async {
    // Create a temporary file for testing
    final tempFile = await File('test_recording.aac').create();
    await fileService.saveRecording(tempFile.path, 'Test Recording');

    final recordings = await fileService.getRecordings();
    expect(recordings.any((r) => r.name == 'Test Recording.aac'), isTrue);

    // Clean up
    await fileService.deleteRecording('${(await getApplicationDocumentsDirectory()).path}/Test Recording.aac');
  });

  test('deleteRecording removes the file', () async {
    // Create a temporary file for testing
    final tempFile = await File('test_recording.aac').create();
    await fileService.saveRecording(tempFile.path, 'Test Recording');

    await fileService.deleteRecording('${(await getApplicationDocumentsDirectory()).path}/Test Recording.aac');

    final recordings = await fileService.getRecordings();
    expect(recordings.any((r) => r.name == 'Test Recording.aac'), isFalse);
  });
}