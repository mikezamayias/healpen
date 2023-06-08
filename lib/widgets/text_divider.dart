import 'package:flutter/material.dart' hide Divider;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/constants.dart';
import 'divider.dart';

class TextDivider extends StatelessWidget {
  final String data;
  const TextDivider({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gap),
      child: Row(
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
      ),
    );
  }
}
