import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../extensions/int_extensions.dart';
import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

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
                    titleString: 'Date and Time',
                    responsiveWidth: true,
                    contentPadding: EdgeInsets.all(gap),
                    explanationString: DateFormat('MMM dd, yyyy - HH:mm')
                        // subtitleString: DateFormat('MMM dd, yyyy - hh:mm a')
                        .format(noteModel.timestamp.timestampToDateTime()),
                    enableExplanationWrapper: true,
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: CustomListTile(
                    responsiveWidth: true,
                    contentPadding: EdgeInsets.all(gap),
                    titleString: 'Duration',
                    explanationString:
                        noteModel.duration.writingDurationFormat(),
                    enableExplanationWrapper: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: gap),
            CustomListTile(
              titleString: 'Content',
              contentPadding: EdgeInsets.all(gap),
              explanationString: noteModel.content,
              enableExplanationWrapper: true,
            ),
          ],
        ),
      ),
    );
  }
}
