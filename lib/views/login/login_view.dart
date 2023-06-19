import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';
import '../writing/writing_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    implements EmailLinkAuthListener {
  ActionCodeSettings actionCodeSettings = ActionCodeSettings(
    url: 'https://healpen.page.link',
    handleCodeInApp: true,
    androidMinimumVersion: '1',
    androidPackageName: 'com.mikezamayias.healpen',
    iOSBundleId: 'com.mikezamayias.healpen',
  );

  @override
  final auth = FirebaseAuth.instance;

  @override
  late final EmailLinkAuthProvider provider =
      EmailLinkAuthProvider(actionCodeSettings: actionCodeSettings)
        ..authListener = this
        ..auth = auth;

  @override
  void onBeforeLinkSent(String email) {
    setState(() {
      child = const LoadingTile(
        durationTitle: 'Sending link to your email',
      );
    });
  }

  @override
  void onLinkSent(String email) {
    setState(() {
      child = CustomListTile(
        titleString: 'Please check your email.',
        cornerRadius: radius,
      );
    });
  }

  @override
  void onBeforeProvidersForEmailFetch() {
    setState(() {
      child = const CircularProgressIndicator();
    });
  }

  @override
  void onBeforeSignIn() {
    setState(() {
      child = const CircularProgressIndicator();
    });
  }

  @override
  void onCanceled() {
    setState(() {
      child = const Text('Authenticated cancelled');
    });
  }

  @override
  void onCredentialLinked(AuthCredential credential) {
    log(
      credential.toString(),
      name: 'onCredentialLinked',
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WritingView()),
    );
  }

  @override
  void onDifferentProvidersFound(
    String email,
    List<String> providers,
    AuthCredential? credential,
  ) {
    showDifferentMethodSignInDialog(
      context: context,
      availableProviders: providers,
      providers: FirebaseUIAuth.providersFor(FirebaseAuth.instance.app),
    );
  }

  @override
  void onError(Object error) {
    if (error is FirebaseException && error.code == 'too-many-requests') {
      // handle the too-many-requests error
      setState(() {
        child = CustomListTile(
          backgroundColor: context.theme.colorScheme.tertiary,
          textColor: context.theme.colorScheme.onTertiary,
          cornerRadius: radius,
          titleString: 'Error',
          subtitle: Text(
            'Too many requests. Try again later.',
            style: context.theme.textTheme.titleSmall,
          ),
        );
      });
    } else {
      try {
        // tries default recovery strategy
        defaultOnAuthError(provider, error);
      } catch (err) {
        setState(() {
          defaultOnAuthError(provider, error);
        });
      }
    }
  }

  @override
  void onSignedIn(UserCredential credential) {
    log(
      credential.toString(),
      name: 'onSignedIn',
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WritingView()),
    );
  }

  @override
  void onCredentialReceived(AuthCredential credential) {
    log(
      credential.toString(),
      name: 'onCredentialReceived',
    );
    setState(() {
      child = const Text('onCredentialReceived');
    });
  }

  @override
  void onMFARequired(MultiFactorResolver resolver) {
    setState(() {
      child = const Text('Expecting MFA widget');
    });
  }

  late Widget child = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomListTile(
        cornerRadius: radius,
        contentPadding: const EdgeInsets.all(12),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your email',
              style: context.theme.textTheme.titleLarge,
            ),
          ],
        ),
        subtitle: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: context.theme.textTheme.titleLarge,
          ),
          style: context.theme.textTheme.titleLarge,
        ),
      ),
      SizedBox(height: gap),
      CustomListTile(
        cornerRadius: radius,
        responsiveWidth: true,
        titleString: 'Send link to email',
        onTap: () => provider.sendLink(emailController.text),
      )
    ],
  );

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Passwordless Sign In'],
      ),
      body: child,
    );
  }
}
