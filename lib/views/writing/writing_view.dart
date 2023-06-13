import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';

class WritingView extends ConsumerWidget {
  const WritingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, Widget> pageWidgets = {};

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Hello Mike,\nWhat\'s on your mind today?'],
      ),
      body: Container(),
    );
  }
}
