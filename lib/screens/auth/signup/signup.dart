import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/components/social_login_widget.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup_action.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/add_on/addon_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/on_behalf_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/staticPage/static_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/components/common_privacy_and_terms_page.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/helpers/show_message_state.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isRecaptchaActive = false;
  WebViewController? _controller;
  final String _recaptchaUrl = "${AppConfig.BASE_URL}/google-recaptcha";
  bool _isObscure = true; // Controls password field visibility toggle
  // Sanket: Removed 5 dead OTP final booleans — they were never used (bugs 10, 11)
  bool _isPhoneValid = false;
  PhoneNumber _selectedPhoneNumber = PhoneNumber(isoCode: 'IN');
  final TextEditingController _phoneController = TextEditingController();

  bool? isGoogle;
  bool? isFacebook;
  bool? isTwitter;
  bool? isOtpSystem;

  final Color primaryColor = const Color(0xFFE54861);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFECECEC);
  final Color inputFillColor = const Color(0xFFF3F4F6);

  @override
  void initState() {
    super.initState();
    _isRecaptchaActive = settingIsActive(
      'recaptcha_user_register',
      '1',
    );
    isGoogle = settingIsActive('google_login_activation', '1');
    isFacebook = settingIsActive('facebook_login_activation', '1');
    isTwitter = settingIsActive('twitter_login_activation', "1");
    isOtpSystem = store.state.addonState!.data!.otpSystem ?? false;

    if (_isRecaptchaActive) _setupWebViewController();
  }

  void _setupWebViewController() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..addJavaScriptChannel(
            'Captcha',
            onMessageReceived: (message) {
              if (message.message.isNotEmpty && message.message != "error") {
                store.dispatch(
                  SetKeyValueAction(keyValuePayload: message.message),
                );
              }
            },
          )
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 48.0,
              ),
              child: Column(
                children: [
                  Center(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                      child: Image.asset(
                        'assets/logo/app_logo.png',
                        height: 72,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.signup_screen_title,
                    style: Styles.h1.copyWith(color: textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.login_screen_phone_subtitle,
                    textAlign: TextAlign.center,
                    style: Styles.body.copyWith(color: textSecondary),
                  ),
                  const SizedBox(height: 32),
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
                          _buildInputField(
                            title: AppLocalizations.of(context)!.signup_screen_onbehalf,
                            child: DropdownButtonFormField<dynamic>(
                              dropdownColor: cardColor,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: textSecondary,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              initialValue: state.signUpState!.on_behalves_value,
                              items:
                                  state.signUpState!.onBehalfList
                                      ?.map(
                                        (e) => DropdownMenuItem(
                                          value: e.id,
                                          child: Text(
                                            e.name!,
                                            style: Styles.body.copyWith(
                                              color: textPrimary,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList() ??
                                  [],
                              onChanged:
                                  (val) => store.dispatch(
                                    SignupSetOnBehalvesAction(payload: val),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  title: AppLocalizations.of(context)!.signup_screen_first_name,
                                  child: TextFormField(
                                    controller:
                                        state.signUpState?.firstNameController,
                                    style: Styles.body.copyWith(
                                      color: textPrimary,
                                    ),
                                    // Sanket: Bug 6 — first name must not be empty
                                    validator: (val) {
                                      if (val == null || val.trim().isEmpty) {
                                        return AppLocalizations.of(context)!.signup_screen_first_name;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.signup_screen_first_name,
                                      hintStyle: Styles.body.copyWith(
                                        color: textSecondary.withOpacity(0.5),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInputField(
                                  title: AppLocalizations.of(context)!.manage_profile_l_name,
                                  child: TextFormField(
                                    controller:
                                        state.signUpState?.lastNameController,
                                    style: Styles.body.copyWith(
                                      color: textPrimary,
                                    ),
                                    // Sanket: Bug 6 — last name must not be empty
                                    validator: (val) {
                                      if (val == null || val.trim().isEmpty) {
                                        return AppLocalizations.of(context)!.manage_profile_l_name;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.signup_screen_last_name,
                                      hintStyle: Styles.body.copyWith(
                                        color: textSecondary.withOpacity(0.5),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            title: AppLocalizations.of(context)!.signup_screen_gender,
                            child: DropdownButtonFormField(
                              dropdownColor: cardColor,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: textSecondary,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              initialValue: state.signUpState!.currentGender,
                              items:
                                  state.signUpState!.genderItems
                                      ?.map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e == 'Male'
                                                ? 'पुरुष'
                                                : (e == 'Female' ? 'महिला' : e),
                                            style: Styles.body.copyWith(
                                              color: textPrimary,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList() ??
                                  [],
                              onChanged:
                                  (val) => store.dispatch(
                                    SignupSetGenderAction(
                                      payload: val as String?,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            title: AppLocalizations.of(context)!.signup_screen_dob,
                            child: InkWell(
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      state.signUpState!.date ?? DateTime(2000),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  store.dispatch(
                                    SignupSetDateTimeAction(payload: picked),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.signUpState!.date != null
                                        ? DateFormat(
                                          'd MMMM yyyy',
                                        ).format(state.signUpState!.date!)
                                        : "तारीख निवडा",
                                    style: Styles.body.copyWith(
                                      color: textPrimary,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: textSecondary,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            title: AppLocalizations.of(context)!.manage_profile_your_email_id,
                            child: TextFormField(
                              controller: state.signUpState?.emailController,
                              style: Styles.body.copyWith(color: textPrimary),
                              keyboardType: TextInputType.emailAddress,
                              // Sanket: Bug 7 — validate email format and non-empty
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return AppLocalizations.of(context)!.common_enter_email;
                                }
                                final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
                                if (!emailRegex.hasMatch(val.trim())) {
                                  return AppLocalizations.of(context)!.common_enter_email;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.common_enter_email,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            title: AppLocalizations.of(context)!.profile_label_mobile1,
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber n) {
                                setState(() => _selectedPhoneNumber = n);
                                // Sanket: Manual 10-digit Indian number validation
                                // The package's libphonenumber is unreliable on Flutter web
                                // and incorrectly flags valid Indian numbers as invalid.
                                final nationalNumber = n.phoneNumber
                                    ?.replaceFirst('+91', '')
                                    .replaceAll(RegExp(r'\s+'), '') ?? '';
                                final isValid = RegExp(r'^[6-9]\d{9}$').hasMatch(nationalNumber);
                                setState(() => _isPhoneValid = isValid);
                              },
                              // Sanket: Disable the package's built-in error display —
                              // we show our own error hint below the field instead.
                              onInputValidated: (_) {},
                              selectorConfig: const SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                setSelectorButtonAsPrefixIcon: true,
                                showFlags: false,
                              ),
                              countries: const ['IN'],
                              textStyle: Styles.body.copyWith(
                                color: textPrimary,
                              ),
                              inputDecoration: const InputDecoration(
                                hintText: "8XXXXXXXXX",
                                border: InputBorder.none,
                                // Suppress the package's own "Invalid phone number" English error
                                errorText: null,
                              ),
                              textFieldController: _phoneController,
                              errorMessage: '',
                            ),
                          ),
                          // Sanket: Bug 3 — show helpful hint when phone field has value but is invalid
                          if (!_isPhoneValid && _phoneController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 4),
                              child: Text(
                                'वैध 10-अंकी मोबाइल नंबर प्रविष्ट करा',
                                style: Styles.caption.copyWith(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            title: AppLocalizations.of(context)!.common_password_text,
                            child: TextFormField(
                              controller: state.signUpState?.passwordController,
                              obscureText: _isObscure,
                              style: Styles.body.copyWith(
                                color: textPrimary,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                border: InputBorder.none,
                                suffixIcon: GestureDetector(
                                  onTap:
                                      () => setState(
                                        () => _isObscure = !_isObscure,
                                      ),
                                  child: Icon(
                                    _isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: textSecondary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            title: AppLocalizations.of(context)!.common_screen_confim_password,
                            child: TextFormField(
                              controller:
                                  state.signUpState?.confirmPasswordController,
                              obscureText: _isObscure,
                              style: Styles.body.copyWith(
                                color: textPrimary,
                                fontSize: 14,
                              ),
                              // Sanket: Bug 5 — validate confirm password matches password
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'कृपया पासवर्ड पुन्हा प्रविष्ट करा';
                                }
                                if (val != state.signUpState?.passwordController?.text) {
                                  return 'पासवर्ड जुळत नाही';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: state.signUpState!.checkBox ?? false,
                                onChanged:
                                    (v) => store.dispatch(
                                      SignupCheckBoxAction(payload: v),
                                    ),
                                activeColor: primaryColor,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: AppLocalizations.of(context)!.signup_screen_terms_part1,
                                    style: Styles.caption.copyWith(
                                      color: textSecondary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: AppLocalizations.of(context)!.signup_screen_terms_part2,
                                        style: Styles.caption.copyWith(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap =
                                                  () => NavigatorPush.push(
                                                    context,
                                                    CommonPrivacyAndTerms(
                                                      title: AppLocalizations.of(context)!.signup_screen_terms_part2,
                                                      // Sanket: Bug 9 — use real content from Redux static page state
                                                      content: state.staticPageState?.termsAndCondition ?? "",
                                                    ),
                                                  ),
                                      ),
                                      TextSpan(text: " ${AppLocalizations.of(context)!.signup_screen_terms_part3} "),
                                      TextSpan(
                                        text: AppLocalizations.of(context)!.signup_screen_terms_part4,
                                        style: Styles.caption.copyWith(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap =
                                                  () => NavigatorPush.push(
                                                    context,
                                                    CommonPrivacyAndTerms(
                                                      title: AppLocalizations.of(context)!.signup_screen_terms_part4,
                                                      // Sanket: Bug 9 — use real content from Redux static page state
                                                      content: state.staticPageState?.privacyPolicy ?? "",
                                                    ),
                                                  ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Container(
                            height: 52,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: !(state.signUpState!.isLoading ?? false) ? Styles.primaryGradient : null,
                              borderRadius: BorderRadius.circular(12),
                              color: !(state.signUpState!.isLoading ?? false) ? null : primaryColor.withOpacity(0.5),
                              boxShadow: !(state.signUpState!.isLoading ?? false) ? [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ] : [],
                            ),
                            child: ElevatedButton(
                              onPressed:
                                   // Sanket: Always tappable — phone checked inside callback
                                   (state.signUpState!.isLoading ?? false)
                                       ? null
                                       : () {
                                           if (!_isPhoneValid) {
                                             store.dispatch(ShowMessageAction(
                                               msg: AppLocalizations.of(context)!.profile_error_mobile_invalid,
                                             ));
                                             return;
                                           }
                                           store.dispatch(SignUpRequestAction(
                                             payloadContext: context,
                                             phoneNumber: _selectedPhoneNumber,
                                           ));
                                         },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child:
                                  (state.signUpState!.isLoading ?? false)
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                        AppLocalizations.of(context)!.signup_screen_button_text_signup,
                                        style: Styles.buttonText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if ((isGoogle ?? false) ||
                              (isFacebook ?? false) ||
                              (isTwitter ?? false))
                            Column(
                              children: [
                                Center(
                                  child: Text(
                                    "किंवा नोंदणी करा",
                                    style: Styles.caption.copyWith(
                                      color: textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const SocialLoginWidget(),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!.login_screen_if_have_account,
                          style: Styles.body.copyWith(color: textSecondary),
                          children: [
                            TextSpan(
                              text: " ${AppLocalizations.of(context)!.login_button_text}",
                              style: Styles.buttonText.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Styles.body.copyWith(
            color: textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        // Sanket: Removed fixed height:48 — container must grow to show validator errors
        Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: inputFillColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
