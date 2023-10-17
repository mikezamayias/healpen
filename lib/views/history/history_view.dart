import 'package:flutter/material.dart' hide AppBar, Divider, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/emotional_echo_controller.dart';
import '../../controllers/healpen/healpen_controller.dart';
import '../../controllers/history_view_controller.dart';
import '../../models/note/note_model.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/calendar_tile.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      showAppBarTitle: ref.watch(navigationShowAppBarTitleProvider),
      appBar: const AppBar(
        pathNames: [
          'Your past notes',
        ],
      ),
      body: StreamBuilder(
        stream: HistoryViewController().notesStream,
        initialData: const <NoteModel>[],
        builder: (
          BuildContext context,
          AsyncSnapshot<List<NoteModel>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingTile(durationTitle: 'Loading notes');
          } else {
            if (snapshot.hasError) {
              return Center(
                child: CustomListTile(
                  titleString: 'Something went wrong',
                  backgroundColor: context.theme.colorScheme.error,
                  textColor: context.theme.colorScheme.onError,
                  subtitle: SelectableText(snapshot.error.toString()),
                ),
              );
            }
            if (snapshot.data!.isNotEmpty) {
              HistoryViewController.noteModels = snapshot.data!;
              List<String> numScale = [
                ...sentimentLabels.map(
                  (String label) {
                    return '${sentimentValues[sentimentLabels.indexOf(label)]}';
                  },
                )
              ];
              List<String> labelScale = [
                for (int i = 0; i < sentimentLabels.length; i++)
                  if (i == 0 || i == sentimentLabels.length - 1)
                    sentimentLabels[i]
              ];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: context.theme.colorScheme.surfaceVariant,
                ),
                padding: EdgeInsets.all(gap),
                child: Column(
                  children: [
                    Expanded(
                      child: CalendarTile(
                        noteModels: HistoryViewController.notesToAnalyze,
                      ),
                    ),
                    Gap(gap),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius - gap),
                        color: context.theme.colorScheme.surface,
                      ),
                      padding: EdgeInsets.all(gap),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(gap),
                            height: gap,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  EmotionalEchoController.goodColor,
                                  EmotionalEchoController.badColor,
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: numScale.map(
                              (String label) {
                                return Text(
                                  label,
                                  style: context.theme.textTheme.bodyMedium!
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: getSentimentShapeColor(
                                      numScale.indexOf(label),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: labelScale.map(
                              (String label) {
                                return Text(
                                  label,
                                  style: context.theme.textTheme.bodyMedium!
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: getSentimentShapeColor(
                                      labelScale.indexOf(label),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  CustomListTile(
                    titleString: 'No notes yet',
                    contentPadding: EdgeInsets.all(gap),
                    subtitle:
                        const Text('Start writing to see your notes here'),
                    onTap: () => ref
                        .read(HealpenController()
                            .currentPageIndexProvider
                            .notifier)
                        .state = 0,
                    leadingIconData: FontAwesomeIcons.pencil,
                    showcaseLeadingIcon: true,
                  ),
                  const Spacer(),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
