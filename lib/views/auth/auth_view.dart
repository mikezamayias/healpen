import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/page_controller.dart' as page_controller;
import '../../providers/custom_auth_provider.dart';
import '../../utils/helper_functions.dart';
import '../../utils/logger.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/auth_failed_state.dart';
import 'widgets/awaiting_dynamic_link_state.dart';
import 'widgets/sending_link_state.dart';
import 'widgets/signing_in_state.dart';
import 'widgets/uninitialized_state.dart';
import 'widgets/unknown_state.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder<EmailLinkAuthController>(
      provider: ref.read(CustomAuthProvider().emailLinkAuthProvider),
      listener: (oldState, newState, ctrl) {
        if (newState is SignedIn) {
          pushWithAnimation(
            context: context,
            widget: page_controller.PageController().authWrapper.widget,
            replacement: true,
            dataCallback: null,
          );
        }
      },
      builder: (
        BuildContext context,
        AuthState state,
        EmailLinkAuthController authController,
        Widget? _,
      ) {
        logger.i(
          '${state.runtimeType}',
        );
        logger.i(
          '${FirebaseAuth.instance.currentUser}',
        );
        return BlueprintView(
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.surface,
            pathNames: [
              page_controller.PageController().authView.titleGenerator(
                  FirebaseAuth.instance.currentUser?.displayName),
            ],
            automaticallyImplyLeading: false,
          ),
          body: switch (state.runtimeType) {
            const (Uninitialized) => const UninitializedState(),
            const (SendingLink) => const SendingLinkState(),
            const (AwaitingDynamicLink) => const AwaitingDynamicLinkState(),
            const (SignedIn) ||
            const (SigningIn) ||
            const (UserCreated) ||
            const (CredentialLinked) ||
            const (CredentialReceived) =>
              const SigningInState(),
            const (AuthFailed) => AuthFailedState(state: state),
            _ => UnknownState(state: state)
          },
        );
      },
    );
  }
}
