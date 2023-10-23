import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../providers/settings_providers.dart';
import '../../../widgets/custom_list_tile.dart';
import 'insights/emotional_echo/emotional_echo_tile.dart';
import 'insights/journal_length_tile.dart';
import 'insights/journaling_rhythm_tile.dart';
import 'insights/mood_journey/mood_journey_tile.dart';
import 'insights/writing_flow_tracker/writing_flow_tracker_tile.dart';

class AnalysisSection extends ConsumerStatefulWidget {
  const AnalysisSection({
    super.key,
  });

  @override
  ConsumerState<AnalysisSection> createState() => _AnalysisSectionState();
}

class _AnalysisSectionState extends ConsumerState<AnalysisSection> {
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    pageController = PageController(
      initialPage: currentPage,
    );
    super.initState();
  }

  final tileData = <({
    String explanationString,
    String titleString,
    Widget? content,
  })>[
    /// This widget could be represented by a mood ring or color spectrum.
    /// The color changes according to the inferred mood from the journal
    /// entries, giving a quick and intuitive view of the user's mood based
    /// on their notes.
    (
      titleString: 'Emotional Echo',
      explanationString: 'The color of the echo changes according to your '
          'overall mood.\nHint: press and hold to see the color scale.',
      content: const EmotionalEchoTile(),
    ),

    /// Time Spent Writing Breakdown Widget:
    /// This could be represented by a 24-hour circular clock chart.
    /// Each section of the circle represents a time period of the day and
    /// the size of each section is proportional to the time spent writing
    /// during that period.
    (
      titleString: 'Writing Flow Tracker',
      content: const WritingFlowTrackerTile(),
      explanationString: 'See what hours of the day you write the most.',
    ),

    /// This widget could be represented by a word cloud.
    /// You could add interactivity, for example, users could tap on a word
    /// to see the entries where it was used.
    // (
    //   titleString: 'Word Cloud',
    //   explanationString: 'See the most frequent words in your notes.',
    //   content: const WordCloudTile(),
    // ),

    /// Instead of a line graph, consider a river or stream graph.
    /// It provides a more visual, less analytical depiction of the ebb and
    /// flow of sentiment over time. The width of the "river" at any point can
    /// indicate the strength of sentiment (positive or negative).
    (
      titleString: 'Mood Journey',
      explanationString: 'See how your mood has changed over time.\nHint: '
          'double tap a point to see more details about that entry.',
      content: const MoodJourneyTile(),
    ),

    /// Frequency Breakdown Widget
    /// Instead of a conventional bar graph, you can use a calendar
    /// heat map. Each day of the week will be a column, and each week
    /// will be a row. The color intensity of each cell represents the
    /// number of entries on that day. Darker colors mean more entries.
    /// This visualization provides an intuitive view of the user's writing
    /// habit.
    (
      titleString: 'Journaling Rhythm',
      explanationString: 'See how often you write.',
      content: const JournalingRhythmTile(),
    ),

    /// Length of Entries Breakdown Widget:
    /// Use a bubble chart, where each bubble represents an entry.
    /// The size of the bubble corresponds to the length of the entry,
    /// allowing users to visually compare entry lengths. This widget would
    /// showcase the variability in the lengths of their entries in a
    /// visually appealing way.
    (
      titleString: 'Journal Length',
      explanationString: 'See how long your entries are.',
      content: const JournalLengthTile(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      titleString: tileData.elementAt(currentPage).titleString,
      trailing: SmoothPageIndicator(
        controller: pageController,
        count: tileData.length,
        effect: ExpandingDotsEffect(
          dotHeight: gap,
          dotWidth: gap,
          activeDotColor: context.theme.colorScheme.primary,
          dotColor: context.theme.colorScheme.outline,
        ),
      ),
      enableSubtitleWrapper: false,
      expandSubtitle: true,
      subtitle: Container(
        padding: EdgeInsets.symmetric(vertical: gap),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius - gap),
        ),
        child: PageView.builder(
          itemCount: tileData.length,
          // itemBuilder: (BuildContext context, int index) => Padding(
          //   padding: EdgeInsets.symmetric(horizontal: gap),
          //   child: tileData[index].content!,
          // ),
          itemBuilder: (context, index) {
            final bool active = index == currentPage;
            final double opacity = active ? 1 : 0;
            final double slide = active
                ? 0
                : index < currentPage
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: gap),
                  child: tileData[index].content!,
                ),
              ),
            );
          },
          controller: pageController,
          onPageChanged: (int index) {
            vibrate(
              ref.watch(navigationEnableHapticFeedbackProvider),
              () {
                setState(() {
                  currentPage = index;
                });
              },
            );
          },
        ),
      ),
      explanationString: tileData.elementAt(currentPage).explanationString,
    );
  }
}
