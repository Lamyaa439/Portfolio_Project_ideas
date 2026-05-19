class TokenStorage {
  final Map<String, String> _storage = {};
  static const String _tokenKey = 'access_token';

  Future<void> saveToken(String token) async {
    _storage[_tokenKey] = token;
  }

  Future<String?> getToken() async {
    return _storage[_tokenKey];
  }

  Future<void> clearToken() async {
    _storage.remove(_tokenKey);
  }
}
