import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProvider {
  // Singleton constructor
  static final AuthProvider _instance = AuthProvider._internal();

  factory AuthProvider() => _instance;

  AuthProvider._internal();

  // Methods
  /// Configures the [EmailLinkAuthProvider] with the required action code
  /// settings.
  final emailLinkAuthProvider = StateProvider<EmailLinkAuthProvider>(
    (ref) => EmailLinkAuthProvider(
      actionCodeSettings: ActionCodeSettings(
        url: 'https://healpen.page.link',
        handleCodeInApp: true,
        androidMinimumVersion: '1',
        androidPackageName: 'com.mikezamayias.healpen',
        iOSBundleId: 'com.mikezamayias.healpen',
      ),
    ),
  );
}
