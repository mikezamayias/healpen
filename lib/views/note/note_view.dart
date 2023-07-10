import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

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
      appBar: AppBar(
        pathNames: [noteModel.timestamp.timestampFormat()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: CustomListTile(
                  contentPadding: EdgeInsets.all(gap),
                  titleString: 'Duration',
                  subtitle: Text(
                    noteModel.duration.writingDurationFormat(),
                  ),
                ),
              ),
              SizedBox(width: gap),
              Flexible(
                child: CustomListTile(
                  contentPadding: EdgeInsets.all(gap),
                  titleString: 'Word Count',
                  subtitle: Text(
                    noteModel.content.split(' ').length.toString(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: gap),
          Expanded(
            child: CustomListTile(
              titleString: 'Content',
              contentPadding: EdgeInsets.all(gap),
              subtitle: SelectableText(
                noteModel.content,
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  color: context.theme.colorScheme.onBackground,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
