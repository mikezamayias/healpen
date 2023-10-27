import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class UnknownState extends StatelessWidget {
  final AuthState state;

  const UnknownState({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: gap * 2,
            vertical: gap,
          ),
          leadingIconData: FontAwesomeIcons.solidCircleQuestion,
          backgroundColor: context.theme.colorScheme.tertiary,
          textColor: context.theme.colorScheme.onTertiary,
          titleString: 'Unknown state',
          selectableText: true,
          enableExplanationWrapper: true,
          explanationString: '${state.runtimeType}',
        ),
        SizedBox(height: gap),
        CustomListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: gap * 2,
            vertical: gap,
          ),
          responsiveWidth: true,
          leadingIconData: FontAwesomeIcons.arrowLeft,
          selectableText: true,
          titleString: 'Go back',
          onTap: () => context.navigator.pushReplacementNamed('/auth'),
        ),
      ],
    );
  }
}
