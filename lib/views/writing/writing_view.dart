import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/new_entry_button.dart';
import 'widgets/stopwatch_tile.dart';
import 'widgets/writing_entry.dart';

class WritingView extends ConsumerStatefulWidget {
  const WritingView({Key? key}) : super(key: key);

  @override
  ConsumerState<WritingView> createState() => _WritingViewState();
}

class _WritingViewState extends ConsumerState<WritingView>
    with WidgetsBindingObserver {
  bool isKeyboardOpen = false;

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
    if (newValue != isKeyboardOpen) {
      setState(() {
        isKeyboardOpen = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName;
    return BlueprintView(
      appBar: isKeyboardOpen
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
            const Expanded(child: WritingEntry()),
            SizedBox(height: gap),
            Row(
              children: [
                const Expanded(child: StopwatchTile()),
                SizedBox(width: gap),
                const NewEntryButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
