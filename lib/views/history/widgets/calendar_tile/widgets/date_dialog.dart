import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../models/analysis/analysis_model.dart';
import '../../../../../models/note/note_model.dart';
import '../../../../../providers/settings_providers.dart';
import '../../../../../services/note_analysis_service.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/custom_list_tile.dart';
import '../../note_tile.dart';

class DateDialog extends ConsumerWidget {
  final DateTime date;
  const DateDialog({super.key, required this.date});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<NoteModel>>(
      stream: NoteAnalysisService().getNoteEntriesListOnDate(date),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<NoteModel>> noteListStreamSnapshot,
      ) {
        return StreamBuilder<List<AnalysisModel>>(
          stream: NoteAnalysisService().getAnalysisEntriesListOnDate(date),
          builder: (context, analysisListStreamSnapshot) {
            List<Widget> widgets = [
              if (noteListStreamSnapshot.hasData)
                for (int i = 0; i < noteListStreamSnapshot.data!.length; i++)
                  if (analysisListStreamSnapshot.hasData &&
                      analysisListStreamSnapshot.data!.isNotEmpty)
                    NoteTile(
                      noteModel: noteListStreamSnapshot.data!.elementAt(i),
                      analysisModel:
                          analysisListStreamSnapshot.data!.elementAt(i),
                    )
                  else
                    NoteTile(
                      noteModel: noteListStreamSnapshot.data!.elementAt(i),
                    )
            ];
            return Padding(
              padding: EdgeInsets.all(gap),
              child: AnimatedCrossFade(
                duration: emphasizedDuration,
                reverseDuration: emphasizedDuration,
                sizeCurve: emphasizedCurve,
                firstCurve: emphasizedCurve,
                secondCurve: emphasizedCurve,
                firstChild: SizedBox(
                  height: 42.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius - gap),
                    child: AnimatedCrossFade(
                      firstChild: AnimatedCrossFade(
                        firstChild: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              widgets[index].animate().fade(
                                    duration: standardDuration,
                                    curve: standardCurve,
                                  ),
                          separatorBuilder: (_, __) => SizedBox(height: gap),
                          itemCount: widgets.length,
                        ),
                        secondChild: AnimatedCrossFade(
                          firstChild: CustomListTile(
                            titleString: 'Loading notes',
                            cornerRadius: radius - gap,
                          ),
                          secondChild: CustomListTile(
                            titleString: 'You are offline',
                            cornerRadius: radius - gap,
                            leadingIconData: FontAwesomeIcons.globe,
                            backgroundColor: context.theme.colorScheme.error,
                            textColor: context.theme.colorScheme.onError,
                          ),
                          crossFadeState: switch (
                              ref.watch(isDeviceConnectedProvider)) {
                            true => CrossFadeState.showFirst,
                            false => CrossFadeState.showSecond
                          },
                          duration: standardDuration,
                          reverseDuration: standardDuration,
                          sizeCurve: standardCurve,
                          firstCurve: standardCurve,
                          secondCurve: standardCurve,
                        ),
                        crossFadeState: switch (widgets.isNotEmpty) {
                          true => CrossFadeState.showFirst,
                          false => CrossFadeState.showSecond,
                        },
                        duration: standardDuration,
                        reverseDuration: standardDuration,
                        sizeCurve: standardCurve,
                        firstCurve: standardCurve,
                        secondCurve: standardCurve,
                      ),
                      secondChild: CustomListTile(
                        titleString: 'No notes',
                        cornerRadius: radius - gap,
                        backgroundColor:
                            context.theme.colorScheme.surfaceVariant,
                        textColor: context.theme.colorScheme.onSurfaceVariant,
                      ),
                      crossFadeState: switch (noteListStreamSnapshot.hasData) {
                        true => CrossFadeState.showFirst,
                        false => CrossFadeState.showSecond,
                      },
                      duration: standardDuration,
                      reverseDuration: standardDuration,
                      sizeCurve: standardCurve,
                      firstCurve: standardCurve,
                      secondCurve: standardCurve,
                    ),
                  ),
                ).animate().fade(
                      duration: emphasizedDuration,
                      curve: emphasizedCurve,
                    ),
                secondChild: CustomListTile(
                  titleString: 'No notes',
                  cornerRadius: radius - gap,
                  backgroundColor: context.theme.colorScheme.surfaceVariant,
                  textColor: context.theme.colorScheme.onSurfaceVariant,
                ).animate().fade(
                      duration: emphasizedDuration,
                      curve: emphasizedCurve,
                    ),
                crossFadeState: noteListStreamSnapshot.connectionState ==
                        ConnectionState.active
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            );
          },
        );
      },
    );
  }
}
