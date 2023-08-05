import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../widgets/custom_list_tile.dart';

class WritingStopwatchTile extends ConsumerWidget {
  const WritingStopwatchTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Automatic stopwatch control',
      subtitle: const Text(
        'Pauses the stopwatch when you stop typing and resets it when you clear all text.',
      ),
      trailing: Switch(
        value: ref.watch(writingResetStopwatchOnEmptyProvider),
        onChanged: (value) async {
          ref.read(writingResetStopwatchOnEmptyProvider.notifier).state = value;
          writeWritingResetStopwatchOnEmpty(
              ref.watch(writingResetStopwatchOnEmptyProvider));
          log(
            '${ref.watch(writingResetStopwatchOnEmptyProvider)}',
            name: 'SettingsWritingView:writingResetStopwatchOnEmpty',
          );
        },
      ),
    );
  }
}
