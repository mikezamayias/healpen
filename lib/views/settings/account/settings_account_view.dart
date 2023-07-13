import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/widget_extenstions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/edit_name_tile.dart';
import 'widgets/sign_out_tile.dart';

class SettingsAccountView extends ConsumerStatefulWidget {
  const SettingsAccountView({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsAccountView> createState() =>
      _SettingsAccountViewState();
}

class _SettingsAccountViewState extends ConsumerState<SettingsAccountView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pageWidgets = [
      const EditNameTile(),

      /// TODO: study and implement the re-authentication process required
      ///  to change email
      // const EditEmailTile(),
      const SignOutTile(),
      // const DeleteAccountTile(),
    ].animateWidgetList();

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Settings', 'Account'],
      ),
      body: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: pageWidgets,
      ),
    );
  }
}
