import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pesuvl/models/recording_model.dart';
import 'package:pesuvl/services/audio_player_service.dart';

import 'package:share_plus/share_plus.dart';

class RecordingListItem extends StatefulWidget {
  final Recording recording;
  final Function onDelete;
  RecordingListItem({
    required this.recording,
    required this.onDelete,
  });

  @override
  _RecordingListItemState createState() => _RecordingListItemState();
}

class _RecordingListItemState extends State<RecordingListItem> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayerService.dispose();
    //  _loadAudioDuration();
    super.dispose();
  }

  Duration? _duration = Duration.zero;
  Future<void> _loadAudioDuration() async {
    _duration =
        await _audioPlayerService.getAudioDuration(widget.recording.filePath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate =
        DateFormat('MMM d yyyy,h:mm:ss a').format(widget.recording.date);
    return ExpansionTile(
      title: Text(widget.recording.name),
      subtitle: Text(formattedDate.toString()),
      children: [
        StreamBuilder<Duration>(
          stream: _audioPlayerService.positionStream,
          builder: (context, snapshot) {
            var position = snapshot.data ?? Duration.zero;
            return Slider(
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: _duration?.inSeconds.toDouble() ??
                  position.inSeconds.toDouble(),
              onChanged: (value) {
                _duration?.inSeconds.toDouble() ?? 0.0;
              },
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onDelete();
              },
            ),
            StreamBuilder<PlayerState>(
              stream: _audioPlayerService.playerStateStream,
              builder: (context, snapshot) {
                _isPlaying = snapshot.data == PlayerState.playing;
                return Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_5),
                      onPressed: () {
                        _skipBackward();
                      },
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: _togglePlayPause,
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_5),
                      onPressed: () {
                        _skipForward();
                      },
                    ),
                  ],
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.shareXFiles([XFile(widget.recording.filePath)]);
              },
            ),
          ],
        ),
      ],
    );
  }

  void _togglePlayPause() async {
    await _loadAudioDuration();
    if (_isPlaying) {
      _audioPlayerService.pauseAudio();
    } else {
      _audioPlayerService.playAudio(widget.recording.filePath);
    }
  }

  void _skipForward() async {
    var currentPosition = await _audioPlayerService.positionStream.first;
    var newPosition = currentPosition + Duration(seconds: 5);
    if (_duration != null && newPosition > _duration!) {
      newPosition = _duration!;
    }
    _audioPlayerService.seekAudio(newPosition);
  }

  void _skipBackward() async {
    var currentPosition = await _audioPlayerService.positionStream.first;
    var newPosition = currentPosition - Duration(seconds: 5);
    if (newPosition < Duration.zero) {
      newPosition = Duration.zero;
    }
    _audioPlayerService.seekAudio(newPosition);
  }
}
