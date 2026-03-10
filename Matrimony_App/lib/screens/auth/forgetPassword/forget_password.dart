import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/forgetPassword/forgetpassword_action.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';

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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        bool isOtpSystem = state.addonState?.data?.otpSystem ?? false;
        
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: cardColor,
            elevation: 0,
            toolbarHeight: 56,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: textPrimary,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.forget_screen_title,
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
                    AppLocalizations.of(context)!.forget_screen_title,
                    style: Styles.h1.copyWith(
                      color: textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.forget_screen_subtitle,
                    textAlign: TextAlign.center,
                    style: Styles.body.copyWith(
                      color: textSecondary,
                      height: 1.5,
                    ),
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
                                ? AppLocalizations.of(context)!.profile_label_mobile1
                                : AppLocalizations.of(context)!.common_email_or_phone,
                            style: Styles.body.copyWith(
                              color: textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: inputFillColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: state.forgetPasswordState!.valueChanger!
                                ? (isOtpSystem
                                    ? InternationalPhoneNumberInput(
                                        onInputChanged: (PhoneNumber number) {
                                          store.dispatch(
                                            SetForgetPasswordPhoneNumberAction(
                                              payload: number.phoneNumber,
                                            ),
                                          );
                                        },
                                        spaceBetweenSelectorAndTextField: 0,
                                        countries: store.state.commonState!
                                            .countriesToString(),
                                        selectorConfig: const SelectorConfig(
                                          selectorType:
                                              PhoneInputSelectorType.DIALOG,
                                          setSelectorButtonAsPrefixIcon: true,
                                          trailingSpace: false,
                                          showFlags: false,
                                        ),
                                        inputDecoration: _inputDecoration(
                                          AppLocalizations.of(context)!.profile_label_mobile1,
                                        ),
                                        textStyle: Styles.body.copyWith(
                                          color: textPrimary,
                                        ),
                                        selectorTextStyle: Styles.body
                                            .copyWith(color: textPrimary),
                                      )
                                    : const SizedBox.shrink())
                                : TextFormField(
                                    controller: state.forgetPasswordState!
                                        .forgetpasswordController,
                                    style: Styles.body.copyWith(
                                      color: textPrimary,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!.common_enter_email;
                                      }
                                      return null;
                                    },
                                    decoration: _inputDecoration(
                                      AppLocalizations.of(context)!.common_enter_email,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 12),

                          // Use Email/Phone Toggle
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => store.dispatch(
                                ForgetPasswordEmailOrPhoneAction(),
                              ),
                              child: Text(
                                state.forgetPasswordState!.valueChanger!
                                    ? AppLocalizations.of(context)!.forget_screen_use_email_instead
                                    : AppLocalizations.of(context)!.common_screen_use_phone,
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
                          Container(
                            height: 52,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: state.forgetPasswordState!.fp_loader == false ? Styles.primaryGradient : null,
                              borderRadius: BorderRadius.circular(12),
                              color: state.forgetPasswordState!.fp_loader == false ? null : primaryColor.withOpacity(0.5),
                              boxShadow: state.forgetPasswordState!.fp_loader == false ? [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ] : [],
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  state.forgetPasswordState!.fp_loader == false
                                      ? () => store.dispatch(
                                            SendCodeAction(
                                                payloadContext: context),
                                          )
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
                              child: state.forgetPasswordState!.fp_loader == false
                                  ? Text(
                                      AppLocalizations.of(context)!.forget_screen_send_code,
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
                        AppLocalizations.of(context)!.forget_screen_or_back_to,
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
        );
      },
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
