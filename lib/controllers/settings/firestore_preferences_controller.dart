import 'dart:developer';

import '../../enums/app_theming.dart';
import '../../models/settings/preference_model.dart';
import '../../services/firestore_service.dart';

class FirestorePreferencesController {
  /// Singleton constructor to ensure only one instance of this class exists.
  FirestorePreferencesController._();

  /// Static instance accessible through the factory constructor.
  static final instance = FirestorePreferencesController._();

  /// Factory constructor to return the singleton instance.
  factory FirestorePreferencesController() => instance;

  /// Method to save a single preference to Firestore.
  Future<void> savePreference(PreferenceModel preferenceModel) async {
    // Update the Firestore document with the new preference.
    try {
      await FirestoreService().preferencesCollectionReference().update({
        preferenceModel.key: [ThemeColor, ThemeAppearance]
                .contains(preferenceModel.value.runtimeType)
            ? preferenceModel.value.toString()
            : preferenceModel.value,
      });
    } on Exception catch (e) {
      if (e.toString().contains('cloud_firestore/not-found')) {
        await FirestoreService().preferencesCollectionReference().set({
          preferenceModel.key: [ThemeColor, ThemeAppearance]
                  .contains(preferenceModel.value.runtimeType)
              ? preferenceModel.value.toString()
              : preferenceModel.value,
        });
      }
    }

    // Log the preference being saved for debugging.
    log(
      '$preferenceModel',
      name: 'FirestorePreferencesController:savePreference() - '
          'preference to save',
    );
  }

  /// Method to get all user preferences from Firestore.
  Stream<List<PreferenceModel>> getPreferences() {
    return FirestoreService()
        .preferencesCollectionReference()
        .snapshots()
        .map((snapshot) {
      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) {
        return [];
      }
      return data
          .map((key, value) {
            var valueToSave = _convertValue(value);
            return MapEntry(key, PreferenceModel(key, valueToSave));
          })
          .values
          .toList();
    });
  }

  /// Method to get a single preference from Firestore.
  Stream<PreferenceModel?> getPreference<T>(
    PreferenceModel<T> preferenceModel,
  ) {
    return FirestoreService()
        .preferencesCollectionReference()
        .snapshots()
        .map((snapshot) {
      final Map<String, dynamic>? data = snapshot.data();
      if (data != null) {
        var valueToSave = _convertValue(data[preferenceModel.key]);
        return PreferenceModel(preferenceModel.key, valueToSave);
      }
      return null;
    });
  }

  /// Utility method to convert Firestore values into the appropriate Dart
  /// types.
  dynamic _convertValue(dynamic value) {
    // Check if the value is a String that needs to be converted to an enum.
    if (value is String) {
      try {
        // Convert to ThemeColor enum if applicable.
        if (value.contains('ThemeColor')) {
          return ThemeColor.values.firstWhere(
            (e) => e.toString() == value,
            orElse: () =>
                throw const FormatException('Invalid ThemeColor value'),
          );
        }
        // Convert to ThemeAppearance enum if applicable.
        else if (value.contains('ThemeAppearance')) {
          return ThemeAppearance.values.firstWhere(
            (e) => e.toString() == value,
            orElse: () =>
                throw const FormatException('Invalid ThemeAppearance value'),
          );
        }
      } catch (e) {
        // Log any exceptions that occur during conversion.
        log(
          'Error converting value: $e',
          name: 'FirestorePreferencesController:_convertValue',
        );
        // Here, you could add further error handling depending on your needs.
      }
    }

    // Return the original value if it's not a String or if an exception was caught.
    return value;
  }
}
