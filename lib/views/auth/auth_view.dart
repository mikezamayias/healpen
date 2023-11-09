import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../../controllers/page_controller.dart' as page_controller;
import '../../providers/custom_auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import '../onboarding/onboarding_view.dart';
import 'widgets/auth_failed_state.dart';
import 'widgets/awaiting_dynamic_link_state.dart';
import 'widgets/legal_prompt.dart';
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
        // TODO: check if the following implementation is correct
        // documentation mentions only the SignedIn check
        if (newState is SignedIn) {
          navigator.pushReplacement(
            PageRouteBuilder(
              transitionDuration: emphasizedDuration,
              reverseTransitionDuration: emphasizedDuration,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  page_controller.PageController().authWrapper.widget,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
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
        log(
          '${FirebaseAuth.instance.currentUser}',
          name: 'AuthView',
        );
        return WillPopScope(
          onWillPop: () {
            goBack();
            return Future.value(true);
          },
          child: BlueprintView(
            appBar: AppBar(
              pathNames: [
                page_controller.PageController().authView.titleGenerator(
                    FirebaseAuth.instance.currentUser?.displayName)
              ],
              automaticallyImplyLeading: true,
              onBackButtonPressed: goBack,
            ),
            body: Column(
              children: [
                const Spacer(flex: 3),
                switch (state.runtimeType) {
                  const (Uninitialized) => const UninitializedState(),
                  const (SendingLink) => const SendingLinkState(),
                  const (AwaitingDynamicLink) =>
                    const AwaitingDynamicLinkState(),
                  const (SignedIn) ||
                  const (SigningIn) ||
                  const (UserCreated) ||
                  const (CredentialLinked) ||
                  const (CredentialReceived) =>
                    const SigningInState(),
                  const (AuthFailed) => AuthFailedState(state: state),
                  _ => UnknownState(state: state)
                },
                const Spacer(flex: 1),
                const LegalPrompt(),
                const Spacer(flex: 3),
              ],
            ),
          ),
        );
      },
    );
  }

  void goBack() {
    ref.read(OnboardingController().pageControllerProvider.notifier).state =
        PageController();
    ref.read(OnboardingController().currentPageIndexProvider.notifier).state =
        0;
    navigator.pushReplacement(
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
}
