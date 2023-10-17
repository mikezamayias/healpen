import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/onboarding/onboarding_controller.dart';
import '../healpen.dart';
import '../views/auth/auth_view.dart';
import '../views/onboarding/onboarding_view.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingCompleted =
        ref.read(OnboardingController.onboardingCompletedProvider);
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return switch (!snapshot.hasData) {
          true => switch (onboardingCompleted) {
              true => const AuthView(),
              false => const OnboardingView()
            },
          false => const Healpen(),
        };
      },
    );
  }
}
