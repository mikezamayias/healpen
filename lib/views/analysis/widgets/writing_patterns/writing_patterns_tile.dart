import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analysis_section.dart';
import 'writing_flow_time_tile.dart';

class WritingPatternsTile extends ConsumerWidget {
  const WritingPatternsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AnalysisSection(
      sectionName: 'Writing Patterns',
      tileData: <({
        String explanationString,
        String titleString,
        Widget? content
      })>[
        /// Frequency Breakdown Widget
        /// Instead of a conventional bar graph, you can use a calendar
        /// heat map. Each day of the week will be a column, and each week
        /// will be a row. The color intensity of each cell represents the
        /// number of entries on that day. Darker colors mean more entries.
        /// This visualization provides an intuitive view of the user's writing
        /// habit.
        (
          titleString: 'Journaling Rhythm',
          explanationString: 'See how often you write',
          content: null,
        ),

        /// Length of Entries Breakdown Widget:
        /// Use a bubble chart, where each bubble represents an entry.
        /// The size of the bubble corresponds to the length of the entry,
        /// allowing users to visually compare entry lengths. This widget would
        /// showcase the variability in the lengths of their entries in a
        /// visually appealing way.
        (
          titleString: 'Journal Length',
          explanationString: 'See how long your entries are',
          content: null,
        ),

        /// Time Spent Writing Breakdown Widget:
        /// This could be represented by a 24-hour circular clock chart.
        /// Each section of the circle represents a time period of the day and
        /// the size of each section is proportional to the time spent writing
        /// during that period.
        (
          titleString: 'Writing Flow Time',
          explanationString: 'See when you write',
          content: WritingFlowTimeTile(),
        ),
      ],
    );
  }
}
