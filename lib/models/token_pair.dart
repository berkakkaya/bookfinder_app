class TokenPair {
  String accessToken;
  String refreshToken;

  TokenPair({
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenPair &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => (accessToken.hashCode + refreshToken.hashCode).hashCode;
}
