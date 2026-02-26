import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/main.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/forgetPassword/forgetpassword_action.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  // --- Theme Constants (Aligning with design system) ---
  final Color primaryColor = const Color(0xFFE54861);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFECECEC);
  final Color inputFillColor = const Color(0xFFF5F5F5);

  bool? isOtpSystem = store.state.addonState!.data!.otpSystem;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          toolbarHeight: 56,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "पासवर्ड विसरलात?", // Forgot Password
            style: Styles.h2.copyWith(color: textPrimary),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: borderColor, height: 1.0),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),

                // Instruction Section
                Text(
                  "पासवर्ड रिसेट करा", // Reset Your Password
                  style: Styles.h1.copyWith(color: textPrimary, letterSpacing: -0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  "तुमचा मोबाईल नंबर किंवा ईमेल प्रविष्ट करा.", // Enter your mobile number or email
                  textAlign: TextAlign.center,
                  style: Styles.body.copyWith(color: textSecondary, height: 1.5),
                ),
                const SizedBox(height: 32),

                // Input Card
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
                    key: state.forgetPasswordState!.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.forgetPasswordState!.valueChanger!
                              ? "मोबाईल नंबर" // Mobile Number
                              : "ईमेल आयडी", // Email ID
                          style: Styles.body.copyWith(
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
                          ),
                          child: state.forgetPasswordState!.valueChanger!
                              ? (isOtpSystem!
                                  ? InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber number) {
                                        store.dispatch(SetForgetPasswordPhoneNumberAction(
                                            payload: number.phoneNumber));
                                      },
                                      spaceBetweenSelectorAndTextField: 0,
                                      countries: store.state.commonState!.countriesToString(),
                                      selectorConfig: const SelectorConfig(
                                          selectorType: PhoneInputSelectorType.DIALOG,
                                          setSelectorButtonAsPrefixIcon: true,
                                          trailingSpace: false),
                                      inputDecoration: _inputDecoration("मोबाईल नंबर"),
                                      textStyle: Styles.body.copyWith(color: textPrimary),
                                      selectorTextStyle: Styles.body.copyWith(color: textPrimary),
                                    )
                                  : const SizedBox.shrink())
                              : TextFormField(
                                  controller: state.forgetPasswordState!.forgetpasswordController,
                                  style: Styles.body.copyWith(color: textPrimary),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "कृपया तुमचा ईमेल प्रविष्ट करा";
                                    }
                                    return null;
                                  },
                                  decoration: _inputDecoration("ईमेल प्रविष्ट करा"),
                                ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Use Email/Phone Toggle
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => store.dispatch(ForgetPasswordEmailOrPhoneAction()),
                            child: Text(
                              state.forgetPasswordState!.valueChanger!
                                  ? "ईमेल वापरा" // Use Email instead
                                  : "फोन नंबर वापरा", // Use Phone Number instead
                              style: Styles.buttonText.copyWith(
                                color: primaryColor,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Send Code Button
                        ElevatedButton(
                          onPressed: state.forgetPasswordState!.fp_loader == false
                              ? () => store.dispatch(SendCodeAction(payloadContext: context))
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
                          child: state.forgetPasswordState!.fp_loader == false
                              ? Text(
                                  "OTP पाठवा", // Send OTP
                                  style: Styles.buttonText.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Back to Login Link
                Center(
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "लॉगिनवर परत जा", // Back to Sign In
                      style: Styles.buttonText.copyWith(
                        color: primaryColor,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Styles.body.copyWith(color: textSecondary.withOpacity(0.6)),
      border: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}
