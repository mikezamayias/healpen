import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAuthProvider {
  /// Singleton constructor
  static final CustomAuthProvider _instance = CustomAuthProvider._internal();

  factory CustomAuthProvider() => _instance;

  CustomAuthProvider._internal();

  // final actionCodeSettingsProvider = StateProvider<ActionCodeSettings>(
  //   (ref) => ActionCodeSettings(
  //     url: 'https://healpen.page.link',
  //     handleCodeInApp: true,
  //     androidPackageName: 'com.mikezamayias.healpen',
  //     iOSBundleId: 'com.mikezamayias.healpen',
  //   ),
  // );

  /// Methods

  /// Configures the [EmailLinkAuthProvider] with the required action code
  /// settings.
  final emailLinkAuthProvider = StateProvider<EmailLinkAuthProvider>(
    (ref) => EmailLinkAuthProvider(
      actionCodeSettings: ActionCodeSettings(
        url: 'https://healpen.page.link',
        handleCodeInApp: true,
        androidPackageName: 'com.mikezamayias.healpen',
        iOSBundleId: 'com.mikezamayias.healpen',
      ),
      // actionCodeSettings:
      //     ref.watch(CustomAuthProvider().actionCodeSettingsProvider),
    ),
  );
}
