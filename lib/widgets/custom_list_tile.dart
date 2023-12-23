import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/settings_providers.dart';
import '../utils/constants.dart';

class CustomListTile extends ConsumerStatefulWidget {
  final String? titleString;
  final String? explanationString;
  final int? maxExplanationStringLines;
  final String? subtitleString;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final IconData? leadingIconData;
  final IconData? trailingIconData;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final GestureTapCallback? trailingOnTap;
  final GestureTapCallback? leadingOnTap;
  final bool? selectableText;
  final bool? responsiveWidth;
  final bool? showcaseLeadingIcon;
  final bool? enableSubtitleWrapper;
  final bool? expandSubtitle;
  final bool? padSubtitle;
  final bool? useSmallerNavigationSetting;
  final bool? padExplanation;
  final bool? enableExplanationWrapper;
  final Color? backgroundColor;
  final Color? textColor;
  final double? cornerRadius;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? subtitlePadding;
  final bool? showShadow;
  final Color? shadowColor;

  const CustomListTile({
    super.key,
    this.titleString,
    this.explanationString,
    this.maxExplanationStringLines,
    this.subtitleString,
    this.leadingIconData,
    this.trailing,
    this.leading,
    this.subtitle,
    this.title,
    this.onTap,
    this.trailingOnTap,
    this.leadingOnTap,
    this.trailingIconData,
    this.backgroundColor,
    this.textColor,
    this.selectableText = false,
    this.responsiveWidth = false,
    this.showcaseLeadingIcon = false,
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
  @override
  Widget build(BuildContext context) {
    final padding = _getPadding();
    final listTile = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize:
          widget.expandSubtitle! ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: standardDuration,
          curve: standardCurve,
          padding: widget.useSmallerNavigationSetting! &&
                  ref.watch(navigationSmallerNavigationElementsProvider)
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  top: widget.subtitle != null || widget.subtitleString != null
                      ? padding.vertical / 4
                      : padding.vertical / 2,
                  left: padding.horizontal / 2,
                  right: padding.horizontal / 2,
                  bottom:
                      widget.subtitle != null || widget.subtitleString != null
                          ? padding.vertical / 4
                          : padding.vertical / 2,
                ),
          child: Row(
            children: [
              _buildLeading(),
              _buildTitle(),
              _buildTrailing(),
            ],
          ),
        ),
        if (widget.subtitle != null || widget.subtitleString != null)
          Flexible(child: _buildSubtitle()),
        if (widget.explanationString != null) _buildExplanation(),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: standardDuration,
        curve: standardCurve,
        decoration: widget.useSmallerNavigationSetting! &&
                ref.watch(navigationSmallerNavigationElementsProvider)
            ? const BoxDecoration()
            : BoxDecoration(
                color: widget.backgroundColor ??
                    (widget.onTap != null
                        ? context.theme.colorScheme.primary
                        : ref.watch(navigationSmallerNavigationElementsProvider)
                            ? context.theme.colorScheme.surface
                            : context.theme.colorScheme.surfaceVariant),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.cornerRadius ?? radius),
                ),
                boxShadow: widget.showShadow!
                    ? [
                        BoxShadow(
                          color: widget.shadowColor ??
                              context.theme.colorScheme.shadow,
                          blurRadius: 6,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null),
        child: widget.responsiveWidth!
            ? IntrinsicWidth(child: listTile)
            : listTile,
      ),
    );
  }

  Color _getTextColor() {
    return widget.textColor ??
        (widget.onTap != null
            ? context.theme.colorScheme.onPrimary
            : ref.watch(navigationSmallerNavigationElementsProvider)
                ? context.theme.colorScheme.onSurface
                : context.theme.colorScheme.onSurfaceVariant);
  }

  EdgeInsetsGeometry _getPadding() {
    return widget.contentPadding ?? EdgeInsets.all(gap);
  }

  Widget _buildLeading() {
    if (widget.leading != null || widget.leadingIconData != null) {
      final padding = _getPadding();
      return Padding(
        padding: (widget.title != null || widget.titleString != null)
            ? padding.horizontal == 0
                ? EdgeInsets.only(right: gap)
                : EdgeInsets.only(right: padding.horizontal / 4)
            : EdgeInsets.zero,
        child: GestureDetector(
          onTap: widget.leadingOnTap,
          child: widget.leading ??
              FaIcon(
                widget.leadingIconData!,
                color: _getTextColor(),
                size: context.theme.textTheme.titleLarge!.fontSize,
              ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTitle() {
    if (widget.title != null || widget.titleString != null) {
      return Expanded(
        child: widget.title ??
            Text(
              widget.titleString!,
              style: context.theme.textTheme.titleLarge!.copyWith(
                color: _getTextColor(),
              ),
            ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTrailing() {
    if (widget.trailing != null || widget.trailingIconData != null) {
      final padding = _getPadding();
      return Padding(
        padding: (widget.title != null || widget.titleString != null)
            ? EdgeInsets.only(left: padding.horizontal / 2)
            : EdgeInsets.zero,
        child: GestureDetector(
          onTap: widget.trailingOnTap,
          child: widget.trailing ??
              FaIcon(
                widget.trailingIconData!,
                color: _getTextColor(),
                size: context.theme.textTheme.titleLarge!.fontSize,
              ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildExplanation() {
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      padding: widget.padExplanation!
          ? widget.useSmallerNavigationSetting! &&
                  ref.watch(navigationSmallerNavigationElementsProvider)
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  bottom: gap,
                  left: gap,
                  right: gap,
                )
          : EdgeInsets.only(bottom: gap),
      child: AnimatedContainer(
        duration: standardDuration,
        curve: standardCurve,
        padding: widget.enableExplanationWrapper! &&
                (widget.useSmallerNavigationSetting! ||
                    ref.watch(navigationSmallerNavigationElementsProvider))
            ? EdgeInsets.all(gap)
            : EdgeInsets.zero,
        decoration: widget.enableExplanationWrapper!
            ? BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.all(
                  Radius.circular(radius - gap),
                ),
              )
            : const BoxDecoration(),
        child: SelectableText(
          widget.explanationString!,
          onTap: widget.onTap,
          maxLines: widget.maxExplanationStringLines,
          enableInteractiveSelection: widget.selectableText!,
          style: TextStyle(
            color: widget.textColor ??
                (widget.onTap != null
                    ? context.theme.colorScheme.onPrimary
                    : widget.enableExplanationWrapper! &&
                            ref.watch(
                                navigationSmallerNavigationElementsProvider)
                        ? context.theme.colorScheme.onSurface
                        : context.theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      padding: widget.padSubtitle!
          ? EdgeInsets.only(
              bottom: gap,
              left: gap,
              right: gap,
            )
          : EdgeInsets.only(bottom: gap),
      child: AnimatedContainer(
        duration: standardDuration,
        curve: standardCurve,
        padding: widget.subtitlePadding,
        decoration: widget.enableSubtitleWrapper!
            ? BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.all(
                  Radius.circular(radius - gap),
                ),
              )
            : const BoxDecoration(),
        child: widget.subtitle != null && widget.subtitleString == null
            ? widget.subtitle!
            : SelectableText(
                widget.subtitleString!,
                onTap: widget.onTap,
                enableInteractiveSelection: widget.selectableText!,
                style: context.theme.textTheme.titleMedium!.copyWith(
                  color: widget.enableSubtitleWrapper! && widget.onTap == null
                      ? ref.watch(navigationSmallerNavigationElementsProvider)
                          ? context.theme.colorScheme.onSurface
                          : context.theme.colorScheme.onSurfaceVariant
                      : context.theme.colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }
}
