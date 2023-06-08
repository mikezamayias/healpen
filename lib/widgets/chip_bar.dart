import 'package:flutter/material.dart';

import '../utils/constants.dart' as constants;
import 'conditional_chip.dart';

class ChipBar extends StatelessWidget {
  const ChipBar({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<ConditionalChip> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: constants.gap,
        runSpacing: constants.gap,
        alignment: WrapAlignment.spaceEvenly,
        runAlignment: WrapAlignment.spaceEvenly,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      ),
    );
  }
}
