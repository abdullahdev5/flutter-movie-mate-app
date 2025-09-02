import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/app_providers.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {

  SharedPrefService(this._sharedPreferencesAsync);

  final SharedPreferencesAsync _sharedPreferencesAsync;


  // bool
  Future<void> setBool(String key, bool value) async {
    await _sharedPreferencesAsync.setBool(key, value);
  }
  Future<bool?> getBool(String key) async {
    return await _sharedPreferencesAsync.getBool(key);
  }

  // String
  Future<void> setString(String key, String value) async {
    await _sharedPreferencesAsync.setString(key, value);
  }
  Future<String?> getString(String key) async {
    return await _sharedPreferencesAsync.getString(key);
  }


}


final sharedPrefServiceProvider = Provider<SharedPrefService>((ref) => SharedPrefService(
  ref.read(sharedPreferencesAsyncProvider)
));