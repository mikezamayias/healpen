import 'dart:io';

import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../controllers/page_controller.dart';
import '../../../../models/page_model.dart';
import '../../../extensions/string_extensions.dart';
import '../../../utils/constants.dart';
import '../controllers/healpen/healpen_controller.dart';
import '../extensions/widget_extensions.dart';
import '../providers/settings_providers.dart';
import '../utils/helper_functions.dart';

class HealpenNavigationBar extends ConsumerWidget {
  const HealpenNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: gap,
          bottom: Platform.isIOS ? 0 : gap,
        ),
        child: AnimatedContainer(
          duration: standardDuration,
          curve: standardCurve,
          padding: smallNavigationElements
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  left: gap,
                  right: gap,
                ),
          child: PhysicalModel(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: standardDuration,
              curve: standardCurve,
              padding: smallNavigationElements
                  ? EdgeInsets.only(
                      left: gap,
                      right: gap,
                    )
                  : EdgeInsets.all(gap),
              decoration: smallNavigationElements
                  ? const BoxDecoration()
                  : BoxDecoration(
                      color: context.theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.all(Radius.circular(radius)),
                    ),
              child: SalomonBottomBar(
                duration: standardDuration,
                curve: standardCurve,
                margin: EdgeInsets.zero,
                itemShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      smallNavigationElements ? radius : radius - gap,
                    ),
                  ),
                ),
                currentIndex:
                    ref.watch(HealpenController().currentPageIndexProvider),
                onTap: (int index) {
                  goToPage(
                    ref.watch(HealpenController().pageControllerProvider),
                    index,
                  );
                },
                selectedItemColor: context.theme.colorScheme.primary,
                unselectedItemColor: context.theme.colorScheme.primary,
                selectedColorOpacity: 1,
                items: [
                  ...PageController().pages.map(
                        (PageModel pageModel) => SalomonBottomBarItem(
                          icon: FaIcon(
                            pageModel.icon,
                            color: ref.watch(HealpenController()
                                        .currentPageIndexProvider) ==
                                    PageController().pages.indexOf(pageModel)
                                ? context.theme.colorScheme.onPrimary
                                : context.theme.colorScheme.primary,
                          ),
                          title: AnimatedOpacity(
                            duration: shortStandardDuration,
                            curve: standardCurve,
                            opacity: ref.watch(HealpenController()
                                        .currentPageIndexProvider) ==
                                    PageController().pages.indexOf(pageModel)
                                ? 1
                                : 0,
                            child: Text(
                              pageModel.label.toTitleCase(),
                              style: TextStyle(
                                fontFamily: context
                                    .theme.textTheme.bodySmall!.fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                                color: context.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ).animateBottomNavigationBar(context),
            ),
          ),
        ),
      ),
    );
  }
}
