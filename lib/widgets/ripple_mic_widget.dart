import 'package:flutter/material.dart';

class RippleMicButton extends StatefulWidget {
  final bool isRecording;

  const RippleMicButton({super.key, required this.isRecording});
  @override
  _RippleMicButtonState createState() => _RippleMicButtonState();
}

class _RippleMicButtonState extends State<RippleMicButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ripple effects
        _buildRipple(100, 1.0),
        _buildRipple(150, 0.7),
        _buildRipple(200, 0.4),
        // Circular container with mic icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: widget.isRecording ? Colors.red : Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mic,
            color: Colors.white,
            size: 50,
          ),
        ),
      ],
    );
  }

  Widget _buildRipple(double radius, double opacity) {
    return AnimatedOpacity(
      opacity: widget.isRecording ? opacity : 0.0,
      duration: Duration(milliseconds: 1000),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        width: widget.isRecording ? radius : 0.0,
        height: widget.isRecording ? radius : 0.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.withOpacity(0.3),
        ),
      ),
    );
  }
}
