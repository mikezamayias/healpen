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
  final bool? padBody;
  final bool? showAppBar;
  final Widget body;

  const SimpleBlueprintView({
    super.key,
    required this.simpleAppBar,
    this.bodyPadding,
    this.padBody = true,
    this.showAppBar = true,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = bodyPadding ?? EdgeInsets.all(radius);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUIOverlayStyle(
        context.theme,
        ref.watch(themeAppearanceProvider),
      ),
      child: GestureDetector(
        onTap: () => context.focusScope.unfocus(),
        child: Scaffold(
          body: Container(
            color: context.theme.colorScheme.primaryContainer,
            child: Column(
              children: <Widget>[
                // if (simpleAppBar != null) simpleAppBar!.animateAppBar(),
                AnimatedCrossFade(
                  duration: standardDuration,
                  firstCurve: standardCurve,
                  secondCurve: standardCurve,
                  sizeCurve: standardCurve,
                  crossFadeState: showAppBar!
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: simpleAppBar,
                  secondChild: const SizedBox.shrink(),
                ),
                Expanded(
                  child: SimpleBody(
                    padBody: padBody,
                    padding: padding,
                    body: body,
                    isAppBarVisible: showAppBar!,
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
