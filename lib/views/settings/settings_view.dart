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
import '../simple/simple_blueprint_view.dart';
import '../simple/widgets/simple_app_bar.dart';
import 'widgets/settings_item_tile.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return _useSimpleUI ? _buildSimpleView() : _buildRegularView();
  }

  Widget _buildSimpleView() {
    return SimpleBlueprintView(
      simpleAppBar: const SimpleAppBar(appBarTitleString: 'Settings'),
      body: _buildBody(),
    );
  }

  Widget _buildRegularView() {
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
        children: <Widget>[Expanded(child: _buildBodyWrapper())],
      ),
    );
  }

  Widget _buildBody() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_dynamicRadius - gap),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: _dynamicSpacing,
          runSpacing: _dynamicSpacing,
          children: SettingsController.settingsItems
              .where((element) => element.widget! is! Placeholder)
              .map((element) => SettingsItemTile(settingsItemModel: element))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildBodyWrapper() {
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      decoration: _useSimpleUI || _useSmallerNavigationElements
          ? BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(_dynamicRadius),
            )
          : BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(_dynamicRadius),
            ),
      padding: _useSimpleUI || _useSmallerNavigationElements
          ? EdgeInsets.zero
          : EdgeInsets.all(_dynamicPadding),
      child: _buildBody(),
    );
  }

  double get _dynamicRadius =>
      _useSimpleUI || _useSmallerNavigationElements ? radius - gap : radius;

  double get _dynamicSpacing => _useSimpleUI ? radius : gap;

  double get _dynamicPadding =>
      _useSimpleUI == _useSmallerNavigationElements ? radius - gap : radius;

  bool get _useSimpleUI => ref.watch(navigationSimpleUIProvider);

  bool get _useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  bool get _showAppBar => ref.watch(navigationShowAppBarProvider);
}
