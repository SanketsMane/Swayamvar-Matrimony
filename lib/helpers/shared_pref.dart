import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  // Singleton setup
  static final SharedPref _instance = SharedPref._internal();
  SharedPreferences? _prefs;

  SharedPref._internal();

  factory SharedPref() {
    return _instance;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _checkAndClearInvalidData();
  }

  void _checkAndClearInvalidData() {
    if (_prefs != null) {
      if (_prefs!.containsKey('isLoggedIn') &&
          _prefs!.get('isLoggedIn') is! bool) {
        _prefs!.remove('isLoggedIn');
      }
    }
  }

  /// is logged in
  bool get isLoggedIn => _prefs?.getBool('isLoggedIn') ?? false;

  set isLoggedIn(bool value) {
    _prefs?.setBool('isLoggedIn', value);
  }

  /// is view
  bool get isView => _prefs?.getBool('isView') ?? false;

  set isView(bool value) {
    _prefs?.setBool('isView', value);
  }

  /// showDialog
  bool get showDialog => _prefs?.getBool('showDialog') ?? false;

  set showDialog(bool value) {
    _prefs?.setBool('showDialog', value);
  }

  /// deactivate
  bool get deactivate => _prefs?.getBool('deactivate') ?? false;

  set deactivate(bool value) {
    _prefs?.setBool('deactivate', value);
  }

  /// user access token
  String get accessToken => _prefs?.getString('accessToken') ?? '';

  set accessToken(String value) {
    _prefs?.setString('accessToken', value);
  }

  /// user name
  String get userName => _prefs?.getString('userName') ?? '';

  set userName(String value) {
    _prefs?.setString('userName', value);
  }

  /// resetVerificationCode
  String get resetVerificationCode =>
      _prefs?.getString('resetVerificationCode') ?? '';

  set resetVerificationCode(String value) {
    _prefs?.setString('resetVerificationCode', value);
  }

  /// resetSendBy
  String get resetSendBy => _prefs?.getString('resetSendBy') ?? '';

  set resetSendBy(String value) {
    _prefs?.setString('resetSendBy', value);
  }

  /// resetEmail
  String get resetEmail => _prefs?.getString('resetEmail') ?? '';

  set resetEmail(String value) {
    _prefs?.setString('resetEmail', value);
  }

  /// user email
  String get userEmail => _prefs?.getString('userEmail') ?? '';

  set userEmail(String value) {
    _prefs?.setString('userEmail', value);
  }

  ///deactivation status
  String get deactivated => _prefs?.getString('deactivated') ?? '';

  set deactivated(String value) {
    _prefs?.setString('deactivated', value);
  }

  /// language
  String? get language => _prefs?.getString('language');

  set language(String? value) {
    if (value != null) {
      _prefs?.setString('language', value);
    }
  }

  /// Advanced Search Filters Persistence
  int? get advReligionId => _prefs?.getInt('adv_religion_id');
  set advReligionId(int? value) =>
      value != null
          ? _prefs?.setInt('adv_religion_id', value)
          : _prefs?.remove('adv_religion_id');

  int? get advCasteId => _prefs?.getInt('adv_caste_id');
  set advCasteId(int? value) =>
      value != null
          ? _prefs?.setInt('adv_caste_id', value)
          : _prefs?.remove('adv_caste_id');

  int? get advCountryId => _prefs?.getInt('adv_country_id');
  set advCountryId(int? value) =>
      value != null
          ? _prefs?.setInt('adv_country_id', value)
          : _prefs?.remove('adv_country_id');

  int? get advStateId => _prefs?.getInt('adv_state_id');
  set advStateId(int? value) =>
      value != null
          ? _prefs?.setInt('adv_state_id', value)
          : _prefs?.remove('adv_state_id');

  int? get advCityId => _prefs?.getInt('adv_city_id');
  set advCityId(int? value) =>
      value != null
          ? _prefs?.setInt('adv_city_id', value)
          : _prefs?.remove('adv_city_id');

  String? get advMaritalStatus => _prefs?.getString('adv_marital_status');
  set advMaritalStatus(String? value) =>
      value != null
          ? _prefs?.setString('adv_marital_status', value)
          : _prefs?.remove('adv_marital_status');

  /// Call this method on user logout.
  void clear() {
    _prefs?.clear();
  }
}
