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
          IconData iconData,
          Widget widget,
        })>? pageWidgets = [
      (
        title: 'Theme',
        widget: const SettingsThemeView(),
        iconData: FontAwesomeIcons.swatchbook,
      ),
      (
        title: 'Navigation',
        widget: const SettingsNavigationView(),
        iconData: FontAwesomeIcons.route,
      ),
      (
        title: 'Account',
        widget: const SettingsAccountView(),
        iconData: FontAwesomeIcons.userLarge,
      ),
      (
        title: 'Writing',
        widget: const SettingsWritingView(),
        iconData: FontAwesomeIcons.pencil,
      ),
      (
        title: 'Insights',
        widget: const SettingsInsightsView(),
        iconData: FontAwesomeIcons.brain,
      ),
      (
        title: 'Data & Privacy',
        widget: const Placeholder(),
        iconData: FontAwesomeIcons.scroll,
      ),
      (
        title: 'Help & Support',
        widget: const Placeholder(),
        iconData: FontAwesomeIcons.solidMessage,
      ),
      (
        title: 'About',
        widget: const Placeholder(),
        iconData: FontAwesomeIcons.circleInfo,
      ),
    ];
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
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
        spacing: smallNavigationElements ? gap * 2 : gap,
        runSpacing: smallNavigationElements ? gap * 2 : gap,
        children: [
          for (({
            String title,
            IconData iconData,
            Widget widget,
          }) element in pageWidgets)
            if (element.widget is! Placeholder)
              _settingButton(
                title: element.title,
                iconData: element.iconData,
                widget: element.widget,
              ),
        ],
      ),
    );
  }

  CustomListTile _settingButton({
    required IconData iconData,
    required String title,
    required Widget widget,
  }) {
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    return CustomListTile(
      responsiveWidth: !smallNavigationElements,
      leadingIconData: iconData,
      cornerRadius: smallNavigationElements ? radius - gap : null,
      contentPadding: smallNavigationElements
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              horizontal: gap * 2,
              vertical: gap,
            ),
      backgroundColor: smallNavigationElements
          ? context.theme.colorScheme.surface
          : context.theme.colorScheme.primary,
      textColor: smallNavigationElements
          ? context.theme.colorScheme.primary
          : context.theme.colorScheme.onPrimary,
      title: Text(
        title,
        style: context.theme.textTheme.titleLarge!.copyWith(
          color: smallNavigationElements
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.onPrimary,
        ),
      ),
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
              return widget;
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
                // child: SlideTransition(
                //   position: Tween<Offset>(
                //     begin: const Offset(1, 0),
                //     end: Offset.zero,
                //   ).animate(animation),
                //   child: child,
                // ),
              );
            },
          ),
        );
      },
    );
  }
}
