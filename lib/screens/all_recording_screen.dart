import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pesuvl/models/recording_model.dart';
import 'package:pesuvl/services/file_service.dart';
import 'package:pesuvl/widgets/recording_list_item.dart';

class AllRecordingsScreen extends StatefulWidget {
  const AllRecordingsScreen({super.key});

  @override
  _AllRecordingsScreenState createState() => _AllRecordingsScreenState();
}

class _AllRecordingsScreenState extends State<AllRecordingsScreen> {
  final FileService _fileService = FileService();
  List<Recording> _recordings = [];

  @override
  void initState() {
    super.initState();
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    await Permission.microphone.request();
    try {
      final recordings = await _fileService.getRecordings();
      setState(() {
        _recordings = recordings;
      });
    } catch (e) {
      // Handle error
      print('Error loading recordings: $e');
    }
  }

  deleteRecording(String filePath) async {
    await _fileService.deleteRecording(filePath);
    setState(() {});
    _loadRecordings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Recordings')),
      body: ListView.builder(
        itemCount: _recordings.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return RecordingListItem(
              recording: _recordings[index],
              onDelete: () {
                deleteRecording(_recordings[index].filePath);
              });
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => RecordingScreen()),
      //     );
      //     _loadRecordings(); // Reload recordings after returning from RecordingScreen
      //   },
      //   child: Icon(Icons.mic),
      // ),
    );
  }
}
