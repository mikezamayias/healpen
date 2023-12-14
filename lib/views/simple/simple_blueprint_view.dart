import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../utils/constants.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/simple_app_bar.dart';

class SimpleBlueprintView extends ConsumerWidget {
  final SimpleAppBar simpleUiAppBar;
  final EdgeInsets? bodyPadding;
  final Widget body;

  const SimpleBlueprintView({
    super.key,
    required this.simpleUiAppBar,
    this.bodyPadding,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = bodyPadding ?? EdgeInsets.all(radius);
    return BlueprintView(
      padBodyHorizontally: false,
      body: Container(
        color: context.theme.colorScheme.primaryContainer,
        child: Column(
          children: <Widget>[
            simpleUiAppBar,
            Expanded(
              child: AnimatedContainer(
                duration: standardDuration,
                curve: standardCurve,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                  left: radius * 2 - padding.left,
                  right: radius * 2 - padding.right,
                  top: radius * 2 - padding.top, 
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
