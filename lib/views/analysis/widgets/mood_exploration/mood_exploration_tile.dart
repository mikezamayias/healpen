import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analysis_section.dart';

class MoodExploration extends ConsumerWidget {
  const MoodExploration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AnalysisSection(
      sectionName: 'Mood Exploration',
      tileData: <({String explanationString, String titleString})>[
        /// This widget could be represented by a word cloud.
        /// You could add interactivity, for example, users could tap on a word
        /// to see the entries where it was used.
        (
          titleString: 'Word Cloud',
          explanationString: 'See the most frequent words in your notes',
        ),

        /// This widget could be represented by a mood ring or color spectrum.
        /// The color changes according to the inferred mood from the journal
        /// entries, giving a quick and intuitive view of the user's mood based
        /// on their notes.
        (
          titleString: 'Emotional Echo',
          explanationString: 'The color of this ring changes according to your '
              'mood',
        ),

        /// Instead of a line graph, consider a river or stream graph.
        /// It provides a more visual, less analytical depiction of the ebb and
        /// flow of sentiment over time. The width of the "river" at any point can
        /// indicate the strength of sentiment (positive or negative).
        (
          titleString: 'Mood Journey',
          explanationString: 'See how your mood has changed over time',
        ),
      ],
    );
  }
}
