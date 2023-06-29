import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../providers/custom_auth_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../blueprint/blueprint_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView>
    implements EmailLinkAuthListener {
  @override
  final auth = FirebaseAuth.instance;

  @override
  late EmailLinkAuthProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.watch(CustomAuthProvider().emailLinkAuthProvider)
      ..authListener = this;
  }

  late Widget body = CustomListTile(
    selectableText: true,
    titleString: 'Sign in using only your email',
    subtitle: TextField(
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: context.theme.textTheme.titleLarge,
      ),
      style: context.theme.textTheme.titleLarge,
      onSubmitted: provider.sendLink,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Password-less Sign In'],
      ),
      body: body,
    );
  }

  @override
  void onBeforeLinkSent(String email) {
    setState(() {
      body = CustomListTile(
        selectableText: true,
        titleString: 'onBeforeLinkSent',
        subtitleString: 'Sending link to $email',
      );
    });
  }

  @override
  void onLinkSent(String email) {
    setState(() {
      body = CustomListTile(
        selectableText: true,
        titleString: 'onLinkSent',
        subtitleString: 'Link sent to $email',
      );
    });
  }

  @override
  void onBeforeProvidersForEmailFetch() {
    setState(() {
      body = const CustomListTile(
        selectableText: true,
        titleString: 'onBeforeProvidersForEmailFetch',
        subtitleString: 'Fetching providers for email',
      );
    });
  }

  @override
  void onBeforeSignIn() {
    setState(() {
      body = const CustomListTile(
        selectableText: true,
        titleString: 'onBeforeSignIn',
        subtitleString: 'Authentication process starts',
      );
    });
  }

  @override
  void onCanceled() {
    setState(() {
      body = const CustomListTile(
        selectableText: true,
        titleString: 'onCanceled',
        subtitleString: 'User canceled the sign in process',
      );
    });
  }

  @override
  void onCredentialLinked(AuthCredential credential) {
    setState(() {
      body = const CustomListTile(
        selectableText: true,
        titleString: 'onCredentialLinked',
        subtitleString: 'Credential linked with current user',
      );
    });
  }

  @override
  void onDifferentProvidersFound(
      String email, List<String> providers, AuthCredential? credential) {
    // Handle case of different providers found
  }

  @override
  void onError(Object error) {
    setState(() {
      body = CustomListTile(
        selectableText: true,
        titleString: 'onError',
        subtitleString: error.toString(),
      );
    });
  }

  @override
  void onCredentialReceived(AuthCredential credential) {
    setState(() {
      body = const CustomListTile(
        selectableText: true,
        titleString: 'onCredentialReceived',
        subtitleString:
            'Linking the credential with currently signed in user account',
      );
    });
  }

  @override
  void onMFARequired(MultiFactorResolver resolver) {
    setState(() {
      body = const CustomListTile(
        selectableText: true,
        titleString: 'onMFARequired',
        subtitleString: 'User has to complete MFA',
      );
    });
  }

  @override
  void onSignedIn(UserCredential credential) {
    setState(() {
      body = CustomListTile(
        selectableText: true,
        titleString: 'Signed in successfully',
        subtitleString: 'User: ${credential.user?.email}',
      );
    });
  }
}
