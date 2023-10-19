import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:rive/rive.dart';

import '../../../../../../controllers/analysis_view_controller.dart';
import '../../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../../providers/settings_providers.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_functions.dart';
import '../../../../../../utils/rive/rive_color_component.dart';
import '../../../../../../utils/rive/rive_color_modifier.dart';

class EmotionalEchoInactiveTile extends ConsumerStatefulWidget {
  const EmotionalEchoInactiveTile({super.key});

  @override
  ConsumerState<EmotionalEchoInactiveTile> createState() =>
      _EmotionalEchoInactiveTileState();
}

class _EmotionalEchoInactiveTileState
    extends ConsumerState<EmotionalEchoInactiveTile> {
  /// We track if the animation is playing by whether or not the controller is
  /// running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  RiveAnimationController? _controller;

  Future<void> _load() async {
    var file = await RiveFile.asset('assets/rive/emotional_echo.riv');
    var artboard = file.mainArtboard;
    artboard.addController(_controller = SimpleAnimation('AllCircles'));
    setState(() => _riveArtboard = artboard);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    double sentiment = ref
        .watch(AnalysisViewController.analysisModelListProvider)
        .map((e) => e.sentiment!)
        .average;
    Color shapeColor = Color.lerp(
      ref.watch(themeProvider).colorScheme.error,
      ref.watch(themeProvider).colorScheme.primary,
      sentiment,
    )!;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // RiveAnimation.asset(
        //   'assets/rive/emotional_echo.riv',
        //   stateMachines: const [
        //     'AllCircles',
        //   ],
        //   fit: BoxFit.contain,
        //   onInit: (Artboard artboard) {
        //     artboard.forEachComponent(
        //       (child) {
        //         if (child is Shape) {
        //           final Shape shape = child;
        //           shape.fills.first.paint.color = shapeColor
        //               .withOpacity(shape.fills.first.paint.color.opacity);
        //         }
        //       },
        //     );
        //   },
        // ),

        if (_riveArtboard != null)
          RiveColorModifier(
            artboard: _riveArtboard!,
            fit: BoxFit.contain,
            components: ['core', 'inner', 'middle', 'outer']
                .map((String element) => RiveColorComponent(
                      shapeName: element,
                      fillName: '$element-fill',
                      color: shapeColor,
                    ))
                .toList(),
          ),

        Align(
          alignment: Alignment.center,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin:
                  ref.watch(EmotionalEchoController.isPressedProvider) ? 1 : 0,
              end: ref.watch(EmotionalEchoController.isPressedProvider) ? 0 : 1,
            ),
            duration: emphasizedDuration,
            curve: emphasizedCurve,
            builder: (BuildContext context, double value, Widget? child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: Text(
                    textAlign: TextAlign.center,
                    '${getSentimentLabel(sentiment)} '
                            '${sentiment.toStringAsFixed(2)}'
                        .split(' ')
                        .join('\n'),
                    style: context.theme.textTheme.titleLarge!.copyWith(
                      color: Color.lerp(
                        context.theme.colorScheme.onError,
                        context.theme.colorScheme.onPrimary,
                        sentiment,
                      )!,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
