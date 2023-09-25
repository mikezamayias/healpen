import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';

class AnalyzeNotesTile extends ConsumerStatefulWidget {
  const AnalyzeNotesTile({Key? key}) : super(key: key);

  @override
  ConsumerState<AnalyzeNotesTile> createState() => _AnalyzeNotesTileState();
}

class _AnalyzeNotesTileState extends ConsumerState<AnalyzeNotesTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Analyze notes',
      subtitle: const Text(
        'Analyzes old notes that have not been analyzed yet and updates the analysis of analyzed notes.',
      ),
      onTap: () {
        vibrate(
          ref.watch(navigationReduceHapticFeedbackProvider),
          () async {
            showHealpenDialog(
              context: context,
              doVibrate: ref.watch(navigationReduceHapticFeedbackProvider),
              customDialog: const CustomDialog(
                titleString: 'Removing previous analysis',
              ),
            );
            // // Make sure there is no sentiment values in the notes.
            // _startProgress();
          },
        );
      },
    );
  }

// _startProgress() async {
//   setState(() {
//     _progress = 0;
//   });
//   QuerySnapshot<Map<String, dynamic>> collection =
//       await FirestoreService.writingCollectionReference()
//           .where('isPrivate', isEqualTo: false)
//           .get();
//   int total = collection.docs.length;
//   int count = 0;
//   for (QueryDocumentSnapshot<Map<String, dynamic>> element
//       in collection.docs) {
//     // Make sure there is no sentiment values in the notes.
//     WritingController().removeSentimentFromDocument(element);
//     count++;
//     setState(() {
//       _progress = count / total;
//     });
//   }
// }
}
