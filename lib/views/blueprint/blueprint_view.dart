import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';

class BlueprintView extends ConsumerWidget {
  const BlueprintView({
    super.key,
    this.appBar,
    this.padBodyHorizontally = true,
    this.showAppBar,
    required this.body,
  });

  final Widget? appBar;
  final Widget body;
  final bool? padBodyHorizontally;
  final bool? showAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAppBarSetting =
        showAppBar ?? ref.watch(navigationShowAppBarProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUIOverlayStyle(
        context.theme,
        ref.watch(themeAppearanceProvider),
      ),
      child: Container(
        color: ref.watch(navigationSmallerNavigationElementsProvider)
            ? context.theme.colorScheme.surfaceVariant
            : context.theme.colorScheme.surface,
        padding: EdgeInsets.symmetric(
          horizontal: padBodyHorizontally! ? gap : 0,
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => context.focusScope.unfocus(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: showAppBarSetting! && appBar != null
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(18.h),
                      child: appBar!
                          .animate(
                            delay: slightlyLongEmphasizedDuration,
                          )
                          .fade(
                            duration: standardDuration,
                            curve: standardEasing,
                          )
                          .slideX(
                            duration: standardDuration,
                            curve: standardEasing,
                            begin: -.3,
                            end: 0,
                          ),
                    )
                  : null,
              body: AnimatedContainer(
                duration: standardDuration,
                curve: standardCurve,
                padding: EdgeInsets.symmetric(vertical: gap),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    overscroll: false,
                  ),
                  child: body,
                ),
              )
                  .animate()
                  .fade(
                    duration: emphasizedDuration,
                    curve: emphasizedCurve,
                  )
                  .slideY(
                    duration: emphasizedDuration,
                    curve: emphasizedCurve,
                    begin: -1,
                    end: 0,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
