import 'package:flutter/material.dart' hide Divider;
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../utils/constants.dart' as constants;

class Divider extends StatefulWidget {
  const Divider({super.key});

  @override
  State<Divider> createState() => _DividerState();
}

class _DividerState extends State<Divider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(constants.gap),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(constants.radius),
          color: theme.colorScheme.outline,
        ),
        height: 3 * constants.unit,
      ),
    );
  }
}
