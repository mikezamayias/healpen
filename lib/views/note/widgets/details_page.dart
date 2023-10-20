import 'package:flutter/material.dart';

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SingleChildScrollView(
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
                      subtitleString: noteModel.timestamp.timestampFormat(),
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
