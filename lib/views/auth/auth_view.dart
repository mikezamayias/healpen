import 'dart:developer';

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

class AuthView extends ConsumerStatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView>
    implements EmailLinkAuthListener {
  @override
  final auth = FirebaseAuth.instance;

  @override
  late final EmailLinkAuthProvider provider = ref
      .watch(CustomAuthProvider().emailLinkAuthProvider)
    ..authListener = this;

  @override
  void onBeforeLinkSent(String email) {
    log(
      email,
      name: 'AuthView:onBeforeLinkSent',
    );
    setState(() {
      child = const SendingLinkState();
    });
  }

  @override
  void onLinkSent(String email) {
    log(
      email,
      name: 'AuthView:onLinkSent',
    );
    setState(() {
      child = const AwaitingDynamicLinkState();
    });
  }

  @override
  void onBeforeProvidersForEmailFetch() {
    log(
      'onBeforeProvidersForEmailFetch',
      name: 'AuthView:onBeforeProvidersForEmailFetch',
    );
    setState(() {
      child = const CircularProgressIndicator();
    });
  }

  @override
  void onBeforeSignIn() {
    log(
      'onBeforeSignIn',
      name: 'AuthView:onBeforeSignIn',
    );
    setState(() {
      child = const SigningInState();
    });
  }

  @override
  void onCanceled() {
    log(
      'onCanceled',
      name: 'AuthView:onCanceled',
    );
    setState(() {
      child = UninitializedState(provider: provider);
    });
  }

  @override
  void onCredentialLinked(AuthCredential credential) {
    log(
      'onCredentialLinked',
      name: 'AuthView:onCredentialLinked',
    );
    context.navigator.pushReplacementNamed('/healpen');
  }

  @override
  void onDifferentProvidersFound(
    String email,
    List<String> providers,
    AuthCredential? credential,
  ) {
    log(
      '$email, $providers, $credential',
      name: 'AuthView:onDifferentProvidersFound',
    );
    showDifferentMethodSignInDialog(
      context: context,
      availableProviders: providers,
      providers: FirebaseUIAuth.providersFor(FirebaseAuth.instance.app),
    );
  }

  @override
  void onError(Object error) {
    log(
      error.toString(),
      name: 'AuthView:onError',
    );
    setState(() {
      child = AuthFailedState(error: error.toString().split('] ').last);
    });
  }

  @override
  void onSignedIn(UserCredential credential) {
    log(
      'onSignedIn',
      name: 'AuthView:onSignedIn',
    );
    context.navigator.pushReplacementNamed('/healpen');
  }

  @override
  void onCredentialReceived(AuthCredential credential) {
    log(
      'onCredentialReceived',
      name: 'AuthView:onCredentialReceived',
    );
    context.navigator.pushReplacementNamed('/healpen');
  }

  @override
  void onMFARequired(MultiFactorResolver resolver) {
    log(
      'onMFARequired',
      name: 'AuthView:onMFARequired',
    );
    throw UnimplementedError();
  }

  late Widget child = UninitializedState(
    provider: provider,
  );

  @override
  Widget build(BuildContext context) {
    log(
      'build',
      name: 'AuthView:build',
    );
    return BlueprintView(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in with magic link',
              style: context.theme.textTheme.headlineSmall!.copyWith(
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: gap),
            child,
          ],
        ),
      ),
    );
  }
}
