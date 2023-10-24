import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../extensions/widget_extensions.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';

class BlueprintView extends ConsumerWidget {
  const BlueprintView({
    Key? key,
    this.appBar,
    this.padBodyHorizontally = true,
    this.showAppBar,
    required this.body,
  }) : super(key: key);

  final Widget? appBar;
  final Widget body;
  final bool? padBodyHorizontally;
  final bool? showAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAppBarSetting =
        showAppBar ?? ref.watch(navigationShowAppBarProvider);
    final smallerNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUIOverlayStyle(
        context.theme,
        ref.watch(themeAppearanceProvider),
      ),
      child: Container(
        color: context.theme.colorScheme.background,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => context.focusScope.unfocus(),
            child: Container(
              color: context.theme.colorScheme.background,
              padding: EdgeInsets.symmetric(
                horizontal: padBodyHorizontally! ? gap : 0,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: showAppBarSetting! && appBar != null
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(24.h),
                        child: appBar!.animateAppBar(),
                      )
                    : null,
                body: AnimatedContainer(
                  duration: standardDuration,
                  curve: standardCurve,
                  padding: showAppBarSetting
                      ? EdgeInsets.symmetric(vertical: gap)
                      : EdgeInsets.only(bottom: gap),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                      overscroll: false,
                    ),
                    child: body,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
