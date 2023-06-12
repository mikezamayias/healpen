import 'package:flutter/material.dart' hide Chip;

import '../utils/constants.dart' as constants;
import 'custom_chip.dart';

class ChipBar extends StatelessWidget {
  const ChipBar({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<CustomChip> children;

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
