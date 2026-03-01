import 'package:active_matrimonial_flutter_app/helpers/translation_helper.dart';
import 'package:active_matrimonial_flutter_app/components/make_alert.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/helpers/auth_helper.dart';
import 'package:active_matrimonial_flutter_app/helpers/localization.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/helpers/show_message_state.dart';
import 'package:active_matrimonial_flutter_app/repository/auth_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/app_navigation.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_action.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> signupMiddleware(
  BuildContext context, {
  dynamic firstName,
  dynamic lastName,
  dynamic email,
  dynamic phone,
  dynamic onBehalf,
  dynamic gender,
  dynamic dateOfBirth,
  dynamic password,
  dynamic passwordConfirmation,
  dynamic referral,
  dynamic recapthca,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SignUpAction());
    var g = int.parse(gender);

    try {
      var data = await AuthRepository().postSignUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        onBehalf: onBehalf,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: passwordConfirmation,
        referral: referral,
        gender: g,
        recapthca: recapthca,
      );
      store.dispatch(SignUpAction());
      store.dispatch(SignupReset());
      if (data.result == true) {
        setUserData(data);
        store.dispatch(
          ShowMessageAction(msg: data.message, color: MyTheme.success),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppNavigation()),
          (route) => false,
        );
      } else if (data.message.runtimeType == String && data.user == null) {
        MakeAlert.show(
          LangText(context: context).getLocal().info,
          TranslationHelper.translate(data.message),
          AlertType.warning,
        );
      } else if (data.message.runtimeType == List) {
        MakeAlert.show(
          LangText(context: context).getLocal().something_went_wrong,
          TranslationHelper.translate(data.message.first),
          AlertType.failed,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  };
}
