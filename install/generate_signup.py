import os

dart_code = """import 'dart:developer';
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
  final bool _isRecaptchaActive = settingIsActive(
    'recaptcha_user_register',
    '1',
  );

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

  @override
  void initState() {
    super.initState();
    if (_isRecaptchaActive) {
      _setupWebViewController();
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _setupWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'Captcha',
        onMessageReceived: (JavaScriptMessage message) {
          log("reCAPTCHA v3 Token Received: ${message.message}");
          if (message.message.isNotEmpty && message.message != "error") {
            store.dispatch(
              SetKeyValueAction(keyValuePayload: message.message),
            );
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url == _recaptchaUrl) {
              return NavigationDecision.navigate;
            } else {
              _launchUrl(request.url);
              return NavigationDecision.prevent;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_recaptchaUrl));
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      log('Could not launch $url');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the page.')),
        );
      }
    }
  }

  // --- Theme Constants ---
  final Color primaryColor = const Color(0xFFE54861);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFECECEC);
  final Color inputFillColor = const Color(0xFFF5F5F5);

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
          final AppState state = store.state;
          final String? initialGender = state.signUpState?.currentGender;

          if (state.systemSettingState?.settingResponse?.data != null &&
              initialGender != null &&
              initialGender.isNotEmpty) {
            String minAgeString = '0';
            if (initialGender == 'Male') {
              minAgeString = state.systemSettingState!.settingResponse!.data!['male_min_age'] ?? '0';
            } else if (initialGender == 'Female') {
              minAgeString = state.systemSettingState!.settingResponse!.data!['female_min_age'] ?? '0';
            }
            final int minimumAge = int.tryParse(minAgeString) ?? 0;
            final DateTime initialDoB = DateTime(
              DateTime.now().year - minimumAge,
              DateTime.now().month,
              DateTime.now().day,
            );
            store.dispatch(SignupSetDateTimeAction(payload: initialDoB));
          }
        },
        builder: (_, state) {
          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo Section
                      Center(
                        child: Image(
                          image: const AssetImage('assets/logo/app_logo.png'),
                          height: 72,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Welcome Text
                      Text(
                        AppLocalizations.of(context)!.signup_screen_title,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Start your journey to find the perfect life partner ❤️",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Signup Form Card
                      Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: state.signUpState!.signUpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // On Behalf
                              _buildInputField(
                                title: AppLocalizations.of(context)!.signup_screen_onbehalf,
                                child: DropdownButtonFormField<dynamic>(
                                  iconSize: 20,
                                  dropdownColor: cardColor,
                                  icon: Icon(Icons.keyboard_arrow_down, color: textSecondary),
                                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                                  value: state.signUpState!.on_behalves_value,
                                  items: state.signUpState!.onBehalfList?.map<DropdownMenuItem<dynamic>>((e) {
                                    return DropdownMenuItem<dynamic>(
                                      value: e.id,
                                      child: Text(e.name!, style: TextStyle(color: textPrimary, fontSize: 14)),
                                    );
                                  }).toList() ?? [],
                                  onChanged: (dynamic newValue) {
                                    store.dispatch(SignupSetOnBehalvesAction(payload: newValue));
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Name Fields
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInputField(
                                      title: AppLocalizations.of(context)!.signup_screen_first_name,
                                      child: TextFormField(
                                        controller: store.state.signUpState?.firstNameController,
                                        style: TextStyle(color: textPrimary, fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)!.signup_screen_first_name,
                                          hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildInputField(
                                      title: AppLocalizations.of(context)!.signup_screen_last_name,
                                      child: TextFormField(
                                        controller: store.state.signUpState?.lastNameController,
                                        style: TextStyle(color: textPrimary, fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)!.signup_screen_last_name,
                                          hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Gender
                              _buildInputField(
                                title: AppLocalizations.of(context)!.signup_screen_gender,
                                child: DropdownButtonFormField(
                                  iconSize: 20,
                                  dropdownColor: cardColor,
                                  icon: Icon(Icons.keyboard_arrow_down, color: textSecondary),
                                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                                  value: state.signUpState!.currentGender,
                                  items: state.signUpState!.genderItems?.map<DropdownMenuItem<dynamic>>((e) {
                                    return DropdownMenuItem<dynamic>(
                                      value: e,
                                      child: Text(e, style: TextStyle(color: textPrimary, fontSize: 14)),
                                    );
                                  }).toList() ?? [],
                                  onChanged: (dynamic newValue) {
                                    store.dispatch(SignupSetGenderAction(payload: newValue));
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Date of Birth
                              _buildInputField(
                                title: AppLocalizations.of(context)!.signup_screen_dob,
                                child: InkWell(
                                  onTap: () async {
                                     DateTime? pickedDate = await showDatePicker(
                                       context: context,
                                       initialDate: state.signUpState!.date ?? DateTime.now(),
                                       firstDate: DateTime(1950),
                                       lastDate: DateTime.now(),
                                     );
                                     if(pickedDate != null){
                                        store.dispatch(SignupSetDateTimeAction(payload: pickedDate));
                                     }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.signUpState!.date != null
                                            ? DateFormat('d MMMM yyyy').format(state.signUpState!.date!)
                                            : AppLocalizations.of(context)!.signup_screen_dob,
                                        style: TextStyle(color: state.signUpState!.date != null ? textPrimary : textSecondary.withOpacity(0.6), fontSize: 14),
                                      ),
                                      Icon(Icons.calendar_today_outlined, color: textSecondary, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Email or Phone OTP Section
                              _buildEmailOrOtpSection(state, context),

                              const SizedBox(height: 16),

                              // Password Field
                              _buildInputField(
                                title: AppLocalizations.of(context)!.common_password_text,
                                child: TextFormField(
                                  controller: store.state.signUpState?.passwordController,
                                  obscureText: _isObscure,
                                  style: TextStyle(color: textPrimary, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: "••••••••",
                                    hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14),
                                    border: InputBorder.none,
                                    isDense: true,
                                    suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                                    suffixIcon: GestureDetector(
                                      onTap: () => setState(() => _isObscure = !_isObscure),
                                      child: Icon(
                                        _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        color: textSecondary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Confirm Password Field
                              _buildInputField(
                                title: AppLocalizations.of(context)!.common_screen_confim_password,
                                child: TextFormField(
                                  controller: store.state.signUpState?.confirmPasswordController,
                                  obscureText: _isObscure,
                                  style: TextStyle(color: textPrimary, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: "••••••••",
                                    hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Terms & Conditions Checkbox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      value: state.signUpState!.checkBox,
                                      onChanged: (bool? value) => store.dispatch(SignupCheckBoxAction(payload: value)),
                                      activeColor: primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      side: BorderSide(color: borderColor, width: 1.5),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: "I agree to the ",
                                        style: TextStyle(color: textSecondary, fontSize: 12, height: 1.5),
                                        children: [
                                          TextSpan(
                                            text: "Terms & Conditions",
                                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                                            recognizer: TapGestureRecognizer()..onTap = () {
                                              NavigatorPush.push(context, const CommonPrivacyAndTerms(title: "Terms & Conditions", content: "Terms rules"));
                                            },
                                          ),
                                          const TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                                            recognizer: TapGestureRecognizer()..onTap = () {
                                               NavigatorPush.push(context, const CommonPrivacyAndTerms(title: "Privacy Policy", content: "Privacy rules"));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Create Account Button
                              ElevatedButton(
                                onPressed: state.signUpState!.isLoading == false
                                    ? () {
                                        store.dispatch(SignUpRequestAction(payloadContext: context, phoneNumber: _selectedPhoneNumber));
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: state.signUpState!.isLoading == false
                                    ? Text(
                                        AppLocalizations.of(context)!.signup_screen_button_text_signup,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      )
                                    : const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Social Logins (If active)
                              if ((isGoogle ?? false) || (isFacebook ?? false) || (isTwitter ?? false))
                                Center(
                                  child: Column(
                                    children: [
                                      Text("Or sign up with", style: TextStyle(color: textSecondary, fontSize: 13)),
                                      const SizedBox(height: 16),
                                      const SocialLoginWidget(),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),

                      // Login Link
                      Center(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.signup_screen_already_account + " ",
                              style: TextStyle(color: textSecondary, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!.signup_screen_login,
                                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Web ReCaptcha Integration
                      if (_isRecaptchaActive)
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          width: double.infinity,
                          height: 90,
                          child: WebViewWidget(controller: _controller),
                        ),

                      const SizedBox(height: 48), // Bottom safe space
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputField({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: inputFillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
          ),
          child: child,
        ),
      ],
    );
  }

  // --- OTP Logic ---
  void _sendVerificationCode(AppState state) async {
    final bool isPhone = isOtpSystem! && (state.signUpState!.emailOrPhone ?? false);
    final String sendBy = isPhone ? "phone" : "email";

    if (isPhone) {
      if ((_selectedPhoneNumber.phoneNumber ?? '').isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your phone number')));
        return;
      }
    } else {
      if (state.signUpState!.emailController!.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your email')));
        return;
      }
    }

    setState(() => _isSendingCode = true);

    try {
      var response = isPhone
          ? await AuthRepository().sendCode(phoneNumber: _selectedPhoneNumber, sendBy: sendBy)
          : await AuthRepository().sendCode(identifier: state.signUpState!.emailController!.text, sendBy: sendBy);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message!), backgroundColor: response.status == 1 ? Colors.green : Colors.red));
        if (response.status == 1) setState(() => _isCodeSent = true);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred. Please try again.')));
    } finally {
      if (mounted) setState(() => _isSendingCode = false);
    }
  }

  void _verifyOtpCode(AppState state) async {
    if (_isVerified || _isVerifyingCode) return;

    final bool isPhone = isOtpSystem! && (state.signUpState!.emailOrPhone ?? false);
    final String sendBy = isPhone ? "phone" : "email";
    final String code = _otpController.text;

    if (code.isEmpty) return;

    setState(() => _isVerifyingCode = true);

    try {
      var response = isPhone
          ? await AuthRepository().verifyCode(phoneNumber: _selectedPhoneNumber, sendBy: sendBy, code: code)
          : await AuthRepository().verifyCode(identifier: state.signUpState!.emailController!.text, sendBy: sendBy, code: code);

      if (mounted) {
        if (response.status == 1) {
          setState(() { _isVerified = true; _verificationFailed = false; });
        } else {
          setState(() { _isVerified = false; _verificationFailed = true; });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message ?? "Invalid OTP"), backgroundColor: Colors.red));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() { _isVerified = false; _verificationFailed = true; });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification failed.')));
      }
    } finally {
      if (mounted) setState(() => _isVerifyingCode = false);
    }
  }

  Widget _buildEmailOrOtpSection(AppState state, BuildContext context) {
    bool isPhone = isOtpSystem! && (state.signUpState!.emailOrPhone ?? false);
    bool regVerification = settingIsActive('registration_verification', '1');

    Widget inputSection;
    if (!regVerification) {
      inputSection = _buildInputField(
        title: isPhone ? "Phone Number" : "Email ID",
        child: isPhone
            ? InternationalPhoneNumberInput(
                initialValue: _selectedPhoneNumber,
                onInputChanged: (PhoneNumber number) => setState(() => _selectedPhoneNumber = number),
                countries: store.state.commonState!.countriesToString(),
                selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG, setSelectorButtonAsPrefixIcon: true, trailingSpace: false),
                textStyle: TextStyle(color: textPrimary, fontSize: 14),
                selectorTextStyle: TextStyle(color: textPrimary, fontSize: 14),
                inputDecoration: InputDecoration(hintText: "8XXXXXXXXX", hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 12)),
              )
            : TextFormField(
                controller: store.state.signUpState?.emailController,
                style: TextStyle(color: textPrimary, fontSize: 14),
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.common_enter_email, hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14), border: InputBorder.none, isDense: true),
              ),
      );
    } else {
      if (!_isCodeSent) {
        inputSection = Column(
          children: [
            _buildInputField(
              title: isPhone ? "Phone Number" : "Email ID",
              child: Row(
                children: [
                  Expanded(
                    child: isPhone
                        ? InternationalPhoneNumberInput(
                            initialValue: _selectedPhoneNumber,
                            onInputChanged: (PhoneNumber number) => setState(() => _selectedPhoneNumber = number),
                            countries: store.state.commonState!.countriesToString(),
                            selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG, setSelectorButtonAsPrefixIcon: true, trailingSpace: false),
                            textStyle: TextStyle(color: textPrimary, fontSize: 14),
                            selectorTextStyle: TextStyle(color: textPrimary, fontSize: 14),
                            inputDecoration: InputDecoration(hintText: "8XXXXXXXXX", hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14), border: InputBorder.none, isDense: true),
                          )
                        : TextFormField(
                            controller: state.signUpState!.emailController,
                            style: TextStyle(color: textPrimary, fontSize: 14),
                            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.common_enter_email, hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 14), border: InputBorder.none, isDense: true),
                          ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _isSendingCode ? null : () => _sendVerificationCode(state),
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(64, 32),
                    ),
                    child: _isSendingCode
                        ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Get OTP", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        inputSection = _buildInputField(
          title: "Verification Code",
          child: TextFormField(
            controller: _otpController,
            onChanged: (value) {
              if (value.length == 6 && !_isVerifyingCode) _verifyOtpCode(state);
            },
            style: TextStyle(color: textPrimary, fontSize: 16, letterSpacing: 4, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            readOnly: _isVerified,
            decoration: InputDecoration(
              hintText: "******", 
              hintStyle: TextStyle(color: textSecondary.withOpacity(0.3), letterSpacing: 4), 
              border: InputBorder.none, 
              isDense: true,
              suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
              suffixIcon: _isVerifyingCode
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : _isVerified 
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 20) 
                      : _verificationFailed ? const Icon(Icons.cancel, color: Colors.red, size: 20) : null          
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        inputSection,
        const SizedBox(height: 8),
        if (isOtpSystem!)
          GestureDetector(
            onTap: () => store.dispatch(SignupSetEmailOrPhoneAction()),
            child: Text(
              isPhone ? "Sign up with Email" : "Sign up with Phone",
              style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
"""

with open('/Users/sanket/Downloads/Active Matrimonial Flutter App/source_code/lib/screens/auth/signup/signup.dart', 'w') as f:
    f.write(dart_code)
