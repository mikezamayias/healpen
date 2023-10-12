import 'package:flutter/material.dart';

import '../../../../widgets/keep_alive_widget.dart';
import '../../../../widgets/to_be_implemented_tile.dart';

class WritingFlowTimeTile extends StatelessWidget {
  const WritingFlowTimeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const KeepAliveWidget(
      child: ToBeImplementedTile(),
    );
  }
}
