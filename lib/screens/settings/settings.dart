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
                _buildSection("Account", [
                  _settingsItem(Icons.person_outline, "Edit Profile", () => NavigatorPush.push(context, const MyProfile())),
                  _settingsItem(Icons.card_membership_outlined, "Membership Plan", () => NavigatorPush.push(context, const PremiumPlans())),
                  _settingsItem(Icons.verified_user_outlined, "Verification Status", () => NavigatorPush.push(context, const VerifyPage())),
                ]),
                const SizedBox(height: 16),
                _buildSection("Preferences", [
                  _settingsItem(Icons.language_rounded, "Language", () {}),
                  _settingsItem(Icons.settings_accessibility_rounded, "Partner Preferences", () => NavigatorPush.push(context, const MyProfile())),
                  _settingsItem(Icons.notifications_none_rounded, "Notifications", () {}),
                ]),
                const SizedBox(height: 16),
                _buildSection("Security", [
                  _settingsItem(Icons.lock_outline, "Change Password", () => NavigatorPush.push(context, ChangePassword())),
                  _settingsItem(Icons.privacy_tip_outlined, "Privacy Settings", () {}),
                  _settingsItem(Icons.person_off_outlined, "Deactivate Account", () {}, color: MyTheme.primary),
                ]),
                const SizedBox(height: 16),
                _buildSection("Support", [
                  _settingsItem(Icons.help_outline_rounded, "Help Center", () => NavigatorPush.push(context, HelpCenter())),
                  _settingsItem(Icons.question_answer_outlined, "FAQ", () => NavigatorPush.push(context, HelpCenter())),
                  _settingsItem(Icons.contact_support_outlined, "Contact Us", () => NavigatorPush.push(context, ContactUs())),
                ]),
                const SizedBox(height: 16),
                _buildSection("Legal", [
                  _settingsItem(Icons.description_outlined, "Terms & Conditions", () {}),
                  _settingsItem(Icons.security_outlined, "Privacy Policy", () {}),
                  _settingsItem(Icons.assignment_return_outlined, "Refund Policy", () {}),
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
      title: const Text("Settings", 
          style: TextStyle(color: MyTheme.text_primary, fontSize: 18, fontWeight: FontWeight.bold)),
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
          child: Text(title, style: const TextStyle(color: MyTheme.text_secondary, fontSize: 13, fontWeight: FontWeight.bold)),
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
      title: Text(title, style: TextStyle(color: color ?? MyTheme.text_primary, fontWeight: FontWeight.w500, fontSize: 14)),
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
        child: const Text("Logout", 
            style: TextStyle(color: MyTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
