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
    final noteModel = ModalRoute.of(context)!.settings.arguments as NoteModel;
    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Note'],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
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
            ],
          ),
          SizedBox(height: gap),
          Row(
            children: [
              Expanded(
                child: CustomListTile(
                  responsiveWidth: true,
                  contentPadding: EdgeInsets.all(gap),
                  titleString: 'Duration',
                  subtitle: Text(
                    noteModel.duration.writingDurationFormat(),
                    // noteModel.timestamp.timestampFormat()
                  ),
                ),
              ),
              SizedBox(width: gap),
              CustomListTile(
                responsiveWidth: true,
                contentPadding: EdgeInsets.all(gap),
                titleString: 'Word Count',
                subtitle: Text(
                  noteModel.content.split(' ').length.toString(),
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
