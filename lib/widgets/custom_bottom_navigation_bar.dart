import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../controllers/page_controller.dart';
import '../../../../models/page_model.dart';
import '../../../../providers/page_providers.dart';
import '../../../extensions/string_extensions.dart';
import '../../../utils/constants.dart';
import '../extensions/widget_extensions.dart';
import '../providers/settings_providers.dart';
import '../utils/helper_functions.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        left: gap,
        right: gap,
        bottom: gap,
      ),
      child: SafeArea(
        child: PhysicalModel(
          color: context.theme.colorScheme.surfaceVariant,
          // shadowColor: context.theme.colorScheme.shadow,
          // elevation: radius,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: Padding(
            padding: EdgeInsets.all(gap),
            child: SalomonBottomBar(
              duration: standardDuration,
              curve: standardCurve,
              margin: EdgeInsets.zero,
              itemShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius / 2)),
              ),
              currentIndex: PageController()
                  .pages
                  .indexOf(ref.watch(currentPageProvider)),
              onTap: (int index) {
                vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
                  ref.watch(currentPageProvider.notifier).state =
                      PageController().pages[index];
                });
              },
              // selectedColorOpacity: 0,
              selectedItemColor: context.theme.colorScheme.primary,
              unselectedItemColor: context.theme.colorScheme.primary,
              selectedColorOpacity: 1,
              items: [
                ...PageController().pages.map(
                      (PageModel pageModel) => SalomonBottomBarItem(
                        icon: FaIcon(
                          pageModel.icon,
                          color: PageController().pages.indexOf(
                                      ref.watch(currentPageProvider)) ==
                                  PageController().pages.indexOf(pageModel)
                              ? context.theme.colorScheme.onPrimary
                              : context.theme.colorScheme.primary,
                        ),
                        title: Text(
                          pageModel.label.toTitleCase(),
                          style: TextStyle(
                            fontFamily:
                                context.theme.textTheme.bodySmall!.fontFamily,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ).animateBottomNavigationBar(context),
      ),
    );
  }
}
