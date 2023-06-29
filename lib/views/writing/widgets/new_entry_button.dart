import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class NewEntryButton extends ConsumerWidget {
  const NewEntryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final writingController = ref.read(writingControllerProvider.notifier);
    final writingTextController =
        ref.read(writingControllerProvider.notifier).textController;
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.all(gap),
      onTap: () {
        if (state.text.isNotEmpty) {
          writingController.handleSaveEntry(); // Saves entry
          writingTextController.clear(); // Clears the TextFormField
          writingController.resetText(); // Resets the text in the state
        }
      },
      titleString: 'New Entry',
      backgroundColor: state.text.isEmpty || writingTextController.text.isEmpty
          ? context.theme.colorScheme.outline
          : null,
      textColor: state.text.isEmpty || writingTextController.text.isEmpty
          ? context.theme.colorScheme.background
          : null,
      responsiveWidth: true,
    );
  }
}