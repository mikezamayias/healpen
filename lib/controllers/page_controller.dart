import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../healpen.dart';
import '../models/page_model.dart';
import '../views/auth/auth_view.dart';
import '../views/history/history_view.dart';
import '../views/insights/insights_view.dart';
import '../views/note/note_view.dart';
import '../views/settings/licenses/settings_licenses_view.dart';
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
      insights,
      history,
      settings,
    ];
  }

  // Members
  List<PageModel> pages = <PageModel>[];

  final home = PageModel(
    titleGenerator: (userName) => 'Welcome Home',
    label: 'home',
    icon: FontAwesomeIcons.house,
    widget: const Center(child: Text('Home')),
  );

  final writing = PageModel(
    titleGenerator: (userName) => userName == null
        ? 'What\'s on your mind today?'
        : userName.isEmpty
            ? 'Hello,\nWhat\'s on your mind today?'
            : 'Hello $userName,\nWhat\'s on your mind today?',
    label: 'expression',
    icon: FontAwesomeIcons.pencil,
    widget: const WritingView(),
  );

  final insights = PageModel(
    titleGenerator: (userName) => 'Explore your writing insights',
    label: 'insights',
    icon: FontAwesomeIcons.brain,
    widget: const InsightsView(),
  );

  final history = PageModel(
    titleGenerator: (userName) => 'See your past entries',
    label: 'history',
    icon: FontAwesomeIcons.calendarDays,
    widget: const HistoryView(),
  );

  final settings = PageModel(
    //   titleGenerator: (userName) => userName == null ? 'Your Settings' : '$userName, Your Settings',
    titleGenerator: (userName) => 'Personalize your experience',
    label: 'settings',
    icon: FontAwesomeIcons.sliders,
    widget: const SettingsView(),
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

  final licenses = PageModel(
    titleGenerator: (userName) => 'Open Source Licenses',
    label: 'licenses',
    icon: FontAwesomeIcons.scroll,
    widget: const SettingsLicensesView(),
  );
}
