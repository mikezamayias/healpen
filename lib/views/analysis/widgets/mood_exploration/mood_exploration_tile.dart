import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/text_divider.dart';

class MoodExplorationTile extends StatelessWidget {
  const MoodExplorationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextDivider('Mood Exploration'),
        Gap(gap),
        const Spacer(),
      ],
    );
  }
}
