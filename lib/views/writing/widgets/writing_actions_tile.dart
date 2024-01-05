import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import 'clear_note_button.dart';
import 'save_note_button.dart';

class WritingActionsTile extends ConsumerStatefulWidget {
  const WritingActionsTile({super.key});

  @override
  ConsumerState<WritingActionsTile> createState() =>
      _WritingActionsButtonState();
}

class _WritingActionsButtonState extends ConsumerState<WritingActionsTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        // TODO: add confirmation dialog for reset and save
        Expanded(child: ClearNoteButton()),
        Expanded(child: SaveNoteButton()),
        // HideKeyboardButton(),
      ].addSpacer(
        SizedBox(width: gap),
        spacerAtEnd: false,
        spacerAtStart: false,
      ),
    );
  }

  bool get isKeyboardOpen =>
      ref.watch(WritingController().isKeyboardOpenProvider);

  bool get useSmallerNavigationSetting =>
      ref.watch(navigationSmallerNavigationElementsProvider);
}
