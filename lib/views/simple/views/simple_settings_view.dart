import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../settings/about/settings_about_view.dart';
import '../../settings/account/settings_account_view.dart';
import '../../settings/insights/settings_insights_view.dart';
import '../../settings/navigation/settings_navigation_view.dart';
import '../../settings/theme/settings_theme_view.dart';
import '../../settings/writing/settings_writing_view.dart';
import '../simple_blueprint_view.dart';
import '../widgets/simple_app_bar.dart';

class SimpleSettingsView extends StatelessWidget {
  const SimpleSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<
        ({
          String title,
          String description,
          IconData iconData,
          Widget widget,
        })>? pageWidgets = [
      (
        title: 'Theme',
        description: 'Change the look of the app.',
        widget: const SettingsThemeView(),
        iconData: FontAwesomeIcons.swatchbook,
      ),
      (
        title: 'Navigation',
        description: 'Change the way you navigate.',
        widget: const SettingsNavigationView(),
        iconData: FontAwesomeIcons.route,
      ),
      (
        title: 'Account',
        description: 'Change your account settings.',
        widget: const SettingsAccountView(),
        iconData: FontAwesomeIcons.userLarge,
      ),
      (
        title: 'Writing',
        description: 'Change the way you write.',
        widget: const SettingsWritingView(),
        iconData: FontAwesomeIcons.pencil,
      ),
      (
        title: 'Insights',
        description: 'Change the way you see your data.',
        widget: const SettingsInsightsView(),
        iconData: FontAwesomeIcons.brain,
      ),
      (
        title: 'Data & Privacy',
        description: 'Learn more about your data.',
        widget: const Placeholder(),
        iconData: FontAwesomeIcons.scroll,
      ),
      (
        title: 'Help & Support',
        description: 'Get help with the app.',
        widget: const Placeholder(),
        iconData: FontAwesomeIcons.solidMessage,
      ),
      (
        title: 'About',
        description: 'Learn more about the app.',
        widget: const SettingsAboutView(),
        iconData: FontAwesomeIcons.circleInfo,
      ),
    ];
    return SimpleBlueprintView(
      simpleUiAppBar: const SimpleAppBar(
        appBarTitleString: 'Settings',
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (({
                String title,
                String description,
                IconData iconData,
                Widget widget,
              }) element in pageWidgets)
                if (element.widget is! Placeholder) _settingButton(element),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingButton(
      ({
        String title,
        String description,
        IconData iconData,
        Widget widget,
      }) element) {
    return Consumer(
      builder: (context, ref, child) {
        return CustomListTile(
          useSmallerNavigationSetting: false,
          cornerRadius: radius,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 2 * gap,
            vertical: gap,
          ),
          leadingIconData: element.iconData,
          titleString: element.title,
          explanationString: ref.watch(navigationShowInfoProvider)
              ? element.description
              : null,
          onTap: () {
            pushWithAnimation(
              context: context,
              widget: element.widget,
              dataCallback: null,
            );
          },
        );
      },
    );
  }
}
