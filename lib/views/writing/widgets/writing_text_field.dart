import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';

class WritingTextField extends ConsumerWidget {
  const WritingTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    final simpleUi = ref.watch(navigationSimpleUIProvider);
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      decoration: smallNavigationElements || simpleUi
          ? BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(radius),
            )
          : BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(radius - gap),
            ),
      padding: simpleUi ? EdgeInsets.zero : EdgeInsets.all(gap),
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
          hintText: "Write a few words about your day or something that's "
              'bothering you, aim for about 15 minutes of writing.\n\n'
              "What's on your mind?",
          hintStyle: context.theme.textTheme.titleLarge!.copyWith(
            overflow: TextOverflow.visible,
            color: context.theme.colorScheme.onSurface.withOpacity(0.6),
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
