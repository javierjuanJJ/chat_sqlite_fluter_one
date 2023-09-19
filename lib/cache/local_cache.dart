import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalCache {
  Future<void> save( String key, Map<String, dynamic> json);
  Map<String, dynamic> fetch(String key);
}

class LocalCache implements ILocalCache {
  final SharedPreferences _sharedPreferences;

  LocalCache(this._sharedPreferences);

  @override
  Map<String, dynamic> fetch(String key) {
    // final String? valueJson = _sharedPreferences.getString(key);
    //
    // if (valueJson != null){
    //   return jsonDecode(valueJson);
    // }
    // else {
    //   return {};
    // }
    //
    return jsonDecode(_sharedPreferences.getString(key) ?? '{}');
  }

  @override
  Future<void> save(String key, Map<String, dynamic> json) async {
    await jsonEncode(_sharedPreferences.getString(key) ?? '{}');
  }

}