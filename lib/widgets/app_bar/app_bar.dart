import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/app_bar_controller.dart';
import '../../controllers/settings/preferences_controller.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import 'widgets/page_icon.dart';
import 'widgets/path_title.dart';

class AppBar extends ConsumerStatefulWidget {
  final List<String> pathNames;
  final bool? automaticallyImplyLeading;
  final VoidCallback? onBackButtonPressed;

  const AppBar({
    Key? key,
    required this.pathNames,
    this.automaticallyImplyLeading = false,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  ConsumerState<AppBar> createState() => _AppBarState();
}

class _AppBarState extends ConsumerState<AppBar> {
  @override
  void initState() {
    final appBarController = ref.read(appBarControllerProvider);
    appBarController.pathNames = widget.pathNames;
    appBarController.automaticallyImplyLeading =
        widget.automaticallyImplyLeading!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _getContainerHeight(),
      duration: longEmphasizedDuration,
      curve: emphasizedCurve,
      decoration: _getContainerDecoration(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          const PageIcon(),
          _buildPathWithLeading(),
        ],
      ),
    );
  }

  BoxDecoration? _getContainerDecoration() {
    return ref.watch(navigationShowAppBarTitleProvider)
        ? BoxDecoration(
            color: context.theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(radius),
          )
        : null;
  }

  double _getContainerHeight() {
    return ref.watch(navigationShowAppBarTitleProvider)
        ? 21.h
        : context.theme.textTheme.titleLarge!.fontSize! * 2;
  }

  Widget _buildPathWithLeading() {
    return AnimatedPadding(
      duration: longEmphasizedDuration,
      curve: emphasizedCurve,
      padding: _getPathPadding(ref),
      child: Stack(
        children: <Widget>[
          _buildBackButton(context, ref),
          AnimatedContainer(
            duration: longEmphasizedDuration,
            curve: emphasizedCurve,
            margin: _getPathMargin(ref),
            alignment: Alignment.bottomLeft,
            child: const PathTitle(),
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPathPadding(WidgetRef ref) {
    return ref.watch(navigationShowAppBarTitleProvider)
        ? EdgeInsets.only(bottom: gap, left: gap)
        : EdgeInsets.zero;
  }

  EdgeInsets _getPathMargin(WidgetRef ref) {
    return ref.watch(navigationShowBackButtonProvider) &&
            widget.automaticallyImplyLeading!
        ? EdgeInsets.only(left: 15.w - gap)
        : EdgeInsets.zero;
  }

  Widget _buildBackButton(BuildContext context, WidgetRef ref) {
    return AnimatedPositioned(
      duration: longEmphasizedDuration,
      curve: emphasizedCurve,
      left: ref.watch(navigationShowBackButtonProvider) &&
              widget.automaticallyImplyLeading!
          ? 0
          : -15.w,
      bottom: 0,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        enableFeedback: true,
        onPressed: () => _handleBackButton(context),
        color: context.theme.colorScheme.onPrimary,
        icon: const FaIcon(FontAwesomeIcons.chevronLeft),
      ),
    );
  }

  void _handleBackButton(BuildContext context) {
    vibrate(PreferencesController.navigationEnableHapticFeedback.value, () {
      if (widget.onBackButtonPressed != null) {
        widget.onBackButtonPressed!();
      } else {
        context.navigator.pop();
      }
    });
  }
}
