import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.bottomNavigationBar,
    this.backgroundColor,
    this.padBodyHorizontally = true,
    this.showAppBar,
    required this.body,
  });

  final Widget? appBar;
  final Widget? bottomNavigationBar;
  final Widget body;
  final Color? backgroundColor;
  final bool? padBodyHorizontally;
  final bool? showAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAppBarSetting =
        showAppBar ?? ref.watch(navigationShowAppBarProvider);
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUIOverlayStyle(
        context.theme,
        ref.watch(themeAppearanceProvider),
      ),
      child: Container(
        color: backgroundColor ??
            (ref.watch(navigationSmallerNavigationElementsProvider)
                ? context.theme.colorScheme.surfaceVariant
                : context.theme.colorScheme.surface),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => context.focusScope.unfocus(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padBodyHorizontally! ? gap : 0,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: showAppBarSetting! && appBar != null
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(
                          smallNavigationElements ? kToolbarHeight : 18.h,
                        ),
                        child: appBar!,
                      )
                    : null,
                body: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    overscroll: false,
                  ),
                  child: body,
                ),
                bottomNavigationBar: bottomNavigationBar,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
