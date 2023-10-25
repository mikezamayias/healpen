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
        child: SingleChildScrollView(
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
                      subtitleString: DateFormat('MMM dd, yyyy - HH:mm')
                          // subtitleString: DateFormat('MMM dd, yyyy - hh:mm a')
                          .format(noteModel.timestamp.timestampToDateTime()),
                    ),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: CustomListTile(
                      responsiveWidth: true,
                      contentPadding: EdgeInsets.all(gap),
                      titleString: 'Duration',
                      subtitleString:
                          noteModel.duration.writingDurationFormat(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: gap),
              CustomListTile(
                titleString: 'Content',
                contentPadding: EdgeInsets.all(gap),
                subtitleString: noteModel.content,
                selectableText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
