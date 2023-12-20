import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../utils/constants.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/simple_app_bar.dart';
import 'widgets/simple_body.dart';

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
              child: SimpleBody(
                padding: padding,
                body: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
