import 'package:active_matrimonial_flutter_app/components/grid_square_card.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/helpers/localization.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/middleware/check_package_middleware.dart';
import 'package:active_matrimonial_flutter_app/middleware/middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/blog/blogs.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_list.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart'
    hide Middleware;
import 'package:active_matrimonial_flutter_app/screens/happy_story/my_happy_stories/my_happy_stories.dart';
import 'package:active_matrimonial_flutter_app/screens/ignore/ignore.dart';
import 'package:active_matrimonial_flutter_app/screens/member_match/MatchedProfileScreen.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest/my_interest.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/shortlist/my_shortlist.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/wallet/my_wallet.dart';
import 'package:active_matrimonial_flutter_app/screens/notifications/notifications.dart';
import 'package:active_matrimonial_flutter_app/screens/profile_and_gallery_picure_rqst/gallery_picture_view_rqst.dart';
import 'package:active_matrimonial_flutter_app/screens/profile_and_gallery_picure_rqst/profile_picture_view_rqst.dart';
import 'package:active_matrimonial_flutter_app/screens/referral/referral.dart';
import 'package:active_matrimonial_flutter_app/screens/referral/referral_earnings.dart';
import 'package:active_matrimonial_flutter_app/screens/referral/referral_earnings_wallet.dart';
import 'package:active_matrimonial_flutter_app/screens/support_ticket/support_ticket.dart';
import 'package:flutter/material.dart';

class GridItems {
  final List<GridSquareCard> _menuList = [];

  VoidCallback _handleNavigation({
    required Widget screen,
    Middleware<bool, bool>? middleware,
    bool isRestricted = true,
  }) {
    return () {
      final context = OneContext().context!;
      bool isDeactivated = store.state.authState?.userData?.deactivated == 1;

      if (isDeactivated && isRestricted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Your account is deactivated. Please reactivate it to use this feature.',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        AIZRoute.push(context, screen, middleware: middleware);
      }
    };
  }

  void addMenu() {
    _menuList.clear();
    _menuList.addAll([
      if (settingIsActive("wallet_system", "1"))
        GridSquareCard(
          onpressed: _handleNavigation(screen: MyWallet()),
          icon: "icon_wallet.png",
          text: "My Wallet",
        ),
      GridSquareCard(
        onpressed: _handleNavigation(
          screen: ChatList(backButtonAppearance: true),
        ),
        icon: "icon_messages.png",
        text: "Messages",
      ),
      GridSquareCard(
        onpressed: _handleNavigation(screen: MatchedProfileScreen()),
        icon: "icon_follow.png",
        text: "Profile Match",
      ),
      GridSquareCard(
        onpressed: _handleNavigation(screen: const Notifications()),
        icon: "icon_notifications.png",
        text: "Notifications",
      ),
      GridSquareCard(
        onpressed: _handleNavigation(screen: const MyInterest()),
        icon: "icon_love.png",
        text: "My Interest",
      ),
      if (settingIsActive("profile_picture_privacy", "only_me"))
        GridSquareCard(
          onpressed: _handleNavigation(screen: const PictureProfileViewRqst()),
          icon: "icon_picture_view.png",
          text: "Profile Picture View Requests",
        ),
      if (settingIsActive("gallery_image_privacy", "only_me"))
        GridSquareCard(
          onpressed: _handleNavigation(screen: const GalleryProfileViewRqst()),
          icon: "icon_gallery_view.png",
          text:
              LangText(
                context: OneContext().context,
              ).getLocal().gallery_picture_screen_appbar_title,
        ),
      GridSquareCard(
        onpressed: _handleNavigation(screen: const MyShortlist()),
        icon: "icon_shortlist.png",
        text: "My Shortlist",
      ),
      GridSquareCard(
        onpressed: _handleNavigation(screen: const Ignore()),
        icon: "icon_ignore.png",
        text: "Ignore list",
      ),

      GridSquareCard(
        onpressed: _handleNavigation(
          screen: const MyHappyStories(),
          middleware: PackageCheckMiddleware(
            context: OneContext().context!,
            user: store.state.authState!.userData,
          ),
          isRestricted: false,
        ),
        icon: "icon_happy_s.png",
        text: "My happy story",
      ),
      if (settingIsActive("show_blog_section", "on"))
        GridSquareCard(
          onpressed: _handleNavigation(screen: const BlogPage()),
          icon: "icon_blogs.png",
          text: "Blogs",
        ),
      if (store.state.addonState!.data!.supportTickets!)
        GridSquareCard(
          onpressed: _handleNavigation(screen: const SupportTicket()),
          icon: "icon_support.png",
          text: "Support Ticket",
        ),
      if (store.state.addonState!.data!.referralSystem!)
        GridSquareCard(
          onpressed: _handleNavigation(screen: const Referral()),
          icon: "icon_referral_user.png",
          text: "Referral",
        ),
      if (store.state.addonState!.data!.referralSystem!)
        GridSquareCard(
          onpressed: _handleNavigation(screen: const RefferalEarnings()),
          icon: "icon_referral_earnings.png",
          text: "Ref.. Earnings",
        ),
      if (store.state.addonState!.data!.referralSystem!)
        GridSquareCard(
          onpressed: _handleNavigation(screen: const ReferralEarningsWallet()),
          icon: "icon_referral_wallet.png",
          text: "Ref.. Wallet",
        ),
    ]);
  }

  List<GridSquareCard> get gridMenuItems => _menuList;
}
