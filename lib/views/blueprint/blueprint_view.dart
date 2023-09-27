import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../extensions/widget_extensions.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';

class BlueprintView extends ConsumerStatefulWidget {
  const BlueprintView({
    Key? key,
    this.appBar,
    this.padBodyHorizontally = true,
    this.showAppBarTitle = true,
    required this.body,
  }) : super(key: key);

  final Widget? appBar;
  final Widget body;
  final bool? padBodyHorizontally;
  final bool? showAppBarTitle;

  @override
  ConsumerState<BlueprintView> createState() => _BlueprintViewState();
}

class _BlueprintViewState extends ConsumerState<BlueprintView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUIOverlayStyle(
        context.theme,
        ref.watch(themeAppearanceProvider),
      ),
      child: GestureDetector(
        onTap: () => context.focusScope.unfocus(),
        child: Container(
          color: context.theme.colorScheme.background,
          padding: EdgeInsets.only(
            bottom: gap,
            top: gap,
            left: widget.padBodyHorizontally! ? gap : 0,
            right: widget.padBodyHorizontally! ? gap : 0,
          ),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: widget.showAppBarTitle!
                  ? widget.appBar != null
                      ? PreferredSize(
                          preferredSize: Size.fromHeight(100.h),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: gap),
                            child: widget.appBar!.animateAppBar(),
                          ),
                        )
                      : null
                  : null,
              body: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                ),
                child: widget.body,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
