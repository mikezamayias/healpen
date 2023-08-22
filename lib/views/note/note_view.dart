import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_animate/flutter_animate.dart';
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
    const String model = 'text-davinci-003';
    final List<String> labels = [
      'Very Unpleasant',
      'Unpleasant',
      'Slightly Unpleasant',
      'Neutral',
      'Slightly Pleasant',
      'Pleasant',
      'Very Pleasant'
    ];
    return BlueprintView(
      appBar: const AppBar(
        automaticallyImplyLeading: true,
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
                  noteModel.wordCount.toString(),
                ),
              ),
              SizedBox(width: gap),
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
          SizedBox(height: gap),
          FutureBuilder(
            future: OpenAI.instance.completion.create(
              model: model,
              prompt: buildPrompt(noteModel, labels),
              temperature: 0,
              maxTokens: 60,
              topP: 1,
              frequencyPenalty: 0.5,
              presencePenalty: 0,
              n: 1,
              stop: 'Label:',
              echo: true,
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<OpenAICompletionModel>
                  openAICompletionModelSnapshot,
            ) {
              String sentiment = '';
              if (openAICompletionModelSnapshot.connectionState ==
                  ConnectionState.done) {
                sentiment = openAICompletionModelSnapshot
                    .data!.choices.first.text
                    .split('Label:')
                    .last
                    .trim();
                return CustomListTile(
                  titleString: 'Sentiment',
                  contentPadding: EdgeInsets.all(gap),
                  subtitle: SelectableText(
                    sentiment,
                    style: context.theme.textTheme.bodyLarge!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                ).animate().fade().shimmer();
              } else {
                return CustomListTile(
                  titleString: 'Sentiment',
                  contentPadding: EdgeInsets.all(gap),
                  subtitle: SelectableText(
                    sentiment,
                    style: context.theme.textTheme.bodyLarge!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                ).animate().fade().shimmer();
              }
            },
          ),
        ],
      ),
    );
  }

  String buildPrompt(NoteModel noteModel, List<String> labels) => '''
Label the following text as ${labels.join(', ')}.\n
Text:${noteModel.content}\n
Label:''';
}
