// Sanket: New Settings screen — premium 2026 design system
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/signout_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/change_password/change_password.dart';
import 'package:active_matrimonial_flutter_app/screens/contact_us/contact_us.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/manage_profiles/manage_profile.dart';
import 'package:active_matrimonial_flutter_app/screens/package/premium_plans.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_page.dart';
import 'package:active_matrimonial_flutter_app/screens/help_center/help_center.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return Scaffold(
          backgroundColor: MyTheme.background,
          appBar: _buildHeader(context),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSection("खाते", [
                  _settingsItem(Icons.person_outline, "प्रोफाईल संपादित करा", () => NavigatorPush.push(context, const MyProfile())),
                  _settingsItem(Icons.card_membership_outlined, "सदस्यत्व योजना", () => NavigatorPush.push(context, const PremiumPlans())),
                  _settingsItem(Icons.verified_user_outlined, "पडताळणी स्थिती", () => NavigatorPush.push(context, const VerifyPage())),
                ]),
                const SizedBox(height: 16),
                _buildSection("प्राधान्यता", [
                  _settingsItem(Icons.language_rounded, "भाषा", () {}),
                  _settingsItem(Icons.settings_accessibility_rounded, "साथीदाराची अपेक्षा", () => NavigatorPush.push(context, const MyProfile())),
                  _settingsItem(Icons.notifications_none_rounded, "सूचना", () {}),
                ]),
                const SizedBox(height: 16),
                _buildSection("सुरक्षा", [
                  _settingsItem(Icons.lock_outline, "पासवर्ड बदला", () => NavigatorPush.push(context, ChangePassword())),
                  _settingsItem(Icons.privacy_tip_outlined, "गोपनीयता सेटिंग्ज", () {}),
                  _settingsItem(Icons.person_off_outlined, "खाते निष्क्रिय करा", () {}, color: MyTheme.primary),
                ]),
                const SizedBox(height: 16),
                _buildSection("सहाय्यता", [
                  _settingsItem(Icons.help_outline_rounded, "सहाय्यता केंद्र", () => NavigatorPush.push(context, HelpCenter())),
                  _settingsItem(Icons.question_answer_outlined, "वारंवार विचारले जाणारे प्रश्न", () => NavigatorPush.push(context, HelpCenter())),
                  _settingsItem(Icons.contact_support_outlined, "आमच्याशी संपर्क साधा", () => NavigatorPush.push(context, ContactUs())),
                ]),
                const SizedBox(height: 16),
                _buildSection("कानूनी", [
                  _settingsItem(Icons.description_outlined, "नियम व अटी", () {}),
                  _settingsItem(Icons.security_outlined, "गोपनीयता धोरण", () {}),
                  _settingsItem(Icons.assignment_return_outlined, "परतावा धोरण", () {}),
                ]),
                const SizedBox(height: 32),
                _buildLogoutButton(context),
                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: MyTheme.text_primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("सेटिंग्ज", 
          style: Styles.h2.copyWith(color: MyTheme.text_primary, fontSize: 18)),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: MyTheme.border, height: 1),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: Styles.caption.copyWith(color: MyTheme.text_secondary, fontSize: 13, fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: BoxDecoration(
            color: MyTheme.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              return Column(
                children: [
                  items[index],
                  if (index != items.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: MyTheme.border),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _settingsItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? MyTheme.text_secondary, size: 22),
      title: Text(title, style: Styles.body.copyWith(color: color ?? MyTheme.text_primary, fontWeight: FontWeight.w500, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: MyTheme.text_secondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => store.dispatch(signOutMiddleware(context)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: MyTheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text("लॉगआउट", 
            style: Styles.buttonText.copyWith(color: MyTheme.primary, fontSize: 16)),
      ),
    );
  }
}
