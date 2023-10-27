import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../controllers/emotional_echo_controller.dart';
import '../../../../../providers/settings_providers.dart';
import '../../../../../utils/helper_functions.dart';
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
        vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              true;
        });
      },
      onLongPressEnd: (_) {
        vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              false;
        });
      },
      child: const EmotionalEchoActiveTile(),
    );
  }
}
