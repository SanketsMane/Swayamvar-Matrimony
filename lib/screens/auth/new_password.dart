import 'dart:async';

import 'package:active_matrimonial_flutter_app/components/common_input.dart';
import 'package:active_matrimonial_flutter_app/components/group_item_with_child.dart';
import 'package:active_matrimonial_flutter_app/components/my_gradient_container.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/reset_password_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/reset_password_reducer.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

import 'forgetPassword/forgetpassword_middleware.dart';

class NewPassword extends StatefulWidget {
  final String sendBy;
  final String emailOrPhone;
  const NewPassword({
    super.key,
    required this.sendBy,
    required this.emailOrPhone,
  });

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  String? passwordErrorText = '';
  bool? visibility = false;
  String? confirmPasswordErrorText = '';

  bool requiredFieldVerification() {
    if (store.state.resetPasswordState!.passwordController!.text.isEmpty) {
      passwordErrorText = AppLocalizations.of(context)!.common_enter_password;
      visibility = true;
      setState(() {});
      return false;
    } else if (store
            .state
            .resetPasswordState!
            .passwordController!
            .text
            .length <=
        7) {
      passwordErrorText = AppLocalizations.of(context)!.common_screen_8_or_more_char;
      visibility = true;

      setState(() {});

      return false;
    } else if (store
        .state
        .resetPasswordState!
        .confirmPasswordController!
        .text
        .isEmpty) {
      confirmPasswordErrorText = AppLocalizations.of(context)!.common_screen_confim_password;
      setState(() {});
      return false;
    } else if (store.state.resetPasswordState!.passwordController!.text
            .toString() !=
        store.state.resetPasswordState!.confirmPasswordController!.text
            .toString()) {
      confirmPasswordErrorText = "Passwords do not match";
      setState(() {});
      return false;
    }

    return true;
  }

  void confirm(context) {
    print('on confirm');
    FocusManager.instance.primaryFocus?.unfocus();
    if (!requiredFieldVerification()) {
      return;
    }

    store.dispatch(
      resetPasswordMiddleware(
        emailOrPhone: widget.emailOrPhone,
        sendBy: widget.sendBy,
        opt: store.state.resetPasswordState!.verifyController!.text,
        password: store.state.resetPasswordState!.passwordController!.text,
        confirm_password:
            store.state.resetPasswordState!.confirmPasswordController!.text,
        context: context,
      ),
    );
  }

