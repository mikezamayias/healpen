import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class AuthFailedState extends StatelessWidget {
  final AuthState state;

  const AuthFailedState({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomListTile(
            cornerRadius: radius,
            contentPadding: EdgeInsets.symmetric(
              horizontal: gap * 2,
              vertical: gap,
            ),
            leadingIconData: FontAwesomeIcons.circleExclamation,
            selectableText: true,
            backgroundColor: context.theme.colorScheme.error,
            textColor: context.theme.colorScheme.onError,
            titleString: 'Something went wrong',
            subtitleString:
                (state as AuthFailed).exception.toString().split('] ').last,
          ),
          SizedBox(height: gap),
          CustomListTile(
            cornerRadius: radius,
            responsiveWidth: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: gap * 2,
              vertical: gap,
            ),
            leadingIconData: FontAwesomeIcons.arrowLeft,
            selectableText: true,
            // backgroundColor: context.theme.colorScheme.error,
            // textColor: context.theme.colorScheme.onError,
            titleString: 'Go back',
            onTap: () => context.navigator.pushReplacementNamed('/auth'),
          ),
        ],
      ),
    );
  }
}
