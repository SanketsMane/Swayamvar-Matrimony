import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/helpers/auth_helper.dart';
import 'package:active_matrimonial_flutter_app/repository/app_info_repository.dart';
import 'package:active_matrimonial_flutter_app/repository/auth_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/app_navigation.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/phone_otp_verify.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../helpers/shared_pref.dart';
import '../verify/verify_action.dart';

ThunkAction<AppState> requestFirebaseOtpAction({
  required BuildContext context,
  required String phoneNumber,
}) {
  return (Store<AppState> store) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution (Android only)
          store.dispatch(
            ShowMessageAction(
              msg: 'OTP Auto-verified. Signing in...',
              color: MyTheme.success,
            ),
          );
          await _signInClient(context, store, credential, phoneNumber);
        },
        verificationFailed: (FirebaseAuthException e) {
          store.dispatch(
            ShowMessageAction(
              msg: 'Verification Failed: ${e.message}',
              color: MyTheme.failure,
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          store.dispatch(
            ShowMessageAction(
              msg: 'OTP Sent successfully',
              color: MyTheme.success,
            ),
          );
          // Navigate to OTP entry screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PhoneOtpVerify(
                    verificationId: verificationId,
                    phoneNumber: phoneNumber, // to display or pass to backend
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout
        },
      );
    } catch (e) {
      store.dispatch(
        ShowMessageAction(
          msg: 'An error occurred. Try again.',
          color: MyTheme.failure,
        ),
      );
    }
  };
}

ThunkAction<AppState> verifyFirebaseOtpAction({
  required BuildContext context,
  required String verificationId,
  required String smsCode,
  required String phoneNumber,
}) {
  return (Store<AppState> store) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _signInClient(context, store, credential, phoneNumber);
    } on FirebaseAuthException catch (e) {
      store.dispatch(
        ShowMessageAction(
          msg: 'Invalid OTP: ${e.message}',
          color: MyTheme.failure,
        ),
      );
    } catch (e) {
      store.dispatch(
        ShowMessageAction(
          msg: 'An error occurred during verification.',
          color: MyTheme.failure,
        ),
      );
    }
  };
}

Future<void> _signInClient(
  BuildContext context,
  Store<AppState> store,
  PhoneAuthCredential credential,
  String phone,
) async {
  try {
    // 1. Sign into Firebase to ensure token is valid
    await FirebaseAuth.instance.signInWithCredential(credential);

    // 2. We are authenticated with Firebase! Now tell Laravel to log us in.
    var data = await AuthRepository().firebasePhoneLogin(phone: phone);

    if (data.result == true) {
      setUserData(data);
      store.dispatch(
        ShowMessageAction(msg: data.message, color: MyTheme.success),
      );
      store.dispatch(getUserIsApproveAction());

      // 3. Clear Navigation Stack and go to Dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AppNavigation()),
        (route) => false,
      );

      // (Optional) Setup Firebase Messaging Token
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
            await AppInfoRepository().getDeviceTokenUpdateResponse(
              deviceToken: fCMToken,
            );
          }
        } catch (e) {
          // Non-fatal exception handling
        }
      }
    } else {
      store.dispatch(
        ShowMessageAction(
          msg: data.message ?? 'Server login failed',
          color: MyTheme.failure,
        ),
      );
    }
  } catch (e) {
    store.dispatch(
      ShowMessageAction(
        msg: 'Authentication Failed: $e',
        color: MyTheme.failure,
      ),
    );
  }
}
