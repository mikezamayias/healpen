import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../widgets/to_be_implemented_tile.dart';

class DateDialog extends ConsumerWidget {
  const DateDialog({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return StreamBuilder<List<AnalysisModel>>(
    //   stream: NoteAnalysisService().getAnalysisEntriesListOnDate(date),
    //   builder: (context, analysisListStreamSnapshot) {
    //     List<Widget> widgets = [
    //       if (noteListStreamSnapshot.hasData)
    //         for (int i = 0; i < noteListStreamSnapshot.data!.length; i++)
    //           if (analysisListStreamSnapshot.hasData &&
    //               analysisListStreamSnapshot.data!.isNotEmpty)
    //             NoteTile(
    //               noteModel: noteListStreamSnapshot.data!.elementAt(i),
    //               analysisModel:
    //                   analysisListStreamSnapshot.data!.elementAt(i),
    //             )
    //           else
    //             NoteTile(
    //               noteModel: noteListStreamSnapshot.data!.elementAt(i),
    //             )
    //     ];
    //     return Padding(
    //       padding: EdgeInsets.all(gap),
    //       child: AnimatedCrossFade(
    //         duration: emphasizedDuration,
    //         reverseDuration: emphasizedDuration,
    //         sizeCurve: emphasizedCurve,
    //         firstCurve: emphasizedCurve,
    //         secondCurve: emphasizedCurve,
    //         firstChild: SizedBox(
    //           height: 42.h,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(radius - gap),
    //             child: AnimatedCrossFade(
    //               firstChild: AnimatedCrossFade(
    //                 firstChild: ListView.separated(
    //                   shrinkWrap: true,
    //                   itemBuilder: (BuildContext context, int index) =>
    //                       widgets[index].animate().fade(
    //                             duration: standardDuration,
    //                             curve: standardCurve,
    //                           ),
    //                   separatorBuilder: (_, __) => SizedBox(height: gap),
    //                   itemCount: widgets.length,
    //                 ),
    //                 secondChild: AnimatedCrossFade(
    //                   firstChild: CustomListTile(
    //                     titleString: 'Loading notes',
    //                     cornerRadius: radius - gap,
    //                   ),
    //                   secondChild: CustomListTile(
    //                     titleString: 'You are offline',
    //                     cornerRadius: radius - gap,
    //                     leadingIconData: FontAwesomeIcons.globe,
    //                     backgroundColor: context.theme.colorScheme.error,
    //                     textColor: context.theme.colorScheme.onError,
    //                   ),
    //                   crossFadeState: switch (
    //                       ref.watch(isDeviceConnectedProvider)) {
    //                     true => CrossFadeState.showFirst,
    //                     false => CrossFadeState.showSecond
    //                   },
    //                   duration: standardDuration,
    //                   reverseDuration: standardDuration,
    //                   sizeCurve: standardCurve,
    //                   firstCurve: standardCurve,
    //                   secondCurve: standardCurve,
    //                 ),
    //                 crossFadeState: switch (widgets.isNotEmpty) {
    //                   true => CrossFadeState.showFirst,
    //                   false => CrossFadeState.showSecond,
    //                 },
    //                 duration: standardDuration,
    //                 reverseDuration: standardDuration,
    //                 sizeCurve: standardCurve,
    //                 firstCurve: standardCurve,
    //                 secondCurve: standardCurve,
    //               ),
    //               secondChild: CustomListTile(
    //                 titleString: 'No notes',
    //                 cornerRadius: radius - gap,
    //                 backgroundColor:
    //                     context.theme.colorScheme.surfaceVariant,
    //                 textColor: context.theme.colorScheme.onSurfaceVariant,
    //               ),
    //               crossFadeState: switch (noteListStreamSnapshot.hasData) {
    //                 true => CrossFadeState.showFirst,
    //                 false => CrossFadeState.showSecond,
    //               },
    //               duration: standardDuration,
    //               reverseDuration: standardDuration,
    //               sizeCurve: standardCurve,
    //               firstCurve: standardCurve,
    //               secondCurve: standardCurve,
    //             ),
    //           ),
    //         ).animate().fade(
    //               duration: emphasizedDuration,
    //               curve: emphasizedCurve,
    //             ),
    //         secondChild: CustomListTile(
    //           titleString: 'No notes',
    //           cornerRadius: radius - gap,
    //           backgroundColor: context.theme.colorScheme.surfaceVariant,
    //           textColor: context.theme.colorScheme.onSurfaceVariant,
    //         ).animate().fade(
    //               duration: emphasizedDuration,
    //               curve: emphasizedCurve,
    //             ),
    //         crossFadeState: noteListStreamSnapshot.connectionState ==
    //                 ConnectionState.active
    //             ? CrossFadeState.showFirst
    //             : CrossFadeState.showSecond,
    //       ),
    //     );
    //   },
    // );
    return const ToBeImplementedTile();
    // return FirestorePagination(
    //   query: FirestoreService().analysisCollectionReference().orderBy(
    //         'timestamp',
    //         descending: true,
    //       ),
    //   itemBuilder: (
    //     BuildContext context,
    //     DocumentSnapshot snapshot,
    //     int index,
    //   ) {
    //     final analysisModel = snapshot.data() as AnalysisModel;
    //     return Column(
    //       children: [
    //         CustomListTile(
    //           titleString: DateFormat('EEEE, d MMMM').format(
    //             DateTime.fromMillisecondsSinceEpoch(
    //               analysisModel.timestamp,
    //             ),
    //           ),
    //           subtitleString: analysisModel.content,
    //           trailing: Text(
    //             analysisModel.score.toString(),
    //             style: context.theme.textTheme.titleLarge!.copyWith(
    //               color: switch (analysisModel.score) {
    //                 > 0 => context.theme.colorScheme.primary,
    //                 < 0 => context.theme.colorScheme.error,
    //                 _ => context.theme.colorScheme.onSurfaceVariant,
    //               },
    //             ),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
