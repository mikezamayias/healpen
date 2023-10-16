import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/settings/preferences_controller.dart';
import '../../models/analysis/analysis_model.dart';
import '../../models/note/note_model.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/analysis_page.dart';
import 'widgets/details_page.dart';

class NoteView extends ConsumerStatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  ConsumerState<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends ConsumerState<NoteView> {
  late PageController controller;
  final segments = ['details', 'analysis'];
  int selectedPage = 0;

  @override
  void initState() {
    controller = PageController(initialPage: selectedPage);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ({
      NoteModel noteModel,
      AnalysisModel analysisModel
    });
    final NoteModel noteModel = args.noteModel;
    final AnalysisModel analysisModel = args.analysisModel;
    final showAnalysis = !noteModel.isPrivate;
    return BlueprintView(
      appBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: gap),
        child: const AppBar(
          automaticallyImplyLeading: true,
          pathNames: ['Note'],
        ),
      ),
      padBodyHorizontally: false,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              clipBehavior: Clip.none,
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DetailsPage(noteModel: noteModel),
                if (showAnalysis) AnalysisPage(analysisModel: analysisModel),
              ],
            ),
          ),
          if (showAnalysis)
            Padding(
              padding: EdgeInsets.only(top: gap),
              child: SegmentedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                    ),
                  ),
                ),
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: 'details',
                    label: const Text('Details'),
                    icon: FaIcon(
                      FontAwesomeIcons.circleInfo,
                      color: selectedPage == 0
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onBackground,
                    ),
                  ),
                  ButtonSegment(
                    value: 'analysis',
                    label: const Text('Analysis'),
                    icon: FaIcon(
                      FontAwesomeIcons.chartPie,
                      color: selectedPage == 1
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onBackground,
                    ),
                  ),
                ],
                selected: {segments[selectedPage]},
                onSelectionChanged: (Set<String> value) {
                  vibrate(
                      PreferencesController
                          .navigationEnableHapticFeedback.value, () {
                    setState(() {
                      selectedPage = segments.indexOf(value.first);
                      controller.animateToPage(
                        selectedPage,
                        duration: emphasizedDuration,
                        curve: emphasizedCurve,
                      );
                    });
                  });
                },
              ),
            )
        ],
      ),
    );
  }
}
