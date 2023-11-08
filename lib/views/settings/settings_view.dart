import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'
    hide AppBar, ListTile, Feedback, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/page_controller.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'about/settings_about_view.dart';
import 'account/settings_account_view.dart';
import 'insights/settings_insights_view.dart';
import 'navigation/settings_navigation_view.dart';
import 'theme/settings_theme_view.dart';
import 'writing/settings_writing_view.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
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
    return BlueprintView(
      showAppBar: ref.watch(navigationShowAppBarProvider),
      appBar: AppBar(
        pathNames: [
          PageController()
              .settings
              .titleGenerator(FirebaseAuth.instance.currentUser?.displayName)
        ],
      ),
      body: Wrap(
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
    );
  }

  CustomListTile _settingButton(
      ({
        String title,
        String description,
        IconData iconData,
        Widget widget,
      }) element) {
    return CustomListTile(
      useSmallerNavigationSetting: false,
      cornerRadius: radius,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 2 * gap,
        vertical: gap,
      ),
      leadingIconData: element.iconData,
      titleString: element.title,
      explanationString: element.description,
      onTap: () {
        navigator.push(
          PageRouteBuilder(
            transitionDuration: standardDuration,
            reverseTransitionDuration: standardDuration,
            pageBuilder: (
              context,
              animation,
              secondaryAnimation,
            ) {
              return element.widget;
            },
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(
                opacity: Tween<double>(
                  begin: -1,
                  end: 1,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
