import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/page_model.dart';
import '../views/settings/settings_view.dart';

class PageController {
  /// Singleton
  static final PageController _instance = PageController._internal();
  factory PageController() => _instance;
  PageController._internal() {
    pages = [
      // project,
      // charts,
      // dayDashboard,
      // user,
      settings,
      // about,
    ];
  }

  // Members
  List<PageModel> pages = <PageModel>[];

  final settings = PageModel(
    label: 'settigns',
    icon: FontAwesomeIcons.solidFileCode,
    widget: const SettingsView(),
  );
}
