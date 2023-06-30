import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/widget_extenstions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/app_bar.dart';
import '../../blueprint/blueprint_view.dart';
import 'widgets/edit_email_tile.dart';
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
      const EditEmailTile(),
      const SignOutTile(),
      // const DeleteAccountTile(),
    ].animateWidgetList();

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Settings', 'Account'],
      ),
      body: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (_, int index) => pageWidgets[index],
        separatorBuilder: (_, __) => SizedBox(height: gap),
        itemCount: pageWidgets.length,
      ),
    );
  }
}
