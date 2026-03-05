// Sanket: Updated Phone Login with immediate controller initialization for Web stability
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/components/social_login_widget.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/otp_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/email_login.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final Color primaryColor = const Color(0xFFE54861);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFECECEC);

  PhoneNumber _selectedPhoneNumber = PhoneNumber(isoCode: 'IN');
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              ColorFiltered(
                colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                child: Image.asset(
                  'assets/logo/app_logo.png',
                  height: 80,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.login_screen_phone_subtitle,
                style: Styles.body.copyWith(color: textSecondary),
              ),
              const SizedBox(height: 40),
              _buildLoginCard(context),
              const SizedBox(height: 32),
              const SocialLoginWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildLoginCard(BuildContext context) {
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
            AppLocalizations.of(context)!.login_button_text,
            textAlign: TextAlign.center,
            style: Styles.h2.copyWith(fontSize: 20, color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.login_screen_enter_phone,
            textAlign: TextAlign.center,
            style: Styles.body.copyWith(color: textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor.withOpacity(0.5)),
            ),
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                setState(() {
                  _selectedPhoneNumber = number;
                });
              },
              onInputValidated: (bool value) {
                setState(() {
                  _isPhoneValid = value;
                });
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                setSelectorButtonAsPrefixIcon: true,
                leadingPadding: 0,
                showFlags: false,
              ),
              countries: const ['IN'],
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
              initialValue: _selectedPhoneNumber,
              formatInput: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputDecoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.profile_label_mobile1,
                hintStyle: TextStyle(color: textSecondary.withOpacity(0.4), fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              textFieldController: _phoneController,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: _isPhoneValid && !_isLoading ? Styles.primaryGradient : null,
              borderRadius: BorderRadius.circular(12),
              color: _isPhoneValid && !_isLoading ? null : primaryColor.withOpacity(0.5),
              boxShadow: _isPhoneValid && !_isLoading ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: ElevatedButton(
              onPressed:
                  !_isLoading && _isPhoneValid
                      ? () {
                        setState(() {
                          _isLoading = true;
                        });
                        store.dispatch(
                          requestOtpAction(
                            context: context,
                            phoneNumber: _phoneController.text.replaceAll(RegExp(r'[^0-9]'), ''),
                          ),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        });
                      }
                      : null,
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
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        AppLocalizations.of(context)!.login_screen_get_otp,
                        style: Styles.buttonText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Divider(color: borderColor, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  AppLocalizations.of(context)!.login_screen_or,
                  style: Styles.body.copyWith(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(child: Divider(color: borderColor, thickness: 1)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EmailLogin()),
                );
              },
              icon: Icon(Icons.email_outlined, color: textSecondary, size: 20),
              label: Text(
                AppLocalizations.of(context)!.login_screen_continue_email,
                style: Styles.buttonText.copyWith(
                  color: textPrimary,
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.login_screen_if_have_account,
                style: Styles.body.copyWith(color: textSecondary, fontSize: 13),
              ),
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    ),
                child: Text(
                  AppLocalizations.of(context)!.login_screen_signup,
                  style: Styles.buttonText.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
