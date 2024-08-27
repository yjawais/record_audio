import 'package:flutter_test/flutter_test.dart';
import 'package:pesuvl/services/audio_recorder_service.dart';

void main() {
  late AudioRecorderService audioRecorderService;

  setUp(() {
    audioRecorderService = AudioRecorderService();
  });

  test('startRecording initializes recorder', () async {
    await audioRecorderService.startRecording();
    expect(audioRecorderService.getRecordingStream(), isNotNull);
  });

  test('stopRecording returns a file path', () async {
    await audioRecorderService.startRecording();
    final path = await audioRecorderService.stopRecording();
    expect(path, isNotNull);
  });
}