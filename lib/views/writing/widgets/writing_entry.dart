import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../utils/constants.dart';
import 'writing_check_box.dart';
import 'writing_text_field.dart';

class WritingEntry extends StatelessWidget {
  const WritingEntry({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius - gap),
      ),
      padding: EdgeInsets.all(gap),
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: WritingTextField()),
          WritingCheckBox(),
        ],
      ),
    );
  }
}
