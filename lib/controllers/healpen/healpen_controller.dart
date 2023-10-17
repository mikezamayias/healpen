import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/page_model.dart';
import '../../wrappers/keep_alive_wrapper.dart';
import '../page_controller.dart' as page_controller;

class HealpenController {
  /// Singleton constructor
  static final HealpenController _instance = HealpenController._internal();

  factory HealpenController() => _instance;

  HealpenController._internal();

  /// Members
  final List<Widget> pages = [
    for (PageModel pageModel in page_controller.PageController().pages)
      KeepAliveWrapper(child: pageModel.widget)
  ];
  final List<PageModel> models = page_controller.PageController().pages;

  /// Providers
  final pageControllerProvider = StateProvider<PageController>(
    (ref) => PageController(),
  );
  final currentPageIndexProvider = StateProvider<int>((ref) => 0);

  /// Get [Widget]
  Widget currentPage(int currentIndex) => pages.elementAt(currentIndex);

  /// Get [PageModel]
  PageModel currentPageModel(int currentIndex) =>
      models.elementAt(currentIndex);
}
