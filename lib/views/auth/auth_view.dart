import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../providers/custom_auth_provider.dart';
import '../../utils/constants.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/auth_failed_state.dart';
import 'widgets/awaiting_dynamic_link_state.dart';
import 'widgets/sending_link_state.dart';
import 'widgets/signing_in_state.dart';
import 'widgets/uninitialized_state.dart';
import 'widgets/unknown_state.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailLinkProvider = ref.watch(
      CustomAuthProvider().emailLinkAuthProvider,
    );
    return AuthFlowBuilder<EmailLinkAuthController>(
      provider: emailLinkProvider,
      listener: (oldState, newState, ctrl) {
        if (newState is SignedIn ||
            newState is UserCreated ||
            newState is CredentialLinked ||
            newState is CredentialReceived) {
          FirebaseAuth.instance.currentUser!.updatePassword(
            FirebaseAuth.instance.currentUser!.email!,
          );
          context.navigator.pushReplacementNamed('/healpen');
        }
      },
      builder: (
        BuildContext context,
        AuthState state,
        EmailLinkAuthController authController,
        Widget? _,
      ) {
        return BlueprintView(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign in with magic link',
                style: context.theme.textTheme.headlineSmall!.copyWith(
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: gap * 2),
              switch (state.runtimeType) {
                Uninitialized => const UninitializedState(),
                AwaitingDynamicLink => const AwaitingDynamicLinkState(),
                SendingLink => const SendingLinkState(),
                SigningIn => const SigningInState(),
                AuthFailed => AuthFailedState(state: state),
                _ => UnknownState(state: state)
              },
            ],
          ),
        );
      },
    );
  }
}
