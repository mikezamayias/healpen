import 'package:flutter/material.dart';
import 'package:magic_sdk/magic_sdk.dart';

import 'views/login/login_view.dart';

class LoginViewWrapper extends StatelessWidget {
  const LoginViewWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const LoginView(),
        Magic.instance.relayer,
      ],
    );
  }
}
