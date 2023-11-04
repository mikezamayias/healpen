import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../extensions/int_extensions.dart';
import '../../../models/note/note_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class DetailsPage extends ConsumerWidget {
  final NoteModel noteModel;

  const DetailsPage({
    super.key,
    required this.noteModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomListTile(
                    useSmallerNavigationSetting:
                        !ref.watch(navigationSmallerNavigationElementsProvider),
                    enableExplanationWrapper:
                        !ref.watch(navigationSmallerNavigationElementsProvider),
                    titleString: 'Date and Time',
                    responsiveWidth: true,
                    explanationString: DateFormat('MMM dd, yyyy - HH:mm')
                        // subtitleString: DateFormat('MMM dd, yyyy - hh:mm a')
                        .format(noteModel.timestamp.timestampToDateTime()),
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: CustomListTile(
                    useSmallerNavigationSetting:
                        !ref.watch(navigationSmallerNavigationElementsProvider),
                    enableExplanationWrapper:
                        !ref.watch(navigationSmallerNavigationElementsProvider),
                    responsiveWidth: true,
                    titleString: 'Duration',
                    explanationString:
                        noteModel.duration.writingDurationFormat(),
                  ),
                ),
              ],
            ),
            SizedBox(height: gap),
            CustomListTile(
              useSmallerNavigationSetting:
                  !ref.watch(navigationSmallerNavigationElementsProvider),
              enableExplanationWrapper:
                  !ref.watch(navigationSmallerNavigationElementsProvider),
              titleString: 'Content',
              explanationString: noteModel.content,
            ),
          ],
        ),
      ),
    );
  }
}
