import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../extensions/int_extensions.dart';
import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import 'note_stats_title.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.entry,
  });

  final NoteModel entry;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      backgroundColor: context.theme.colorScheme.surface,
      textColor: context.theme.colorScheme.onSurface,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            entry.timestamp.timestampFormat(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.titleLarge!.copyWith(
              color: context.theme.colorScheme.onSurface,
            ),
          ),
          Text(
            entry.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.titleSmall!.copyWith(
              color: context.theme.colorScheme.onSurface,
            ),
          ),
          NoteStatsTile(
            statsTitle: 'Duration',
            statsValue: entry.duration.writingDurationFormat(),
          ),
          NoteStatsTile(
            statsTitle: 'Word Count',
            statsValue: entry.wordCount.toString(),
          ),
        ],
      ),
      // leadingIconData:
      //     entry.isPrivate ? FontAwesomeIcons.lock : FontAwesomeIcons.lockOpen,
      onTap: () => context.navigator.pushNamed(
        '/note',
        arguments: entry,
      ),
    );
  }
}
