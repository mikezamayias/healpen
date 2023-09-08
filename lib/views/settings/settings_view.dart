import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'account/settings_account_view.dart';
import 'navigation/settings_navigation_view.dart';
import 'theme/settings_theme_view.dart';
import 'writing/settings_writing_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, (Widget, IconData)> pageWidgets = {
      'Theme': (
        const SettingsThemeView(),
        FontAwesomeIcons.swatchbook,
      ),
      'Navigation': (
        const SettingsNavigationView(),
        FontAwesomeIcons.route,
      ),
      'Account': (
        const SettingsAccountView(),
        FontAwesomeIcons.userLarge,
      ),
      'Writing': (
        const SettingsWritingView(),
        FontAwesomeIcons.solidPenToSquare,
      ),
      'Data & Privacy': (
        const Placeholder(),
        FontAwesomeIcons.scroll,
      ),
      'Help & Support': (
        const Placeholder(),
        FontAwesomeIcons.solidMessage,
      ),
      'About': (
        const Placeholder(),
        FontAwesomeIcons.circleInfo,
      ),
    };

    return BlueprintView(
      showAppBarTitle: ref.watch(navigationShowAppBarTitle),
      appBar: const AppBar(
        pathNames: ['Personalize your experience'],
      ),
      body: Stack(
        children: [
          Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (String title in pageWidgets.keys)
                if (pageWidgets[title]!.$1 is! Placeholder)
                  CustomListTile(
                    responsiveWidth: true,
                    leadingIconData: pageWidgets[title]!.$2,
                    contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                    textColor: context.theme.colorScheme.onPrimary,
                    titleString: title,
                    onTap: () {
                      vibrate(ref.watch(navigationReduceHapticFeedbackProvider),
                          () {
                        context.navigator.push(
                          MaterialPageRoute(
                            builder: (_) => pageWidgets[title]!.$1,
                          ),
                        );
                      });
                    },
                  ),
              // CustomListTile(
              //   responsiveWidth: true,
              //   leadingIconData: FontAwesomeIcons.palette,
              //   contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
              //   textColor: context.theme.colorScheme.onPrimary,
              //   titleString: 'Theme',
              //   onTap: () {
              //     showModalBottomSheet(
              //       context: context,
              //       useSafeArea: true,
              //       showDragHandle: true,
              //       builder: (BuildContext context) {
              //         return SafeArea(
              //           child: Padding(
              //             padding: EdgeInsets.symmetric(horizontal: gap),
              //             child: Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 const TextDivider('Theme'),
              //                 SizedBox(height: gap),
              //                 const ThemeColorTile(),
              //                 SizedBox(height: gap),
              //                 const ThemeAppearanceTile(),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Center(
                child: CustomListTile(
                  responsiveWidth: true,
                  leadingIconData: FontAwesomeIcons.solidCommentDots,
                  contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                  textColor: context.theme.colorScheme.onPrimary,
                  titleString: 'Feedback',
                  onTap: () {
                    vibrate(
                      ref.watch(navigationReduceHapticFeedbackProvider),
                      () {
                        BetterFeedback.of(context)
                            .show((UserFeedback feedback) {
                          // Do something with the feedback
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: gap * 2),
            ],
          ),
        ],
      ),
    );
  }
}
