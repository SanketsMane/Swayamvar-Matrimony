import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/signout_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/manage_profiles/manage_profile.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest/my_interest.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/shortlist/my_shortlist.dart';
import 'package:active_matrimonial_flutter_app/screens/package/premium_plans.dart';
import 'package:active_matrimonial_flutter_app/screens/settings/settings.dart';
import 'package:active_matrimonial_flutter_app/screens/support_ticket/support_ticket.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:active_matrimonial_flutter_app/components/my_images.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = store.state.authState?.userData;
    return Drawer(
      backgroundColor: MyTheme.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: MyTheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: MyTheme.white, width: 2),
                    image: DecorationImage(
                      image: MyImage.imageProvider(store.state.accountState?.profileData?.memberPhoto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userData?.name ?? "User",
                  style: Styles.h1.copyWith(color: MyTheme.white, fontSize: 18),
                ),
                Text(
                  userData?.email ?? "",
                  style: Styles.body.copyWith(color: MyTheme.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
          _drawerItem(context, icon: Icons.person_outline, title: "माझी प्रोफाईल", onTap: () => AIZRoute.push(context, UserPublicProfile(userId: userData?.id), middleware: ProfileViewMiddleware(context: context, user: userData))),
          _drawerItem(context, icon: Icons.edit_outlined, title: "प्रोफाईल संपादित करा", onTap: () => NavigatorPush.push(context, const MyProfile())),
          _drawerItem(context, icon: Icons.favorite_border, title: "पाठवलेली आवड", onTap: () => NavigatorPush.push(context, MyInterest())),
          _drawerItem(context, icon: Icons.star_border, title: "निवडलेले (Shortlist)", onTap: () => NavigatorPush.push(context, MyShortlist())),
          _drawerItem(context, icon: Icons.verified_outlined, title: "पडताळणी (Verification)", onTap: () {
            NavigatorPush.push(context, const MyProfile());
          }),
          _drawerItem(context, icon: Icons.card_membership_rounded, title: "सदस्यत्व योजना", onTap: () => NavigatorPush.push(context, PremiumPlans())),
          const Divider(),
          _drawerItem(context, icon: Icons.settings_outlined, title: "सेटिंग्ज", onTap: () => NavigatorPush.push(context, const SettingsScreen())),
          _drawerItem(context, icon: Icons.help_outline, title: "मदत केंद्र", onTap: () => NavigatorPush.push(context, const SupportTicket())),
          const Divider(),
          _drawerItem(context, icon: Icons.logout_rounded, title: "बाहेर पडा", color: MyTheme.primary, onTap: () {
            Navigator.pop(context); // close drawer first
            store.dispatch(signOutMiddleware(context));
          }),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? MyTheme.text_secondary, size: 22),
      title: Text(
        title,
        style: Styles.body.copyWith(
          color: color ?? MyTheme.text_primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        onTap();
      },
    );
  }
}
