// Sanket: Updated Sign In screen with Marathi translations and clean UI
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/feature/feature_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin_action.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signup/signup.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/forgetPassword/forget_password.dart';
import 'package:active_matrimonial_flutter_app/components/social_login_widget.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/staticPage/static_page.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin_reducer.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  State<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  final Color primaryColor = const Color(0xFFE54861);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFECECEC);

  bool? isGoogle;
  bool? isFacebook;
  bool? isTwitter;

  @override
  void initState() {
    super.initState();
    isGoogle = settingIsActive('google_login_activation', '1');
    isFacebook = settingIsActive('facebook_login_activation', '1');
    isTwitter = settingIsActive('twitter_login_activation', "1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit:
            (store) => [
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
            _buildLoginCard(context, state),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: borderColor, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    AppLocalizations.of(context)!.login_screen_or,
                    style: Styles.body.copyWith(color: textSecondary),
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
                  AppLocalizations.of(context)!.login_screen_if_have_account,
                  style: Styles.body.copyWith(color: textSecondary),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      ),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    textStyle: Styles.buttonText.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.login_screen_signup),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                '${AppLocalizations.of(context)!.signup_screen_terms_part1} ${AppLocalizations.of(context)!.signup_screen_terms_part2} ${AppLocalizations.of(context)!.signup_screen_terms_part3} ${AppLocalizations.of(context)!.signup_screen_terms_part4}',
                textAlign: TextAlign.center,
                style: Styles.caption.copyWith(color: textSecondary),
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
            AppLocalizations.of(context)!.login_button_text,
            textAlign: TextAlign.center,
            style: Styles.h2.copyWith(fontSize: 20, color: textPrimary),
          ),
          const SizedBox(height: 24),
          _buildInputField(
            controller: state.signInState!.emailController!,
            hint: AppLocalizations.of(context)!.common_email_or_phone,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(state, context),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPassword(),
                    ),
                  ),
              child: Text(
                AppLocalizations.of(context)!.login_screen_forget_password,
                style: Styles.buttonText.copyWith(
                  fontSize: 13,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: state.signInState!.isLogin == false ? Styles.primaryGradient : null,
              borderRadius: BorderRadius.circular(12),
              color: state.signInState!.isLogin == false ? null : primaryColor.withOpacity(0.5),
              boxShadow: state.signInState!.isLogin == false ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: ElevatedButton(
              onPressed:
                  state.signInState!.isLogin == false
                      ? () => store.dispatch(LoginRequest(payloadContext: context))
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
                  state.signInState!.isLogin == false
                      ? Text(
                        AppLocalizations.of(context)!.login_button_text,
                        style: Styles.buttonText.copyWith(
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
      style: Styles.body.copyWith(color: textPrimary),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: textSecondary, size: 20),
        hintText: hint,
        hintStyle: Styles.body.copyWith(color: textSecondary.withOpacity(0.5)),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
      style: Styles.body.copyWith(color: textPrimary),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: textSecondary, size: 20),
        hintText: "पासवर्ड प्रविष्ट करा", // Enter Password
        hintStyle: Styles.body.copyWith(color: textSecondary.withOpacity(0.5)),
        suffixIcon: GestureDetector(
          onTap: () => store.dispatch(IsObscureAction()),
          child: Icon(
            state.signInState!.isObscure!
                ? Icons.visibility_off
                : Icons.visibility,
            color: textSecondary,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
