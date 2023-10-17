import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';

class WritingTextField extends ConsumerWidget {
  const WritingTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius - gap),
      ),
      padding: EdgeInsets.all(gap),
      child: TextField(
        controller: ref.read(writingControllerProvider.notifier).textController,
        onChanged:
            ref.read(writingControllerProvider.notifier).handleTextChange,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        style: context.theme.textTheme.titleLarge!.copyWith(
          color: context.theme.colorScheme.onSurfaceVariant,
          overflow: TextOverflow.visible,
        ),
        decoration: InputDecoration(
          // TODO: hint text should be affected from previous writing entries
          hintText: 'Express your feelings and thoughts',
          hintStyle: context.theme.textTheme.titleLarge!.copyWith(
            overflow: TextOverflow.visible,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
