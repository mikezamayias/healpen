import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../extensions/int_extensions.dart';
import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/text_divider.dart';

class DetailsPage extends StatelessWidget {
  final NoteModel noteModel;

  const DetailsPage({
    super.key,
    required this.noteModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: gap),
            child: const TextDivider('Details'),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomListTile(
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
              ),
              SizedBox(width: gap),
              Expanded(
                child: CustomListTile(
                  responsiveWidth: true,
                  contentPadding: EdgeInsets.all(gap),
                  titleString: 'Duration',
                  subtitle: Text(
                    noteModel.duration.writingDurationFormat(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: gap),
          Row(
            children: [
              Expanded(
                child: CustomListTile(
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
              ),
              SizedBox(width: gap),
              Expanded(
                child: CustomListTile(
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
              ),
            ],
          ),
          SizedBox(height: gap),
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
