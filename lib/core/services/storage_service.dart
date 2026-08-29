import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class StorageService {
  String? getString(String key);
  Future<bool> setString(String key, String value);

  List<String>? getStringList(String key);
  Future<bool> setStringList(String key, List<String> value);

  int? getInt(String key);
  Future<bool> setInt(String key, int value);

  bool? getBool(String key);
  Future<bool> setBool(String key, bool value);

  Map<String, dynamic>? getJson(String key);
  Future<bool> setJson(String key, Map<String, dynamic> value);

  List<Map<String, dynamic>>? getJsonList(String key);
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value);

  Future<bool> remove(String key);
  Future<bool> clear();
}

class SharedPreferencesStorageService implements StorageService {
  const SharedPreferencesStorageService(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  @override
  Future<bool> setJson(String key, Map<String, dynamic> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  @override
  List<Map<String, dynamic>>? getJsonList(String key) {
    final rawList = _prefs.getStringList(key);
    if (rawList == null) return null;
    final result = <Map<String, dynamic>>[];
    for (final raw in rawList) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          result.add(decoded);
        } else if (decoded is Map) {
          result.add(Map<String, dynamic>.from(decoded));
        }
      } catch (_) {}
    }
    return result;
  }

  @override
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) {
    final rawList = value.map((e) => jsonEncode(e)).toList();
    return _prefs.setStringList(key, rawList);
  }

  @override
  Future<bool> remove(String key) => _prefs.remove(key);

  @override
  Future<bool> clear() => _prefs.clear();
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in ProviderScope');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesStorageService(prefs);
});
