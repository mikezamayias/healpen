import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validated/validated.dart' as validated;

import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class EditEmailTile extends ConsumerStatefulWidget {
  const EditEmailTile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditEmailTile> createState() => _EditEmailTileState();
}

class _EditEmailTileState extends ConsumerState<EditEmailTile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _emailController = TextEditingController(
    text: FirebaseAuth.instance.currentUser!.email,
  );
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: user should confirm email before updating
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Email',
      subtitle: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                // hintText: currentUser.email ?? 'What is your email address?',
                hintStyle: context.theme.textTheme.titleLarge,
                helperStyle: context.theme.textTheme.bodyMedium!.copyWith(
                  color: context.theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: context.theme.textTheme.titleLarge,
              validator: (String? email) => validated.isEmail('$email')
                  ? null
                  : 'Please enter a valid email address.',
            ),
            SizedBox(height: gap),
            CustomListTile(
              responsiveWidth: true,
              cornerRadius: radius,
              contentPadding: EdgeInsets.symmetric(
                horizontal: gap * 2,
                vertical: gap,
              ),
              titleString: 'Save Email',
              leadingIconData: FontAwesomeIcons.solidFloppyDisk,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  log(
                    _emailController.text,
                    name: '_LoginViewState:build:email',
                  );
                  currentUser
                      .reauthenticateWithCredential(
                        EmailAuthProvider.credential(
                          email: currentUser.email!,
                          password: currentUser.email!,
                        ),
                      )
                      .then(
                        (value) =>
                            currentUser.updateEmail(_emailController.text).then(
                          (_) {
                            log(
                              '$currentUser',
                              name: '_LoginViewState:build:updateEmail:then',
                            );
                            return ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: 6.seconds,
                                content: CustomListTile(
                                  backgroundColor:
                                      context.theme.colorScheme.secondary,
                                  title: Text(
                                    'Your email has been updated.',
                                    style: context.theme.textTheme.bodyLarge!
                                        .copyWith(
                                      color:
                                          context.theme.colorScheme.onSecondary,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: gap,
                                    horizontal: gap * 2,
                                  ),
                                  cornerRadius: radius,
                                ),
                              ),
                            );
                          },
                        ).onError(
                          (error, stackTrace) {
                            log(
                              '$currentUser',
                              name: '_LoginViewState:build:updateEmail:onError',
                            );
                            return ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: 6.seconds,
                                content: CustomListTile(
                                  backgroundColor:
                                      context.theme.colorScheme.error,
                                  textColor: context.theme.colorScheme.onError,
                                  titleString: 'Something went wrong!',
                                  subtitleString: error.toString(),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: gap,
                                    horizontal: gap * 2,
                                  ),
                                  cornerRadius: radius,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
