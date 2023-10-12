import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/keep_alive_widget.dart';
import '../../../../widgets/to_be_implemented_tile.dart';

class MoodJourneyTile extends ConsumerWidget {
  const MoodJourneyTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const KeepAliveWidget(
      child: ToBeImplementedTile(),
    );
  }
}
