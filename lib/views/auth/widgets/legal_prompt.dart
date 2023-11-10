import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalPrompt extends StatelessWidget {
  const LegalPrompt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'By continuing, you agree to Healpen\'s ',
        style: context.theme.textTheme.bodyMedium!.copyWith(
          color: context.theme.colorScheme.onSurface,
        ),
        children: [
          TextSpan(
            text: 'Privacy Policy',
            style: context.theme.textTheme.bodyMedium!.copyWith(
              color: context.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(
                  Uri.https(
                    'iubenda.com',
                    'privacy-policy/29795832',
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
          ),
          TextSpan(
            text: ' and ',
            style: context.theme.textTheme.bodyMedium!.copyWith(
              color: context.theme.colorScheme.onSurface,
            ),
          ),
          TextSpan(
            text: 'Terms and Conditions',
            style: context.theme.textTheme.bodyMedium!.copyWith(
              color: context.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(
                  Uri.https(
                    'iubenda.com',
                    'terms-and-conditions/29795832',
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
          ),
          TextSpan(
            text: '.',
            style: context.theme.textTheme.bodyMedium!.copyWith(
              color: context.theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
