import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../extensions/int_extensions.dart';
import '../../models/note/note_model.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';

class NoteView extends StatelessWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NoteModel noteModel =
        ModalRoute.of(context)!.settings.arguments as NoteModel;
    return BlueprintView(
      appBar: const AppBar(
        automaticallyImplyLeading: true,
        pathNames: ['Note'],
      ),
      body: Wrap(
        spacing: gap, // horizontal spacing between children
        runSpacing: gap, // vertical spacing between lines
        children: <Widget>[
          CustomListTile(
            titleString: 'Date and Time',
            responsiveWidth: true,
            contentPadding: EdgeInsets.all(gap),
            subtitle: SelectableText(
              noteModel.timestamp.timestampFormat(),
              style: context.theme.textTheme.bodyLarge!.copyWith(
                color: context.theme.colorScheme.onBackground,
              ),
            ),
          ),
          CustomListTile(
            responsiveWidth: true,
            contentPadding: EdgeInsets.all(gap),
            titleString: 'Duration',
            subtitle: Text(
              noteModel.duration.writingDurationFormat(),
            ),
          ),
          CustomListTile(
            responsiveWidth: true,
            contentPadding: EdgeInsets.all(gap),
            titleString: 'Private',
            subtitle: Center(
              child: FaIcon(
                noteModel.isPrivate
                    ? FontAwesomeIcons.lock
                    : FontAwesomeIcons.lockOpen,
                size: context.theme.textTheme.headlineSmall!.fontSize! +
                    context.theme.textTheme.headlineSmall!.height!,
                color: context.theme.colorScheme.onBackground,
              ),
            ),
          ),
          CustomListTile(
            responsiveWidth: true,
            contentPadding: EdgeInsets.all(gap),
            titleString: 'Word Count',
            subtitle: Text(
              noteModel.wordCount.toString(),
            ),
          ),
          CustomListTile(
            responsiveWidth: true,
            contentPadding: EdgeInsets.all(gap),
            titleString: 'Favorite',
            subtitle: Center(
              child: FaIcon(
                noteModel.isFavorite
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                size: context.theme.textTheme.headlineSmall!.fontSize! +
                    context.theme.textTheme.headlineSmall!.height!,
                color: context.theme.colorScheme.onBackground,
              ),
            ),
          ),
          CustomListTile(
            titleString: 'Content',
            contentPadding: EdgeInsets.all(gap),
            subtitle: SelectableText(
              noteModel.content,
              style: context.theme.textTheme.bodyLarge!.copyWith(
                color: context.theme.colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
