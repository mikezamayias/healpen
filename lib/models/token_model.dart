class TokenModel {
  final String accessToken;
  final String refreshToken;
  final String uid;
  final String tokenType;
  final DateTime expiresAt;
  final int expiresIn;
  final String scope;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.uid,
    required this.tokenType,
    required this.expiresAt,
    required this.expiresIn,
    required this.scope,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      uid: json['uid'],
      tokenType: json['token_type'],
      expiresAt: DateTime.parse(json['expires_at']),
      expiresIn: int.parse(json['expires_in']),
      scope: json['scope'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'uid': uid,
      'token_type': tokenType,
      'expires_at': expiresAt.toIso8601String(),
      'expires_in': expiresIn.toString(),
      'scope': scope,
    };
  }

  @override
  String toString() {
    final string =
        'TokenModel(accessToken: $accessToken, refreshToken: $refreshToken, uid: $uid, tokenType: $tokenType, expiresAt: $expiresAt, expiresIn: $expiresIn, scope: $scope)';
    return string;
  }
}
