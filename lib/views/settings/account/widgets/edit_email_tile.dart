import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validated/validated.dart' as validated;

import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile/custom_list_tile.dart';

class EditEmailTile extends StatefulWidget {
  const EditEmailTile({Key? key}) : super(key: key);

  @override
  State<EditEmailTile> createState() => _EditEmailTileState();
}

class _EditEmailTileState extends State<EditEmailTile> {
  final currentUserEmailAddress = FirebaseAuth.instance.currentUser?.email;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      titleString: 'Email',
      subtitle: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText:
                    currentUserEmailAddress ?? 'What is your email address?',
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
              titleString: 'Save Email',
              cornerRadius: radius,
              contentPadding: EdgeInsets.symmetric(
                vertical: gap,
                horizontal: gap * 2,
              ),
              leadingIconData: FontAwesomeIcons.solidFloppyDisk,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  log(
                    _emailController.text,
                    name: '_LoginViewState:build:email',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: 6.seconds,
                      backgroundColor: Colors.transparent,
                      content: CustomListTile(
                        backgroundColor: context.theme.colorScheme.secondary,
                        title: Text(
                          'Your email has been updated.',
                          style: context.theme.textTheme.bodyLarge!.copyWith(
                            color: context.theme.colorScheme.onSecondary,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: gap,
                          horizontal: gap * 2,
                        ),
                        cornerRadius: radius,
                      ),
                      padding: EdgeInsets.all(gap * 2),
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
