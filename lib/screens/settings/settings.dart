// Sanket: New Settings screen — premium 2026 design system
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/signout_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/staticPage/static_page.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/change_password/change_password.dart';
import 'package:active_matrimonial_flutter_app/screens/contact_us/contact_us.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/manage_profiles/manage_profile.dart';
import 'package:active_matrimonial_flutter_app/screens/package/premium_plans.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_page.dart';
import 'package:active_matrimonial_flutter_app/screens/help_center/help_center.dart';
import 'package:active_matrimonial_flutter_app/screens/notifications/notifications.dart';
import 'package:active_matrimonial_flutter_app/screens/settings/language_dialog.dart';
import 'package:active_matrimonial_flutter_app/screens/settings/static_page_view.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return StoreConnector<AppState, AppState>(
      onInit: (store) => store.dispatch(fetchStaticPageAction()),
      converter: (store) => store.state,
      builder: (_, state) {
        return Scaffold(
          backgroundColor: MyTheme.background,
          appBar: _buildHeader(context, l),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSection(l.settings_section_account, [
                  _settingsItem(
                    Icons.person_outline,
                    l.settings_item_edit_profile,
                    () => NavigatorPush.push(context, const MyProfile()),
                  ),
                  _settingsItem(
                    Icons.card_membership_outlined,
                    l.settings_item_plans,
                    () => NavigatorPush.push(context, const PremiumPlans()),
                  ),
                  _settingsItem(
                    Icons.verified_user_outlined,
                    l.settings_item_verify,
                    () => NavigatorPush.push(context, const VerifyPage()),
                  ),
                ]),
                const SizedBox(height: 16),
                _buildSection(l.settings_section_preferences, [
                  _settingsItem(
                    Icons.language_rounded,
                    l.settings_item_language,
                    () {
                      showDialog(
                        context: context,
                        builder: (_) => const LanguageSelectionDialog(),
                      );
                    },
                  ),
                  _settingsItem(
                    Icons.settings_accessibility_rounded,
                    l.settings_item_partner_pref,
                    () => NavigatorPush.push(
                      context,
                      const MyProfile(initialStep: 3),
                    ),
                  ),
                  _settingsItem(
                    Icons.notifications_none_rounded,
                    l.settings_item_notifications,
                    () => NavigatorPush.push(context, const Notifications()),
                  ),
                  _settingsItem(
                    Icons.palette_outlined,
                    l.settings_item_app_theme,
                    () {},
                    subtitle: l.settings_personalization_desc,
                  ),
                ]),
                const SizedBox(height: 16),
                _buildSection(l.settings_section_security, [
                  _settingsItem(
                    Icons.lock_outline,
                    l.settings_item_change_password,
                    () => NavigatorPush.push(context, ChangePassword()),
                  ),
                  _settingsItem(
                    Icons.privacy_tip_outlined,
                    l.settings_item_privacy_settings,
                    () {},
                  ),
                  _settingsItem(
                    Icons.person_off_outlined,
                    l.settings_item_deactivate,
                    () => _showDeactivateDialog(context, l),
                    color: MyTheme.primary,
                  ),
                ]),
                const SizedBox(height: 16),
                _buildSection(l.settings_section_help, [
                  _settingsItem(
                    Icons.help_outline_rounded,
                    l.settings_item_help_center,
                    () => NavigatorPush.push(context, HelpCenter()),
                  ),
                  _settingsItem(
                    Icons.question_answer_outlined,
                    l.settings_item_faq,
                    () => NavigatorPush.push(context, HelpCenter()),
                  ),
                  _settingsItem(
                    Icons.contact_support_outlined,
                    l.settings_item_contact_us,
                    () => NavigatorPush.push(context, ContactUs()),
                  ),
                ]),
                const SizedBox(height: 16),
                _buildSection(l.settings_section_legal, [
                  _settingsItem(
                    Icons.description_outlined,
                    l.settings_item_terms,
                    () {
                      NavigatorPush.push(
                        context,
                        StaticPageView(
                          title: l.settings_item_terms,
                          content:
                              state.staticPageState?.termsAndCondition ?? "",
                        ),
                      );
                    },
                  ),
                  _settingsItem(
                    Icons.security_outlined,
                    l.settings_item_privacy_policy,
                    () {
                      NavigatorPush.push(
                        context,
                        StaticPageView(
                          title: l.settings_item_privacy_policy,
                          content: state.staticPageState?.privacyPolicy ?? "",
                        ),
                      );
                    },
                  ),
                  _settingsItem(
                    Icons.assignment_return_outlined,
                    l.settings_item_refund_policy,
                    () {},
                  ),
                ]),
                const SizedBox(height: 32),
                _buildLogoutButton(context, l),
                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context, AppLocalizations l) {
    return AppBar(
      backgroundColor: MyTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: MyTheme.text_primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        l.settings_title,
        style: Styles.h2.copyWith(color: MyTheme.text_primary, fontSize: 18),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: MyTheme.border, height: 1),
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context, AppLocalizations l) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              l.settings_item_deactivate,
              style: Styles.h2.copyWith(fontSize: 18),
            ),
            content: Text(l.settings_deactivate_confirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.common_no ?? "No"),
              ),
              TextButton(
                onPressed: () {
                  // Sanket: Placeholder for deactivation logic
                  Navigator.pop(context);
                },
                child: Text(
                  l.common_yes ?? "Yes",
                  style: const TextStyle(color: MyTheme.primary),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: Styles.caption.copyWith(
              color: MyTheme.text_secondary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: MyTheme.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
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

  Widget _settingsItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
    String? subtitle,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? MyTheme.text_secondary, size: 22),
      title: Text(
        title,
        style: Styles.body.copyWith(
          color: color ?? MyTheme.text_primary,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle:
          subtitle != null
              ? Text(subtitle, style: Styles.caption.copyWith(fontSize: 11))
              : null,
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: MyTheme.text_secondary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => store.dispatch(signOutMiddleware(context)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: MyTheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          l.settings_logout,
          style: Styles.buttonText.copyWith(
            color: MyTheme.primary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
