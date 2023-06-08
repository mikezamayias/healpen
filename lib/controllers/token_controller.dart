import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/token_model.dart';

class TokenController {
  /// Singleton
  static final TokenController _instance = TokenController._internal();
  factory TokenController() => _instance;
  TokenController._internal() : _storage = const FlutterSecureStorage();

  // Properties
  final FlutterSecureStorage _storage;
  TokenModel? tokenModel;

  // Methods
  Future<TokenModel?> fetchTokens() async {
    TokenController tokenController = TokenController();
    try {
      tokenModel = await tokenController.getTokens();
    } on Exception {
      tokenModel = null;
    }
    return tokenModel;
  }

  Future<void> storeTokens(TokenModel tokenModel) async {
    await _storage.write(
      key: 'access_token',
      value: tokenModel.accessToken,
    );
    await _storage.write(
      key: 'refresh_token',
      value: tokenModel.refreshToken,
    );
    await _storage.write(
      key: 'expires_in',
      value: tokenModel.expiresIn.toString(),
    );
    await _storage.write(
      key: 'expires_at',
      value: tokenModel.expiresAt.toIso8601String(),
    );
    await _storage.write(
      key: 'uid',
      value: tokenModel.uid,
    );
    await _storage.write(
      key: 'token_type',
      value: tokenModel.tokenType,
    );
    await _storage.write(
      key: 'scope',
      value: tokenModel.scope,
    );
  }

  Future<TokenModel> getTokens() async {
    String? accessToken = await _storage.read(key: 'access_token');
    String? refreshToken = await _storage.read(key: 'refresh_token');
    String? expiresIn = await _storage.read(key: 'expires_in');
    String? expiresAt = await _storage.read(key: 'expires_at');
    String? uid = await _storage.read(key: 'uid');
    String? tokenType = await _storage.read(key: 'token_type');
    String? scope = await _storage.read(key: 'scope');

    try {
      return TokenModel(
        accessToken: accessToken!,
        refreshToken: refreshToken!,
        uid: uid!,
        tokenType: tokenType!,
        expiresAt: DateTime.parse(expiresAt!),
        expiresIn: int.parse(expiresIn!),
        scope: scope!,
      );
    } catch (e) {
      throw Exception('Incomplete token data');
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'expires_in');
    await _storage.delete(key: 'expires_at');
  }
}
