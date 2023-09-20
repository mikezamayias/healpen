import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../models/note/note_model.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../../utils/show_healpen_dialog.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      showAppBarTitle: ref.watch(navigationShowAppBarTitle),
      appBar: const AppBar(
        pathNames: ['Your writing insights'],
      ),
      body: StreamBuilder(
        stream: AnalysisViewController().metricGroupingsStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<NoteModel>> metricGroupingsSnapshot,
        ) {
          if (metricGroupingsSnapshot.hasError) {
            return Center(
              child: CustomListTile(
                titleString: 'Something went wrong',
                backgroundColor: context.theme.colorScheme.error,
                textColor: context.theme.colorScheme.onError,
                subtitle:
                    SelectableText(metricGroupingsSnapshot.error.toString()),
              ),
            );
          }
          if (metricGroupingsSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const LoadingTile(durationTitle: 'Loading metrics');
          }
          if (metricGroupingsSnapshot.data!.isNotEmpty) {
            /// show the sentiment value of each note
            // return ListView.separated(
            //   itemCount: metricGroupingsSnapshot.data!.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return CustomListTile(
            //       titleString: 'Sentiment value',
            //       leadingIconData: FontAwesomeIcons.solidChartBar,
            //       trailing: Text(
            //         metricGroupingsSnapshot.data![index],
            //         style: context.theme.textTheme.bodyLarge,
            //       ),
            //     );
            //   },
            //   separatorBuilder: (_, __) => SizedBox(height: gap),
            // );
            /// calculate the average sentiment value of all notes
            /// and show it as a single tile
            double averageSentimentValue = 0.0;
            for (NoteModel note in metricGroupingsSnapshot.data!) {
              averageSentimentValue += note.sentiment!;
            }
            averageSentimentValue /= metricGroupingsSnapshot.data!.length;
            return Column(
              children: [
                CustomListTile(
                  contentPadding: EdgeInsets.all(gap),
                  titleString: 'Average overall sentiment',
                  subtitle: Padding(
                    padding: EdgeInsets.only(bottom: gap),
                    child: SfSlider(
                      min: sentimentValues.min,
                      max: sentimentValues.max,
                      value: averageSentimentValue,
                      interval: 1,
                      showTicks: true,
                      showLabels: true,
                      showDividers: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 0,
                      shouldAlwaysShowTooltip: false,
                      // labelFormatterCallback: (actualValue, formattedText) {
                      //   return sentimentLabels[int.parse(formattedText) + 3];
                      // },
                      tooltipTextFormatterCallback: (actualValue,
                              formattedText) =>
                          sentimentLabels[averageSentimentValue.toInt() + 3],
                      labelPlacement: LabelPlacement.onTicks,
                      onChanged: (dynamic value) {
                        vibrate(
                          ref.watch(navigationReduceHapticFeedbackProvider),
                          () {},
                        );
                      },
                    ),
                  ),
                  leadingIconData: FontAwesomeIcons.circleInfo,
                  leadingOnTap: () {
                    /// explain to the user what they are seeing
                    showHealpenDialog(
                      context: context,
                      doVibrate:
                          ref.watch(navigationReduceHapticFeedbackProvider),
                      customDialog: const CustomDialog(
                        titleString: 'What is this?',
                        contentString:
                            'This is the average sentiment value of all '
                            'your notes. It is calculated by adding up the '
                            'sentiment value of each note and dividing it by the '
                            'number of notes you have written.',
                      ),
                    );
                  },
                  trailing: Text(
                    averageSentimentValue.toStringAsFixed(2),
                    style: context.theme.textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: gap),
              ],
            );
          } else {
            return const CustomListTile(
              titleString: 'No metrics yet',
              subtitleString: 'Start writing to see your metrics!',
              leadingIconData: FontAwesomeIcons.solidChartBar,
            );
          }
        },
      ),
    );
  }
}
