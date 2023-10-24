import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../models/page_model.dart';
import '../page_controller.dart' as page_controller;

class HealpenController {
  /// Singleton constructor
  static final HealpenController _instance = HealpenController._internal();

  factory HealpenController() => _instance;

  HealpenController._internal();

  /// Members
  final List<Widget> pages = [
    for (PageModel pageModel in page_controller.PageController().pages)
      pageModel.widget
  ];
  final List<PageModel> models = page_controller.PageController().pages;

  /// Providers
  final pageControllerProvider = StateProvider<PreloadPageController>(
    (ref) => PreloadPageController(),
  );
  final currentPageIndexProvider = StateProvider<int>((ref) => 0);

  /// Get [Widget]
  Widget currentPage(int currentIndex) => pages.elementAt(currentIndex);

  /// Get [PageModel]
  PageModel currentPageModel(int currentIndex) =>
      models.elementAt(currentIndex);
}
