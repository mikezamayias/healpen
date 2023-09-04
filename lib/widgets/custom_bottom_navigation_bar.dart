import 'package:flutter/material.dart' hide PageController;
import 'package:flutter/services.dart';
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
          color: context.theme.colorScheme.primary,
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
              onTap: (int index) async {
                await HapticFeedback.vibrate();
                ref.watch(currentPageProvider.notifier).state =
                    PageController().pages[index];
              },
              // selectedColorOpacity: 0,
              selectedItemColor: context.theme.colorScheme.onPrimary,
              unselectedItemColor: context.theme.colorScheme.onPrimary,
              items: [
                ...PageController().pages.map(
                      (PageModel pageModel) => SalomonBottomBarItem(
                        icon: FaIcon(pageModel.icon),
                        title: Text(
                          pageModel.label.toTitleCase(),
                          style: context.theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    )
              ],
            ),
          ),
        ).animateBottomNavigationBar(context),
      ),
    );
  }
}
