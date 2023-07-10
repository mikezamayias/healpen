import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      title: Text(
        entry.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.theme.textTheme.bodyLarge!.copyWith(
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
      subtitle: Wrap(
        runSpacing: 0,
        spacing: gap,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          NoteStatsTile(
            statsTitle: 'Date',
            statsValue: entry.timestamp.timestampFormat(),
          ),
          NoteStatsTile(
            statsTitle: 'Words',
            statsValue: entry.content.split(' ').length.toString(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Private',
                style: context.theme.textTheme.bodyMedium!.copyWith(
                  color: context.theme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: gap / 2),
              FaIcon(
                entry.isPrivate
                    ? FontAwesomeIcons.lock
                    : FontAwesomeIcons.lockOpen,
                size: context.theme.textTheme.bodyMedium!.fontSize,
                color: context.theme.colorScheme.onBackground,
              ),
            ],
          ),
          NoteStatsTile(
            statsTitle: 'Duration',
            statsValue: entry.duration.writingDurationFormat(),
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
