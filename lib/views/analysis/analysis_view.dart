import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> tabTitles = ['Mood Explorer', 'Writing Patterns'];
    return BlueprintView(
      appBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: gap),
        child: const AppBar(
          pathNames: ['Your writing insights'],
        ),
      ),
      body: Column(
        children: [
          CustomListTile(
            titleString: tabTitles.first,
            subtitle: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text('hello world'),
                ),
              ],
            ),
          ),
          SizedBox(height: gap),
          CustomListTile(
            titleString: tabTitles.last,
            subtitle: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text('hello world'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
