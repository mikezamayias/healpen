import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/page_controller.dart';
import '../../extensions/widget_extenstions.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pageWidgets = [
      const Placeholder(),
    ].animateWidgetList();

    return BlueprintView(
      appBar: AppBar(
        pageModel: PageController().settings,
      ),
      body: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (_, int index) => pageWidgets[index],
        separatorBuilder: (_, __) => SizedBox(height: gap * 2),
        itemCount: pageWidgets.length,
      ),
    );
  }
}
