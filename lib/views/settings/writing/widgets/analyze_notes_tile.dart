import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';

final isAnalysisCompleteProvider = StateProvider<bool>((ref) => false);

class AnalyzeNotesTile extends ConsumerStatefulWidget {
  const AnalyzeNotesTile({Key? key}) : super(key: key);

  @override
  ConsumerState<AnalyzeNotesTile> createState() => _AnalyzeNotesTileState();
}

class _AnalyzeNotesTileState extends ConsumerState<AnalyzeNotesTile> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> removePreviousAnalysis() async {
    // Simulated delay for demonstration purposes
    await Future.delayed(2.seconds, () {
      _pageController.nextPage(
        duration: longEmphasizedDuration,
        curve: emphasizedCurve,
      );
    });
    return;
  }

  Future<void> analyzeNotes() async {
    // Simulated delay for demonstration purposes
    await Future.delayed(2.seconds, () {
      _pageController.nextPage(
        duration: longEmphasizedDuration,
        curve: emphasizedCurve,
      );
    });
    ref.watch(isAnalysisCompleteProvider.notifier).state = true;
    return;
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Analyze notes',
      subtitle: const Text(
        'Update analysis of existing notes and analyze new ones.',
      ),
      onTap: () {
        vibrate(
          ref.watch(navigationReduceHapticFeedbackProvider),
          () async {
            List<CustomListTile> children = [
              // remove previous analysis
              CustomListTile(
                cornerRadius: radius - gap,
                contentPadding: EdgeInsets.all(gap),
                titleString: 'Removing previous analysis...',
                subtitleString:
                    'This may take a while depending on the number of notes.',
                leading: const CircularProgressIndicator(),
              ),
              // analyze notes
              CustomListTile(
                cornerRadius: radius - gap,
                contentPadding: EdgeInsets.all(gap),
                titleString: 'Analyzing notes...',
                subtitleString:
                    'This may take a while depending on the number of notes.',
                leading: const CircularProgressIndicator(),
              ),
              // completed
              CustomListTile(
                cornerRadius: radius - gap,
                contentPadding: EdgeInsets.all(gap),
                titleString: 'Completed',
                subtitleString: 'All notes have been analyzed.',
                leadingIconData: FontAwesomeIcons.check,
              ),
            ];
            ref.watch(isAnalysisCompleteProvider.notifier).state = false;
            showHealpenDialog(
              context: context,
              doVibrate: ref.watch(navigationReduceHapticFeedbackProvider),
              customDialog: CustomDialog(
                enableContentContainer: false,
                titleString: 'Analyzing notes',
                contentWidget: SizedBox(
                  height: 18.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius - gap),
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: children
                          .map(
                            (child) => Padding(
                              padding: EdgeInsets.all(gap),
                              child: child,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                actions: [
                  CustomListTile(
                    responsiveWidth: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                    cornerRadius: radius - gap,
                    titleString: 'Close',
                    onTap: ref.watch(isAnalysisCompleteProvider)
                        ? navigator.pop
                        : null,
                  ),
                ],
              ),
            );
            // // Make sure there is no sentiment values in the notes.
            // _startProgress();
            await removePreviousAnalysis();
            await analyzeNotes();
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
