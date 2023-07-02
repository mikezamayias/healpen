import 'package:flutter/material.dart' hide PageController;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../controllers/page_controller.dart';
import '../../../../models/page_model.dart';
import '../../../../providers/page_providers.dart';
import '../../../extensions/string_extensions.dart';
import '../../../extensions/widget_extenstions.dart';
import '../../../utils/constants.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: PhysicalModel(
        color: context.theme.colorScheme.outlineVariant,
        // shadowColor: context.theme.colorScheme.shadow,
        // elevation: radius,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Padding(
          padding: EdgeInsets.all(gap),
          child: SalomonBottomBar(
            duration: animationDuration.milliseconds,
            curve: curve,
            margin: EdgeInsets.zero,
            itemShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius / 2)),
            ),
            currentIndex:
                PageController().pages.indexOf(ref.watch(currentPageProvider)),
            onTap: (int index) {
              HapticFeedback.mediumImpact();
              ref.watch(currentPageProvider.notifier).state =
                  PageController().pages[index];
            },
            // selectedColorOpacity: 0,
            selectedItemColor: context.theme.colorScheme.primary,
            unselectedItemColor: context.theme.colorScheme.outline,
            items: [
              ...PageController().pages.map(
                    (PageModel pageModel) => SalomonBottomBarItem(
                      icon: FaIcon(pageModel.icon),
                      title: Text(
                        pageModel.label.toTitleCase(),
                        style: TextStyle(
                          fontFamily:
                              context.theme.textTheme.bodyLarge!.fontFamily,
                        ),
                      ),
                    ),
                  )
            ],
          ),
        ),
      ).animateBottomNavigationBar(context),
    );
  }
}
