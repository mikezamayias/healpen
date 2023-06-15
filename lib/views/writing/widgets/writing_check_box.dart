import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';

class WritingCheckBox extends ConsumerWidget {
  const WritingCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final controller = ref.read(writingControllerProvider.notifier);

    return CheckboxListTile(
      value: state.isPrivate,
      enableFeedback: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      onChanged: (bool? value) {
        controller.updatePrivate(value!);
      },
      title: Padding(
        padding: EdgeInsets.only(left: gap),
        child: const Text(
          'Private entry',
        ),
      ),
    );
  }
}
