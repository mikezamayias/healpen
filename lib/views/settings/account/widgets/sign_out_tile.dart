import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide PageController;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../controllers/page_controller.dart';
import '../../../../providers/page_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile/custom_list_tile.dart';
import '../../../auth/auth_view.dart';

class SignOutTile extends ConsumerWidget {
  const SignOutTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: 12,
      ),
      titleString: 'Sign out',
      leadingIconData: FontAwesomeIcons.rightFromBracket,
      onTap: () async {
        User user = FirebaseAuth.instance.currentUser!;
        log('$user', name: 'Signing out user');
        FirebaseAuth.instance.signOut().onError(
          (error, stackTrace) {
            log('$error', name: 'Error signing out user');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                  titleString: 'Error signing out',
                  contentString: 'Please try again later.',
                  actions: [
                    CustomListTile(
                      onTap: () => context.navigator.pop(),
                      titleString: 'OK',
                    ),
                  ],
                );
              },
            );
          },
        ).then(
          (_) {
            ref.read(currentPageProvider.notifier).state =
                PageController().writing;
            return context.navigator
                .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AuthView(),
                  ),
                )
                .whenComplete(
                  () async => await HapticFeedback.heavyImpact(),
                );
          },
        );
      },
    );
  }
}
