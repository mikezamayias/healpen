import 'package:flutter/material.dart' hide PageController;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
      child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: curve,
          switchOutCurve: curve,
          child: Padding(
            padding: EdgeInsets.only(
              left: gap * 2,
              right: gap * 2,
              bottom: gap * 2,
            ),
            child: PhysicalModel(
              color: context.theme.colorScheme.background,
              // shadowColor: context.theme.colorScheme.shadow,
              // elevation: radius,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              child: Padding(
                padding: EdgeInsets.all(gap),
                child: SalomonBottomBar(
                  duration: duration,
                  curve: curve,
                  margin: EdgeInsets.zero,
                  itemShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(radius / 2)),
                  ),
                  currentIndex: PageController()
                      .pages
                      .indexOf(ref.watch(currentPageProvider)),
                  onTap: (int index) {
                    HapticFeedback.mediumImpact();
                    ref.watch(currentPageProvider.notifier).state =
                        PageController().pages[index];
                  },
                  selectedItemColor: context.theme.colorScheme.primary,
                  unselectedItemColor: context.theme.colorScheme.outline,
                  items: [
                    ...PageController().pages.map(
                          (PageModel pageModel) => SalomonBottomBarItem(
                            icon: FaIcon(pageModel.icon),
                            title: Text(
                              pageModel.label.toTitleCase(),
                              style: TextStyle(
                                fontFamily: GoogleFonts.ubuntuMono().fontFamily,
                              ),
                            ),
                          ),
                        )
                  ],
                ),
              ),
            ),
          ).animateBottomNavigationBar(context)),
    );
  }
}
