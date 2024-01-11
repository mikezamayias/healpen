import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/date_view_controller.dart';
import 'date_view_action_button.dart';

class SelectNoneNotesActionButton extends ConsumerWidget {
  const SelectNoneNotesActionButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DateViewActionButton(
      titleString: 'None',
      onTap: DateViewController.xorNotesSelected(ref)
          ? () {
              DateViewController.deselectAllNotes(ref);
            }
          : null,
    );
  }
}
