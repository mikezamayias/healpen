import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceModel<T> {
  final String key;
  T value;

  PreferenceModel(this.key, this.value);

  @override
  String toString() {
    return 'PreferenceModel{key: $key, value: $value}';
  }

  Future<dynamic> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var readValue = prefs.get(key) ?? value;
    log(
      '$readValue',
      name: 'PreferenceModel:read:$key',
    );
    return readValue;
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
