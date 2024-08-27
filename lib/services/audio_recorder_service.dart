import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class AudioRecorderService {
  FlutterSoundRecorder? _recorder;
  String? _path;
  // final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  Future<void> startRecording() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    final directory = await getApplicationDocumentsDirectory();
    _path =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder!.startRecorder(toFile: _path);
  }

  Future<String?> stopRecording() async {
    await _recorder!.stopRecorder();
    await _recorder!.closeRecorder();
    return _path;
  }

  Future<void> resumeRecording() async {
    await _recorder!.resumeRecorder();
  }

  Future<void> pauseRecording() async {
    await _recorder!.pauseRecorder();
  }

  Stream<RecordingDisposition>? getRecordingStream() {
    return _recorder?.onProgress;
  }

  Future<String?> trimAudio(String inputPath, double start, double end) async {
    final directory = await getApplicationDocumentsDirectory();
    final outputPath =
        '${directory.path}/trimmed_${DateTime.now().millisecondsSinceEpoch}.aac';

    final arguments = [
      '-i',
      inputPath,
      '-ss',
      start.toString(),
      '-to',
      end.toString(),
      '-c',
      'copy',
      outputPath
    ];

    // final result = await _flutterFFmpeg.executeWithArguments(arguments);
    final result = 0;
    if (result == 0) {
      return outputPath;
    } else {
      throw Exception('Failed to trim audio');
    }
  }
}
