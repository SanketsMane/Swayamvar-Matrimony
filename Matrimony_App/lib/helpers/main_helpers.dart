import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/profile_dropdown_middleware.dart';
import 'package:active_matrimonial_flutter_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

bool isNumber(String text) {
  return RegExp('^[0-9]+\$').hasMatch(text);
}

bool isEmail(String text) {
  return RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(text);
}

String capitalize(String text) {
  return toBeginningOfSentenceCase(text) ?? text;
}

/// Sanket: Get token from AuthService (Secure Storage) or fallback to SharedPref
String? get getToken => AuthService().token ?? SharedPref().accessToken;

bool settingIsActive(String key, String value) {
  return store.state.systemSettingState!.settingResponse?.data![key] == value;
}

dynamic getSettingValue(String key) {
  return store.state.systemSettingState!.settingResponse?.data![key];
}

void setProfileDropdownValues() {
  !store.state.manageProfileCombineState!.profiledropdownResponseData!.result!
      ? store.dispatch(profiledropdownMiddleware())
      : null;
}

Map<String, String> get commonHeader => {
  "Accept": "application/json",
  "Content-Type": "application/json",
};

Map<String, String> get authHeader => {"Authorization": "Bearer $getToken"};

Widget itemSpacer(h, w) => SizedBox(height: h.toDouble(), width: w.toDouble());
