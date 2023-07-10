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
      titleString: entry.timestamp.timestampFormat(),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   entry.content,
          //   maxLines: 2,
          //   overflow: TextOverflow.ellipsis,
          //   style: context.theme.textTheme.bodyLarge!.copyWith(
          //     color: context.theme.colorScheme.onBackground,
          //   ),
          // ),
          Row(
            children: [
              NoteStatsTile(
                statsTitle: 'Duration',
                statsValue: entry.duration.writingDurationFormat(),
              ),
              NoteStatsTile(
                statsTitle: 'Words',
                statsValue: entry.content.split(' ').length.toString(),
              ),
            ],
          ),
        ],
      ),
      onTap: () => context.navigator.pushNamed(
        '/note',
        arguments: entry,
      ),
    );
  }
}
