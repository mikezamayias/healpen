import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../blueprint/blueprint_view.dart';

class SettingsWritingView extends ConsumerStatefulWidget {
  const SettingsWritingView({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsWritingView> createState() =>
      _SettingsAccountViewState();
}

class _SettingsAccountViewState extends ConsumerState<SettingsWritingView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pageWidgets = [
      CustomListTile(
        contentPadding: EdgeInsets.all(gap),
        titleString: 'Automatic stopwatch control',
        subtitle: const Text(
          'Pauses the stopwatch when you stop typing and resets it when you clear all text.',
        ),
        trailing: Switch(
          value: ref.watch(writingResetStopwatchOnEmptyProvider),
          onChanged: (value) async {
            ref.read(writingResetStopwatchOnEmptyProvider.notifier).state =
                value;
            writeWritingResetStopwatchOnEmpty(
                ref.watch(writingResetStopwatchOnEmptyProvider));
            log(
              '${ref.watch(writingResetStopwatchOnEmptyProvider)}',
              name: 'SettingsWritingView:writingResetStopwatchOnEmpty',
            );
          },
        ),
      ),
    ];

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Settings', 'Writing'],
      ),
      body: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: pageWidgets,
      ),
    );
  }
}
