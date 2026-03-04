import 'package:flutter/material.dart';

class SignUpState {
  bool? isLoading;
  List? onBehalfList = [];
  bool? isCaptchaShowing;
  String? googleRecaptchaKey;
  // Sanket: Critical — must be a single stable instance, never recreated.
  // Recreating GlobalKey on every copyWith disconnects it from the mounted Form.
  GlobalKey<FormState> signUpFormKey;
  TextEditingController? verificationCodeController;
  bool? isCodeSent;
  bool? isVerified;
  bool? isSendingCode;
  bool? isVerifyingCode;
  SignUpState({
    this.isLoading,
    this.onBehalfList,
    required this.signUpFormKey,
    this.firstNameController,
    this.lastNameController,
    this.emailController,
    this.passwordController,
    this.confirmPasswordController,
    this.dobController,
    this.referController,
    this.genderController,
    this.phoneNumber,
    this.date,
    this.on_behalves_value,
    this.genderItems,
    this.currentGender,
    this.checkBox,
    this.emailOrPhone,
    this.isCaptchaShowing,
    this.googleRecaptchaKey,
    this.verificationCodeController,
    this.isCodeSent,
    this.isVerified,
    this.isSendingCode,
    this.isVerifyingCode,
  });

  TextEditingController? firstNameController = TextEditingController();
  TextEditingController? lastNameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? confirmPasswordController = TextEditingController();
  TextEditingController? dobController = TextEditingController();
  TextEditingController? referController = TextEditingController();
  TextEditingController? genderController = TextEditingController();
  var phoneNumber;
  DateTime? date = DateTime.now();
  var on_behalves_value;

  List? genderItems = ['Male', 'Female'];
  String? currentGender = "Male";

  bool? checkBox = false;
  bool? emailOrPhone;

  SignUpState copyWith({
    bool? isLoading,
    List? onBehalfList,
    String? firstNameController,
    String? lastNameController,
    String? emailController,
    String? passwordController,
    String? confirmPasswordController,
    String? dobController,
    String? referController,
    String? genderController,
    var phoneNumber,
    DateTime? date,
    var on_behalves_value,
    List? genderItems,
    String? currentGender,
    bool? checkBox,
    bool? emailOrPhone,
    bool? isCaptchaShowing,
    String? googleRecaptchaKey,
    TextEditingController? verificationCodeController,
    bool? isCodeSent,
    bool? isVerified,
    bool? isSendingCode,
    bool? isVerifyingCode,
  }) {
    // Sanket: Reuse existing controllers if no new text is provided
    // This prevents cursor-jumping and focus loss on every Redux state update
    if (firstNameController != null) this.firstNameController?.text = firstNameController;
    if (lastNameController != null) this.lastNameController?.text = lastNameController;
    if (emailController != null) this.emailController?.text = emailController;
    if (passwordController != null) this.passwordController?.text = passwordController;
    if (confirmPasswordController != null) this.confirmPasswordController?.text = confirmPasswordController;
    if (dobController != null) this.dobController?.text = dobController;
    if (referController != null) this.referController?.text = referController;
    if (genderController != null) this.genderController?.text = genderController;

    return SignUpState(
      // Sanket: Preserve the same key instance — never create a new one
      signUpFormKey: this.signUpFormKey,
      isLoading: isLoading ?? this.isLoading,
      onBehalfList: onBehalfList ?? this.onBehalfList,
      firstNameController: this.firstNameController,
      lastNameController: this.lastNameController,
      emailController: this.emailController,
      passwordController: this.passwordController,
      confirmPasswordController: this.confirmPasswordController,
      dobController: this.dobController,
      referController: this.referController,
      genderController: this.genderController,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      date: date ?? this.date,
      on_behalves_value: on_behalves_value ?? this.on_behalves_value,
      genderItems: genderItems ?? this.genderItems,
      currentGender: currentGender ?? this.currentGender,
      checkBox: checkBox ?? this.checkBox,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      isCaptchaShowing: isCaptchaShowing ?? this.isCaptchaShowing,
      googleRecaptchaKey: googleRecaptchaKey ?? this.googleRecaptchaKey,
      verificationCodeController:
          verificationCodeController ?? this.verificationCodeController,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isVerified: isVerified ?? this.isVerified,
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isVerifyingCode: isVerifyingCode ?? this.isVerifyingCode,
    );
  }

  SignUpState.initialState()
    : checkBox = false,
      emailOrPhone = true,
      isCaptchaShowing = false,
      googleRecaptchaKey = "",
      // Sanket: Create the key once here — never recreated after this
      signUpFormKey = GlobalKey<FormState>(),
      onBehalfList = [],
      isLoading = false,
      verificationCodeController = TextEditingController(),
      isCodeSent = false,
      isVerified = false,
      isSendingCode = false,
      isVerifyingCode = false;
}
