import 'secure_item_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageModel {
  /// Singleton
  static final SecureStorageModel _instance = SecureStorageModel._internal();
  SecureStorageModel._internal();
  factory SecureStorageModel() => _instance;
  // attributes
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<SecureItemModel> secureItems = [];
}
