import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/emotional_echo_controller.dart';
import '../../../../controllers/settings/preferences_controller.dart';
import '../../../../utils/helper_functions.dart';
import '../insights/emotional_echo/widgets/active_tile.dart';

class EmotionalEchoTile extends ConsumerWidget {
  const EmotionalEchoTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        vibrate(PreferencesController.navigationEnableHapticFeedback.value, () {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              true;
        });
      },
      onLongPressEnd: (_) {
        vibrate(PreferencesController.navigationEnableHapticFeedback.value, () {
          ref.watch(EmotionalEchoController.isPressedProvider.notifier).state =
              false;
        });
      },
      child: const EmotionalEchoActiveTile(),
    );
  }
}
