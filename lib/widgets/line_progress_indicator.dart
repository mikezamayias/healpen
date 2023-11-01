import 'package:flutter/material.dart';

import '../utils/constants.dart' as constants;

class LineProgressIndicator extends StatelessWidget {
  const LineProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(constants.gap),
      child: LinearProgressIndicator(
        minHeight: constants.gap,
      ),
    );
  }
}
