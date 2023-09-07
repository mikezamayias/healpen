import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/note/note_model.dart';
import '../../providers/settings_providers.dart';
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
    final NoteModel noteModel =
    ModalRoute.of(context)!.settings.arguments as NoteModel;
    final showAnalysis = noteModel.sentiment != null && !noteModel.isPrivate;
    final pages = [
      DetailsPage(noteModel: noteModel),
      if (showAnalysis) AnalysisPage(noteModel: noteModel)
    ];
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
            child: PageView.builder(
              clipBehavior: Clip.none,
              controller: controller,
              itemCount: pages.length,
              itemBuilder: (BuildContext context, int index) => pages[index],
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
          if (showAnalysis)
            SegmentedButton(
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
              vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
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
          )
        ],
      ),
    );
  }
}
