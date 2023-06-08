import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/constants.dart' as constants;

class ToggleBar extends StatelessWidget {
  final List<BottomNavigationBarItem> toggles;
  final int currentIndex;
  final Function(int)? onDestinationSelected;

  const ToggleBar({
    Key? key,
    required this.toggles,
    required this.currentIndex,
    this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(constants.radius),
      child: Container(
        alignment: Alignment.center,
        width: 60.w,
        child: Container(
          padding: EdgeInsets.all(constants.gap),
          color: context.theme.colorScheme.background,
          child: BottomNavigationBar(
            items: toggles,
            currentIndex: currentIndex,
            onTap: onDestinationSelected,
          ),
        ),
      ),
    );
  }
}
