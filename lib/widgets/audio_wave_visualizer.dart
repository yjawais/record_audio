import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_sound/flutter_sound.dart';
class AudioWaveVisualizer extends StatefulWidget {
  final Stream<RecordingDisposition>? audioStream;

  AudioWaveVisualizer({this.audioStream});

  @override
  State<AudioWaveVisualizer> createState() => _AudioWaveVisualizerState();
}

class _AudioWaveVisualizerState extends State<AudioWaveVisualizer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<RecordingDisposition>(
        stream: widget.audioStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 100),
              painter: WavePainter(amplitude: snapshot.data!.decibels!),
            );
          } else {
            return Container(height: 100);
          }
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double amplitude;

  WavePainter({required this.amplitude});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(0, height / 2);

    for (double i = 0; i < width; i++) {
      path.lineTo(
        i,
        height / 2 + sin((i / width) * 2 * pi) * amplitude * height / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => amplitude != oldDelegate.amplitude;
}
