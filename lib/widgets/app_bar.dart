import 'package:flutter/material.dart' hide AppBar, Page;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/page_model.dart';
import '../extensions/string_extensions.dart';
import '../utils/constants.dart' as constants;

class AppBar extends StatelessWidget {
  final Icon? icon;
  final String? titleString;
  final Widget? trailingWidget;
  final Widget? widget;
  final Color? color;
  final bool? flag;
  final PageModel pageModel;

  const AppBar({
    Key? key,
    required this.pageModel,
    this.titleString,
    this.icon,
    this.widget,
    this.color,
    this.flag = false,
    this.trailingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      clipBehavior: Clip.none,
      color: color ?? context.theme.colorScheme.background,
      // shadowColor: context.theme.colorScheme.shadow,
      // elevation: constants.radius,
      borderRadius: BorderRadius.all(Radius.circular(constants.radius)),
      child: widget ??
          AnimatedContainer(
            height: 15.h,
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.symmetric(
              horizontal: constants.gap * 2,
              vertical: constants.gap,
            ),
            duration: constants.duration,
            curve: constants.curve,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: constants.gap,
                  ),
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    backgroundColor: flag == null || flag!
                        ? context.theme.colorScheme.tertiary
                        : context.theme.colorScheme.surfaceVariant,
                    radius: context.theme.textTheme.headlineSmall!.fontSize,
                    child: FaIcon(
                      pageModel.icon,
                      color: flag == null || flag!
                          ? context.theme.colorScheme.secondaryContainer
                          : context.theme.colorScheme.primary,
                      size: context.theme.textTheme.headlineSmall!.fontSize,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    titleString ?? pageModel.label.toTitleCase(),
                    style: context.theme.textTheme.headlineMedium!.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
