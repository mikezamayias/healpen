import 'package:flutter/material.dart' hide Chip;

import '../utils/constants.dart' as constants;
import 'custom_chip.dart';

class ChipBar extends StatelessWidget {
  const ChipBar({
    super.key,
    required this.children,
  });

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
