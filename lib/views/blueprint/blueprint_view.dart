import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../extensions/widget_extensions.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';

class BlueprintView extends ConsumerWidget {
  const BlueprintView({
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.padBodyHorizontally = true,
    this.showAppBar = true,
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
    return Container(
      padding: showAppBarSetting! ? EdgeInsets.zero : EdgeInsets.only(top: gap),
      color: backgroundColor ?? context.theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: padBodyHorizontally! ? gap : 0,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: showAppBarSetting && appBar != null
              ? PreferredSize(
                  preferredSize: Size.fromHeight(
                    smallNavigationElements ? 12.h : 18.h,
                  ),
                  child: appBar!.animateAppBar(),
                )
              : null,
          body: SafeArea(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                overscroll: false,
              ),
              child: body,
            ),
          ),
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
