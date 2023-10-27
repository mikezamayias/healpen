import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/insight_model.dart';
import '../views/insights/widgets/insights/emotional_echo/emotional_echo_tile.dart';
import '../views/insights/widgets/insights/journal_length/journal_length_tile.dart';
import '../views/insights/widgets/insights/journaling_rhythm/journaling_rhythm_tile.dart';
import '../views/insights/widgets/insights/mood_journey/mood_journey_tile.dart';
import '../views/insights/widgets/insights/writing_flow_tracker/writing_flow_tracker_tile.dart';

final insightsControllerProvider =
    StateProvider<InsightsController>((ref) => InsightsController());

class InsightsController {
  // Singleton constructor
  static final InsightsController _instance = InsightsController._internal();
  factory InsightsController() => _instance;
  InsightsController._internal() {
    insightModelList = [
      emotionalEcho,
      writingFlowTracker,
      moodJourney,
      journalingRhythm,
      journalLength,
    ];
  }

  // Members
  List<InsightModel> insightModelList = <InsightModel>[];
  PageController pageController = PageController();
  int currentPage = 0;

  /// This widget could be represented by a mood ring or color spectrum.
  /// The color changes according to the inferred mood from the journal
  /// entries, giving a quick and intuitive view of the user's mood based
  /// on their notes.
  final emotionalEcho = const InsightModel(
    title: 'Emotional Echo',
    explanation: 'The color of the echo changes according to your '
        'overall mood.\nHint: press and hold to see the color scale.',
    widget: EmotionalEchoTile(),
  );

  /// Time Spent Writing Breakdown Widget:
  /// This could be represented by a 24-hour circular clock chart.
  /// Each section of the circle represents a time period of the day and
  /// the size of each section is proportional to the time spent writing
  /// during that period.
  final writingFlowTracker = const InsightModel(
    title: 'Writing Flow Tracker',
    explanation: 'See what hours of the day you write the most.',
    widget: WritingFlowTrackerTile(),
  );

  /// Instead of a line graph, consider a river or stream graph.
  /// It provides a more visual, less analytical depiction of the ebb and
  /// flow of sentiment over time. The width of the "river" at any point can
  /// indicate the strength of sentiment (positive or negative).
  final moodJourney = const InsightModel(
    title: 'Mood Journey',
    explanation: 'See how your mood has changed over time.\nHint: '
        'double tap a point to see more details about that entry.',
    widget: MoodJourneyTile(),
  );

  /// Frequency Breakdown Widget
  /// Instead of a conventional bar graph, you can use a calendar
  /// heat map. Each day of the week will be a column, and each week
  /// will be a row. The color intensity of each cell represents the
  /// number of entries on that day. Darker colors mean more entries.
  /// This visualization provides an intuitive view of the user's writing
  /// habit.
  final journalingRhythm = const InsightModel(
    title: 'Journaling Rhythm',
    explanation: 'See how often you write.',
    widget: JournalingRhythmTile(),
  );

  /// Length of Entries Breakdown Widget:
  /// Use a bubble chart, where each bubble represents an entry.
  /// The size of the bubble corresponds to the length of the entry,
  /// allowing users to visually compare entry lengths. This widget would
  /// showcase the variability in the lengths of their entries in a
  /// visually appealing way.
  final journalLength = const InsightModel(
    title: 'Journal Length',
    explanation: 'See how long your entries are.',
    widget: JournalLengthTile(),
  );

  // Methods
  void reorderInsights(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final InsightModel insight = insightModelList.removeAt(oldIndex);
    insightModelList.insert(newIndex, insight);
  }
}
