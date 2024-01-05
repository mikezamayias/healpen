import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import 'writing_action_button.dart';

class ClearNoteButton extends ConsumerWidget {
  const ClearNoteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final writingController = ref.watch(writingControllerProvider.notifier);
    return WritingActionButton.withIcon(
      iconData: FontAwesomeIcons.solidTrashCan,
      condition: state.content.isNotEmpty || (state.duration != 0),
      titleString: 'Clear note',
      activeColor: context.theme.colorScheme.error,
      onTap: () {
        writingController.resetController();
        hideKeyboard(context);
      },
    );
  }
}
