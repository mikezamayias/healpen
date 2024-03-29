import 'package:flutter/material.dart' hide Divider;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'divider.dart';

class TextDivider extends StatelessWidget {
  final String data;

  const TextDivider(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 12.w,
          child: const Divider(),
        ),
        Text(
          data,
          style: context.theme.textTheme.headlineSmall!.copyWith(
            color: context.theme.colorScheme.outline,
          ),
        ),
        const Expanded(
          child: Divider(),
        ),
      ],
    );
  }
}
