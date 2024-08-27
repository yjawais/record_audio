import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration? _audioDuration;

  Future<void> playAudio(String filePath) async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    }
    await _audioPlayer.play(DeviceFileSource(filePath));
    _isPlaying = true;
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<Duration?> getAudioDuration(String filePath) async {
    // Return cached duration if already loaded
    if (_audioDuration != null) {
      return _audioDuration;
    }

    // Load the audio and retrieve its duration
    await _audioPlayer.setSource(DeviceFileSource(filePath));
    _audioDuration = await _audioPlayer.getDuration();
    return _audioDuration;
  }

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;

  Stream<PlayerState> get playerStateStream =>
      _audioPlayer.onPlayerStateChanged;

  void dispose() {
    _audioPlayer.dispose();
  }
}
