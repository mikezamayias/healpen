import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/vibrate_controller.dart';
import '../extensions/color_extensions.dart';
import '../providers/settings_providers.dart';
import '../utils/constants.dart';

class CustomListTile extends ConsumerStatefulWidget {
  final String? titleString, explanationString, subtitleString;
  final int? maxExplanationStringLines;
  final Widget? title, subtitle, leading, trailing;
  final IconData? leadingIconData, trailingIconData;
  final GestureTapCallback? onTap, onLongPress, trailingOnTap, leadingOnTap;
  final bool? selectableText,
      responsiveWidth,
      showcaseLeadingIcon,
      enableSubtitleWrapper,
      expandSubtitle,
      padSubtitle,
      useSmallerNavigationSetting,
      padExplanation,
      enableExplanationWrapper,
      showShadow,
      isDisabled;
  final Color? backgroundColor, textColor, shadowColor, surfaceTintColor;
  final double? cornerRadius, elevation;
  final EdgeInsets? contentPadding, subtitlePadding, explanationPadding;

  const CustomListTile({
    super.key,
    this.titleString,
    this.explanationString,
    this.maxExplanationStringLines,
    this.subtitleString,
    this.leadingIconData,
    this.trailingIconData,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.trailingOnTap,
    this.leadingOnTap,
    this.backgroundColor,
    this.textColor,
    this.surfaceTintColor,
    this.selectableText = false,
    this.responsiveWidth = false,
    this.showcaseLeadingIcon = false,
    this.isDisabled = false,
    this.enableSubtitleWrapper = true,
    this.enableExplanationWrapper = false,
    this.expandSubtitle = false,
    this.padSubtitle = true,
    this.padExplanation = true,
    this.useSmallerNavigationSetting = true,
    this.cornerRadius,
    this.elevation,
    this.contentPadding,
    this.subtitlePadding,
    this.explanationPadding,
    this.showShadow = false,
    this.shadowColor,
  }) : assert(
          surfaceTintColor == null || elevation != null,
          'If surfaceTintColor is set, elevation must be set too.',
        );

  @override
  ConsumerState<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends ConsumerState<CustomListTile> {
  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  bool isTapped = false;

  // isTapped set to false when  button is pressed
  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      isTapped = true;
    });
  }

