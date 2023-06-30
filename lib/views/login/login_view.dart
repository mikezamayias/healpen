import 'dart:developer';

import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:validated/validated.dart' as validate;

import '../../healpen.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String emailAddress = '';
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<String> loginFunction({required String email}) => Magic.instance.auth
          .loginWithEmailOTP(
        email: _emailController.text,
      )
          .then((String authResult) {
        log(authResult, name: '_LoginViewState:loginFunction:authResult');
        context.navigator.pushReplacement(
          MaterialPageRoute(
            builder: (
              context,
            ) {
              log('pushReplacement: Healpen');
              return const Healpen();
            },
          ),
        );
        return authResult;
      }).catchError((error, stackTrace) {
        log('$error', name: '_LoginViewState:loginFunction:catch');
        // showDialog(
        //   context: context,
        //   barrierColor: Colors.transparent,
        //   builder: (context) {
        //     return CustomDialog(
        //       backgroundColor: context.theme.colorScheme.error,
        //       titleString: 'Error',
        //       contentString: '$error',
        //       actions: [
        //         CustomListTile(
        //           responsiveWidth: true,
        //           cornerRadius: radius,
        //           contentPadding: EdgeInsets.symmetric(
        //             vertical: gap,
        //             horizontal: gap * 2,
        //           ),
        //           titleString: 'OK',
        //           onTap: () => context.navigator.pop(),
        //         ),
        //       ],
        //     );
        //   },
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: 2.seconds,
            backgroundColor: Colors.transparent,
            content: CustomListTile(
              backgroundColor: context.theme.colorScheme.error,
              title: Text(
                '${error['message']}',
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  color: context.theme.colorScheme.onError,
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
        return 'An error occurred during login.';
      });

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 42.h,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign in with a\n'
                  'one-time password',
                  style: context.theme.textTheme.headlineLarge!.copyWith(
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: gap),
                CustomListTile(
                  cornerRadius: radius,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: gap * 2,
                    vertical: gap,
                  ),
                  leadingIconData: FontAwesomeIcons.solidEnvelope,
                  title: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (String? value) => validate.isEmail(value ?? '')
                        ? null
                        : 'Please enter a valid email address',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Email',
                      hintStyle: context.theme.textTheme.titleLarge,
                    ),
                    style: context.theme.textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: gap),
                CustomListTile(
                  responsiveWidth: true,
                  titleString: 'Send link',
                  cornerRadius: radius,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: gap,
                    horizontal: gap * 2,
                  ),
                  leadingIconData: FontAwesomeIcons.solidPaperPlane,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      log(
                        _emailController.text,
                        name: '_LoginViewState:build:email',
                      );
                      loginFunction(
                        email: _emailController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: 2.seconds,
                          backgroundColor: Colors.transparent,
                          content: CustomListTile(
                            backgroundColor:
                                context.theme.colorScheme.secondary,
                            title: Text(
                              'Please check your email for the one-time password.',
                              style:
                                  context.theme.textTheme.bodyLarge!.copyWith(
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
        ),
      ),
    );
  }
}
