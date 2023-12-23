import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'
    hide AppBar, ListTile, Feedback, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/page_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../../models/settings/settings_item.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';
import '../simple/simple_blueprint_view.dart';
import '../simple/widgets/simple_app_bar.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    Widget body = ClipRRect(
      borderRadius: BorderRadius.circular(radius - gap),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: useSimpleUI ? radius : gap,
          runSpacing: useSimpleUI ? radius : gap,
          children: [
            for (SettingsItem settingsItem in SettingsController.settingsItems)
              if (settingsItem.widget is! Placeholder)
                _settingButton(settingsItem),
          ],
        ),
      ),
    );
    Widget regularBody = AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      padding: EdgeInsets.all(gap),
      decoration: useSmallerNavigationElements
          ? BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            )
          : BoxDecoration(
              color: context.theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: body,
          ),
        ],
      ),
    );
    return useSimpleUI
        ? SimpleBlueprintView(
            simpleAppBar: const SimpleAppBar(
              appBarTitleString: 'Settings',
            ),
            body: body,
          )
        : BlueprintView(
            showAppBar: showAppBar,
            appBar: AppBar(
              pathNames: [
                PageController().settings.titleGenerator(
                    FirebaseAuth.instance.currentUser?.displayName)
              ],
            ),
            body: regularBody,
          );
  }

  CustomListTile _settingButton(SettingsItem settingsItem) {
    return CustomListTile(
      useSmallerNavigationSetting: useSmallerNavigationElements,
      cornerRadius: useSimpleUI ? radius : radius - gap,
      contentPadding: EdgeInsets.all(useSimpleUI ? radius : gap),
      leadingIconData: settingsItem.iconData,
      titleString: settingsItem.title,
      explanationString: showInformatoryText ? settingsItem.description : null,
      onTap: () {
        pushWithAnimation(
          context: context,
          widget: settingsItem.widget,
          dataCallback: null,
        );
      },
    );
  }

  bool get useSimpleUI => ref.watch(navigationSimpleUIProvider);
  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
  bool get showInformatoryText => ref.watch(navigationShowInfoProvider);
  bool get showAppBar => ref.watch(navigationShowAppBarProvider);
}
