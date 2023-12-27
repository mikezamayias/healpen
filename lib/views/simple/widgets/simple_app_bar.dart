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
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (automaticallyImplyLeading!)
                  CustomListTile(
                    responsiveWidth: true,
                    contentPadding: EdgeInsets.all(radius),
                    leadingIconData: FontAwesomeIcons.arrowLeft,
                    onTap: context.navigator.pop,
                  ),
                if (appBarLeading != null)
                  appBarTrailing == null
                      ? buildAppBarLeading()
                      : Flexible(child: buildAppBarLeading()),
                if (appBarTitleString != null)
                  Expanded(
                    child: Text(
                      appBarTitleString!,
                      style: context.theme.textTheme.headlineSmall,
                      softWrap: true,
                    ),
                  ),
                if (appBarTrailing != null) appBarTrailing!,
              ].addSpacer(SizedBox(width: radius)),
            ),
          ),
          if (belowRowWidget != null) belowRowWidget!,
        ].addSpacer(SizedBox(height: radius)),
      ),
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
