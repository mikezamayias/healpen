import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class AnalysisPage extends StatelessWidget {
  final NoteModel noteModel;

  const AnalysisPage({
    super.key,
    required this.noteModel,
  });

  @override
  Widget build(BuildContext context) {
    final Map<int, String> labels = {
      -1: 'Negative',
      0: 'Neutral',
      1: 'Positive',
    };
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomListTile(
            titleString: 'Sentiment',
            contentPadding: EdgeInsets.all(gap),
            subtitle: SelectableText(
              labels[noteModel.sentiment]!,
              style: context.theme.textTheme.bodyLarge!.copyWith(
                color: context.theme.colorScheme.onBackground,
              ),
            ),
          ),
          SizedBox(height: gap),
          Row(
            children: [
              Expanded(
                child: CustomListTile(
                  responsiveWidth: true,
                  contentPadding: EdgeInsets.all(gap),
                  titleString: 'Words',
                  subtitle: Text(
                    noteModel.wordCount.toString(),
                  ),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: CustomListTile(
                  responsiveWidth: true,
                  contentPadding: EdgeInsets.all(gap),
                  titleString: 'Sentences',
                  subtitle: Text(
                    noteModel.sentenceCount.toString(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
