import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pesuvl/models/recording_model.dart';

class FileService {
  Future<List<Recording>> getRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();
    return files
        .where((file) => file.path.endsWith('.aac'))
        .map((file) => Recording(
              name: file.path.split('/').last,
              date: file.statSync().modified,
              filePath: file.path,
            ))
        .toList();
  }

  Future<void> saveRecording(String tempPath, String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final newPath = '${directory.path}/$name.aac';
    await File(tempPath).copy(newPath);
    await File(tempPath).delete();
  }

  Future<void> deleteRecording(String filePath) async {
    await File(filePath).delete();
  }

  Future<String> getNewFilePath(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$name.aac';
  }
}