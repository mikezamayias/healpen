import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_bar_model.dart';

final appBarControllerProvider =
    StateNotifierProvider<AppBarController, AppBarModel>(
  (ref) => AppBarController(),
);

class AppBarController extends StateNotifier<AppBarModel> {
  AppBarController._() : super(AppBarModel());
  static final AppBarController _singleton = AppBarController._();
  factory AppBarController() => _singleton;

  void updatePathNames(List<String> newPathNames) {
    state = state.copyWith(pathNames: newPathNames);
  }

  void toggleAutomaticallyImplyLeading(bool value) {
    state = state.copyWith(automaticallyImplyLeading: value);
  }

  void setOnBackButtonPressed(void Function()? callback) {
    state = state.copyWith(onBackButtonPressed: callback);
  }
}
