import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../extensions/widget_extenstions.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/new_entry_button.dart';
import 'widgets/stopwatch_tile.dart';
import 'widgets/writing_entry.dart';

class WritingView extends ConsumerWidget {
  const WritingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName;
    return BlueprintView(
      appBar: AppBar(
        pathNames: [
          userName == null
              ? 'Hello,\nWhat\'s on your mind today?'
              : 'Hello $userName,\nWhat\'s on your mind today?',
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.outlineVariant,
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
          ].animateWidgetList(),
        ),
      ).animateSlideInFromTop(),
    );
  }
}
