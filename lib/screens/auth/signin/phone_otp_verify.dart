// Sanket: Updated Phone OTP Verification with immediate controller initialization
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/otp_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:pinput/pinput.dart';

class PhoneOtpVerify extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const PhoneOtpVerify({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });


  @override
  State<PhoneOtpVerify> createState() => _PhoneOtpVerifyState();
}

class _PhoneOtpVerifyState extends State<PhoneOtpVerify> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFFE54861);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: Styles.h2.copyWith(fontSize: 20, color: textPrimary),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFECECEC)),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/app_logo.png',
                height: 64,
                color: primaryColor,
              ),
              const SizedBox(height: 32),
              Text(
                'ओटीपी सत्यापित करा', // Verify OTP
                style: Styles.h1.copyWith(fontSize: 24, color: textPrimary),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'आम्ही ', // We sent code to
                  style: Styles.body.copyWith(color: textSecondary),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: Styles.body.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' वर एक 6-अंकी कोड पाठवला आहे. कृपया खाली प्रविष्ट करा.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Pinput(
                length: 6,
                controller: _pinController,
                focusNode: _pinFocusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: primaryColor, width: 2),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration?.copyWith(
                    color: const Color(0xFFF9FAFB),
                  ),
                ),
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) {
                  _verifyOtp(pin);
                },
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            if (_pinController.text.length == 6) {
                              _verifyOtp(_pinController.text);
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
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
                            'सत्यापित करा', // Verify
                            style: Styles.buttonText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "कोड मिळाला नाही? ", // Didn't receive code?
                    style: Styles.body.copyWith(
                      color: textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      store.dispatch(
                        requestOtpAction(
                          context: context,
                          phoneNumber: widget.phoneNumber,
                        ),
                      );
                    },
                    child: Text(
                      'परत पाठवा', // Resend
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
        ),
      ),
    );
  }

  void _verifyOtp(String smsCode) {
    setState(() {
      _isLoading = true;
    });
    store.dispatch(
      verifyOtpAction(
        context: context,
        verificationId: widget.verificationId,
        smsCode: smsCode,
        phoneNumber: widget.phoneNumber,
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
