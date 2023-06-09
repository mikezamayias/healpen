import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../extensions/widget_extenstions.dart';
import '../../utils/constants.dart';

class BlueprintView extends ConsumerWidget {
  const BlueprintView({
    Key? key,
    this.appBar,
    required this.body,
  }) : super(key: key);

  final Widget? appBar;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.theme.colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: context.theme.colorScheme.background,
          appBar: appBar != null
              ? PreferredSize(
                  preferredSize: Size.fromHeight(100.h),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: gap * 2,
                      right: gap * 2,
                      top: gap,
                      bottom: gap * 2,
                    ),
                    child: appBar!.animateAppBar(context),
                  ),
                )
              : null,
          body: Padding(
            padding: EdgeInsets.only(
              left: gap * 2,
              right: gap * 2,
              bottom: gap,
            ),
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
    );
  }
}
