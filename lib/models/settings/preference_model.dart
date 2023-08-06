import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/app_theming.dart';

class PreferenceModel<T> {
  final String key;
  T value;

  PreferenceModel(this.key, this.value);

  @override
  String toString() {
    return 'PreferenceModel{key: $key, value: $value}';
  }

  Future<T> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    T value;
    var prefsValue = prefs.get(key);

    if (T == ThemeAppearance) {
      value = ThemeAppearance.values.firstWhere(
        (e) => e.toString() == prefsValue,
        orElse: () => ThemeAppearance.system,
      ) as T;
    } else if (T == ThemeColor) {
      value = ThemeColor.values.firstWhere(
        (e) => e.toString() == prefsValue,
        orElse: () => ThemeColor.pastelOcean,
      ) as T;
    } else if (T == bool) {
      value = (prefs.getBool(key) ?? this.value) as T;
    } else {
      value = (prefs.getString(key) ?? this.value) as T;
    }

    log(
      '$value',
      name: 'PreferenceModel:read:$key',
    );

    this.value = value;
    return value;
  }

  Future<void> write(T type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type is bool) {
      prefs.setBool(key, type);
    } else if (type is String) {
      prefs.setString(key, type);
    }
  }
}