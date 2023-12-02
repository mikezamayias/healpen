import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';
import '../utils/constants.dart';
import '../views/settings/writing/widgets/analyze_notes_tile.dart';
import 'custom_list_tile.dart';

class NoAnalysisFoundTile extends ConsumerWidget {
  const NoAnalysisFoundTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomListTile(
          useSmallerNavigationSetting:
              !ref.watch(navigationSmallerNavigationElementsProvider),
          enableExplanationWrapper:
              !ref.watch(navigationSmallerNavigationElementsProvider),
          enableSubtitleWrapper: true,
          titleString: 'No data found',
          explanationString:
              'You don\'t have any insights yet. Try writing a few notes '
              'to get started or tap the \'Update note analysis\' '
              'button.',
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: gap),
          child: const AnalyzeNotesTile(),
        ),
      ],
    );
  }
}
