import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../extensions/widget_extensions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class SimpleAppBar extends StatelessWidget {
  final bool? automaticallyImplyLeading;
  final Widget? appBarLeading;
  final String? appBarTitleString;
  final Widget? appBarTrailing;
  final EdgeInsets? appBarPadding;
  final Widget? belowRowWidget;

  const SimpleAppBar({
    super.key,
    this.automaticallyImplyLeading = true,
    this.appBarLeading,
    this.appBarTitleString,
    this.appBarTrailing,
    this.appBarPadding,
    this.belowRowWidget,
  });

  @override
  Widget build(BuildContext context) {
    final padding = appBarPadding ?? EdgeInsets.all(radius);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SafeArea(
            bottom: false,
            child: AnimatedContainer(
              duration: standardDuration,
              curve: standardCurve,
              padding: padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (automaticallyImplyLeading!)
                    Padding(
                      padding: EdgeInsets.only(right: radius),
                      child: CustomListTile(
                        responsiveWidth: true,
                        contentPadding: EdgeInsets.all(radius),
                        leadingIconData: FontAwesomeIcons.arrowLeft,
                        onTap: context.navigator.pop,
                      ),
                    ),
                  if (appBarLeading != null)
                    if (appBarTrailing == null)
                      buildAppBarLeading()
                    else
                      Flexible(child: buildAppBarLeading()),
                  if (appBarTitleString != null)
                    Expanded(
                      child: Text(
                        appBarTitleString!,
                        style: context.theme.textTheme.headlineSmall,
                        softWrap: true,
                      ),
                    ),
                  if (appBarTrailing != null)
                    Padding(
                      padding: EdgeInsets.only(left: radius),
                      child: appBarTrailing!,
                    ),
                ],
              ).animateSlideInFromTop(),
            ),
          ),
        ),
        if (belowRowWidget != null)
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: padding.vertical / 2),
              child: belowRowWidget!,
            ),
          ).animateSlideInFromRight(),
      ],
    );
  }

  Padding buildAppBarLeading() {
    return Padding(
      padding: appBarTitleString != null
          ? EdgeInsets.only(right: radius)
          : EdgeInsets.zero,
      child: appBarLeading!,
    );
  }
}
