import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../healpen.dart';
import '../models/page_model.dart';
import '../views/analysis/analysis_view.dart';
import '../views/auth/auth_view.dart';
import '../views/history/history_view.dart';
import '../views/note/note_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/settings/settings_view.dart';
import '../views/writing/writing_view.dart';
import '../wrappers/auth_wrapper.dart';

class PageController {
  /// Singleton
  static final PageController _instance = PageController._internal();

  factory PageController() => _instance;

  PageController._internal() {
    pages = [
      // home,
      writing,
      analysis,
      history,
      settings,
    ];
  }

  // Members
  List<PageModel> pages = <PageModel>[];

  final home = PageModel(
    titleGenerator: (userName) =>
        userName == null ? 'Welcome Home' : 'Welcome Home, $userName',
    label: 'home',
    icon: FontAwesomeIcons.house,
    widget: const Center(child: Text('Home')),
  );

  final writing = PageModel(
    // titleGenerator: (userName) =>
    //     userName == null ? 'Your Thoughts?' : '$userName, Your Thoughts?',
    titleGenerator: (userName) => userName == null
        ? 'What\'s on your mind today?'
        : 'Hello $userName,\nWhat\'s on your mind today?',
    label: 'writing',
    icon: FontAwesomeIcons.pencil,
    widget: const WritingView(),
  );

  final analysis = PageModel(
    //   titleGenerator: (userName) => userName == null ? 'Explore Insights' : '$userName, Explore Insights',
    titleGenerator: (userName) => userName == null
        ? 'Explore your writing insights'
        : 'Hello $userName,\nExplore your writing insights',
    label: 'analysis',
    icon: FontAwesomeIcons.chartLine,
    widget: const AnalysisView(),
  );

  final history = PageModel(
    //   titleGenerator: (userName) => userName == null ? 'Past Entries?' : '$userName, Past Entries?',
    titleGenerator: (userName) => userName == null
        ? 'Your past entries'
        : '$userName,\nYour past entries',
    label: 'history',
    icon: FontAwesomeIcons.calendarDays,
    widget: const HistoryView(),
  );

  final settings = PageModel(
    //   titleGenerator: (userName) => userName == null ? 'Your Settings' : '$userName, Your Settings',
    titleGenerator: (userName) => userName == null
        ? 'Personalize your experience'
        : '$userName,\nPersonalize your experience',
    label: 'settings',
    icon: FontAwesomeIcons.sliders,
    widget: const SettingsView(),
  );

  final onboarding = PageModel(
    titleGenerator: (userName) => 'Onboarding',
    label: 'onboarding',
    icon: FontAwesomeIcons.circleInfo,
    widget: const OnboardingView(),
  );

  final authWrapper = PageModel(
    titleGenerator: (userName) => 'Authentication',
    label: 'authWrapper',
    icon: FontAwesomeIcons.userLock,
    widget: const AuthWrapper(),
  );

  final authView = PageModel(
    titleGenerator: (userName) => 'Sign in with magic link',
    label: 'authView',
    icon: FontAwesomeIcons.user,
    widget: const AuthView(),
  );

  final noteView = PageModel(
    titleGenerator: (userName) => 'Note',
    label: 'noteView',
    icon: FontAwesomeIcons.noteSticky,
    widget: const NoteView(),
  );

  final healpen = PageModel(
    titleGenerator: (userName) => 'Healpen',
    label: 'healpen',
    icon: FontAwesomeIcons.pen,
    widget: const Healpen(),
  );
}
