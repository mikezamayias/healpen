import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/secure_item_model.dart';
import '../models/secure_storage_model.dart';

enum Actions { deleteAll }

enum ItemActions { delete, edit, containsKey, read }

class SecureStorageController {
  /// Singleton
  static final SecureStorageController _instance =
      SecureStorageController._internal();
  SecureStorageController._internal();
  factory SecureStorageController() => _instance;

  Future<SecureItemModel> read(SecureItemModel secureItemModel) async {
    if (secureItemModel.key == null) {
      throw Exception('Key must not be null');
    } else {
      secureItemModel.value = await SecureStorageModel().storage.read(
            key: secureItemModel.key!,
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions(),
          );
    }
    return secureItemModel;
  }

  Future<void> delete(SecureItemModel secureItemModel) async {
    if (secureItemModel.key == null) {
      throw Exception('Key must not be null');
    } else {
      await SecureStorageModel().storage.delete(
            key: secureItemModel.key!,
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions(),
          );
      readAll();
    }
  }

  Future<void> readAll() async {
    final all = await SecureStorageModel().storage.readAll(
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions(),
        );
    SecureStorageModel().secureItems = all.entries
        .map(
          (MapEntry<String, String> entry) => SecureItemModel(
            key: entry.key,
            value: entry.value,
          ),
        )
        .toList(growable: false);
    for (SecureItemModel element in SecureStorageModel().secureItems) {
      log(element.toString());
    }
  }

  Future<void> deleteAll() async {
    await SecureStorageModel().storage.deleteAll(
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions(),
        );
    readAll();
  }

  Future<void> addNewItem(SecureItemModel secureItem) async {
    if (secureItem.key == null) {
      throw Exception('Key must not be null');
    } else {
      await SecureStorageModel().storage.write(
            key: secureItem.key!,
            value: secureItem.value,
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions(),
          );
    }
    readAll();
  }

  IOSOptions _getIOSOptions() => const IOSOptions();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
