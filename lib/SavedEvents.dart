import 'package:shared_preferences/shared_preferences.dart';

class SavedEvents {
  static SavedEvents _events;
  static SharedPreferences _preferences;

  static Future getInstance() async {
    if (_events == null) {
      var secureStorage = SavedEvents._();
      await secureStorage._init();
      _events = secureStorage;
    }
    return _events;
  }
  SavedEvents._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }
}