  // for resend timer
  int secondsRemaining = 100;
  bool enableResend = false;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit:
          (store) => {
            store.state.resetPasswordState!.passwordController!.clear(),
            store.state.resetPasswordState!.confirmPasswordController!.clear(),
            store.state.resetPasswordState!.verifyController!.clear(),
            timer = Timer.periodic(const Duration(seconds: 1), (_) {
              if (secondsRemaining != 0) {
                setState(() {
                  secondsRemaining--;
                });
              } else {
                setState(() {
                  enableResend = true;
                });
              }
            }),
          },
      onDispose: (store) => {timer!.cancel()},
      builder:
          (_, state) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: SizedBox(
              height: DeviceInfo(context).height,
              child: Stack(
                children: [
                  // upper section of logo, login
                  buildGredientPlusLogoContainer(context),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: DeviceInfo(context).height! * 0.65,
                      width: DeviceInfo(context).width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // enter otp field
                            GroupItemWithChild(
                              title: AppLocalizations.of(context)!.otp,
                              style: Styles.bold_app_accent_12,
                              child: buildPinPutContainer(context),
                            ),

                            Const.height5,
                            // password field
                            GroupItemWithChild(
                              title:
                                  AppLocalizations.of(
                                    context,
                                  )!.common_password_text,
                              style: Styles.bold_app_accent_12,
                              child: TextField(
                                obscureText:
                                    state.resetPasswordState!.passwordObscure!,
                                controller:
                                    state
                                        .resetPasswordState!
                                        .passwordController,
                                onTap: () {
                                  passwordErrorText = '';
                                  visibility = false;
                                  setState(() {});
                                },
                                decoration: InputStyle.inputDecoratio_password(
                                  hint: "● ● ● ● ● ● ● ●",
                                  suffixIcon: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      store.dispatch(
                                        ResetPasswordActions.passwordObscure,
                                      );
                                    },
                                    icon: Icon(
                                      state.resetPasswordState!.passwordObscure!
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Const.height5,

                            // error text for password
                            Visibility(
                              visible: visibility!,
                              child: Column(
                                children: [
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: DeviceInfo(context).width,
                                    child: Text(
                                      passwordErrorText!,
                                      style: Styles.caption.copyWith(
                                        color: MyTheme.failure,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Const.height5,

                            // warning for password length
                            SizedBox(
                              width: DeviceInfo(context).width,
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.common_screen_8_or_more_char,
                                style: Styles.regular_gull_grey_10,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Const.height18,

                            // confirm password field
                            GroupItemWithChild(
                              title:
                                  AppLocalizations.of(
                                    context,
                                  )!.common_screen_confim_password,
                              style: Styles.bold_app_accent_12,
                              child: TextField(
                                obscureText:
                                    state
                                        .resetPasswordState!
                                        .confirmPasswordObscure!,
                                controller:
                                    state
                                        .resetPasswordState!
                                        .confirmPasswordController,
                                onTap: () {
                                  confirmPasswordErrorText = '';
                                  setState(() {});
                                },
                                decoration: InputStyle.inputDecoratio_password(
                                  hint: "● ● ● ● ● ● ● ●",
                                  suffixIcon: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      store.dispatch(
                                        ResetPasswordActions
                                            .confirmPasswordObscure,
                                      );
                                    },
                                    icon: Icon(
                                      state
                                              .resetPasswordState!
                                              .confirmPasswordObscure!
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Const.height5,

                            SizedBox(
                              width: DeviceInfo(context).width,
                              child: Text(
                                confirmPasswordErrorText!,
                                style: Styles.caption.copyWith(
                                  color: MyTheme.failure,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            Const.height20,

                            // confirm button
                            InkWell(
                              onTap: () => confirm(context),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: state.resetPasswordState!.rp_loader == false ? Styles.primaryGradient : null,
                                  borderRadius: BorderRadius.circular(12),
                                  color: state.resetPasswordState!.rp_loader == false ? null : MyTheme.primary.withOpacity(0.5),
                                  boxShadow: state.resetPasswordState!.rp_loader == false ? [
                                    BoxShadow(
                                      color: MyTheme.primary.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ] : [],
                                ),
                                child: Center(
                                  child:
                                      state.resetPasswordState!.rp_loader == false
                                          ? Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.common_confirm,
                                            style: Styles.bold_white_14,
                                          )
                                          : const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                ),
                              ),
                            ),

                            Const.height20,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // timer text
                                Text(
                                  "Didn't receive code? $secondsRemaining",
                                  style: Styles.body.copyWith(
                                    color: MyTheme.storm_grey,
                                  ),
                                ),

                                // resend button
                                InkWell(
                                  onTap:
                                      enableResend
                                          ? () {
                                            // resetting timer
                                            // if resend button pressed
                                            setState(() {
                                              secondsRemaining = 100;
                                              enableResend = false;
                                            });

                                            store.dispatch(
                                              forgetPasswordMiddleware(
                                                send_by: widget.sendBy,
                                                email: widget.emailOrPhone,
                                                context: context,
                                              ),
                                            );
                                          }
                                          : null,
                                  child: Text(
                                    AppLocalizations.of(context)!.re_send_otp,
                                    style:
                                        enableResend
                                            ? Styles.bold_app_accent_12
                                            : Styles.bold_storm_grey_12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget buildPinPutContainer(BuildContext context) {
    return SizedBox(
      width: DeviceInfo(context).width,
      child: Pinput(
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        controller: store.state.resetPasswordState!.verifyController,
        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
        length: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        defaultPinTheme: PinTheme(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            color: MyTheme.solitude,
          ),
        ),
      ),
    );
  }

  Container buildGredientPlusLogoContainer(BuildContext context) {
    return Container(
      height: DeviceInfo(context).height! * 0.40,
      width: DeviceInfo(context).width,
      decoration: BoxDecoration(
        gradient: Styles.buildLinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 78),
          Center(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(MyTheme.white, BlendMode.srcIn),
              child: Image.asset(
                'assets/logo/app_logo.png',
                height: 72,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.new_password_screen_title,
            style: Styles.bold_white_22,
          ),
          Text(
            AppLocalizations.of(context)!.new_password_screen_subtitle,
            style: Styles.regular_white_14,
          ),
        ],
      ),
    );
  }
}
