import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class AuthFailedState extends ConsumerWidget {
  final AuthState state;

  const AuthFailedState({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseCrashlytics.instance.recordError(
      (state as AuthFailed).exception,
      StackTrace.current,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTile(
          leadingIconData: FontAwesomeIcons.circleExclamation,
          selectableText: true,
          backgroundColor: context.theme.colorScheme.error,
          textColor: context.theme.colorScheme.onError,
          titleString: 'Something went wrong',
          explanationString:
              '${(state as AuthFailed).exception}'.split('] ').last,
        ),
        SizedBox(height: gap),
        CustomListTile(
          responsiveWidth: true,
          leadingIconData: FontAwesomeIcons.arrowLeft,
          selectableText: true,
          // backgroundColor: context.theme.colorScheme.error,
          // textColor: context.theme.colorScheme.onError,
          titleString: 'Go back',
          onTap: () {
            vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
              context.navigator.pushReplacementNamed('/auth');
            });
          },
        ),
      ],
    );
  }
}
