abstract class ApiAuthSubservice {
  Future<String> login(String username, String password);
  Future<String> register(String username, String password);
  Future<void> logout(String authHeader);
}
