import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import 'hide_keyboard_button.dart';
import 'reset_note_button.dart';
import 'save_note_button.dart';

class WritingActionsButton extends ConsumerStatefulWidget {
  const WritingActionsButton({super.key});

  @override
  ConsumerState<WritingActionsButton> createState() =>
      _WritingActionsButtonState();
}

class _WritingActionsButtonState extends ConsumerState<WritingActionsButton> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      useSmallerNavigationSetting: false,
      backgroundColor: context.theme.colorScheme.surface,
      textColor: context.theme.colorScheme.onSurface,
      cornerRadius: useSmallerNavigationElements ? radius : gap,
      titleString: 'Actions',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          SaveNoteButton(),
          ResetNoteButton(),
          HideKeyboardButton(),
        ].addSpacer(
          SizedBox(width: _dynamicStopwatchAndSaveGap),
          spacerAtEnd: false,
          spacerAtStart: false,
        ),
      ),
    );
  }

  double get _dynamicStopwatchAndSaveGap => !isKeyboardOpen ? gap : radius;

  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  bool get isKeyboardOpen =>
      ref.watch(WritingController().isKeyboardOpenProvider);
}
