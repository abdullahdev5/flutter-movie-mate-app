import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_mate_app/core/constants/shared_pref_keys.dart';
import 'package:movie_mate_app/core/service/shared_pref_service.dart';

class SettingsController extends ChangeNotifier {

  SettingsController(this._sharedPrefService) {
   loadSettings();
  }

  final SharedPrefService _sharedPrefService;

  bool _darkTheme = true;
  bool get darkTheme => _darkTheme;

  String _language = 'en-US';
  String get language => _language;

  bool _adult = true;
  bool get adult => _adult;

  Future<void> loadSettings() async {
    _darkTheme = await _sharedPrefService.getBool(SharedPrefKeys.darkTheme) ?? true;
    _language = await _sharedPrefService.getString(SharedPrefKeys.language) ?? 'en-US';
    _adult = await _sharedPrefService.getBool(SharedPrefKeys.adult) ?? true;
    notifyListeners();
  }


  Future<void> setLanguage(String lan) async {
    _language = lan;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      _sharedPrefService.setString(SharedPrefKeys.language, lan);
    });
  }

  Future<void> toggleTheme(bool value) async {
    _darkTheme = value;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      _sharedPrefService.setBool(SharedPrefKeys.darkTheme, value);
    });
  }

  Future<void> toggleAdult(bool value) async {
    _adult = value;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      _sharedPrefService.setBool(SharedPrefKeys.adult, value);
    });
  }


}

final settingsControllerProvider = ChangeNotifierProvider<SettingsController>((ref) {
  final sharedPrefService = ref.read(sharedPrefServiceProvider);
  return SettingsController(sharedPrefService);
});