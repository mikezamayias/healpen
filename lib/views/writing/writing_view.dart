import 'package:flutter/material.dart' hide AppBar, ListTile, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';

class WritingView extends ConsumerWidget {
  const WritingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Hello Mike,\nWhat\'s on your mind today?'],
      ),
      body: CustomListTile(
        cornerRadius: radius,
        contentPadding: EdgeInsets.all(gap),
        subtitle: const Placeholder(),
      ),
    );
  }
}
