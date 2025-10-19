import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();
  static const _key = 'token';
  static final SecureStorage _instance = SecureStorage._constructor();

  SecureStorage._constructor();

  factory SecureStorage() {
    return _instance;
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: _key, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: _key);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: _key);
  }
}
