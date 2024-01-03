import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/settings/settings_item_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class SettingsItemTile extends ConsumerStatefulWidget {
  final SettingsItemModel settingsItemModel;

  const SettingsItemTile({super.key, required this.settingsItemModel});

  @override
  ConsumerState<SettingsItemTile> createState() => _SettingsItemTileState();
}

class _SettingsItemTileState extends ConsumerState<SettingsItemTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      cornerRadius: _useSmallerNavigationElements ? radius : gap,
      useSmallerNavigationSetting: !_useSmallerNavigationElements,
      enableExplanationWrapper:
          !_useSmallerNavigationElements ^ (tileModel.onTap != null),
      titleString: tileModel.title,
      explanationString: _showInfo ? tileModel.description : null,
      onTap: () {
        tileModel.onTap!(context);
      },
      leadingIconData: tileModel.leadingIconData,
    );
  }

  SettingsItemModel get tileModel => widget.settingsItemModel;

  bool get _useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  bool get _showInfo => ref.watch(navigationShowInfoProvider);
}
