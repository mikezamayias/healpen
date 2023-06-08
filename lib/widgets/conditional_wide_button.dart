import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../utils/constants.dart' as constants;

class ConditionalWideButton extends StatefulWidget {
  final bool condition;
  final Widget firstChild;
  final Widget secondChild;

  const ConditionalWideButton({
    Key? key,
    required this.condition,
    required this.firstChild,
    required this.secondChild,
  }) : super(key: key);

  @override
  State<ConditionalWideButton> createState() => _ConditionalWideButtonState();
}

class _ConditionalWideButtonState extends State<ConditionalWideButton> {
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: widget.condition
          ? context.theme.colorScheme.background
          : context.theme.colorScheme.secondaryContainer,
      shadowColor: context.theme.colorScheme.shadow,
      elevation: constants.radius,
      borderRadius: BorderRadius.all(Radius.circular(constants.radius)),
      child: AnimatedContainer(
        duration: constants.duration,
        curve: constants.curve,
        alignment: Alignment.center,
        padding: EdgeInsets.all(constants.gap),
        child: widget.condition ? widget.firstChild : widget.secondChild,
      ),
    );
  }
}
