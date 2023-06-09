import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/page_model.dart';
import '../views/settings/settings_view.dart';

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
    label: 'home',
    icon: FontAwesomeIcons.house,
    widget: const Center(child: Text('Home')),
  );
  final writing = PageModel(
    label: 'writing',
    icon: FontAwesomeIcons.pencil,
    widget: const Center(child: Text('Writing')),
  );
  final analysis = PageModel(
    label: 'analysis',
    icon: FontAwesomeIcons.chartLine,
    widget: const Center(child: Text('Analysis')),
  );
  final history = PageModel(
    label: 'history',
    icon: FontAwesomeIcons.book,
    widget: const Center(child: Text('History')),
  );
  final settings = PageModel(
    label: 'settings',
    icon: FontAwesomeIcons.sliders,
    widget: const SettingsView(),
  );
}
