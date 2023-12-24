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
    final borderRadius = smallNavigationElements ? radius : radius - gap;
    final color = simpleUi
        ? context.theme.colorScheme.surfaceVariant
        : context.theme.colorScheme.surface;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
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
          color: context.theme.colorScheme.onSurface,
          overflow: TextOverflow.visible,
        ),
        decoration: InputDecoration(
          hintText:
              "Write a few words about something that's bothering you.\n\n"
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
      ),
    );
  }
}