//button pressed is true when button is released
  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.isDisabled! || widget.onTap == null
            ? null
            : () => VibrateController().run(widget.onTap!),
        onLongPress: widget.isDisabled! || widget.onLongPress == null
            ? null
            : () => VibrateController().run(widget.onLongPress!),
        child: AnimatedContainer(
          duration: standardDuration,
          curve: standardCurve,
          decoration: containerDecoration,
          child: widget.responsiveWidth!
              ? IntrinsicWidth(
                  child: listTile,
                )
              : listTile,
        ),
      ),
    );
  }

  bool hasWidgetOrElement(Widget? widget, dynamic element) =>
      widget != null || element != null;

  bool get hasLeading =>
      hasWidgetOrElement(widget.leading, widget.leadingIconData);

  bool get hasTrailing =>
      hasWidgetOrElement(widget.trailing, widget.trailingIconData);

  bool get hasTitle => hasWidgetOrElement(widget.title, widget.titleString);

  bool get hasSubtitle =>
      hasWidgetOrElement(widget.subtitle, widget.subtitleString);

  bool get hasExplanation => widget.explanationString != null;

  Widget get listTile => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize:
            widget.expandSubtitle! ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            duration: standardDuration,
            curve: standardCurve,
            padding: firstRowPadding,
            decoration: containerDecoration,
            child: Row(
              children: <Widget>[
                if (hasLeading) leading,
                if (hasTitle) title,
                if (hasTrailing) trailing
              ],
            ),
          ),
          if (hasSubtitle) Flexible(child: subtitle),
          if (hasExplanation) explanation,
        ],
      );

  double get elevation => widget.elevation ?? radius;

  Color? get surfaceTintColor => widget.surfaceTintColor;

  Color get backgroundColor {
    Color tempBackgroundColor = widget.backgroundColor ??
        (widget.onTap != null
            ? widget.isDisabled!
                ? theme.colorScheme.outline
                : theme.colorScheme.primary
            : theme.colorScheme.surfaceVariant);
    return switch (surfaceTintColor == null) {
      true => tempBackgroundColor,
      false => tempBackgroundColor.applySurfaceTint(
          surfaceTintColor: surfaceTintColor!,
          elevation: elevation,
        ),
    };
  }

  Color get textColor =>
      widget.textColor ??
      (widget.onTap != null
          ? widget.isDisabled!
              ? theme.colorScheme.surface
              : theme.colorScheme.onPrimary
          : theme.colorScheme.onSurfaceVariant);

  Widget get leading => Padding(
        padding: leadingPadding,
        child: GestureDetector(
          onTap: widget.leadingOnTap == null
              ? null
              : () => VibrateController().run(widget.leadingOnTap!),
          child: widget.leading ?? _buildIcon(widget.leadingIconData!),
        ),
      );

  Widget get title => Expanded(
        child: widget.title ??
            Text(
              widget.titleString!,
              style: theme.textTheme.titleLarge!.copyWith(color: textColor),
            ),
      );

  Widget get trailing => Padding(
        padding: trailingPadding,
        child: GestureDetector(
          onTap: widget.trailingOnTap == null
              ? null
              : () => VibrateController().run(widget.trailingOnTap!),
          child: widget.trailing ?? _buildIcon(widget.trailingIconData!),
        ),
      );

  Widget get subtitle => AnimatedPadding(
        duration: standardDuration,
        curve: standardCurve,
        padding: widget.padSubtitle! ? subtitlePadding : EdgeInsets.zero,
        child: AnimatedContainer(
          duration: standardDuration,
          curve: standardCurve,
          decoration: subtitleDecoration,
          child: widget.subtitle ??
              SelectableText(
                widget.subtitleString!,
                onTap: widget.onTap,
                enableInteractiveSelection: widget.selectableText!,
                style: theme.textTheme.titleMedium!.copyWith(color: textColor),
              ),
        ),
      );

  Widget get explanation {
    Widget explanationContainer = AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      padding: useSmallerNavigationElements && !widget.enableExplanationWrapper!
          ? explanationPadding
          : padding,
      decoration: explanationDecoration,
      child: SelectableText(
        widget.explanationString!,
        onTap: widget.onTap,
        maxLines: widget.maxExplanationStringLines,
        enableInteractiveSelection: widget.selectableText!,
        style: theme.textTheme.titleMedium!.copyWith(
          color: widget.enableExplanationWrapper!
              ? theme.colorScheme.onSurface
              : textColor,
        ),
      ),
    );
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      child: widget.padExplanation!
          ? AnimatedPadding(
              duration: standardDuration,
              curve: standardCurve,
              padding: !widget.enableExplanationWrapper!
                  ? EdgeInsets.zero
                  : explanationPadding,
              child: explanationContainer,
            )
          : explanationContainer,
    );
  }

  BoxDecoration get containerDecoration => BoxDecoration(
        color: isTapped
            ? backgroundColor.applySurfaceTint(
                surfaceTintColor: theme.colorScheme.surfaceVariant,
                elevation: elevation * 4,
              )
            : backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(widget.cornerRadius ?? radius),
        ),
        boxShadow: (widget.showShadow! || widget.elevation != null) && isTapped
            ? [
                BoxShadow(
                  color: (widget.shadowColor ?? theme.colorScheme.surface)
                      .applySurfaceTint(
                    surfaceTintColor:
                        surfaceTintColor ?? theme.colorScheme.surfaceVariant,
                    elevation: elevation * 2,
                  ),
                  blurStyle: BlurStyle.outer,
                  blurRadius: (widget.elevation ?? radius),
                  spreadRadius: (widget.elevation ?? radius) / 2,
                )
              ]
            : null,
      );

  BoxDecoration get subtitleDecoration => widget.enableSubtitleWrapper!
      ? BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius - gap),
        )
      : const BoxDecoration();

  BoxDecoration get explanationDecoration => widget.enableExplanationWrapper!
      ? BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius - gap),
        )
      : const BoxDecoration();

  Widget _buildIcon(IconData iconData) {
    return FaIcon(
      iconData,
      color: textColor,
      size: theme.textTheme.titleLarge!.fontSize,
    );
  }

  EdgeInsets get padding {
    return widget.contentPadding ?? EdgeInsets.all(gap);
  }

  EdgeInsets get firstRowPadding {
    return hasSubtitle || hasExplanation
        ? padding.copyWith(bottom: 0)
        : padding;
  }

  EdgeInsets get leadingPadding {
    return hasTitle
        ? hasSubtitle || hasExplanation
            ? EdgeInsets.only(right: padding.right)
            : widget.responsiveWidth!
                ? EdgeInsets.only(right: padding.right)
                : EdgeInsets.only(
                    right: padding.right,
                    left: padding.left / 2,
                  )
        : EdgeInsets.zero;
  }

  EdgeInsets get trailingPadding {
    return hasWidgetOrElement(widget.subtitle, widget.subtitleString)
        ? hasSubtitle || hasExplanation
            ? EdgeInsets.only(right: padding.right)
            : widget.responsiveWidth!
                ? EdgeInsets.only(right: padding.right)
                : EdgeInsets.only(
                    right: padding.right,
                    left: padding.left / 2,
                  )
        : EdgeInsets.zero;
  }

  EdgeInsets get explanationPadding =>
      widget.explanationPadding ??
      (widget.padExplanation! ? padding : EdgeInsets.zero);

  EdgeInsets get subtitlePadding => widget.padSubtitle!
      ? hasExplanation
          ? padding.copyWith(bottom: 0)
          : padding
      : EdgeInsets.zero;
}
