import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/text_divider.dart';

class WritingPatternsTile extends ConsumerWidget {
  const WritingPatternsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const TextDivider('Writing Patterns'),
        Gap(gap),
        const Spacer(),
      ],
    );
  }
}
