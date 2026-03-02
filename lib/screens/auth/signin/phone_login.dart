// Sanket: Updated Phone Login with immediate controller initialization for Web stability
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/components/social_login_widget.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/otp_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/email_login.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';

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
              Image.asset(
                'assets/logo/app_logo.png',
                height: 80,
                color: primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'तुमचा योग्य जीवनसाथी शोधा ❤️',
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
            'लॉगिन करा', // Sign In
            textAlign: TextAlign.center,
            style: Styles.h2.copyWith(fontSize: 20, color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'सुरू करण्यासाठी तुमचा मोबाईल नंबर टाका', // Enter mobile number to continue
            textAlign: TextAlign.center,
            style: Styles.body.copyWith(color: textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
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
              ),
              countries: const ['IN'],
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: textPrimary),
              initialValue: _selectedPhoneNumber,
              formatInput: true,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputDecoration: InputDecoration(
                hintText: 'मोबाईल नंबर',
                hintStyle: TextStyle(color: textSecondary.withOpacity(0.5)),
                border: InputBorder.none,
                isDense: false,
              ),
              textFieldController: _phoneController,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed:
                  !_isLoading && (_phoneController.text.length >= 10)
                      ? () {
                        setState(() {
                          _isLoading = true;
                        });
                        store.dispatch(
                          requestOtpAction(
                            context: context,
                            phoneNumber: _selectedPhoneNumber.phoneNumber ?? '',
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
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withOpacity(0.5),
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
                        'ओटीपी मिळवा', // Get OTP
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
                  'किंवा', // OR
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
                'ईमेल द्वारे सुरू ठेवा', // Continue with Email
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
                "खाते नाही का? ", // Don't have an account?
                style: Styles.body.copyWith(color: textSecondary, fontSize: 13),
              ),
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    ),
                child: Text(
                  'नोंदणी करा', // Register/Sign Up
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
