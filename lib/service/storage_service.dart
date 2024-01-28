import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> writeData(String key, String? value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    final data = await _storage.read(key: key);
    return data;
  }

  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsData(String key) async {
    final data = await _storage.containsKey(key: key);
    return data;
  }
}
