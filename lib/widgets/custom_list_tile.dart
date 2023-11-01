import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/settings/preferences_controller.dart';
import '../providers/settings_providers.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

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
  final bool? padExplanation;
  final bool? enableExplanationWrapper;
  final Color? backgroundColor;
  final Color? textColor;
  final double? cornerRadius;
  final EdgeInsetsGeometry? contentPadding;

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
    this.cornerRadius,
    this.contentPadding,
  });

  @override
  ConsumerState<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends ConsumerState<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    final padding = widget.contentPadding ?? EdgeInsets.all(gap);
    final listTile = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize:
          widget.expandSubtitle! ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.leading != null ||
            widget.leadingIconData != null ||
            widget.title != null ||
            widget.titleString != null ||
            widget.trailing != null ||
            widget.trailingIconData != null)
          Padding(
            padding: EdgeInsets.only(
              top: padding.vertical / 2,
              bottom: padding.vertical / 2,
              left: padding.horizontal / 2,
              right: padding.horizontal / 2,
            ),
            child: Row(
              children: [
                if (widget.leading != null || widget.leadingIconData != null)
                  Padding(
                    padding:
                        (widget.title != null || widget.titleString != null)
                            ? padding.horizontal == 0
                                ? EdgeInsets.only(right: gap)
                                : EdgeInsets.only(right: padding.horizontal / 2)
                            : EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: widget.leadingOnTap,
                      child: Animate(
                        effects: widget.showcaseLeadingIcon!
                            ? [
                                ShakeEffect(
                                  delay: 1.seconds,
                                  curve: emphasizedCurve,
                                  duration: 6.seconds,
                                  hz: 1,
                                  offset: const Offset(0, 3),
                                ),
                                ShakeEffect(
                                  delay: 2.seconds,
                                  curve: emphasizedCurve,
                                  duration: 6.seconds,
                                  hz: 1,
                                  offset: const Offset(3, 0),
                                ),
                              ]
                            : null,
                        onInit: widget.showcaseLeadingIcon!
                            ? (_) async {
                                if (!PreferencesController
                                    .navigationShowInfoButtons.value) {
                                  await Future.delayed(
                                    1.seconds,
                                    HapticFeedback.vibrate,
                                  );
                                }
                              }
                            : null,
                        child: widget.leading ??
                            FaIcon(
                              widget.leadingIconData!,
                              color: widget.textColor ??
                                  (widget.leadingOnTap != null
                                      ? context.theme.colorScheme.primary
                                      : widget.onTap == null
                                          ? context.theme.colorScheme
                                              .onSurfaceVariant
                                          : context
                                              .theme.colorScheme.onPrimary),
                              size:
                                  context.theme.textTheme.titleLarge!.fontSize,
                            ),
                      ),
                    ),
                  ),
                if (widget.title != null || widget.titleString != null)
                  Expanded(
                    child: widget.title ??
                        Text(
                          widget.titleString!,
                          style: context.theme.textTheme.titleLarge!.copyWith(
                            color: widget.textColor ??
                                (widget.onTap == null
                                    ? context.theme.colorScheme.onSurfaceVariant
                                    : context.theme.colorScheme.onPrimary),
                          ),
                        ),
                  ),
                if (widget.trailing != null || widget.trailingIconData != null)
                  Padding(
                    padding:
                        (widget.title != null || widget.titleString != null)
                            ? EdgeInsets.only(left: padding.horizontal / 2)
                            : EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: widget.trailingOnTap,
                      child: widget.trailing ??
                          (widget.trailingOnTap != null
                              ? FaIcon(
                                  widget.trailingIconData!,
                                  color: widget.textColor ??
                                      context.theme.colorScheme.primary,
                                  size: context
                                      .theme.textTheme.titleLarge!.fontSize,
                                )
                              : FaIcon(
                                  widget.trailingIconData!,
                                  color: widget.textColor ??
                                      (widget.onTap == null
                                          ? context.theme.colorScheme
                                              .onSurfaceVariant
                                          : context
                                              .theme.colorScheme.onPrimary),
                                  size: context
                                      .theme.textTheme.titleLarge!.fontSize,
                                )),
                    ),
                  ),
              ],
            ),
          )
        else
          SizedBox(height: padding.vertical / 2),
        if (widget.subtitle != null || widget.subtitleString != null)
          Flexible(child: _buildSubtitle()),
        if (widget.explanationString != null) _buildExplanation(),
      ],
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap != null
          ? () {
              vibrate(
                ref.watch(navigationEnableHapticFeedbackProvider),
                widget.onTap!,
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ??
              (widget.onTap == null
                  ? context.theme.colorScheme.surfaceVariant
                  : context.theme.colorScheme.primary),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.cornerRadius ?? radius),
          ),
        ),
        child: switch (widget.responsiveWidth) {
          true => IntrinsicWidth(child: listTile),
          _ => listTile,
        },
      ),
    );
  }

  Widget _buildExplanation() {
    return AnimatedContainer(
      duration: standardDuration,
      curve: standardCurve,
      padding: widget.padExplanation!
          ? EdgeInsets.only(
              bottom: gap,
              left: gap,
              right: gap,
            )
          : EdgeInsets.only(bottom: gap),
      child: AnimatedContainer(
        duration: standardDuration,
        curve: standardCurve,
        padding: widget.enableExplanationWrapper! &&
                ref.watch(navigationSmallerNavigationElementsProvider)
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
            color: widget.enableExplanationWrapper! || widget.onTap == null
                ? context.theme.colorScheme.onSurfaceVariant
                : context.theme.colorScheme.onPrimary,
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
        padding: widget.enableSubtitleWrapper!
            ? !ref.watch(navigationSmallerNavigationElementsProvider)
                ? EdgeInsets.all(gap)
                : EdgeInsets.zero
            : EdgeInsets.zero,
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
                  color: widget.enableSubtitleWrapper! || widget.onTap == null
                      ? context.theme.colorScheme.onSurfaceVariant
                      : context.theme.colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }
}
