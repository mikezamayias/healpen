import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';

class SimpleBody extends ConsumerStatefulWidget {
  const SimpleBody({
    super.key,
    required this.body,
    this.padding,
    this.padBody = true,
    required this.isAppBarVisible,
  });

  final bool? padBody;
  final EdgeInsets? padding;
  final Widget body;
  final bool isAppBarVisible;

  @override
  ConsumerState<SimpleBody> createState() => _SimpleBodyState();
}

class _SimpleBodyState extends ConsumerState<SimpleBody> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      alignment: Alignment.topCenter,
      padding: !padBody
          ? EdgeInsets.zero
          : EdgeInsets.only(
              left: radius - padding.left,
              right: radius - padding.right,
              top: radius - padding.top,
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

  bool get padBody => widget.padBody!;
  EdgeInsets get padding => widget.padding!;
  Widget get body => widget.body;
  bool get isAppBarVisible => widget.isAppBarVisible;

  bool get isKeyboardOpen =>
      ref.watch(WritingController().isKeyboardOpenProvider);
}
