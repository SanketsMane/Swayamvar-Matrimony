import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/repository/auth_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/app_navigation.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/phone_otp_verify.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/helpers/auth_helper.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup.dart';
import 'package:flutter/material.dart';



ThunkAction<AppState> requestOtpAction({
  required BuildContext context,
  required String phoneNumber,
}) {
  return (Store<AppState> store) async {
    try {
      debugPrint("Sanket: Starting Backend OTP Flow");
      
      var data = await AuthRepository().sendOtp(phone: phoneNumber);

      if (data.result == true) {
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
            builder: (context) => PhoneOtpVerify(
              verificationId: "backend_flow",
              phoneNumber: phoneNumber,
            ),
          ),
        );
      } else {
        store.dispatch(
          ShowMessageAction(
            msg: data.message ?? 'Failed to send OTP',
            color: MyTheme.failure,
          ),
        );
        
        if (data.message == 'User not found with this phone number') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUp(),
              ),
            );
        }
      }
    } catch (e) {
      debugPrint("Sanket: OTP Request Error -> $e");
      store.dispatch(
        ShowMessageAction(
          msg: 'Verification Failed: $e',
          color: MyTheme.failure,
        ),
      );
    }
  };
}

ThunkAction<AppState> verifyOtpAction({
  required BuildContext context,
  required String verificationId,
  required String smsCode,
  required String phoneNumber,
}) {
  return (Store<AppState> store) async {
    try {
      debugPrint("Sanket: Starting Backend OTP Verification");
      
      var data = await AuthRepository().verifyOtp(phone: phoneNumber, otp: smsCode);

      if (data.result == true) {
        setUserData(data);
        store.dispatch(ShowMessageAction(msg: data.message, color: MyTheme.success));
        store.dispatch(getUserIsApproveAction());
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppNavigation()),
          (route) => false,
        );
      } else {
        store.dispatch(
          ShowMessageAction(
            msg: data.message ?? 'Verification Failed', 
            color: MyTheme.failure
          )
        );
      }
    } catch (e) {
      debugPrint("Sanket: OTP Verify Error -> $e");
      store.dispatch(
        ShowMessageAction(
          msg: 'Verification Failed: $e',
          color: MyTheme.failure,
        ),
      );
    }
  };
}
