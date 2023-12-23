import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/settings/settings_item.dart';
import '../../views/settings/about/settings_about_view.dart';
import '../../views/settings/account/settings_account_view.dart';
import '../../views/settings/insights/settings_insights_view.dart';
import '../../views/settings/navigation/settings_navigation_view.dart';
import '../../views/settings/theme/settings_theme_view.dart';
import '../../views/settings/writing/settings_writing_view.dart';

class SettingsController {
  static final SettingsController _instance = SettingsController._internal();
  factory SettingsController() => _instance;
  SettingsController._internal();

  static final theme = SettingsItem(
    title: 'Theme',
    description: 'Change the look of the app.',
    iconData: FontAwesomeIcons.swatchbook,
    widget: const SettingsThemeView(),
  );
  static final navigation = SettingsItem(
    title: 'Navigation',
    description: 'Change the way you navigate the app.',
    iconData: FontAwesomeIcons.route,
    widget: const SettingsNavigationView(),
  );
  static final account = SettingsItem(
    title: 'Account',
    description: 'Change your account settings.',
    iconData: FontAwesomeIcons.userLarge,
    widget: const SettingsAccountView(),
  );
  static final writing = SettingsItem(
    title: 'Writing',
    description: 'Change the way you write.',
    iconData: FontAwesomeIcons.pencil,
    widget: const SettingsWritingView(),
  );
  static final insights = SettingsItem(
    title: 'Insights',
    description: 'Change the way you see your data.',
    iconData: FontAwesomeIcons.brain,
    widget: const SettingsInsightsView(),
  );
  static final dataAndPrivacy = SettingsItem(
    title: 'Data & Privacy',
    description: 'Learn more about your data.',
    iconData: FontAwesomeIcons.scroll,
    widget: const Placeholder(),
  );
  static final helpAndSupport = SettingsItem(
    title: 'Help & Support',
    description: 'Get help with the app.',
    iconData: FontAwesomeIcons.solidMessage,
    widget: const Placeholder(),
  );
  static final about = SettingsItem(
    title: 'About',
    description: 'Learn more about the app.',
    iconData: FontAwesomeIcons.circleInfo,
    widget: const SettingsAboutView(),
  );
  static final List<SettingsItem> settingsItems = [
    theme,
    navigation,
    account,
    writing,
    insights,
    dataAndPrivacy,
    helpAndSupport,
    about,
  ];
}
