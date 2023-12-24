import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../utils/constants.dart';

class SimpleBody extends StatelessWidget {
  const SimpleBody({
    super.key,
    required this.body,
    this.padding,
    this.padBody = true,
  });

  final bool? padBody;
  final EdgeInsets? padding;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      alignment: Alignment.topCenter,
      padding: !padBody!
          ? EdgeInsets.zero
          : EdgeInsets.only(
              left: radius * 2 - padding!.left,
              right: radius * 2 - padding!.right,
              top: radius * 2 - padding!.top,
            ),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius * 2),
          topRight: Radius.circular(radius * 2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: body,
      ),
    );
  }
}
