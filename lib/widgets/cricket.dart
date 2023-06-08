import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Cricket extends StatefulWidget {
  const Cricket({Key? key}) : super(key: key);

  @override
  State<Cricket> createState() => CricketState();
}

class CricketState extends State<Cricket> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'body',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => _isPlaying ? null : _controller.isActive = true,
      child: RiveAnimation.asset(
        'assets/rive/cricket.riv',
        controllers: [_controller],
        // Update the play state when the widget's initialized
        onInit: (_) => setState(() {}),
        animations: const [
          'antenna',
          'body',
          'head',
          'wings',
          'legs',
        ],
      ),
    );
  }
}
