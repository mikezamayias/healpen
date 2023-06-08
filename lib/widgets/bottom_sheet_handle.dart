import 'package:flutter/material.dart' hide Divider;
import 'package:responsive_sizer/responsive_sizer.dart';

import 'divider.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15.w,
      child: const Divider(),
    );
  }
}
