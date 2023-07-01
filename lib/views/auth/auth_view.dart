import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthProvider;
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../extensions/widget_extenstions.dart';
import '../../healpen.dart';
import '../../providers/custom_auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../../widgets/text_divider.dart';
import '../blueprint/blueprint_view.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseUIAuth.configureProviders([
      AppleProvider(),
      GoogleProvider(
        clientId:
            '1058887275393-nujimnudrgjikn3c9uoqsra7i49n628m.apps.googleusercontent.com',
      ),
    ]);
    final emailLinkProvider = ref.watch(
      CustomAuthProvider().emailLinkAuthProvider,
    );
    return AuthFlowBuilder<EmailLinkAuthController>(
      provider: emailLinkProvider,
      builder: (
        BuildContext context,
        AuthState state,
        EmailLinkAuthController authController,
        Widget? _,
      ) {
        if (state is SignedIn || FirebaseAuth.instance.currentUser != null) {
          log(
            '${FirebaseAuth.instance.currentUser}',
            name: 'currentUser',
          );
          return const Healpen();
        }

        // We know the state is not SignedIn, so we can handle other cases separately
        String emailAddress = '';
        Widget body;
        if (state is Uninitialized) {
          body = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomListTile(
                cornerRadius: radius,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: gap * 2, vertical: gap),
                leadingIconData: FontAwesomeIcons.solidEnvelope,
                title: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Email',
                    hintStyle: context.theme.textTheme.titleLarge,
                  ),
                  style: context.theme.textTheme.titleLarge,
                  onChanged: (String value) => emailAddress = value,
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
                onTap: () => authController.sendLink(emailAddress),
              ),
              const TextDivider(data: 'Or continue with'),
              GoogleSignInButton(
                clientId:
                    '1058887275393-nujimnudrgjikn3c9uoqsra7i49n628m.apps.googleusercontent.com',
                loadingIndicator: const CircularProgressIndicator(),
                onSignedIn: (UserCredential credential) {
                  context.navigator.pushReplacementNamed('/healpen');
                },
              ),
              SizedBox(height: gap),
              AppleSignInButton(
                loadingIndicator: const CircularProgressIndicator(),
                onSignedIn: (UserCredential credential) {
                  context.navigator.pushReplacementNamed('/healpen');
                },
                onError: (exception) {
                  FirebaseCrashlytics.instance
                      .recordError(exception, StackTrace.current);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: CustomListTile(
                        backgroundColor: context.theme.colorScheme.error,
                        textColor: context.theme.colorScheme.onError,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: gap * 2,
                          vertical: gap,
                        ),
                        titleString: '$exception',
                      ),
                    ),
                  );
                },
              )
            ],
          );
        } else if (state is AwaitingDynamicLink) {
          body = Text(
            'We\'ve sent you an email with a magic link. Check your email and follow the link to sign in',
            style: context.theme.textTheme.titleMedium!.copyWith(
              color: context.theme.colorScheme.onSurface,
            ),
          );
        } else if (state is SendingLink) {
          body = const LoadingTile(
            durationTitle: 'Sending link to your email',
          );
        } else if (state is SigningIn) {
          body = const LoadingTile(
            durationTitle: 'Signing in',
          );
        } else if (state is AuthFailed) {
          log(
            state.exception.toString(),
            name: 'AuthFailed',
          );
          FirebaseCrashlytics.instance.recordError(
            state.exception,
            null,
          );
          body = CustomListTile(
            cornerRadius: radius,
            contentPadding: const EdgeInsets.all(12),
            backgroundColor: context.theme.colorScheme.error,
            textColor: context.theme.colorScheme.onError,
            titleString: 'Something went wrong!',
            subtitle: ErrorText(exception: state.exception),
            // subtitleString: state.exception.toString(),
          );
        } else {
          log(
            '${state.runtimeType.toString()}:${state.toString()}',
            name: 'state:else',
          );
          body = CustomListTile(
            cornerRadius: radius,
            contentPadding: const EdgeInsets.all(12),
            titleString: 'Unknown state',
            subtitleString: '${state.runtimeType}',
          );
        }
        // Only need one return statement
        return BlueprintView(
          body: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign in with magic link',
                  style: context.theme.textTheme.headlineSmall!.copyWith(
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: gap),
                body,
                // Future.delayed(Duration(seconds: 5), () {
                //   Navigator.push(
                //       context, MaterialPageRoute(builder: (_) => Screen2()));
                // }),
                if (state is! Uninitialized)
                  FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 0)),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<dynamic> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CustomListTile(
                          titleString: 'Having trouble signing in?',
                          subtitleString: 'Click here to start over',
                          onTap: authController.reset,
                          cornerRadius: radius,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: gap,
                            horizontal: gap * 2,
                          ),
                          leadingIconData: FontAwesomeIcons.arrowsRotate,
                        )
                            .animate()
                            .fadeIn(
                              curve: curve,
                              duration: animationDuration.milliseconds,
                            )
                            .slideY(
                              curve: curve,
                              duration: animationDuration.milliseconds,
                              begin: 0.5,
                            );
                      }
                      return const SizedBox();
                    },
                  ),
              ].animateWidgetList(),
            ),
          ),
        );
      },
    );
  }
}
