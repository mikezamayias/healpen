import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../utils/constants.dart';

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
      elevation: radius,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: AnimatedContainer(
        duration: animationDuration.milliseconds,
        curve: curve,
        alignment: Alignment.center,
        padding: EdgeInsets.all(gap),
        child: widget.condition ? widget.firstChild : widget.secondChild,
      ),
    );
  }
}
