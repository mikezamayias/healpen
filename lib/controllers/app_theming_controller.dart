import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/app_theming.dart';
import '../models/app_theming_model.dart';

class AppColorController extends StateNotifier<AppColorModel> {
  static final instance = AppColorController._();

  AppColorController._() : super(AppColorModel(AppColor.blue));

  final appColorControllerProvider =
      StateNotifierProvider<AppColorController, AppColorModel>(
    (ref) => throw UnimplementedError(),
  );

  Future<void> updateAppColor(AppColor newColor) async {
    state = AppColorModel(newColor);
    await saveColor();
  }

  Future<void> loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? color = prefs.getString('color');
    state = AppColorModel(
      color != null
          ? AppColor.values.firstWhere((e) => e.toString() == color)
          : AppColor.blue,
    );
  }

  Future<void> saveColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('color', state.appColor.toString());
  }
}

class AppearanceController extends StateNotifier<AppearanceModel> {
  static final instance = AppearanceController._();
  AppearanceController._() : super(AppearanceModel(Appearance.system));
  final appearanceControllerProvider =
      StateNotifierProvider<AppearanceController, AppearanceModel>(
    (ref) => throw UnimplementedError(),
  );

  Future<void> loadAppearance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('appearance');

    if (value != null) {
      Appearance? matchingAppearance = Appearance.values.firstWhereOrNull(
        (Appearance e) => e.toString() == value,
      );

      if (matchingAppearance != null) {
        state = AppearanceModel(matchingAppearance);
      }
    }
  }

  Future<void> updateAppearance(Appearance newAppearance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('appearance', '$newAppearance');

    state = AppearanceModel(newAppearance);
  }
}
