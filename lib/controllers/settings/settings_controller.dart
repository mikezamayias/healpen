import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/settings/settings_item_model.dart';
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

  static final theme = SettingsItemModel.withWidget(
    title: 'Theme',
    description: 'Change the look of the app.',
    leadingIconData: FontAwesomeIcons.swatchbook,
    widget: const SettingsThemeView(),
  );
  static final navigation = SettingsItemModel.withWidget(
    title: 'Navigation',
    description: 'Change the way you navigate the app.',
    leadingIconData: FontAwesomeIcons.route,
    widget: const SettingsNavigationView(),
  );
  static final account = SettingsItemModel.withWidget(
    title: 'Account',
    description: 'Change your account settings.',
    leadingIconData: FontAwesomeIcons.userLarge,
    widget: const SettingsAccountView(),
  );
  static final writing = SettingsItemModel.withWidget(
    title: 'Writing',
    description: 'Change the way you write.',
    leadingIconData: FontAwesomeIcons.pencil,
    widget: const SettingsWritingView(),
  );
  static final insights = SettingsItemModel.withWidget(
    title: 'Insights',
    description: 'Change the way you see your data.',
    leadingIconData: FontAwesomeIcons.brain,
    widget: const SettingsInsightsView(),
  );
  static final dataAndPrivacy = SettingsItemModel.withWidget(
    title: 'Data & Privacy',
    description: 'Learn more about your data.',
    leadingIconData: FontAwesomeIcons.scroll,
    widget: const Placeholder(),
  );
  static final helpAndSupport = SettingsItemModel.withWidget(
    title: 'Help & Support',
    description: 'Get help with the app.',
    leadingIconData: FontAwesomeIcons.solidMessage,
    widget: const Placeholder(),
  );
  static final about = SettingsItemModel.withWidget(
    title: 'About',
    description: 'Learn more about the app.',
    leadingIconData: FontAwesomeIcons.circleInfo,
    widget: const SettingsAboutView(),
  );
  static final List<SettingsItemModel> settingsItems = [
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
