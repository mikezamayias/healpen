import 'dart:developer';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../providers/custom_auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import '../onboarding/onboarding_view.dart';
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
  void goBack() {
    context.navigator.pushReplacement(
      PageRouteBuilder(
        transitionDuration: emphasizedDuration,
        reverseTransitionDuration: emphasizedDuration,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: Tween<double>(
            begin: -1,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailLinkProvider = ref.watch(
      CustomAuthProvider().emailLinkAuthProvider,
    );
    return AuthFlowBuilder<EmailLinkAuthController>(
      provider: emailLinkProvider,
      listener: (oldState, newState, ctrl) {
        // TODO: check if the following implementation is correct
        // documentation mentions only the SignedIn check
        if (newState is SignedIn ||
            newState is UserCreated ||
            newState is CredentialLinked ||
            newState is CredentialReceived) {
          context.navigator.pushReplacementNamed('/healpen');
        }
      },
      builder: (
        BuildContext context,
        AuthState state,
        EmailLinkAuthController authController,
        Widget? _,
      ) {
        log(
          '${state.runtimeType}',
          name: 'AuthView:state',
        );
        return WillPopScope(
          onWillPop: () {
            goBack();
            return Future.value(true);
          },
          child: BlueprintView(
            appBar: AppBar(
                pathNames: const ['Sign in with magic link'],
                automaticallyImplyLeading: true,
                onBackButtonPressed: goBack),
            body: Center(
              child: switch (state.runtimeType) {
                Uninitialized => const UninitializedState(),
                SendingLink => const SendingLinkState(),
                AwaitingDynamicLink => const AwaitingDynamicLinkState(),
                SigningIn => const SigningInState(),
                AuthFailed => AuthFailedState(state: state),
                _ => UnknownState(state: state)
              },
            ),
          ),
        );
      },
    );
  }
}
