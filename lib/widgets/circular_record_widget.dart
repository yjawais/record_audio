import 'package:flutter/material.dart';

class CircularRecordButton extends StatefulWidget {
  final Function onTap;
  final bool isRecording;
  const CircularRecordButton({
    super.key,
    required this.onTap,
    required this.isRecording,
  });
  @override
  _CircularRecordButtonState createState() => _CircularRecordButtonState();
}

class _CircularRecordButtonState extends State<CircularRecordButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isRecording ? Colors.red : Colors.white,
            width: 4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: widget.isRecording ? Colors.red : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.isRecording
                  ? Icons.stop_rounded
                  : Icons.play_arrow_rounded,
              color: widget.isRecording ? Colors.white : Colors.red,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
