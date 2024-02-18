import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../extensions/widget_extensions.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class EditEmailTile extends ConsumerStatefulWidget {
  const EditEmailTile({super.key});

  @override
  ConsumerState<EditEmailTile> createState() => _EditEmailTileState();
}

class _EditEmailTileState extends ConsumerState<EditEmailTile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final currentEmail = FirebaseAuth.instance.currentUser!.email;
  static final textEditingControllerProvider =
      StateProvider<TextEditingController>((ref) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    bool useSmallerNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    // TODO: user should confirm email before updating
    return CustomListTile(
      showShadow: false,
      useSmallerNavigationSetting: !useSmallerNavigationElements,
      enableExplanationWrapper: !useSmallerNavigationElements,
      titleString: 'Email',
      subtitle: Row(
        children: [
          Expanded(
            child: TextFormField(
              enableInteractiveSelection: true,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              controller: ref.watch(textEditingControllerProvider),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: gap),
                hintText: currentEmail,
                hintStyle: context.theme.textTheme.titleLarge,
              ),
              style: context.theme.textTheme.titleLarge!.copyWith(
                color: useSmallerNavigationElements
                    ? context.theme.colorScheme.onSurface
                    : context.theme.colorScheme.onSurfaceVariant,
              ),
              onChanged: handleSubmitted,
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: ref.watch(textEditingControllerProvider),
            builder: (context, value, child) {
              return IconButton(
                color: context.theme.colorScheme.primary,
                icon: const FaIcon(
                  FontAwesomeIcons.check,
                ),
                onPressed: canUpdateStringValue(value.text, currentEmail)
                    ? handlePressed
                    : null,
              ).animateSlideInFromBottom();
            },
          ),
        ],
      ),
      // subtitle: Form(
      //   key: _formKey,
      //   child: Column(
      //     children: [
      //       TextFormField(
      //         controller: _emailController,
      //         decoration: InputDecoration(
      //           contentPadding: EdgeInsets.zero,
      //           // hintText: currentUser.email ?? 'What is your email address?',
      //           hintStyle: context.theme.textTheme.titleLarge,
      //           helperStyle: context.theme.textTheme.bodyMedium!.copyWith(
      //             color: context.theme.colorScheme.secondary,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         style: context.theme.textTheme.titleLarge,
      //         validator: (String? email) => validated.isEmail('$email')
      //             ? null
      //             : 'Please enter a valid email address.',
      //       ),
      //       SizedBox(height: gap),
      //       CustomListTile(
      //         responsiveWidth: true,
      //         cornerRadius: radius,
      //         contentPadding: EdgeInsets.symmetric(
      //           horizontal: gap * 2,
      //           vertical: gap,
      //         ),
      //         titleString: 'Save Email',
      //         leadingIconData: FontAwesomeIcons.solidFloppyDisk,
      //         onTap: () {
      //           if (_formKey.currentState!.validate()) {
      //             logger.i(
      //               _emailController.text,
      //             );
      //             currentUser
      //                 .reauthenticateWithCredential(
      //                   EmailAuthProvider.credential(
      //                     email: currentUser.email!,
      //                     password: currentUser.email!,
      //                   ),
      //                 )
      //                 .then(
      //                   (UserCredential authenticatedUserCredentials) =>
      //                       authenticatedUserCredentials.user!
      //                           .verifyBeforeUpdateEmail(_emailController.text)
      //                           .then(
      //                     (_) {
      //                       logger.i(
      //                         '$currentUser',
      //                       );
      //                       return ScaffoldMessenger.of(context).showSnackBar(
      //                         SnackBar(
      //                           duration: 6.seconds,
      //                           content: CustomListTile(
      //                             backgroundColor:
      //                                 context.theme.colorScheme.secondary,
      //                             title: Text(
      //                               'Your email has been updated.',
      //                               style: context.theme.textTheme.bodyLarge!
      //                                   .copyWith(
      //                                 color:
      //                                     context.theme.colorScheme.onSecondary,
      //                               ),
      //                             ),
      //                             contentPadding: EdgeInsets.symmetric(
      //                               vertical: gap,
      //                               horizontal: gap * 2,
      //                             ),
      //                             cornerRadius: radius,
      //                           ),
      //                         ),
      //                       );
      //                     },
      //                   ).onError(
      //                     (error, stackTrace) {
      //                       logger.i(
      //                         '$currentUser',
      //                       );
      //                       return ScaffoldMessenger.of(context).showSnackBar(
      //                         SnackBar(
      //                           duration: 6.seconds,
      //                           content: CustomListTile(
      //                             backgroundColor:
      //                                 context.theme.colorScheme.error,
      //                             textColor: context.theme.colorScheme.onError,
      //                             titleString: 'Something went wrong!',
      //                             explanationString: error.toString(),
      //                             contentPadding: EdgeInsets.symmetric(
      //                               vertical: gap,
      //                               horizontal: gap * 2,
      //                             ),
      //                             cornerRadius: radius,
      //                           ),
      //                         ),
      //                       );
      //                     },
      //                   ),
      //                 );
      //           }
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  void handleSubmitted(String value) {
    ref.read(textEditingControllerProvider.notifier).state.text = value.trim();
    logger.i(
      'textEditingControllerProvider: ${ref.read(textEditingControllerProvider)}',
    );
  }

  Future<void> handlePressed() async {
    String msg = '';
    try {
      msg = 'Email updated successfully';
      currentUser
          .reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: currentUser.email!,
              password: currentUser.email!,
            ),
          )
          .then(
            (UserCredential authenticatedUserCredentials) =>
                authenticatedUserCredentials.user!.verifyBeforeUpdateEmail(
                    ref.read(textEditingControllerProvider).text),
          )
          .onError(
        (error, stackTrace) {
          msg = 'Failed to update email with error: $error';
          logger.e(msg);
          logger.e(stackTrace);
        },
      );
      // await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(
      //     ref.read(textEditingControllerProvider).text);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      ref.read(textEditingControllerProvider).clear();
      logger.i(ref.read(textEditingControllerProvider));
    } on FirebaseException catch (e) {
      msg = 'Failed to update email with error: ${e.message}';
      logger.e(msg);
    } catch (e) {
      msg = 'An unexpected error occurred: $e';
      logger.e(msg);
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}
