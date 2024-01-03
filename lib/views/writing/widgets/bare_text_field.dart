import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';

class BareTextField extends ConsumerStatefulWidget {
  const BareTextField({
    super.key,
  });

  @override
  ConsumerState<BareTextField> createState() => _BareTextFieldState();
}

class _BareTextFieldState extends ConsumerState<BareTextField> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      padding:
          useSmallerNavigationSetting ? EdgeInsets.all(gap) : EdgeInsets.zero,
      decoration: useSmallerNavigationSetting
          ? BoxDecoration(
              color: context.theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(radius),
            )
          : const BoxDecoration(),
      child: TextField(
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

  WritingController get writingController =>
      ref.watch(writingControllerProvider.notifier);

  bool get useSmallerNavigationSetting =>
      ref.watch(navigationSmallerNavigationElementsProvider);
}
