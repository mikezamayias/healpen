import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../utils/constants.dart';
import 'writing_text_field.dart';

class WritingEntry extends ConsumerWidget {
  const WritingEntry({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius - gap),
      ),
      padding: EdgeInsets.all(gap),
      child: const WritingTextField(),
    );
  }
}
