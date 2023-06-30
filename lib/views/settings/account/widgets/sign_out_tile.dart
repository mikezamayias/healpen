import 'dart:developer';

import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:magic_sdk/magic_sdk.dart';

import '../../../../login_view_wrapper.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile/custom_list_tile.dart';

class SignOutTile extends StatefulWidget {
  const SignOutTile({
    super.key,
  });

  @override
  State<SignOutTile> createState() => _SignOutTileState();
}

class _SignOutTileState extends State<SignOutTile> {
  signOut() {
    Magic.instance.user.logout().then((bool authResult) {
      log('$authResult', name: '_LoginViewState:loginFunction:authResult');
      context.navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginViewWrapper(),
        ),
      );
    }).catchError(
      (e) {
        log('$e', name: '_LoginViewState:loginFunction:catch');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: gap,
      ),
      titleString: 'Sign out',
      leadingIconData: FontAwesomeIcons.rightFromBracket,
      onTap: signOut,

      /// The code below works for Firebase Authentication
      // onTap: () async {
      //   User user = FirebaseAuth.instance.currentUser!;
      //   log('$user', name: 'Signing out user');
      //   FirebaseAuth.instance.signOut().onError(
      //     (error, stackTrace) {
      //       log('$error', name: 'Error signing out user');
      //       showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return CustomDialog(
      //             titleString: 'Error signing out',
      //             contentString: 'Please try again later.',
      //             actions: [
      //               CustomListTile(
      //                 onTap: () => context.navigator.pop(),
      //                 titleString: 'OK',
      //               ),
      //             ],
      //           );
      //         },
      //       );
      //     },
      //   ).then(
      //     (_) {
      //       ref.read(currentPageProvider.notifier).state =
      //           PageController().writing;
      //       return context.navigator
      //           .pushReplacement(
      //             MaterialPageRoute(
      //               builder: (context) => const AuthView(),
      //             ),
      //           )
      //           .whenComplete(
      //             () async => await HapticFeedback.heavyImpact(),
      //           );
      //     },
    );
  }
}
