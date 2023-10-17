import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/healpen/healpen_controller.dart';
import '../controllers/settings/preferences_controller.dart';
import '../providers/settings_providers.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

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
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _getContainerHeight(),
      duration: emphasizedDuration,
      curve: emphasizedCurve,
      decoration: _getContainerDecoration(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          _buildIcon(),
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

  Widget _buildIcon() {
    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: emphasizedDuration,
        curve: emphasizedCurve,
        opacity: ref.watch(navigationShowAppBarTitleProvider) ? 1 : 0,
        child: Padding(
          padding: EdgeInsets.all(gap),
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Padding(
                padding: EdgeInsets.all(gap * 1.5),
                child: FaIcon(
                  HealpenController()
                      .currentPageModel(ref
                          .watch(HealpenController().currentPageIndexProvider))
                      .icon,
                  color: context.theme.colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPathWithLeading() {
    final path = _buildPath(context);
    return AnimatedPadding(
      duration: emphasizedDuration,
      curve: emphasizedCurve,
      padding: _getPathPadding(ref),
      child: Stack(
        children: <Widget>[
          _buildBackButton(context, ref),
          AnimatedContainer(
            duration: emphasizedDuration,
            curve: emphasizedCurve,
            margin: _getPathMargin(ref),
            alignment: Alignment.bottomLeft,
            child: path,
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

  Widget _buildPath(BuildContext context) {
    return AnimatedPadding(
      duration: emphasizedDuration,
      curve: emphasizedCurve,
      padding: (ref.watch(navigationShowBackButtonProvider) &&
              widget.automaticallyImplyLeading!)
          ? EdgeInsets.only(bottom: gap / 2)
          : EdgeInsets.zero,
      child: RichText(
        text: TextSpan(
          children: [
            for (int i = 0; i < widget.pathNames.length; i++)
              TextSpan(
                text: _getPathText(i),
                style: _getPathTextStyle(context, i),
              ),
          ],
        ),
      ),
    );
  }

  TextStyle _getPathTextStyle(BuildContext context, int i) {
    return (i < widget.pathNames.length - 1)
        ? context.theme.textTheme.titleLarge!.copyWith(
            color: context.theme.colorScheme.outline,
          )
        : context.theme.textTheme.headlineSmall!.copyWith(
            color: context.theme.colorScheme.secondary,
          );
  }

  String _getPathText(int i) {
    return i < widget.pathNames.length - 1
        ? '${widget.pathNames[i]} / '
        : widget.pathNames.length != 1 && widget.pathNames.length > 2
            ? '\n${widget.pathNames[i]}'
            : widget.pathNames[i];
  }

  Widget _buildBackButton(BuildContext context, WidgetRef ref) {
    return AnimatedPositioned(
      duration: emphasizedDuration,
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
