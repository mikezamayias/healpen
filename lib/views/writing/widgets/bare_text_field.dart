import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';

class BareTextField extends ConsumerWidget {
  const BareTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final writingController = ref.watch(writingControllerProvider.notifier);
    return TextField(
      controller: writingController.textController,
      onChanged: writingController.handleTextChange,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      style: context.theme.textTheme.titleLarge!.copyWith(
        color: context.theme.colorScheme.onSurface,
        overflow: TextOverflow.visible,
      ),
      decoration: InputDecoration(
        hintText: "Write a few words about something that's bothering you.\n\n"
            'Try to write for about 15 minutes.',
        hintStyle: context.theme.textTheme.titleLarge!.copyWith(
          overflow: TextOverflow.visible,
          color: context.theme.colorScheme.onSurfaceVariant,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
