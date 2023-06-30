import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:magic_sdk/magic_sdk.dart';

import '../../healpen.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {
  final magic = Magic.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  loginFunction({required String email}) {
    magic.auth
        .loginWithEmailOTP(email: _emailController.text)
        .then((String value) {
      log(value, name: 'LoginViewState:loginFunction:token');
      context.navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Healpen(),
        ),
      );
    }).catchError((error) {
      log(error, name: 'LoginViewState:loginFunction:error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in using a one-time password',
              style: context.theme.textTheme.headlineSmall,
            ),
            SizedBox(height: gap),
            CustomListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: gap * 2,
                vertical: gap,
              ),
              leadingIconData: FontAwesomeIcons.solidEnvelope,
              title: TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    contentPadding: EdgeInsets.zero),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  return null;
                },
                controller: _emailController,
              ),
            ),
            SizedBox(height: gap),
            CustomListTile(
              responsiveWidth: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: gap * 2,
                vertical: gap,
              ),
              leadingIconData: FontAwesomeIcons.solidPaperPlane,
              titleString: 'Send email',
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  debugPrint('Email: ${_emailController.text}');
                  loginFunction(
                    email: _emailController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.all(gap * 2),
                      content: CustomListTile(
                        backgroundColor: context.theme.colorScheme.secondary,
                        textColor: context.theme.colorScheme.onSecondary,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: gap * 2,
                          vertical: gap,
                        ),
                        titleString: 'Please check your email for the OTP',
                      ),
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
