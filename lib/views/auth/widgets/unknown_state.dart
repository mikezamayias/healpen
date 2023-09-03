import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class UnknownState extends StatelessWidget {
  final AuthState state;

  const UnknownState({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTile(
          leadingIconData: FontAwesomeIcons.solidCircleQuestion,
          selectableText: true,
          backgroundColor: context.theme.colorScheme.tertiary,
          textColor: context.theme.colorScheme.onTertiary,
          titleString: 'Unknown state',
          subtitleString: '${state.runtimeType}',
        ),
        SizedBox(height: gap),
        CustomListTile(
          responsiveWidth: true,
          leadingIconData: FontAwesomeIcons.arrowLeft,
          selectableText: true,
          // backgroundColor: context.theme.colorScheme.error,
          // textColor: context.theme.colorScheme.onError,
          titleString: 'Go back',
          onTap: () => context.navigator.pushReplacementNamed('/auth'),
        ),
      ],
    );
  }
}
