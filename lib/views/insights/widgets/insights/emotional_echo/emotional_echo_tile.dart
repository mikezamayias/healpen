import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../controllers/vibrate_controller.dart';
import 'widgets/active_tile.dart';

class EmotionalEchoTile extends ConsumerWidget {
  const EmotionalEchoTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        VibrateController().run(() {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              true;
        });
      },
      onLongPressEnd: (_) {
        VibrateController().run(() {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              false;
        });
      },
      child: const EmotionalEchoActiveTile(),
    );
  }
}
