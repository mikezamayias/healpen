import 'secure_item_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageModel {
  // Singleton
  static final SecureStorageModel _secureStorageModel =
      SecureStorageModel._internal();
  SecureStorageModel._internal();
  factory SecureStorageModel() => _secureStorageModel;
  // attributes
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<SecureItemModel> secureItems = [];
}
