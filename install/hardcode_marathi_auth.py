import os

# Update Sign In (signin.dart)
signin_code = """// Sanket: Updated Sign In screen with Marathi translations and clean UI
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/feature/feature_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/forgetPassword/forget_password.dart';
import 'package:active_matrimonial_flutter_app/components/social_login_widget.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/staticPage/static_page.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin_reducer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Color primaryColor = const Color(0xFFE54861);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFECECEC);

  bool? isGoogle = settingIsActive('google_login_activation', '1');
  bool? isFacebook = settingIsActive('facebook_login_activation', '1');
  bool? isTwitter = settingIsActive('twitter_login_activation', "1");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => [
          store.dispatch(fetchStaticPageAction()),
          SharedPref().isView = true,
          store.dispatch(featureCheckMiddleware()),
        ],
        builder: (_, state) => _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppState state) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 64),
            Image.asset(
              'assets/logo/app_logo.png',
              height: 80,
              color: primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'तुमचा योग्य जीवनसाथी शोधा ❤️', // Find Your Perfect Life Partner
              style: TextStyle(
                fontFamily: 'Mukta',
                fontSize: 16,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            _buildLoginCard(context, state),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: borderColor, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'किंवा', // OR
                    style: TextStyle(color: textSecondary, fontFamily: 'Mukta'),
                  ),
                ),
                Expanded(child: Divider(color: borderColor, thickness: 1)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "खाते नाही का? ", // Don't have an account?
                  style: TextStyle(color: textSecondary, fontFamily: 'Mukta'),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  ),
                  child: const Text('नोंदणी करा'), // Register/Sign Up
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    textStyle: const TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'सुरू ठेवून तुम्ही अटी आणि गोपनीयता धोरणाशी सहमत आहात', // Terms & Privacy
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondary,
                  fontFamily: 'Mukta',
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (isGoogle == true || isFacebook == true || isTwitter == true)
              const SocialLoginWidget(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context, AppState state) {
    final store = StoreProvider.of<AppState>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'लॉगिन करा', // Sign In
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Mukta',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildInputField(
            controller: state.signInState!.emailController!,
            hint: "ईमेल किंवा मोबाईल नंबर", // Email or Mobile Number
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(state, context),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgetPassword()),
              ),
              child: Text(
                "पासवर्ड विसरलात?", // Forgot Password?
                style: TextStyle(fontSize: 13, color: primaryColor, fontFamily: 'Mukta', fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => store.dispatch(LoginRequest(payloadContext: context)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: state.signInState!.isLogin == false
                  ? const Text(
                      'लॉगिन करा', // Sign In
                      style: TextStyle(
                        fontFamily: 'Mukta',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta'),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: textSecondary, size: 20),
        hintText: hint,
        hintStyle: TextStyle(color: textSecondary.withOpacity(0.5), fontFamily: 'Mukta'),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildPasswordField(AppState state, BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return TextField(
      controller: state.signInState!.passwordController!,
      obscureText: state.signInState!.isObscure!,
      style: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta'),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: textSecondary, size: 20),
        hintText: "पासवर्ड प्रविष्ट करा", // Enter Password
        hintStyle: TextStyle(color: textSecondary.withOpacity(0.5), fontFamily: 'Mukta'),
        suffixIcon: GestureDetector(
          onTap: () => store.dispatch(IsObscureAction()),
          child: Icon(
            state.signInState!.isObscure! ? Icons.visibility_off : Icons.visibility,
            color: textSecondary,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }
}
"""

