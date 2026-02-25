import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/helpers/auth_helper.dart';
import 'package:active_matrimonial_flutter_app/repository/auth_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin_action.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../helpers/shared_pref.dart';
import '../../../repository/app_info_repository.dart';
import '../../app_navigation.dart';
import '../verify/verify_action.dart';

ThunkAction<AppState> signInMiddleware({email, password, from, context}) {
  return (Store<AppState> store) async {
    store.dispatch(SignInAction(from: from));
    var data =
        (await AuthRepository().signIn(email: email, password: password))!;

    if (data.result == true) {
      setUserData(data);
      store.dispatch(
          ShowMessageAction(msg: data.message, color: MyTheme.success));
      store.dispatch(getUserIsApproveAction());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppNavigation()),
          (route) => false);
      store.state.signInState!.emailController!.clear();
      store.state.signInState!.passwordController!.clear();

      // Sanket: Firebase Messaging requires service workers — skip on web where it's unsupported
      if (!kIsWeb) {
        try {
          final FirebaseMessaging fcm = FirebaseMessaging.instance;

          await fcm.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

          String? fCMToken = await fcm.getToken();

          if (fCMToken != null && SharedPref().isLoggedIn) {
            await AppInfoRepository()
                .getDeviceTokenUpdateResponse(deviceToken: fCMToken);
          }
        } catch (e) {
          // Non-fatal: token registration failed, app continues normally
        }
      }
    } else {
      store.dispatch(
          ShowMessageAction(msg: data.message, color: MyTheme.failure));
    }

    store.dispatch(SignInAction(from: from));
  };
}
