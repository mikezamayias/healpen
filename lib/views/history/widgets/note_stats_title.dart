import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

class NoteStatsTile extends StatelessWidget {
  final String statsTitle;
  final String statsValue;

  const NoteStatsTile({
    super.key,
    required this.statsTitle,
    required this.statsValue,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '$statsTitle ',
            style: context.theme.textTheme.bodyMedium!.copyWith(
              color: context.theme.colorScheme.secondary,
            ),
          ),
          TextSpan(
            text: statsValue,
            style: context.theme.textTheme.bodyLarge!.copyWith(
              color: context.theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
