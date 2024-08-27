import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pesuvl/screens/all_recording_screen.dart';

import 'package:pesuvl/services/audio_recorder_service.dart';
import 'package:pesuvl/services/file_service.dart';
import 'package:pesuvl/services/permission_service.dart';
import 'package:pesuvl/widgets/circular_record_widget.dart';
import 'package:pesuvl/widgets/ripple_mic_widget.dart';

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final AudioRecorderService _recorderService = AudioRecorderService();
  final FileService _fileService = FileService();
  final PermissionService _permissionService = PermissionService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _isPaused = false;
  String? _currentRecordingPath;
  double _startTrim = 0.0;
  double _endTrim = 0.0;
  bool _showTrimControls = false;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('Record Audio')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   height: 300,
            //   width: MediaQuery.of(context).size.width,
            //   child: StreamBuilder<RecordingDisposition>(
            //     stream: _recorderService.getRecordingStream(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return CustomPaint(
            //           size: Size(MediaQuery.of(context).size.width, 200),
            //           painter: WavePainter(amplitude: snapshot.data!.decibels!),
            //         );
            //       } else {
            //         return Container(height: 100);
            //       }
            //     },
            //   ),
            // ),
            SizedBox(
              height: 400,
              child: Center(
                child: RippleMicButton(
                  isRecording: _isRecording,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (_isRecording)
                      ? _isPaused
                          ? _resumeRecording
                          : _pauseRecording
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (_isRecording) ? Colors.white : Colors.grey,
                          width: 4,
                        ),
                      ),
                      child: Icon(
                        _isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: (_isRecording) ? Colors.white : Colors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                CircularRecordButton(
                  onTap: _toggleRecording,
                  isRecording: _isRecording,
                ),
                GestureDetector(
                  onTap: (_isRecording)
                      ? null
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllRecordingsScreen()),
                          );
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Icon(
                        Icons.list,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // if (_currentRecordingPath != null) ...[
            //   ElevatedButton(
            //     onPressed: _togglePlayback,
            //     child: Text(_isPlaying ? 'Stop Playback' : 'Play Recording'),
            //   ),
            //   ElevatedButton(
            //     onPressed: () => setState(() => _showTrimControls = true),
            //     child: Text('Edit'),
            //   ),
            //   if (_showTrimControls) ...[
            //     Slider(
            //       min: 0.0,
            //       max: _audioDurationInSeconds ?? 0.0,
            //       value: _startTrim,
            //       onChanged: (value) => setState(() => _startTrim = value),
            //     ),
            //     Slider(
            //       min: 0.0,
            //       max: _audioDurationInSeconds ?? 0.0,
            //       value: _endTrim,
            //       onChanged: (value) => setState(() => _endTrim = value),
            //     ),
            //     ElevatedButton(
            //       onPressed: _trimAudio,
            //       child: Text('Trim Audio'),
            //     ),
            //   ],
            // ],
          ],
        ),
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      _currentRecordingPath = await _recorderService.stopRecording();
      _isPaused = false;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          TextEditingController _controller = TextEditingController(
              text: DateTime.now().millisecondsSinceEpoch.toString());

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16,
                right: 20,
                left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Save Recording',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Recording Name',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _deleteRecording();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_currentRecordingPath != null) {
                          await _fileService.saveRecording(
                              _currentRecordingPath!, _controller.text);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      bool hasPermission =
          await _permissionService.requestMicrophonePermission();
      if (hasPermission) {
        await _recorderService.startRecording();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Microphone permission denied')),
        );
        return;
      }
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  Future<void> _pauseRecording() async {
    await _recorderService.pauseRecording();
    setState(() {
      _isPaused = true;
    });
  }

  Future<void> _resumeRecording() async {
    await _recorderService.resumeRecording();
    setState(() {
      _isPaused = false;
    });
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    } else if (_currentRecordingPath != null) {
      await _audioPlayer.play(DeviceFileSource(_currentRecordingPath!));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  double? _audioDurationInSeconds; // Store the duration here

  @override
  void initState() {
    super.initState();
    // Fetch the duration when the widget is initialized
    _fetchAudioDuration();
  }

  Future<void> _fetchAudioDuration() async {
    var duration = await _audioPlayer.getDuration();
    setState(() {
      _audioDurationInSeconds = duration?.inSeconds.toDouble() ?? 0.0;
    });
  }

  Future<void> _trimAudio() async {
    if (_currentRecordingPath == null) return;

    try {
      final trimmedPath = await _recorderService.trimAudio(
        _currentRecordingPath!,
        _startTrim,
        _endTrim,
      );

      if (trimmedPath != null) {
        await _fileService.saveRecording(trimmedPath, 'Trimmed Recording');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio trimmed and saved successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to trim audio: $e')),
      );
    }
  }

  void _deleteRecording() {
    if (_currentRecordingPath != null) {
      _fileService.deleteRecording(_currentRecordingPath!);
      setState(() {
        _currentRecordingPath = null;
        _showTrimControls = false;
      });
    }
  }
}
