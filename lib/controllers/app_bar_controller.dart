// create a singleton constructor for the app bar controller

import 'package:flutter_riverpod/flutter_riverpod.dart';

final appBarControllerProvider =
    StateProvider<AppBarController>((ref) => AppBarController());

class AppBarController {
  // Singleton constructor
  static final AppBarController _instance = AppBarController._internal();
  factory AppBarController() => _instance;
  AppBarController._internal();

  // Attributes
  List<String> pathNames = [];
  bool automaticallyImplyLeading = false;

  // Methods
  String getPathText(int i) {
    return i < pathNames.length - 1
        ? '${pathNames[i]} / '
        : pathNames.length != 1 && pathNames.length > 2
            ? '\n${pathNames[i]}'
            : pathNames[i];
  }
}
