import 'package:active_matrimonial_flutter_app/helpers/translation_helper.dart';
import 'package:active_matrimonial_flutter_app/components/make_alert.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/helpers/localization.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/helpers/show_message_state.dart';
import 'package:active_matrimonial_flutter_app/repository/auth_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/phone_login.dart';
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
      // Sanket: Toggle loading OFF after API responds
      store.dispatch(SignUpAction());

      if (data.result == true) {
        // Sanket: Only reset form on success — not on error
        store.dispatch(SignupReset());
        // Sanket: Do NOT auto-login after signup.
        // Show success message and redirect to login screen.
        store.dispatch(
          ShowMessageAction(
            msg: 'नोंदणी यशस्वी! कृपया लॉगिन करा.',
            color: MyTheme.success,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PhoneLogin()),
          (route) => false,
        );
      } else if (data.message.runtimeType == String && data.user == null) {
        // Sanket: Show API error, form stays intact for the user to correct
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
      // Sanket: Always turn loading OFF on error — prevents button getting stuck
      store.dispatch(SignUpAction());
      debugPrint(e.toString());
      return;
    }
  };
}
