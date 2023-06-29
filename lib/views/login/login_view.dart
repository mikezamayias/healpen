import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/custom_auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView>
    with WidgetsBindingObserver {
  final TextEditingController _emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailLink(userEmail) async {
    return await _auth
        .sendSignInLinkToEmail(
            email: userEmail,
            actionCodeSettings:
                ref.watch(CustomAuthProvider().actionCodeSettingsProvider))
        .then((value) {
      log('Email sent');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      FirebaseDynamicLinks.instance.onLink.listen((
        PendingDynamicLinkData dynamicLink,
      ) async {
        final Uri deepLink = dynamicLink.link;
        handleLink(deepLink, _emailController.text);
      },
          // onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          //   final Uri? deepLink = dynamicLink?.link;
          //   if (deepLink != null) {
          //     handleLink(deepLink, _emailController.text);
          //     FirebaseDynamicLinks.instance.onLink(
          //         onSuccess: (PendingDynamicLinkData?dynamicLink) async {
          //           final Uri? deepLink = dynamicLink!.link;
          //           handleLink(deepLink!, _emailController.text);
          //         }, onError: (OnLinkErrorException e) async {
          //       print(e.message);
          //     });
          //     // Navigator.pushNamed(context, deepLink.path);
          //   }
          // },
          onError: (e) async {
        log('$e', name: 'FirebaseDynamicLinks');
      });

      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      if (deepLink != null) {
        print(deepLink.userInfo);
      }
    } catch (e) {
      print(e);
    }
  }

  void handleLink(Uri link, String userEmail) async {
    log(userEmail, name: 'handleLink:userEmail');
    log('$link', name: 'handleLink:link');
    final UserCredential user = await FirebaseAuth.instance.signInWithEmailLink(
      email: userEmail,
      emailLink: link.toString(),
    );
    log('${user.credential}', name: 'handleLink');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: 'Type in your email address',
                fillColor: Colors.white70,
              ),
              controller: _emailController,
            ),
            const SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {
                signInWithEmailLink(_emailController.text);
              },
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
