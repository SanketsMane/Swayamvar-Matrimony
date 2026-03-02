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

class RequestOtpAction {
  final BuildContext context;
  final String phoneNumber;

  RequestOtpAction({required this.context, required this.phoneNumber});

  @override
  String toString() {
    return 'RequestOtpAction{phoneNumber: $phoneNumber}';
  }
}

class VerifyOtpAction {
  final BuildContext context;
  final String verificationId;
  final String smsCode;
  final String phoneNumber;

  VerifyOtpAction({
    required this.context,
    required this.verificationId,
    required this.smsCode,
    required this.phoneNumber,
  });

  @override
  String toString() {
    return 'VerifyOtpAction{verificationId: $verificationId, smsCode: $smsCode, phoneNumber: $phoneNumber}';
  }
}
