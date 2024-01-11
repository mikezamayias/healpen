import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/date_view_controller.dart';
import 'date_view_action_button.dart';

class SelectAllNotesActionButton extends ConsumerWidget {
  const SelectAllNotesActionButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DateViewActionButton(
      titleString: 'All',
      onTap: !DateViewController.allNotesSelected(ref)
          ? () {
              DateViewController.selectAllNotes(ref);
            }
          : null,
    );
  }
}
