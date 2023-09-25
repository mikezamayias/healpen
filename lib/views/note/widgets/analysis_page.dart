import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/note/note_model.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/text_divider.dart';

class AnalysisPage extends StatelessWidget {
  final NoteModel noteModel;

  const AnalysisPage({
    super.key,
    required this.noteModel,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      'Very Unpleasant',
      'Unpleasant',
      'Slightly Unpleasant',
      'Neutral',
      'Slightly Pleasant',
      'Pleasant',
      'Very Pleasant'
    ];
    final values = [-3, -2, -1, 0, 1, 2, 3];
    final Map<int, String> sentimentLabels = {
      for (var i = 0; i < labels.length; i++) values[i]: labels[i]
    };
    final Map<int, IconData> sentimentIcons = {
      -3: FontAwesomeIcons.faceSadTear,
      -2: FontAwesomeIcons.faceFrown,
      -1: FontAwesomeIcons.faceFrownOpen,
      0: FontAwesomeIcons.faceMeh,
      1: FontAwesomeIcons.faceSmile,
      2: FontAwesomeIcons.faceLaugh,
      3: FontAwesomeIcons.faceLaughBeam,
    };
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: gap),
            child: const TextDivider('Analysis'),
          ),
          CustomListTile(
            titleString: 'Sentiment',
            contentPadding: EdgeInsets.all(gap),
            subtitle: SelectableText(
              // sentimentLabels[noteModel.sentiment]!,
              sentimentLabels[noteModel.timestamp]!,
              style: context.theme.textTheme.bodyLarge!.copyWith(
                color: context.theme.colorScheme.onBackground,
              ),
            ),
            // trailingIconData: sentimentIcons[noteModel.sentiment],
            trailing: FaIcon(
              // sentimentIcons[noteModel.sentiment],
              sentimentIcons[noteModel.timestamp],
              color: context.theme.colorScheme.onBackground,
              size: radius * 2,
            ),
            leadingIconData: FontAwesomeIcons.circleInfo,
            leadingOnTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor:
                    context.theme.colorScheme.background.withOpacity(0.8),
                builder: (BuildContext context) => CustomDialog(
                  titleString: 'Sentiment',
                  // explain what's sentiment, how it's calculated, and
                  // what's the range (negative, neutral, positive)
                  // https://chat.openai.com/c/53e97b3f-9812-4c68-81bf-f307cd8b8166
                  contentString: '''
Sentiment is a metric that indicates the overall emotional tone of the text. It ranges from -3 to 3, where -3 is the most negative and 3 is the most positive.''',
                  actions: [
                    CustomListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                      cornerRadius: radius - gap,
                      responsiveWidth: true,
                      titleString: 'Okay',
                      onTap: context.navigator.pop,
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(height: gap),
          Row(
            children: [
              CustomListTile(
                responsiveWidth: true,
                contentPadding: EdgeInsets.all(gap),
                titleString: 'Words',
                subtitle: Text(
                  noteModel.wordCount.toString(),
                ),
                leadingIconData: FontAwesomeIcons.circleInfo,
                leadingOnTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor:
                        context.theme.colorScheme.background.withOpacity(0.8),
                    builder: (BuildContext context) => CustomDialog(
                      titleString: 'Words',
                      // explain what's words, how it's calculated, and
                      // what's the range (negative, neutral, positive)
                      contentString: 'The "Words" metric indicates the text'
                          'word count.\n\n'
                          'Word count is calculated by the number of '
                          'words in the text.',
                      actions: [
                        CustomListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: gap * 2),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          titleString: 'Okay',
                          onTap: context.navigator.pop,
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
