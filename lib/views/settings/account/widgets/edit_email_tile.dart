import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validated/validated.dart' as validated;

import '../../../../widgets/custom_list_tile/custom_list_tile.dart';

class EditEmailTile extends StatefulWidget {
  const EditEmailTile({Key? key}) : super(key: key);

  @override
  State<EditEmailTile> createState() => _EditEmailTileState();
}

class _EditEmailTileState extends State<EditEmailTile> {
  final currentUserEmailAddress = FirebaseAuth.instance.currentUser?.email;
  final emailController = TextEditingController();
  bool readOnlyEmailTextField = true;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      titleString: 'Email',
      subtitle: TextFormField(
        enabled: !readOnlyEmailTextField,
        controller: emailController,
        readOnly: readOnlyEmailTextField,
        decoration: InputDecoration(
          fillColor: readOnlyEmailTextField
              ? context.theme.colorScheme.outline
              : Colors.white,
          hintText: currentUserEmailAddress,
          hintStyle: context.theme.textTheme.titleLarge,
          helperText: readOnlyEmailTextField
              ? 'Press the icon to edit your email'
              : 'You are editing your email',
          helperStyle: context.theme.textTheme.bodyMedium!.copyWith(
            color: context.theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: context.theme.textTheme.titleLarge,
        validator: (String? email) => validated.isEmail('$email')
            ? null
            : 'Please enter a valid email address.',
        onChanged: (String email) {
          log(email, name: 'email');
        },
        onFieldSubmitted: (String email) {
          log('$readOnlyEmailTextField', name: 'readOnlyEmailTextField');
          setState(() {
            readOnlyEmailTextField = !readOnlyEmailTextField;
          });
        },
      ),
      trailingIconData: FontAwesomeIcons.penToSquare,
      textColor: readOnlyEmailTextField
          ? context.theme.colorScheme.outline
          : context.theme.colorScheme.primary,
      trailingOnTap: () async {
        await HapticFeedback.heavyImpact();
        log('$readOnlyEmailTextField', name: 'readOnlyEmailTextField');
        setState(() {
          readOnlyEmailTextField = !readOnlyEmailTextField;
        });
      },
    );
  }
}
