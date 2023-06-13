import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';

class WritingView extends StatefulWidget {
  const WritingView({Key? key}) : super(key: key);

  @override
  WritingViewState createState() => WritingViewState();
}

class WritingViewState extends State<WritingView> {
  final TextEditingController _controller = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    if (_controller.text.isNotEmpty) {
      if (!_stopwatch.isRunning) {
        _startTimer();
        setState(() {});
      } else {
        _restartDelayTimer();
      }
    } else if (_controller.text.isEmpty && _stopwatch.isRunning) {
      _pauseTimerAndLogInput();
      setState(() {});
    }
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    _delayTimer = Timer(const Duration(seconds: 3), _pauseTimerAndLogInput);
  }

  void _restartDelayTimer() {
    _delayTimer?.cancel();
    _delayTimer = Timer(const Duration(seconds: 3), _pauseTimerAndLogInput);
  }

  void _pauseTimerAndLogInput() {
    _timer?.cancel();
    _stopwatch.stop();
    log(
      'Input: ${_controller.text}',
      name: '_pauseTimerAndLogInput()',
    );
    log(
      'Time spent writing: ${_stopwatch.elapsed.inSeconds} seconds',
      name: '_pauseTimerAndLogInput()',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Hello Mike,\nWhat\'s on your mind today?'],
      ),
      body: CustomListTile(
        cornerRadius: radius,
        contentPadding: EdgeInsets.all(gap),
        subtitle: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                style: context.theme.textTheme.titleLarge!.copyWith(
                  overflow: TextOverflow.visible,
                ),
                decoration: const InputDecoration(
                  hintText: 'Express your feelings and thoughts',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            Text('Time spent writing: ${_stopwatch.elapsed.inSeconds} seconds'),
          ],
        ),
      ),
    );
  }
}
