import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/page_controller.dart' as page_controller;
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
      AnalysisModel? analysisModel
    });
    final NoteModel noteModel = args.noteModel;
    final AnalysisModel? analysisModel = args.analysisModel;
    final showAnalysis = !noteModel.isPrivate && analysisModel != null;
    final pages = [
      DetailsPage(noteModel: noteModel),
      if (showAnalysis) AnalysisPage(analysisModel: analysisModel),
    ];
    return BlueprintView(
      showAppBar: true,
      appBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: gap),
        child: AppBar(
          pathNames: [
            page_controller.PageController()
                .noteView
                .titleGenerator(FirebaseAuth.instance.currentUser?.displayName)
          ],
          automaticallyImplyLeading: true,
        ),
      ),
      padBodyHorizontally: false,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              clipBehavior: Clip.none,
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final bool active = index == selectedPage;
                final double opacity = active ? 1 : 0;
                final double slide = active
                    ? 0
                    : index < selectedPage
                        ? -1
                        : 1;
                return AnimatedContainer(
                  duration: standardDuration,
                  curve: standardEasing,
                  transform: Matrix4.identity()
                    ..translate(slide * 100.w)
                    ..scale(active ? 1.0 : 0.3),
                  child: AnimatedOpacity(
                    duration: standardDuration,
                    curve: standardEasing,
                    opacity: opacity,
                    child: pages.elementAt(index),
                  ),
                );
              },
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
