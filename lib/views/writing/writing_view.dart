import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../controllers/page_controller.dart' as page_controller;
import '../../controllers/writing_controller.dart';
import '../../extensions/widget_extensions.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import '../settings/writing/widgets/analyze_notes_tile.dart';
import 'widgets/stopwatch_tile.dart';
import 'widgets/writing_actions_button.dart';
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
      body: Padding(
        padding: ref.watch(WritingController().isKeyboardOpenProvider)
            ? EdgeInsets.only(bottom: gap)
            : EdgeInsets.zero,
        child: AnimatedContainer(
          duration: standardDuration,
          curve: standardCurve,
          decoration: useSmallerNavigationElements
              ? const BoxDecoration()
              : BoxDecoration(
                  color: context.theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(radius),
                ),
          padding: useSmallerNavigationElements
              ? EdgeInsets.zero
              : EdgeInsets.all(gap),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              if (!useSimpleUi)
                const WritingActionsButton().animateSlideInFromTop(),
              const Expanded(child: WritingTextField())
                  .animate()
                  .fade(curve: standardCurve, duration: standardDuration),
              if (!useSimpleUi)
                const StopwatchTile().animateSlideInFromBottom(),
              if (ref.watch(analysisModelSetProvider).isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: gap),
                  child: const AnalyzeNotesTile(),
                ),
            ].addSpacer(
              SizedBox(height: gap),
              spacerAtEnd: false,
              spacerAtStart: false,
            ),
          ),
        ),
      ),
    );
  }

  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
  bool get showAppBar => ref.watch(navigationShowAppBarProvider);
  bool get useSimpleUi => ref.watch(navigationSimpleUIProvider);
}
