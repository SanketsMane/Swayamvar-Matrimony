// Sanket: Updated Sign Up screen with full Marathi translations
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:active_matrimonial_flutter_app/components/common_privacy_and_terms_page.dart';
import 'package:active_matrimonial_flutter_app/components/social_login_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/add_on/addon_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/repository/auth_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_action.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/on_behalf_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/staticPage/static_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final bool _isRecaptchaActive = settingIsActive('recaptcha_user_register', '1');
  late final WebViewController _controller;
  final String _recaptchaUrl = "${AppConfig.BASE_URL}/google-recaptcha";
  bool _isObscure = true;
  PhoneNumber _selectedPhoneNumber = PhoneNumber(isoCode: '');
  final TextEditingController _otpController = TextEditingController();
  bool _isCodeSent = false;
  bool _isSendingCode = false;
  bool _isVerified = false;
  bool _verificationFailed = false;
  bool _isVerifyingCode = false;

  bool? isGoogle = settingIsActive('google_login_activation', '1');
  bool? isFacebook = settingIsActive('facebook_login_activation', '1');
  bool? isTwitter = settingIsActive('twitter_login_activation', "1");
  bool? isOtpSystem = store.state.addonState!.data!.otpSystem ?? false;

  final Color primaryColor = const Color(0xFFE54861);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFECECEC);
  final Color inputFillColor = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    if (_isRecaptchaActive) _setupWebViewController();
  }

  void _setupWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel('Captcha', onMessageReceived: (message) {
          if (message.message.isNotEmpty && message.message != "error") {
            store.dispatch(SetKeyValueAction(keyValuePayload: message.message));
          }
      })
      ..loadRequest(Uri.parse(_recaptchaUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) {
          store.dispatch(fetchOnbehalfMiddleware());
          store.dispatch(addonCheckMiddleware());
          store.dispatch(fetchStaticPageAction());
        },
        builder: (_, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                children: [
                  Center(child: Image.asset('assets/logo/app_logo.png', height: 72, color: primaryColor)),
                  const SizedBox(height: 24),
                  Text("तुमचे प्रोफाइल तयार करा", style: Styles.h1.copyWith(color: textPrimary)),
                  const SizedBox(height: 8),
                  Text("तुमचा योग्य जीवनसाथी शोधण्यासाठी प्रवास सुरू करा ❤️", textAlign: TextAlign.center, style: Styles.body.copyWith(color: textSecondary)),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4))]),
                    child: Form(
                      key: state.signUpState!.signUpFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputField(title: "च्या वतीने", child: DropdownButtonFormField<dynamic>(
                            dropdownColor: cardColor,
                            icon: Icon(Icons.keyboard_arrow_down, color: textSecondary),
                            decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                            value: state.signUpState!.on_behalves_value,
                            items: state.signUpState!.onBehalfList?.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name!, style: Styles.body.copyWith(color: textPrimary)))).toList() ?? [],
                            onChanged: (val) => store.dispatch(SignupSetOnBehalvesAction(payload: val)),
                          )),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(child: _buildInputField(title: "पहिले नाव", child: TextFormField(controller: state.signUpState?.firstNameController, style: Styles.body.copyWith(color: textPrimary), decoration: InputDecoration(hintText: "पहिले नाव", hintStyle: Styles.body.copyWith(color: textSecondary.withOpacity(0.5)), border: InputBorder.none)))),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField(title: "आडनाव", child: TextFormField(controller: state.signUpState?.lastNameController, style: Styles.body.copyWith(color: textPrimary), decoration: InputDecoration(hintText: "आडनाव", hintStyle: Styles.body.copyWith(color: textSecondary.withOpacity(0.5)), border: InputBorder.none)))),
                          ]),
                          const SizedBox(height: 16),
                          _buildInputField(title: "लिंग", child: DropdownButtonFormField(
                            dropdownColor: cardColor,
                            icon: Icon(Icons.keyboard_arrow_down, color: textSecondary),
                            decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                            value: state.signUpState!.currentGender,
                            items: state.signUpState!.genderItems?.map((e) => DropdownMenuItem(value: e, child: Text(e == 'Male' ? 'पुरुष' : (e == 'Female' ? 'महिला' : e), style: Styles.body.copyWith(color: textPrimary)))).toList() ?? [],
                            onChanged: (val) => store.dispatch(SignupSetGenderAction(payload: val as String?)),
                          )),
                          const SizedBox(height: 16),
                          _buildInputField(title: "जन्म तारीख", child: InkWell(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(context: context, initialDate: state.signUpState!.date ?? DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now());
                              if(picked != null) store.dispatch(SignupSetDateTimeAction(payload: picked));
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(state.signUpState!.date != null ? DateFormat('d MMMM yyyy').format(state.signUpState!.date!) : "तारीख निवडा", style: Styles.body.copyWith(color: textPrimary)),
                              Icon(Icons.calendar_today_outlined, color: textSecondary, size: 18),
                            ]),
                          )),
                          const SizedBox(height: 16),
                          _buildEmailOrOtpSection(state),
                          const SizedBox(height: 16),
                          _buildInputField(title: "पासवर्ड", child: TextFormField(controller: state.signUpState?.passwordController, obscureText: _isObscure, style: Styles.body.copyWith(color: textPrimary, fontSize: 14), decoration: InputDecoration(hintText: "••••••••", border: InputBorder.none, suffixIcon: GestureDetector(onTap: () => setState(() => _isObscure = !_isObscure), child: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: textSecondary, size: 20))))),
                          const SizedBox(height: 16),
                          _buildInputField(title: "पासवर्डची पुष्टी करा", child: TextFormField(controller: state.signUpState?.confirmPasswordController, obscureText: _isObscure, style: Styles.body.copyWith(color: textPrimary, fontSize: 14), decoration: InputDecoration(hintText: "••••••••", border: InputBorder.none))),
                          const SizedBox(height: 24),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Checkbox(value: state.signUpState!.checkBox ?? false, onChanged: (v) => store.dispatch(SignupCheckBoxAction(payload: v)), activeColor: primaryColor),
                            Expanded(child: RichText(text: TextSpan(text: "मी ", style: Styles.caption.copyWith(color: textSecondary), children: [
                              TextSpan(text: "अटी आणि शर्ती", style: Styles.caption.copyWith(color: primaryColor, fontWeight: FontWeight.w600), recognizer: TapGestureRecognizer()..onTap = () => NavigatorPush.push(context, const CommonPrivacyAndTerms(title: "अटी आणि शर्ती", content: ""))),
                              const TextSpan(text: " आणि "),
                              TextSpan(text: "गोपनीयता धोरणाशी", style: Styles.caption.copyWith(color: primaryColor, fontWeight: FontWeight.w600), recognizer: TapGestureRecognizer()..onTap = () => NavigatorPush.push(context, const CommonPrivacyAndTerms(title: "गोपनीयता धोरण", content: ""))),
                              const TextSpan(text: " सहमत आहे."),
                            ]))),
                          ]),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: (state.signUpState!.isLoading ?? false) ? null : () => store.dispatch(SignUpRequestAction(payloadContext: context, phoneNumber: _selectedPhoneNumber)),
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: (state.signUpState!.isLoading ?? false) ? const CircularProgressIndicator(color: Colors.white) : Text("प्रोफाईल तयार करा", style: Styles.buttonText.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 24),
                          if ((isGoogle ?? false) || (isFacebook ?? false) || (isTwitter ?? false))
                            Column(children: [Center(child: Text("किंवा नोंदणी करा", style: Styles.caption.copyWith(color: textSecondary, fontSize: 13))), const SizedBox(height: 16), const SocialLoginWidget()]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(child: InkWell(onTap: () => Navigator.pop(context), child: RichText(text: TextSpan(text: "आधीच खाते आहे का? ", style: Styles.body.copyWith(color: textSecondary), children: [TextSpan(text: "लॉगिन करा", style: Styles.buttonText.copyWith(color: primaryColor, fontWeight: FontWeight.w700))])))),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({required String title, required Widget child}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Styles.body.copyWith(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Container(height: 48, padding: const EdgeInsets.symmetric(horizontal: 16), alignment: Alignment.centerLeft, decoration: BoxDecoration(color: inputFillColor, borderRadius: BorderRadius.circular(12)), child: child),
    ]);
  }

  Widget _buildEmailOrOtpSection(AppState state) {
    bool isPhone = isOtpSystem! && (state.signUpState!.emailOrPhone ?? false);
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      _buildInputField(title: isPhone ? "मोबाईल नंबर" : "ईमेल आयडी", child: isPhone 
        ? InternationalPhoneNumberInput(onInputChanged: (n) => setState(() => _selectedPhoneNumber = n), countries: store.state.commonState!.countriesToString(), selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG, setSelectorButtonAsPrefixIcon: true), textStyle: Styles.body.copyWith(color: textPrimary), inputDecoration: const InputDecoration(hintText: "8XXXXXXXXX", border: InputBorder.none))
        : TextFormField(controller: state.signUpState?.emailController, style: Styles.body.copyWith(color: textPrimary), decoration: const InputDecoration(hintText: "ईमेल प्रविष्ट करा", border: InputBorder.none))),
      const SizedBox(height: 8),
      GestureDetector(onTap: () => store.dispatch(SignupSetEmailOrPhoneAction()), child: Text(isPhone ? "ईमेलने नोंदणी करा" : "मोबाईलने नोंदणी करा", style: Styles.buttonText.copyWith(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600))),
    ]);
  }
}
