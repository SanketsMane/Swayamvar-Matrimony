import 'package:flutter/material.dart';

class SignInAction {
  String? from;

  SignInAction({this.from});

  @override
  String toString() {
    return 'SignInAction{from: $from}';
  }
}

class SetPhoneNumberAction {
  var payload;

  @override
  String toString() {
    return 'SetPhoneNumberAction{payload: $payload}';
  }

  SetPhoneNumberAction({this.payload});
}

class IsObscureAction {
  @override
  String toString() {
    return 'IsObscureAction{}';
  }
}

class RequestFirebaseOtpAction {
  final BuildContext context;
  final String phoneNumber;

  RequestFirebaseOtpAction({required this.context, required this.phoneNumber});

  @override
  String toString() {
    return 'RequestFirebaseOtpAction{phoneNumber: $phoneNumber}';
  }
}

class VerifyFirebaseOtpAction {
  final BuildContext context;
  final String verificationId;
  final String smsCode;
  final String phoneNumber;

  VerifyFirebaseOtpAction({
    required this.context,
    required this.verificationId,
    required this.smsCode,
    required this.phoneNumber,
  });

  @override
  String toString() {
    return 'VerifyFirebaseOtpAction{verificationId: $verificationId, smsCode: $smsCode, phoneNumber: $phoneNumber}';
  }
}
