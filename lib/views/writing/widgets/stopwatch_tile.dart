import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/int_extensions.dart';
import 'writing_action_button.dart';

class StopwatchTile extends ConsumerWidget {
  const StopwatchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WritingActionButton.withWidget(
      titleString: 'Stopwatch',
      child: Text(
        ref.watch(writingControllerProvider).duration.writingDurationFormat(),
        style: context.theme.textTheme.titleLarge!.copyWith(
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
