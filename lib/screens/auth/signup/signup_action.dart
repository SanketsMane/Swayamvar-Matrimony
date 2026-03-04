import 'package:active_matrimonial_flutter_app/models_response/drop_down/on_behalf.dart';
// ADD THIS IMPORT
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpAction {}

class SignupReset {}

class SignUpRequestAction {
  var payloadContext;
  PhoneNumber? phoneNumber;

  SignUpRequestAction({this.payloadContext, this.phoneNumber});

  @override
  String toString() {
    return 'SignUpRequestAction{payloadContext: $payloadContext, phoneNumber: $phoneNumber}';
  }
}

class SetKeyValueAction {
  var keyValuePayload;

  SetKeyValueAction({this.keyValuePayload});

  @override
  String toString() {
    return 'SetKeyValueActionAction{keyValuePayload: $keyValuePayload}';
  }
}

class SetIsCaptchaShowingAction {
  var payload;

  SetIsCaptchaShowingAction({this.payload});
  @override
  String toString() {
    return 'SetIsCaptchaShowingAction{payload: $payload}';
  }
}

class SignupSetDateTimeAction {
  DateTime? payload;

  SignupSetDateTimeAction({this.payload});

  @override
  String toString() {
    return 'SignupSetDateTime{payload: $payload}';
  }
}

class SignupSetOnBehalvesAction {
  var payload;

  SignupSetOnBehalvesAction({this.payload});

  @override
  String toString() {
    return 'SignupSetOnBehalves{payload: $payload}';
  }
}

class SignupSetGenderAction {
  String? payload;

  SignupSetGenderAction({this.payload});

  @override
  String toString() {
    return 'SignupSetGender{payload: $payload}';
  }
}

class SignupCheckBoxAction {
  bool? payload;

  SignupCheckBoxAction({this.payload});

  @override
  String toString() {
    return 'SignupCheckBox{payload: $payload}';
  }
}

class SignupSetEmailOrPhoneAction {
  @override
  String toString() {
    return 'SignupSetEmailOrPhone{}';
  }
}

class SignupStoreOnBehalfAction {
  OnbehalfResponse? payload;

  SignupStoreOnBehalfAction({this.payload});

  @override
  String toString() {
    return 'SignupStoreOnBehalf{payload: $payload}';
  }
}

class IsSendingCodeAction {}

class IsVerifyingCodeAction {}

class SetIsCodeSentAction {
  final bool payload;
  SetIsCodeSentAction(this.payload);
}

class SetIsVerifiedAction {
  final bool payload;
  SetIsVerifiedAction(this.payload);
}