# Update Sign Up (signup.dart)
signup_code = r'''// Sanket: Updated Sign Up screen with full Marathi translations
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
                  Text("तुमचे प्रोफाइल तयार करा", style: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Mukta')),
                  const SizedBox(height: 8),
                  Text("तुमचा योग्य जीवनसाथी शोधण्यासाठी प्रवास सुरू करा ❤️", textAlign: TextAlign.center, style: TextStyle(color: textSecondary, fontSize: 14, fontFamily: 'Mukta')),
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
                            items: state.signUpState!.onBehalfList?.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name!, style: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta')))).toList() ?? [],
                            onChanged: (val) => store.dispatch(SignupSetOnBehalvesAction(payload: val)),
                          )),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(child: _buildInputField(title: "पहिले नाव", child: TextFormField(controller: state.signUpState?.firstNameController, style: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta'), decoration: InputDecoration(hintText: "पहिले नाव", hintStyle: TextStyle(color: textSecondary.withOpacity(0.5), fontSize: 14, fontFamily: 'Mukta'), border: InputBorder.none)))),
                            const SizedBox(width: 12),
                            Expanded(child: _buildInputField(title: "आडनाव", child: TextFormField(controller: state.signUpState?.lastNameController, style: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta'), decoration: InputDecoration(hintText: "आडनाव", hintStyle: TextStyle(color: textSecondary.withOpacity(0.5), fontSize: 14, fontFamily: 'Mukta'), border: InputBorder.none)))),
                          ]),
                          const SizedBox(height: 16),
                          _buildInputField(title: "लिंग", child: DropdownButtonFormField(
                            dropdownColor: cardColor,
                            icon: Icon(Icons.keyboard_arrow_down, color: textSecondary),
                            decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                            value: state.signUpState!.currentGender,
                            items: state.signUpState!.genderItems?.map((e) => DropdownMenuItem(value: e, child: Text(e == 'Male' ? 'पुरुष' : (e == 'Female' ? 'महिला' : e), style: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta')))).toList() ?? [],
                            onChanged: (val) => store.dispatch(SignupSetGenderAction(payload: val as String?)),
                          )),
                          const SizedBox(height: 16),
                          _buildInputField(title: "जन्म तारीख", child: InkWell(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(context: context, initialDate: state.signUpState!.date ?? DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now());
                              if(picked != null) store.dispatch(SignupSetDateTimeAction(payload: picked));
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(state.signUpState!.date != null ? DateFormat('d MMMM yyyy').format(state.signUpState!.date!) : "तारीख निवडा", style: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta')),
                              Icon(Icons.calendar_today_outlined, color: textSecondary, size: 18),
                            ]),
                          )),
                          const SizedBox(height: 16),
                          _buildEmailOrOtpSection(state),
                          const SizedBox(height: 16),
                          _buildInputField(title: "पासवर्ड", child: TextFormField(controller: state.signUpState?.passwordController, obscureText: _isObscure, style: TextStyle(color: textPrimary, fontSize: 14), decoration: InputDecoration(hintText: "••••••••", border: InputBorder.none, suffixIcon: GestureDetector(onTap: () => setState(() => _isObscure = !_isObscure), child: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: textSecondary, size: 20))))),
                          const SizedBox(height: 16),
                          _buildInputField(title: "पासवर्डची पुष्टी करा", child: TextFormField(controller: state.signUpState?.confirmPasswordController, obscureText: _isObscure, style: TextStyle(color: textPrimary, fontSize: 14), decoration: InputDecoration(hintText: "••••••••", border: InputBorder.none))),
                          const SizedBox(height: 24),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Checkbox(value: state.signUpState!.checkBox ?? false, onChanged: (v) => store.dispatch(SignupCheckBoxAction(payload: v)), activeColor: primaryColor),
                            Expanded(child: RichText(text: TextSpan(text: "मी ", style: TextStyle(color: textSecondary, fontSize: 12, fontFamily: 'Mukta'), children: [
                              TextSpan(text: "अटी आणि शर्ती", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600), recognizer: TapGestureRecognizer()..onTap = () => NavigatorPush.push(context, const CommonPrivacyAndTerms(title: "अटी आणि शर्ती", content: ""))),
                              TextSpan(text: " आणि "),
                              TextSpan(text: "गोपनीयता धोरणाशी", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600), recognizer: TapGestureRecognizer()..onTap = () => NavigatorPush.push(context, const CommonPrivacyAndTerms(title: "गोपनीयता धोरण", content: ""))),
                              TextSpan(text: " सहमत आहे."),
                            ]))),
                          ]),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: (state.signUpState!.isLoading ?? false) ? null : () => store.dispatch(SignUpRequestAction(payloadContext: context, phoneNumber: _selectedPhoneNumber)),
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: (state.signUpState!.isLoading ?? false) ? const CircularProgressIndicator(color: Colors.white) : const Text("प्रोफाईल तयार करा", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Mukta')),
                          ),
                          const SizedBox(height: 24),
                          if ((isGoogle ?? false) || (isFacebook ?? false) || (isTwitter ?? false))
                            Column(children: [Center(child: Text("किंवा नोंदणी करा", style: TextStyle(color: textSecondary, fontSize: 13, fontFamily: 'Mukta'))), const SizedBox(height: 16), const SocialLoginWidget()]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(child: InkWell(onTap: () => Navigator.pop(context), child: RichText(text: TextSpan(text: "आधीच खाते आहे का? ", style: TextStyle(color: textSecondary, fontSize: 14, fontFamily: 'Mukta'), children: [TextSpan(text: "लॉगिन करा", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontFamily: 'Mukta'))])))),
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
      Text(title, style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Mukta')),
      const SizedBox(height: 8),
      Container(height: 48, padding: const EdgeInsets.symmetric(horizontal: 16), alignment: Alignment.centerLeft, decoration: BoxDecoration(color: inputFillColor, borderRadius: BorderRadius.circular(12)), child: child),
    ]);
  }

  Widget _buildEmailOrOtpSection(AppState state) {
    bool isPhone = isOtpSystem! && (state.signUpState!.emailOrPhone ?? false);
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      _buildInputField(title: isPhone ? "मोबाईल नंबर" : "ईमेल आयडी", child: isPhone 
        ? InternationalPhoneNumberInput(onInputChanged: (n) => setState(() => _selectedPhoneNumber = n), countries: store.state.commonState!.countriesToString(), selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG, setSelectorButtonAsPrefixIcon: true), textStyle: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta'), inputDecoration: InputDecoration(hintText: "8XXXXXXXXX", border: InputBorder.none))
        : TextFormField(controller: state.signUpState?.emailController, style: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'Mukta'), decoration: InputDecoration(hintText: "ईमेल प्रविष्ट करा", border: InputBorder.none))),
      const SizedBox(height: 8),
      GestureDetector(onTap: () => store.dispatch(SignupSetEmailOrPhoneAction()), child: Text(isPhone ? "ईमेलने नोंदणी करा" : "मोबाईलने नोंदणी करा", style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Mukta'))),
    ]);
  }
}
'''

# Use raw strings for code
with open('/Users/sanket/Downloads/Active Matrimonial Flutter App/source_code/lib/screens/auth/signin/signin.dart', 'w') as f:
    f.write(signin_code)

with open('/Users/sanket/Downloads/Active Matrimonial Flutter App/source_code/lib/screens/auth/signup/signup.dart', 'w') as f:
    f.write(signup_code)
