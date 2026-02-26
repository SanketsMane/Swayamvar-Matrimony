
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/get_context.dart';
import 'package:active_matrimonial_flutter_app/helpers/localization.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/signout_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/vertify_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';
class Verify extends StatefulWidget {
  const Verify({super.key});
  @override
  State<Verify> createState() => _VerifyState();
}
class _VerifyState extends State<Verify> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _verifyController = TextEditingController();

  @override
  void initState() {
    SystemHelper.isVerifyScreenShown = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: screenSize.height,
          child: Stack(
            children: [
              buildGradientAndLogoContainer(context, screenSize),
              Positioned(
                bottom: 0,
                child: Container(
                  height: screenSize.height * 0.65,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenSize.width * 0.08),
                      topRight: Radius.circular(screenSize.width * 0.08),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.08,
                      vertical: screenSize.height * 0.04,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenSize.height * 0.02),
                          buildPinPutContainer(context, screenSize),
                          SizedBox(height: screenSize.height * 0.05),
                          buildVerifyButtonContainer(context, state, screenSize),
                          SizedBox(height: screenSize.height * 0.04),
                          InkWell(
                            onTap: () {
                              store.dispatch(resendVerifyCodeMiddleware());
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.re_send_otp,
                                style: Styles.bold_app_accent_12.copyWith(fontSize: screenSize.width * 0.035), // Responsive font
                              ),
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: InkWell(
                              onTap: () {
                                store.dispatch(signOutMiddleware(context));
                              },
                              child: Text(
                                LangText(context: SystemHelper.context).getLocal().or_logout,
                                style: Styles.buttonText.copyWith(
                                  fontSize: screenSize.width * 0.04,
                                  color: MyTheme.app_accent_color,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                        ],
                      ),
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

  Widget buildPinPutContainer(BuildContext context, Size screenSize) {
    // Proportional size for pin fields
    final pinSize = screenSize.width * 0.12;

    return SizedBox(
      width: screenSize.width,
      child: Pinput(
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        controller: _verifyController,
        length: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        defaultPinTheme: PinTheme(
          height: pinSize,
          width: pinSize,
          textStyle: Styles.h2.copyWith(fontSize: screenSize.width * 0.05),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            color: MyTheme.solitude,
          ),
        ),
      ),
    );
  }

  Widget buildVerifyButtonContainer(BuildContext context, AppState state, Size screenSize) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (_verifyController.text.isEmpty) {
          store.dispatch(ShowMessageAction(msg: 'Please enter code.'));
        } else if (_verifyController.text.length < 6) {
          store.dispatch(ShowMessageAction(msg: 'Code must be 6 digits.'));
        } else {
          store.dispatch(
            verifyMiddleware(code: _verifyController.text, fromPage: "verify"),
          );
          SharedPref().resetVerificationCode = _verifyController.text;
        }
      },
      child: Container(
        height: screenSize.height * 0.06,
        width: screenSize.width,
        decoration: BoxDecoration(
          gradient: Styles.buildLinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: state.verifyState!.vloader == false
              ? Text(
            AppLocalizations.of(context)!.verify_screen_btn_text,
            style: Styles.bold_white_14.copyWith(fontSize: screenSize.width * 0.04), // Responsive font
          )
              :  CircularProgressIndicator(color: MyTheme.storm_grey),
        ),
      ),
    );
  }

  Widget buildGradientAndLogoContainer(BuildContext context, Size screenSize) {
    return Container(
      height: screenSize.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Styles.buildLinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenSize.height * 0.05),
          ImageIcon(
            const AssetImage('assets/logo/app_logo.png'),
            size: screenSize.height * 0.11,
            color: MyTheme.white,
          ),
          SizedBox(height: screenSize.height * 0.02),
          Text(
            AppLocalizations.of(context)!.verify_screen_title,
            style: Styles.h1.copyWith(
              color: MyTheme.white,
              fontSize: screenSize.width * 0.06,
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            AppLocalizations.of(context)!.verify_screen_sub_title,
            style: Styles.regular_white_14.copyWith(fontSize: screenSize.width * 0.035), // Responsive font
          ),
        ],
      ),
    );
  }
}