import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();
  static final SecureStorage _instance = SecureStorage._constructor();

  SecureStorage._constructor();

  factory SecureStorage() {
    return _instance;
  }

  Future<void> saveKey(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> getKey(String key) async {
    return await storage.read(key: key);
  }

  Future<void> deleteKey(String key) async {
    await storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await storage.deleteAll();
  }
}
