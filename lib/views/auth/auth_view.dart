import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../healpen.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  @override
  Widget build(BuildContext context) {
    final ctrl = ref.watch(AuthProvider().emailLinkAuthProvider);
    return AuthFlowBuilder<EmailLinkAuthController>(
      provider: ctrl,
      builder: (context, AuthState state, ctrl, child) {
        if (state is SignedIn) {
          log(
            '${FirebaseAuth.instance.currentUser}',
            name: 'currentUser',
          );
          return const Healpen();
        }

        // We know the state is not SignedIn, so we can handle other cases separately
        Widget body;
        if (state is Uninitialized) {
          body = CustomListTile(
            cornerRadius: radius,
            contentPadding: const EdgeInsets.all(12),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign in using only your email',
                  style: context.theme.textTheme.titleLarge,
                ),
              ],
            ),
            subtitle: TextField(
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: context.theme.textTheme.titleLarge,
              ),
              style: context.theme.textTheme.titleLarge,
              onSubmitted: (String email) {
                ctrl.sendLink(email);
              },
            ),
          );
        } else if (state is AwaitingDynamicLink) {
          body = CustomListTile(
            cornerRadius: radius,
            // contentPadding: EdgeInsets.symmetric(
            //   vertical: gap,
            //   horizontal: gap * 2,
            // ),
            titleString: 'Please check your email inbox',
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
          log(state.exception.toString(), name: 'AuthFailed');
          body = CustomListTile(
            cornerRadius: radius,
            contentPadding: const EdgeInsets.all(12),
            backgroundColor: context.theme.colorScheme.error,
            textColor: context.theme.colorScheme.onError,
            titleString: 'Something went wrong!',
            subtitle: ErrorText(exception: state.exception),
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
          appBar: const AppBar(
            pathNames: ['Password-less Sign In'],
          ),
          body: body,
        );
      },
    );
  }
}
