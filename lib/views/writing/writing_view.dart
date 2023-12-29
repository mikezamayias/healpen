import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/page_controller.dart' as page_controller;
import '../../controllers/writing_controller.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/writing_text_field.dart';

class WritingView extends ConsumerStatefulWidget {
  const WritingView({super.key});

  @override
  ConsumerState<WritingView> createState() => _WritingViewState();
}

class _WritingViewState extends ConsumerState<WritingView> {
  @override
  Widget build(BuildContext context) {
    WritingController.writingAutomaticStopwatch =
        ref.watch(writingAutomaticStopwatchProvider);
    // WritingController().updateAllUserNotes();
    final pathNames = page_controller.PageController()
        .writing
        .titleGenerator(FirebaseAuth.instance.currentUser?.displayName)
        .split('\n');
    return BlueprintView(
      showAppBar: showAppBar,
      appBar: ref.watch(WritingController().isKeyboardOpenProvider)
          ? null
          : AppBar(
              pathNames: [
                if (useSmallerNavigationElements)
                  pathNames.last
                else
                  pathNames.join('\n')
              ],
            ),
      body: AnimatedContainer(
        duration: standardDuration,
        curve: standardCurve,
        padding:
            isKeyboardOpen ? EdgeInsets.only(top: gap) : EdgeInsets.zero,
        child: AnimatedContainer(
          duration: standardDuration,
          curve: standardCurve,
          decoration: useSmallerNavigationElements || isKeyboardOpen
              ? const BoxDecoration()
              : BoxDecoration(
                  color: context.theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(radius),
                ),
          padding: useSmallerNavigationElements || isKeyboardOpen
              ? EdgeInsets.zero
              : EdgeInsets.all(gap),
          child: const WritingTextField(),
        ),
      ),
    );
  }

  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
  bool get showAppBar => ref.watch(navigationShowAppBarProvider);
  bool get useSimpleUi => ref.watch(navigationSimpleUIProvider);
  bool get isKeyboardOpen =>
      ref.watch(WritingController().isKeyboardOpenProvider);
}
