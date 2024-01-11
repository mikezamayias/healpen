import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/date_view_controller.dart';
import 'date_view_action_button.dart';

class SelectActionButton extends ConsumerWidget {
  const SelectActionButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DateViewActionButton(
      onTap: () {
        ref
            .read(DateViewController.noteSelectionEnabledProvider.notifier)
            .state = !ref.read(DateViewController.noteSelectionEnabledProvider);
      },
      titleString: ref.watch(DateViewController.noteSelectionEnabledProvider)
          ? 'Cancel'
          : 'Select',
    );
  }
}
