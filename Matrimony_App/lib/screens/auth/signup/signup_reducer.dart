import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_state.dart';
import 'package:flutter/cupertino.dart';
import '../../../helpers/data_time_format.dart';
import '../../core.dart';
import 'signup_middleware.dart';

SignUpState sign_up_reducer(SignUpState state, dynamic action) {
  if (action is SignupReset) {
    return state.copyWith(
      firstNameController: "",
      lastNameController: "",
      emailController: "",
      passwordController: "",
      phoneNumber: "",
      confirmPasswordController: "",
      checkBox: false,
      isCodeSent: false,
      isVerified: false,
      isSendingCode: false,
      isVerifyingCode: false,
      verificationCodeController: TextEditingController(text: ""),
    );
  }

  if (action is SignUpRequestAction) {
    if (state.checkBox == false) {
      store.dispatch(ShowMessageAction(msg: 'Agree to terms and condition!'));
      return state;
    }
    if (!state.signUpFormKey.currentState!.validate()) {
      return state;
    }

    // Sanket: Explicit guard — only set Male(1) or Female(2), never a wrong value
    if (state.currentGender == "Female") {
      state.genderController!.text = "2";
    } else {
      state.genderController!.text = "1"; // Default to Male for null/any other value
    }

    // Preserve the '+' sign for E.164 formatting (fix for "invalid mobile number" error)
    String phoneValue = (action.phoneNumber?.phoneNumber ?? "");
    String emailValue = state.emailController!.text.trim();

    if (emailValue.isEmpty || phoneValue.isEmpty) {
      store.dispatch(
        ShowMessageAction(msg: 'Email and Phone cannot be empty!'),
      );
      return state;
    }

    // Use separate first and last name controllers directly
    String extractedFirstName = state.firstNameController!.text.trim();
    String extractedLastName = state.lastNameController!.text.trim();

    // Default "Profile Created For" to "Myself" (ID = 1) if omitted in the new UI
    String onBehalfValue = state.on_behalves_value?.toString() ?? "1";

    store.dispatch(
      signupMiddleware(
        action.payloadContext,
        firstName: extractedFirstName,
        lastName: extractedLastName,
        email: emailValue,
        phone: phoneValue,
        onBehalf: onBehalfValue,
        gender: state.genderController!.text,
        // Sanket: Guard DOB null — fallback to today if state.date is unexpectedly null
        dateOfBirth: yearMonthDay(state.date ?? DateTime.now()),
        password: state.passwordController!.text,
        passwordConfirmation: state.confirmPasswordController!.text,
        referral: state.referController!.text,
        recapthca: state.googleRecaptchaKey,
      ),
    );

    return state;
  }

  if (action is SignUpAction) {
    return loader(state, action);
  }
  if (action is SignupSetDateTimeAction) {
    return state.copyWith(date: action.payload!);
  }
  if (action is SignupSetOnBehalvesAction) {
    return state.copyWith(on_behalves_value: action.payload);
  }
  if (action is SignupSetGenderAction) {
    return state.copyWith(currentGender: action.payload);
  }
  if (action is SignupCheckBoxAction) {
    // Sanket: Use action.payload directly — avoids null crash from !state.checkBox!
    return state.copyWith(checkBox: action.payload ?? !(state.checkBox ?? false));
  }
  if (action is SignupSetEmailOrPhoneAction) {
    return state.copyWith(emailOrPhone: !state.emailOrPhone!);
  }
  if (action is SignupStoreOnBehalfAction) {
    return state.copyWith(
      onBehalfList: action.payload!.data,
      on_behalves_value: action.payload!.data?.first.id,
    );
  }
  if (action is SetKeyValueAction) {
    return state.copyWith(googleRecaptchaKey: action.keyValuePayload);
  }
  if (action is SetIsCaptchaShowingAction) {
    return state.copyWith(isCaptchaShowing: action.payload);
  }
  if (action is IsSendingCodeAction) {
    return state.copyWith(isSendingCode: !state.isSendingCode!);
  }
  if (action is IsVerifyingCodeAction) {
    return state.copyWith(isVerifyingCode: !state.isVerifyingCode!);
  }
  if (action is SetIsCodeSentAction) {
    return state.copyWith(isCodeSent: action.payload);
  }
  if (action is SetIsVerifiedAction) {
    return state.copyWith(isVerified: action.payload);
  }

  return state;
}

SignUpState loader(SignUpState state, SignUpAction action) {
  return state.copyWith(isLoading: !state.isLoading!);
}
