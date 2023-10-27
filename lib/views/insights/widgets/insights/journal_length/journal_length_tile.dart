import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/bubble_chart.dart';

class JournalLengthTile extends ConsumerWidget {
  const JournalLengthTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const BubbleChart();
  }
}
