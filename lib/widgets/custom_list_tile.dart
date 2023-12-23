import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/settings_providers.dart';
import '../utils/constants.dart';

class CustomListTile extends ConsumerStatefulWidget {
  final String? titleString, explanationString, subtitleString;
  final int? maxExplanationStringLines;
  final Widget? title, subtitle, leading, trailing;
  final IconData? leadingIconData, trailingIconData;
  final GestureTapCallback? onTap, trailingOnTap, leadingOnTap;
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
  final Color? backgroundColor, textColor, shadowColor;
  final double? cornerRadius;
  final EdgeInsets? contentPadding, subtitlePadding;

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
    this.trailingOnTap,
    this.leadingOnTap,
    this.backgroundColor,
    this.textColor,
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
    this.contentPadding,
    this.subtitlePadding,
    this.showShadow = false,
    this.shadowColor,
  });

  @override
  ConsumerState<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends ConsumerState<CustomListTile> {
  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.isDisabled! ? () {} : widget.onTap,
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

  Color get backgroundColor =>
      widget.backgroundColor ??
      (widget.onTap != null
          ? widget.isDisabled!
              ? theme.colorScheme.outline
              : theme.colorScheme.primary
          : theme.colorScheme.surfaceVariant);

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
          onTap: widget.leadingOnTap,
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
          onTap: widget.trailingOnTap,
          child: widget.trailing ?? _buildIcon(widget.trailingIconData!),
        ),
      );

  Widget get subtitle => AnimatedPadding(
        duration: standardDuration,
        curve: standardCurve,
        padding: widget.padSubtitle! ? padding : EdgeInsets.zero,
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

  Widget get explanation => AnimatedPadding(
        duration: standardDuration,
        curve: standardCurve,
        padding:
            useSmallerNavigationElements && !widget.enableExplanationWrapper!
                ? EdgeInsets.zero
                : padding,
        child: AnimatedContainer(
          duration: standardDuration,
          curve: standardCurve,
          padding:
              useSmallerNavigationElements && !widget.enableExplanationWrapper!
                  ? explanationPadding.copyWith(top: 0)
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
        ),
      );

  BoxDecoration get containerDecoration => BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(widget.cornerRadius ?? radius),
        ),
        boxShadow: widget.showShadow!
            ? [
                BoxShadow(
                  color: widget.shadowColor ?? theme.colorScheme.shadow,
                  blurRadius: 6,
                  offset: const Offset(0, 0),
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
      widget.padExplanation! ? padding : EdgeInsets.zero;
}
