import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';

class WritingTextField extends ConsumerWidget {
  const WritingTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(writingControllerProvider.notifier);
    final textController = controller.textController;

    return TextFormField(
      controller: textController,
      onChanged: controller.handleTextChange,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      style: context.theme.textTheme.titleLarge!.copyWith(
        overflow: TextOverflow.visible,
      ),
      decoration: const InputDecoration(
        // TODO: hint text should be affected from previous writing entries
        hintText: 'Express your feelings and thoughts',
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
