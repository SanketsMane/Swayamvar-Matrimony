import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/helpers/profile_completeness_helper.dart';

import 'dart:io';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/profile_picture_view_request/profile_picture_view_get_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest_request/interest_request_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest_request/interest_requests.dart';
import 'package:active_matrimonial_flutter_app/screens/profile_and_gallery_picure_rqst/profile_picture_view_rqst.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/auth_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/manage_profile_combine_state.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/home/activity_pages/new_matches.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/models_response/account_response.dart';
import 'package:active_matrimonial_flutter_app/components/my_images.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/verify/verify_action.dart';
import 'package:active_matrimonial_flutter_app/screens/manage_profiles/manage_profile.dart';
import 'package:active_matrimonial_flutter_app/screens/account/account_middleware.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_matrimonial_flutter_app/components/main_drawer.dart';
import 'package:active_matrimonial_flutter_app/components/deactivate_Massage.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/screens/search_screens/advanced_search.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/report/report_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/shortlist/my_shortlist.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest/express_interest_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/shortlist/add_shortlist_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/notifications/notifications.dart';

import '../explore/explore.dart';
import 'home_action.dart';
import 'home_middleware.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void onRefresh() {
    store.dispatch(accountMiddleware());
    store.dispatch(homeMiddleware());
  }

  @override
  void initState() {
    super.initState();
    store.dispatch(authMiddleware());
    store.dispatch(accountMiddleware());
    store.dispatch(getUserIsApproveAction());
    store.dispatch(homeMiddleware());
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Sanket: Removed legacy swipe cards mapping methods

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, HomeViewModel>(
      converter: (store) => HomeViewModel.fromStore(store),
      builder:
          (_, HomeViewModel vm) => Scaffold(
            backgroundColor: MyTheme.background,
            appBar: buildAppBar(context),
            drawer: MainDrawer(),
            body: SafeArea(
              bottom: false,
              child:
                  vm.isAccountDataLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: MyTheme.primary,
                        ),
                      )
                      : vm.accountError != null && vm.accountError!.isNotEmpty
                      ? Center(
                        child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 24),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Icon(Icons.mark_email_unread, size: 48, color: MyTheme.failure),
                               const SizedBox(height: 16),
                               Text(
                                 vm.accountError!.contains('un_verified') 
                                     ? "Your email address is not verified.\nPlease verify your email to access the dashboard."
                                     : vm.accountError!,
                                 style: Styles.body.copyWith(color: MyTheme.failure, fontSize: 16),
                                 textAlign: TextAlign.center,
                               ),
                             ],
                           ),
                        ),
                      )
                      : vm.isDeactivated
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: const DeactivatedAccountMessage(),
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: () async {
                          store.dispatch(homeMiddleware());
                          store.dispatch(
                            getProfilePictureViewRequestMiddleware(),
                          );
                          store.dispatch(interestRequestMiddleware());
                          return Future.delayed(const Duration(seconds: 1));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGreetingSection(context, vm),
                              const SizedBox(height: 24),
                              _buildQuickActionHub(context),
                              const SizedBox(height: 32),
                              if (vm.activeMembers != null &&
                                  vm.activeMembers!.isNotEmpty)
                                _buildHorizontalRecommended(
                                  context,
                                  vm.activeMembers!,
                                ),
                              const SizedBox(height: 32),

                              _buildActivityInsights(context, vm),
                              const SizedBox(height: 32),
                              _buildPremiumCTA(),
                              const SizedBox(
                                height: 100,
                              ), // Bottom padding for navbar
                            ],
                          ),
                        ),
                      ),
            ),
          ),
    );
  }

  Widget _buildFilterChips() {
    final l = AppLocalizations.of(context)!;
    final filters = [
      l.home_filter_all,
      l.home_filter_new,
      l.home_filter_near_me,
      l.home_filter_verified,
      l.home_filter_online,
    ];
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          bool isFirst = index == 0;
          return ChoiceChip(
            selected: isFirst,
            onSelected: (val) {},
            backgroundColor: Colors.white,
            selectedColor: MyTheme.warm_rose,
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            label: Text(
              filters[index],
              style: TextStyle(
                color:
                    isFirst
                        ? Colors.white
                        : MyTheme.text_deep_maroon.withOpacity(0.8),
                fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Noto Sans Devanagari',
                fontSize: 13,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color:
                    isFirst
                        ? Colors.transparent
                        : MyTheme.warm_rose.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: MyTheme.white,
      toolbarHeight: 56,
      shape: Border(bottom: BorderSide(color: MyTheme.border, width: 1)),
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu, color: MyTheme.text_primary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      centerTitle: true,
      title: Image.asset(
        'assets/logo/app_logo.png',
        height: 36.0,
        color: MyTheme.primary,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: MyTheme.text_primary,
          ),
          onPressed: () => AIZRoute.push(context, const Notifications()),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildGreetingSection(BuildContext context, HomeViewModel vm) {
    String name =
        vm.profileData?.memberName?.split(" ")[0] ??
        store.state.authState?.userData?.name?.split(" ")[0] ??
        "वापरकर्ता";

    int hour = DateTime.now().hour;
    String greeting;
    if (hour >= 5 && hour < 12) {
      greeting = AppLocalizations.of(context)!.home_greeting_morning;
    } else if (hour >= 12 && hour < 17) {
      greeting = AppLocalizations.of(context)!.home_greeting_afternoon;
    } else {
      greeting = AppLocalizations.of(context)!.home_greeting_evening;
    }

    // Sanket: Use centralized granular real-time profile completeness
    int percent = ProfileCompletenessHelper.calculate(store.state);
    if (percent == 0) percent = 15; // Initial fallback for basic signup

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: Styles.body.copyWith(
                      color: MyTheme.text_secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "$name ✨",
                        style: Styles.h1.copyWith(
                          fontSize: 26,
                          color: MyTheme.text_primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () => NavigatorPush.push(context, const MyProfile()),
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MyTheme.primary.withOpacity(0.2),
                      width: 2,
                    ),
                    image:
                        vm.profileData?.memberPhoto != null
                            ? DecorationImage(
                              image: MyImage.imageProvider(
                                vm.profileData!.memberPhoto,
                              ),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      vm.profileData?.memberPhoto == null
                          ? Icon(Icons.person_outline, color: MyTheme.primary)
                          : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(
                0xFFFFF7F8,
              ), // Subtle premium pinkish background
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: MyTheme.primary.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.home_profile_completeness(percent.toString()),
                      style: Styles.body.copyWith(
                        color: MyTheme.text_primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$percent%",
                      style: Styles.h2.copyWith(
                        color: MyTheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 8,
                      width:
                          (DeviceInfo(context).width! - 88) * (percent / 100),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            MyTheme.primary,
                            MyTheme.primary.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: MyTheme.primary.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (percent < 100) ...[
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => NavigatorPush.push(context, const MyProfile()),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.home_increase_matches_3x,
                            style: Styles.caption.copyWith(
                              color: MyTheme.text_secondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: MyTheme.primary,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sanket: Section 2 - Quick Action Hub (2026 premium redesign)
  Widget _buildQuickActionHub(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.search_rounded,
        label: AppLocalizations.of(context)!.home_action_search,
        sub: AppLocalizations.of(context)!.home_new_partner,
        gradient: const [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
        onTap: () => AIZRoute.push(context, AdvancedSearch()),
      ),
      _ActionItem(
        icon: Icons.favorite_rounded,
        label: AppLocalizations.of(context)!.home_action_liked,
        sub: AppLocalizations.of(context)!.home_received_likes,
        gradient: const [Color(0xFFE040FB), Color(0xFF7C4DFF)],
        onTap: () => AIZRoute.push(context, const InterestRequest()),
      ),
      _ActionItem(
        icon: Icons.remove_red_eye_rounded,
        label: AppLocalizations.of(context)!.home_action_viewed,
        sub: AppLocalizations.of(context)!.home_profiles_viewed,
        gradient: const [Color(0xFF00BCD4), Color(0xFF2979FF)],
        onTap: () => AIZRoute.push(context, const PictureProfileViewRqst()),
      ),
      _ActionItem(
        icon: Icons.star_rounded,
        label: AppLocalizations.of(context)!.home_action_shortlist,
        sub: AppLocalizations.of(context)!.home_selected,
        gradient: const [Color(0xFF43E97B), Color(0xFF38F9D7)],
        onTap: () => AIZRoute.push(context, const MyShortlist()),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFF7C4DFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.home_quick_actions,
                style: Styles.h2.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 112,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: actions.length,
            itemBuilder: (ctx, i) => _premiumActionCard(actions[i]),
          ),
        ),
      ],
    );
  }

  Widget _premiumActionCard(_ActionItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        width: 136,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: item.gradient.map((c) => c.withOpacity(0.12)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: item.gradient.first.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: item.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: item.gradient.last.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(item.icon, color: Colors.white, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: Styles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: MyTheme.text_primary,
                  ),
                ),
                Text(
                  item.sub,
                  style: Styles.caption.copyWith(
                    fontSize: 10,
                    color: MyTheme.text_secondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Sanket: Section 3 - Horizontal Recommended Matches (Preview Only)
  Widget _buildHorizontalRecommended(BuildContext context, List recommended) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.home_recommended_for_you,
                style: Styles.h2,
              ),
              InkWell(
                onTap: () => AIZRoute.push(context, Explore()),
                child: Text(
                  AppLocalizations.of(context)!.home_see_all,
                  style: Styles.caption.copyWith(
                    color: MyTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: recommended.length > 5 ? 5 : recommended.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              var member = recommended[index];
              return InkWell(
                onTap: () {
                  AIZRoute.push(
                    context,
                    UserPublicProfile(userId: member.userId),
                    middleware: ProfileViewMiddleware(
                      context: context,
                      user: store.state.authState?.userData,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: MyTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MyTheme.border),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image(
                          image: MyImage.imageProvider(member.photo),
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              member.name ?? '',
                              style: Styles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${member.age} ${AppLocalizations.of(context)!.pub_profile_age_years}",
                              style: Styles.body.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Sanket: Section 4 - Activity Insights
  Widget _buildActivityInsights(BuildContext context, HomeViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.home_recent_activity,
            style: Styles.h2,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MyTheme.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MyTheme.border),
            ),
            child: Column(
              children: [
                _insightRow(
                  icon: Icons.visibility_outlined,
                  highlight:
                      "${vm.profileViewCount} ${AppLocalizations.of(context)!.home_people}",
                  description:
                      AppLocalizations.of(context)!.home_viewed_your_profile,
                  onTap:
                      () => AIZRoute.push(
                        context,
                        const PictureProfileViewRqst(),
                      ),
                ),
                const Divider(height: 24),
                _insightRow(
                  icon: Icons.favorite_border,
                  highlight: "${vm.likesReceivedCount} नवीन",
                  description:
                      AppLocalizations.of(context)!.home_new_like_received,
                  onTap: () => AIZRoute.push(context, const InterestRequest()),
                ),
                const Divider(height: 24),
                _insightRow(
                  icon: Icons.person_add_alt,
                  highlight: "${vm.newMatchesCount} नवीन",
                  description:
                      AppLocalizations.of(context)!.home_new_profiles_available,
                  onTap: () => AIZRoute.push(context, const NewMatchesPage()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightRow({
    required IconData icon,
    required String highlight,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyTheme.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: MyTheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            highlight,
            style: Styles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.body.copyWith(color: MyTheme.text_secondary),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: MyTheme.text_secondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  // Sanket: Section 6 - Premium CTA Banner
  Widget _buildPremiumCTA() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF9A826), Color(0xFFFF7B00)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF7B00).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.home_upgrade_to_platinum,
                    style: Styles.h2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.home_prioritize_profile,
                    style: Styles.caption.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartMatches(
    BuildContext context,
    List smartMatches,
    HomeViewModel vm,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text("Matches for You", style: Styles.h2),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75, // Matches aspect ratio
          ),
          itemCount: smartMatches.length,
          itemBuilder: (context, index) {
            return _buildSmallMatchCard(smartMatches[index]);
          },
        ),
      ],
    );
  }

  Widget _buildProfileBoost(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(Styles.br_card),
          border: Border.all(color: MyTheme.primary.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: MyTheme.primary.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.home_complete_profile_now,
              style: Styles.h2.copyWith(color: MyTheme.primary),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.home_increase_matches_3x,
              style: Styles.caption,
            ),
            const SizedBox(height: 16),
            _buildBoostBtn(
              AppLocalizations.of(context)!.home_add_education,
              () =>
                  NavigatorPush.push(context, const MyProfile(initialStep: 1)),
            ),
            const SizedBox(height: 8),
            _buildBoostBtn(
              AppLocalizations.of(context)!.home_add_photos,
              () =>
                  NavigatorPush.push(context, const MyProfile(initialStep: 2)),
            ),
            const SizedBox(height: 8),
            _buildBoostBtn(
              AppLocalizations.of(context)!.home_add_partner_prefs,
              () =>
                  NavigatorPush.push(context, const MyProfile(initialStep: 3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoostBtn(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: MyTheme.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Styles.bold_arsenic_12),
            const Icon(Icons.add_circle, color: MyTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Icon(Icons.person_search_rounded, size: 64, color: MyTheme.border),
          const SizedBox(height: 16),
          Text(
            "No matches yet.",
            style: Styles.h2.copyWith(color: MyTheme.text_secondary),
          ),
          Text(
            "Complete your preferences to find the perfect match.",
            style: Styles.body.copyWith(color: MyTheme.text_secondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMatchCard(
    dynamic member,
    BuildContext context,
    HomeViewModel vm,
  ) {
    return Container(
      width: double.infinity,
      height: 420,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(Styles.br_card),
        boxShadow: [
          BoxShadow(
            color: MyTheme.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Styles.br_card),
              child: Image(
                image: MyImage.imageProvider(member.photo),
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Container(color: MyTheme.border),
              ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Styles.br_card),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.5, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      // Sanket: prevent overflow when name+age text is wide
                      child: Text(
                        "${member.name ?? ''}, ${member.age ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.profileName.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (member.membership != null && member.membership != 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(Styles.br_pill),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.home_premium_label,
                          style: Styles.caption.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  member.country ?? 'ठाणे',
                  style: Styles.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${member.religion ?? ''} • ${member.profession ?? ''}"
                      .trim()
                      .replaceAll(RegExp(r'^•|•$'), ''),
                  style: Styles.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.home_verified_profile,
                      style: Styles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Buttons
          Positioned(
            bottom: 20,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeroActionBtn(
                  Icons.close,
                  AppLocalizations.of(context)!.home_action_no,
                  () {},
                ),
                _buildHeroActionBtn(
                  Icons.star_border,
                  AppLocalizations.of(context)!.drawer_shortlist,
                  () => vm.addShortlist!(user: member.userId),
                ),
                _buildHeroActionBtn(
                  Icons.favorite_border,
                  AppLocalizations.of(context)!.home_action_liked,
                  () => vm.expressInterest(userId: member.userId),
                  isPrimary: true,
                ),
                _buildHeroActionBtn(
                  Icons.visibility_outlined,
                  AppLocalizations.of(context)!.home_action_view,
                  () {
                    AIZRoute.push(
                      context,
                      UserPublicProfile(userId: member.userId),
                      middleware: ProfileViewMiddleware(
                        context: context,
                        user: store.state.authState?.userData,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sanket: Changed to column layout (icon + label) with fixed width to eliminate Row overflow on narrow screens
  Widget _buildHeroActionBtn(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Styles.br_pill),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(Styles.br_pill),
          boxShadow: [
            BoxShadow(
              color: MyTheme.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary ? MyTheme.primary : MyTheme.text_secondary,
              size: 18,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Styles.caption.copyWith(
                color: isPrimary ? MyTheme.primary : MyTheme.text_primary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalMatches(BuildContext context, HomeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.home_matches_for_you,
                style: Styles.h2,
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.home_handpicked_interests,
                style: Styles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: vm.activeMembers?.length ?? 0,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              var member = vm.activeMembers![index];
              return _buildSmallMatchCard(member);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSmallMatchCard(dynamic member) {
    return Container(
      width: 160,
      height: 220,
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(Styles.br_card),
        boxShadow: [
          BoxShadow(
            color: MyTheme.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Styles.br_card),
              child: Image(
                image: MyImage.imageProvider(member.photo),
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Container(color: MyTheme.border),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Styles.br_card),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name ?? '',
                  style: Styles.profileName.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  "${member.age ?? ''} वर्षे",
                  style: Styles.caption.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }

  void _showFullProfileSheet(
    BuildContext context,
    dynamic member,
    HomeViewModel vm,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height:
              MediaQuery.of(context).size.height *
              0.90, // Takes up 90% of screen height
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Small handle for visual affordance
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: UserPublicProfile(userId: member.userId),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget exit_alert_dialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.exit,
        style: Styles.bold_arsenic_14,
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () {
            if (kIsWeb) {
              Navigator.pop(context, false);
            } else {
              Platform.isAndroid ? SystemNavigator.pop() : exit(0);
            }
          },
          child: Text('Yes', style: Styles.body),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('No', style: Styles.body),
        ),
      ],
    );
  }
}

class HomeViewModel {
  final bool? isFullProfileView;
  final List? activeMembers;
  final List? activeNowList;
  final bool? isFetch;
  final String? packageExpire;
  final bool? myInterestStateLoading;
  final bool? shortlistStateLoading;
  final String? myMembershipType;
  final bool isDeactivated;
  final bool isAccountDataLoading;
  final String? accountError;
  final PageController? controller;
  final TextEditingController? reportController;
  final void Function({dynamic user, dynamic reason})? userReport;
  final void Function({dynamic user})? addShortlist;
  final void Function({required int userId}) expressInterest;
  final void Function({dynamic user})? ignoreUser;
  final void Function()? goToNext;
  final void Function()? goToPrev;

  final int profileViewCount;
  final int likesReceivedCount;
  final int newMatchesCount;

  final ManageProfileCombineState? profileState;
  final ProfileData? profileData;

  HomeViewModel({
    this.packageExpire,
    this.isFetch,
    this.activeMembers,
    this.activeNowList,
    this.isFullProfileView,
    this.myInterestStateLoading,
    this.shortlistStateLoading,
    this.userReport,
    this.addShortlist,
    required this.expressInterest,
    this.ignoreUser,
    this.myMembershipType,
    required this.isDeactivated,
    required this.isAccountDataLoading,
    this.accountError,
    this.controller,
    this.reportController,
    this.goToNext,
    this.goToPrev,
    required this.profileViewCount,
    required this.likesReceivedCount,
    required this.newMatchesCount,
    this.profileState,
    this.profileData,
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    String? error = store.state.accountState?.error;
    bool isLoading = store.state.accountState?.profileData == null && (error == null || error.isEmpty);

    return HomeViewModel(
      profileData: store.state.accountState?.profileData,
      profileState: store.state.manageProfileCombineState,
      isAccountDataLoading: isLoading,
      accountError: error,
      isDeactivated: store.state.authState?.userData?.deactivated == 1,
      isFullProfileView: settingIsActive(
        "full_profile_show_according_to_membership",
        "1",
      ),
      activeMembers: store.state.homeState!.homeDataList,
      activeNowList:
          store
              .state
              .homeState!
              .homeDataList, // TODO: Assuming standard list for now, will refine if there's a specific 'activeNow' list in state later.
      isFetch: store.state.homeState!.isFetching,
      packageExpire:
          store
              .state
              .accountState!
              .profileData
              ?.currentPackageInfo
              ?.packageExpiry,
      myInterestStateLoading: store.state.myInterestState?.isLoading,
      shortlistStateLoading: store.state.shortlistState?.isLoading,
      profileViewCount:
          store.state.pictureProfileViewState?.pictureProfileList?.length ?? 0,
      likesReceivedCount:
          store.state.interestRequestState?.interestRequestList?.length ?? 0,
      newMatchesCount: store.state.homeState?.newMatches?.length ?? 0,
      myMembershipType: store.state.packageDetailsState?.data?.name,
      controller: store.state.homeState?.controller,
      reportController: store.state.homeState?.reportController,
      userReport:
          ({dynamic user, dynamic reason}) =>
              store.dispatch(reportMiddleware(userId: user, reason: reason)),
      addShortlist:
          ({dynamic user}) =>
              store.dispatch(addShortlistMiddleware(userId: user)),
      expressInterest:
          ({required int userId}) =>
              store.dispatch(expressInterestMiddleware(userId: userId)),
      ignoreUser:
          ({dynamic user}) =>
              store.dispatch(AddToIgnoreListFromHome(user: user)),
      goToNext: () => store.dispatch(GoNextPage()),
      goToPrev: () => store.dispatch(GoPrevPage()),
    );
  }
}

// Sanket: Data class for premium quick action tiles
class _ActionItem {
  final IconData icon;
  final String label;
  final String sub;
  final List<Color> gradient;
  final VoidCallback onTap;
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.sub,
    required this.gradient,
    required this.onTap,
  });
}
