import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import 'widgets/simple_app_bar.dart';
import 'widgets/simple_body.dart';

class SimpleBlueprintView extends ConsumerWidget {
  final SimpleAppBar simpleAppBar;
  final EdgeInsets? bodyPadding;
  final Widget body;

  const SimpleBlueprintView({
    super.key,
    required this.simpleAppBar,
    this.bodyPadding,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = bodyPadding ?? EdgeInsets.all(radius);
    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUIOverlayStyle(
          context.theme,
          ref.watch(themeAppearanceProvider),
        ),
        child: GestureDetector(
          onTap: () => context.focusScope.unfocus(),
          child: Container(
            color: context.theme.colorScheme.primaryContainer,
            child: Column(
              children: <Widget>[
                simpleAppBar,
                Expanded(
                  child: SimpleBody(
                    padding: padding,
                    body: body,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
