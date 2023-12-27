import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import 'action_button.dart';

class HideKeyboardButton extends ConsumerWidget {
  const HideKeyboardButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboardOpen =
        ref.watch(WritingController().isKeyboardOpenProvider);

    return ActionButton(
      leadingIconData: FontAwesomeIcons.solidKeyboard,
      condition: isKeyboardOpen,
      onTap: () {
        hideKeyboard(context);
      },
    );
  }
}
