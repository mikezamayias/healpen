import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'
    hide AppBar, Feedback, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/page_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/settings_item_tile.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      showAppBar: _showAppBar,
      appBar: AppBar(
        pathNames: [
          PageController()
              .settings
              .titleGenerator(FirebaseAuth.instance.currentUser?.displayName)
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: standardDuration,
              curve: standardCurve,
              decoration: _useSmallerNavigationElements
                  ? const BoxDecoration()
                  : BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(radius),
                    ),
              padding: _useSmallerNavigationElements
                  ? EdgeInsets.zero
                  : EdgeInsets.all(gap),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_dynamicRadius),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: _dynamicSpacing,
                    runSpacing: _dynamicSpacing,
                    children: SettingsController.settingsItems
                        .where((element) => element.widget! is! Placeholder)
                        .map((element) =>
                            SettingsItemTile(settingsItemModel: element))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double get _dynamicRadius => _useSmallerNavigationElements ? radius : gap;

  double get _dynamicSpacing => gap;

  bool get _useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  bool get _showAppBar => ref.watch(navigationShowAppBarProvider);
}
