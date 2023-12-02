import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../controllers/page_controller.dart' as page_controller;
import '../../controllers/writing_controller.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import '../settings/writing/widgets/analyze_notes_tile.dart';
import 'widgets/save_note_button.dart';
import 'widgets/stopwatch_tile.dart';
import 'widgets/writing_text_field.dart';

class WritingView extends ConsumerWidget {
  const WritingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WritingController.writingAutomaticStopwatch =
        ref.watch(writingAutomaticStopwatchProvider);
    // WritingController().updateAllUserNotes();
    final smallerNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    final pathNames = page_controller.PageController()
        .writing
        .titleGenerator(FirebaseAuth.instance.currentUser?.displayName)
        .split('\n');
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    return BlueprintView(
      showAppBar: ref.watch(navigationShowAppBarProvider),
      appBar: ref.watch(WritingController().isKeyboardOpenProvider)
          ? null
          : AppBar(
              pathNames: [
                if (smallerNavigationElements)
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
          decoration: smallNavigationElements
              ? const BoxDecoration()
              : BoxDecoration(
                  color: context.theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(radius),
                ),
          padding:
              smallNavigationElements ? EdgeInsets.zero : EdgeInsets.all(gap),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Expanded(child: WritingTextField()),
              Padding(
                padding: EdgeInsets.only(top: gap),
                child: Row(
                  children: [
                    const Expanded(child: StopwatchTile()),
                    SizedBox(width: gap),
                    const SaveNoteButton(),
                  ],
                ),
              ),
              if (ref.watch(analysisModelListProvider).isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: gap),
                  child: const AnalyzeNotesTile(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
