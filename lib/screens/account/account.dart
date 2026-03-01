import 'package:active_matrimonial_flutter_app/components/main_drawer.dart';
import 'package:active_matrimonial_flutter_app/components/my_images.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/signout_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/account/account_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/manage_profiles/manage_profile.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/gallery/my_gallery.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest/my_interest.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/shortlist/my_shortlist.dart';
import 'package:active_matrimonial_flutter_app/screens/package/premium_plans.dart';
import 'package:active_matrimonial_flutter_app/screens/referral/referral.dart';
import 'package:active_matrimonial_flutter_app/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/helpers/profile_completeness_helper.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) => [store.dispatch(accountMiddleware())],
      builder: (_, state) {
        final l = AppLocalizations.of(context)!;
        final profileData = state.accountState?.profileData;
        final userData = state.authState?.userData;

        return Scaffold(
          backgroundColor: MyTheme.background,
          drawer: MainDrawer(),
          body: Column(
            children: [
              // Sanket: Fixed 56px header
              _buildHeader(context, l),

              Expanded(
                child: RefreshIndicator(
                  color: MyTheme.primary,
                  onRefresh: () async {
                    await store.dispatch(accountMiddleware());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // 1. Profile Card
                        _buildProfileCard(context, profileData, userData),

                        const SizedBox(height: 16),

                        // 2. Membership Card
                        _buildMembershipCard(context, profileData),

                        const SizedBox(height: 16),

                        // 3. Quick Actions Grid
                        _buildQuickActionsGrid(context),

                        const SizedBox(height: 16),

                        // 4. Settings Section
                        _buildSettingsSection(context),

                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l) {
    return Container(
      height: 56 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: MyTheme.white,
        border: Border(bottom: BorderSide(color: MyTheme.border, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Builder(
              builder:
                  (context) => _headerIconBtn(Icons.menu_rounded, () {
                    Scaffold.of(context).openDrawer();
                  }),
            ),
            const Spacer(),
            Text(
              l.profile_title,
              style: Styles.bold_arsenic_16.copyWith(
                fontSize: 18,
                color: MyTheme.text_primary,
              ),
            ),
            const Spacer(),
            _headerIconBtn(
              Icons.settings_outlined,
              () => NavigatorPush.push(context, const SettingsScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerIconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: MyTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyTheme.border),
        ),
        child: Icon(icon, color: MyTheme.text_primary, size: 20),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    dynamic profileData,
    dynamic userData,
  ) {
    final l = AppLocalizations.of(context)!;
    final int completion = ProfileCompletenessHelper.calculate(store.state);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 80px Profile Image
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: MyTheme.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: MyImages.normalImage(profileData?.memberPhoto),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            userData?.name ?? "User Name",
                            style: Styles.bold_arsenic_16.copyWith(
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.verified,
                          color: MyTheme.success,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID: SYW-${userData?.id ?? '10234'}",
                      style: Styles.regular_gull_grey_12.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: MyTheme.text_secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Pune, Maharashtra",
                          style: Styles.regular_gull_grey_12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Profile Completion Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.profile_completion,
                    style: Styles.bold_arsenic_12.copyWith(
                      color: MyTheme.text_primary,
                    ),
                  ),
                  Text(
                    "$completion%",
                    style: Styles.bold_arsenic_12.copyWith(
                      color: MyTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyTheme.background,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: completion / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyTheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => NavigatorPush.push(context, MyProfile()),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: MyTheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                l.profile_edit,
                style: const TextStyle(
                  color: MyTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context, dynamic profileData) {
    final l = AppLocalizations.of(context)!;
    final packageName =
        profileData?.currentPackageInfo?.packageName ?? "Free Member";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.profile_membership_status,
            style: Styles.regular_gull_grey_12,
          ),
          const SizedBox(height: 4),
          Text(
            packageName,
            style: Styles.bold_arsenic_16.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _creditItem(
                Icons.favorite_outline,
                "12",
                l.profile_interests,
              ),
              _creditItem(
                Icons.visibility_outlined,
                "5",
                l.profile_contacts,
              ),
              _creditItem(
                Icons.photo_library_outlined,
                "3",
                l.profile_gallery,
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => NavigatorPush.push(context, PremiumPlans()),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primary,
                foregroundColor: MyTheme.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                l.profile_upgrade,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: MyTheme.text_secondary),
        const SizedBox(height: 8),
        Text(value, style: Styles.bold_arsenic_14),
        Text(label, style: Styles.regular_gull_grey_12.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> items = [
      {
        'title': l.profile_shortlist,
        'icon': Icons.star_outline,
        'onTap': () => NavigatorPush.push(context, MyShortlist()),
      },
      {
        'title': l.profile_interests_sent,
        'icon': Icons.favorite_outline,
        'onTap': () => NavigatorPush.push(context, MyInterest()),
      },
      {
        'title': l.profile_gallery,
        'icon': Icons.photo_library_outlined,
        'onTap': () => NavigatorPush.push(context, const MyGallery()),
      },
      {
        'title': l.profile_packages,
        'icon': Icons.card_membership_rounded,
        'onTap': () => NavigatorPush.push(context, PremiumPlans()),
      },
      {
        'title': l.settings_item_language,
        'icon': Icons.settings_accessibility_rounded,
        'onTap': () => NavigatorPush.push(context, const SettingsScreen()),
      },
      {
        'title': l.profile_referral,
        'icon': Icons.share_outlined,
        'onTap': () => NavigatorPush.push(context, Referral()),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: items[index]['onTap'],
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: MyTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(items[index]['icon'], color: MyTheme.primary, size: 24),
                const SizedBox(height: 8),
                Text(
                  items[index]['title'],
                  style: Styles.bold_arsenic_12.copyWith(
                    color: MyTheme.text_primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _settingsItem(
            Icons.lock_outline,
            l.settings_item_change_password,
            () => NavigatorPush.push(context, const SettingsScreen()),
          ),
          _settingsDivider(),
          _settingsItem(
            Icons.settings_outlined,
            l.settings_title,
            () => NavigatorPush.push(context, const SettingsScreen()),
          ),
          _settingsDivider(),
          _settingsItem(
            Icons.logout_rounded,
            l.settings_logout,
            () => store.dispatch(signOutMiddleware(context)),
            color: MyTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _settingsItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? MyTheme.text_secondary, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? MyTheme.text_primary,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: MyTheme.text_secondary,
      ),
    );
  }

  Widget _settingsDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: MyTheme.border),
    );
  }
}
