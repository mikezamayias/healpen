import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/writing_controller.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import '../settings/writing/widgets/analyze_notes_tile.dart';
import 'widgets/save_note_button.dart';
import 'widgets/stopwatch_tile.dart';
import 'widgets/writing_text_field.dart';

class WritingView extends ConsumerStatefulWidget {
  const WritingView({Key? key}) : super(key: key);

  @override
  ConsumerState<WritingView> createState() => _WritingViewState();
}

class _WritingViewState extends ConsumerState<WritingView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != ref.watch(WritingController().isKeyboardOpenProvider)) {
      ref.read(WritingController().isKeyboardOpenProvider.notifier).state =
          newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName;
    WritingController.writingAutomaticStopwatch =
        ref.watch(writingAutomaticStopwatchProvider);
    // WritingController().updateAllUserNotes();
    return BlueprintView(
      showAppBarTitle: ref.watch(navigationShowAppBarTitleProvider),
      appBar: ref.watch(WritingController().isKeyboardOpenProvider)
          ? null
          : AppBar(
              pathNames: [
                userName == null
                    ? 'Hello,\nWhat\'s on your mind today?'
                    : 'Hello $userName,\nWhat\'s on your mind today?',
              ],
            ),
      body: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.all(gap),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Expanded(child: WritingTextField()),
            if (!ref.watch(WritingController().isKeyboardOpenProvider))
              Column(
                children: [
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
                  if (ref.watch(writingShowAnalyzeNotesButtonProvider))
                    Padding(
                      padding: EdgeInsets.only(top: gap),
                      child: const AnalyzeNotesTile(),
                    ),
                ],
              )
                  .animate()
                  .fadeIn(
                    curve: standardCurve,
                    duration: standardDuration,
                  )
                  .slideY(
                    begin: gap,
                    curve: standardCurve,
                    duration: standardDuration,
                  ),
          ],
        ),
      ),
    );
  }
}
