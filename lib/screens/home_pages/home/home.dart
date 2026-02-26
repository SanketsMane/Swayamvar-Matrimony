import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import 'dart:io';
import 'dart:ui';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/const/const.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/auth/auth_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/components/main_drawer.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import '../../../components/common_widget.dart';
import '../../../components/container_with_icon.dart';
import '../../../components/custom_popup.dart';
import '../../../components/deactivate_Massage.dart';
import '../../../components/my_circular_indicator.dart';
import '../../../components/my_images.dart';
import '../../../helpers/aiz_route.dart';
import '../../../helpers/main_helpers.dart';
import '../../../helpers/shared_pref.dart';
import '../../../l10n/app_localizations.dart';
import '../../../redux/libs/report/report_middleware.dart';
import '../../../redux/libs/auth/signout_middleware.dart';
import '../../account/account_middleware.dart';
import '../../auth/verify/verify_action.dart';
import '../../manage_profiles/manage_profile.dart';
import '../../my_dashboard_pages/interest/my_interest.dart';
import '../../my_dashboard_pages/shortlist/my_shortlist.dart';
import '../../package/premium_plans.dart';
import '../../settings/settings.dart';
import '../../support_ticket/support_ticket.dart';
import '../../my_dashboard_pages/interest/express_interest_middleware.dart';
import '../../my_dashboard_pages/shortlist/add_shortlist_middleware.dart';
import '../../notifications/notifications.dart';
import '../../search_screens/search.dart';
import '../../search_screens/advanced_search.dart';
import 'home_action.dart';
import 'home_middleware.dart';
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _showFilters = false;

  onRefresh() {
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


  Widget _buildRecentlyActive(BuildContext context, List recentProfiles, HomeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text("Recently Active", style: Styles.h2),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: recentProfiles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              var member = recentProfiles[index];
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
                borderRadius: BorderRadius.circular(Styles.br_card),
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Styles.br_card),
                        boxShadow: [
                          BoxShadow(color: MyTheme.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                        image: DecorationImage(
                          image: MyImage.imageProvider(member.photo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: MyTheme.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: MyTheme.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActiveNow(BuildContext context, List activeProfiles, HomeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text("Active Now", style: Styles.h2),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110, // Adjust height slightly to accommodate the text below avatar
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: activeProfiles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              var member = activeProfiles[index];
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
                borderRadius: BorderRadius.circular(Styles.br_card),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: MyTheme.border, width: 2), // Gives a subtle ring effect
                            image: DecorationImage(
                              image: MyImage.imageProvider(member.photo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1CB14D), // Green dot color matching reference
                              shape: BoxShape.circle,
                              border: Border.all(color: MyTheme.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Hardcoded active time for demonstration, matching design "Active 1m ago"
                    // Ideally, this should come from member.lastActive TimeAgo logic
                    Text(
                      index % 2 == 0 ? "Active 1m ago" : "Active 6m ago", 
                      style: TextStyle(
                        fontFamily: 'Mukta', // Using same family as app
                        fontSize: 10,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVerifiedProfiles(BuildContext context, List verifiedProfiles, HomeViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text("Verified Profiles", style: Styles.h2),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: verifiedProfiles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              var member = verifiedProfiles[index];
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
                borderRadius: BorderRadius.circular(Styles.br_card),
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Styles.br_card),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Styles.br_card),
                        child: Image(
                          image: MyImage.imageProvider(member.photo),
                          width: 140,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: MyTheme.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified, color: MyTheme.primary, size: 16),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(Styles.br_card),
                              bottomRight: Radius.circular(Styles.br_card),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                            ),
                          ),
                          child: Text(
                            member.name ?? '',
                            style: Styles.caption.copyWith(color: MyTheme.white, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      converter: (store) => HomeViewModel.fromStore(store),
      builder: (_, HomeViewModel vm) => Scaffold(
          backgroundColor: MyTheme.background,
          appBar: buildAppBar(context),
          drawer: MainDrawer(),
          body: SafeArea(
            bottom: false,
            child: vm.isAccountDataLoading
                ? const Center(child: CircularProgressIndicator(color: MyTheme.primary))
                : vm.isDeactivated
                    ? Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: const DeactivatedAccountMessage()))
                    : RefreshIndicator(
                        onRefresh: () {
                          onRefresh();
                          return Future.delayed(const Duration(seconds: 1));
                        },
                        child: Builder(
                          builder: (context) {
                            var members = vm.activeMembers ?? [];
                            var activeNowProfiles = vm.activeNowList ?? [];

                            return NestedScrollView(
                              headerSliverBuilder: (context, innerBoxIsScrolled) {
                                return [
                                  SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildGreetingSection(context, vm),
                                        if (activeNowProfiles.isNotEmpty) ...[
                                          const SizedBox(height: 16),
                                          _buildActiveNow(context, activeNowProfiles, vm),
                                          const SizedBox(height: 16),
                                        ],
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              body: members.isEmpty
                                  ? _buildEmptyState(context)
                                  : PageView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: members.length,
                                      itemBuilder: (context, index) {
                                        return _buildReelMatchCard(context, members[index], vm);
                                      },
                                    ),
                            );
                          }
                        ),
                      ),
          ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ["सर्व", "नवीन", "माझ्या जवळ", "पडताळणी केलेले", "ऑनलाइन"];
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
                color: isFirst ? Colors.white : MyTheme.text_deep_maroon.withOpacity(0.8),
                fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Noto Sans Devanagari',
                fontSize: 13,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: isFirst ? Colors.transparent : MyTheme.warm_rose.withOpacity(0.3)),
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
      leading: IconButton(
        icon: const Icon(Icons.tune_rounded, color: MyTheme.text_primary),
        onPressed: () => AIZRoute.push(context, AdvancedSearch()),
      ),
      centerTitle: true,
      title: Text("Matches", style: Styles.bold_arsenic_16.copyWith(color: MyTheme.text_primary, fontSize: 18, letterSpacing: -0.3)),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: MyTheme.text_primary),
          onPressed: () => NavigatorPush.push(context, const Notifications()),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
  Widget _buildGreetingSection(BuildContext context, HomeViewModel vm) {
    String name = store.state.accountState?.profileData?.memberName?.split(" ")[0] ?? 
                  store.state.authState?.userData?.name?.split(" ")[0] ?? "User";
    int hour = DateTime.now().hour;
    String greeting = "Good Morning";
    if (hour >= 12 && hour < 17) greeting = "Good Afternoon";
    if (hour >= 17) greeting = "Good Evening";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  "$greeting\n$name ✨",
                  style: Styles.h1.copyWith(fontSize: 24, height: 1.2),
                ),
              ),
              OutlinedButton(
                onPressed: () => NavigatorPush.push(context, const MyProfile()),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: MyTheme.primary.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Complete Profile",
                  style: Styles.bold_arsenic_12.copyWith(color: MyTheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Profile 85% Complete",
                style: Styles.body.copyWith(color: MyTheme.text_secondary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.85,
              minHeight: 8,
              backgroundColor: MyTheme.border,
              valueColor: const AlwaysStoppedAnimation<Color>(MyTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyRecommended(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyTheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(Styles.br_card),
          border: Border.all(color: MyTheme.primary.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Why this profile is recommended", style: Styles.bold_arsenic_14.copyWith(color: MyTheme.text_primary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildReasonChip("✔ Same Religion"),
                _buildReasonChip("✔ Same City"),
                _buildReasonChip("✔ Similar Education"),
              ],
            ),
            const SizedBox(height: 8),
            Text("This profile strongly matches your partner preferences.", style: Styles.regular_gull_grey_12),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(Styles.br_pill),
        border: Border.all(color: MyTheme.border),
      ),
      child: Text(label, style: Styles.bold_arsenic_12.copyWith(color: MyTheme.text_secondary, fontSize: 11)),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Activities", style: Styles.h2),
          const SizedBox(height: 16),
          _buildActivityCard(Icons.visibility_outlined, "3 people", "viewed your profile today", () {}),
          const SizedBox(height: 8),
          _buildActivityCard(Icons.favorite_border, "1 new", "interest received", () {}),
          const SizedBox(height: 8),
          _buildActivityCard(Icons.person_add_alt, "5 new", "matches found", () {}),
        ],
      ),
    );
  }

  Widget _buildActivityCard(IconData icon, String highlight, String description, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyTheme.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: MyTheme.background, shape: BoxShape.circle),
              child: Icon(icon, color: MyTheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "$highlight ", style: Styles.bold_arsenic_14.copyWith(color: MyTheme.text_primary)),
                    TextSpan(text: description, style: Styles.regular_gull_grey_12.copyWith(color: MyTheme.text_secondary)),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: MyTheme.text_secondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartMatches(BuildContext context, List smartMatches, HomeViewModel vm) {
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
            BoxShadow(color: MyTheme.primary.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Complete Your Profile", style: Styles.h2.copyWith(color: MyTheme.primary)),
            const SizedBox(height: 4),
            Text("Get 3x more matches by adding your details.", style: Styles.regular_gull_grey_12),
            const SizedBox(height: 16),
            _buildBoostBtn("Add Education Details"),
            const SizedBox(height: 8),
            _buildBoostBtn("Add Photos"),
            const SizedBox(height: 8),
            _buildBoostBtn("Add Partner Preferences"),
          ],
        ),
      ),
    );
  }

  Widget _buildBoostBtn(String title) {
    return InkWell(
      onTap: () => NavigatorPush.push(context, const MyProfile()),
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
          Text("No matches yet.", style: Styles.h2.copyWith(color: MyTheme.text_secondary)),
          Text("Complete your preferences to find the perfect match.", style: Styles.body.copyWith(color: MyTheme.text_secondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHeroMatchCard(dynamic member, BuildContext context, HomeViewModel vm) {

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
          )
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
                errorBuilder: (context, error, stackTrace) => Container(color: MyTheme.border),
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
                    Flexible( // Sanket: prevent overflow when name+age text is wide
                      child: Text(
                        "${member.name ?? ''} | ${member.age ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.h1.copyWith(color: MyTheme.white, fontSize: 22),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (member.membership != null && member.membership != 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: MyTheme.primary,
                          borderRadius: BorderRadius.circular(Styles.br_pill),
                        ),
                        child: const Text(
                          "Premium",
                          style: TextStyle(color: MyTheme.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  member.country ?? 'Thane',
                  style: Styles.body.copyWith(color: MyTheme.white.withOpacity(0.9)),
                ),
                const SizedBox(height: 4),
                Text(
                  "${member.religion ?? ''} • ${member.profession ?? ''}".trim().replaceAll(RegExp(r'^•|•$'), ''),
                  style: Styles.body.copyWith(color: MyTheme.white.withOpacity(0.9), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.verified, color: MyTheme.success, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "Serious about marriage",
                      style: Styles.caption.copyWith(color: MyTheme.white, fontWeight: FontWeight.bold),
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
                _buildHeroActionBtn(Icons.close, "Pass", () {}),
                _buildHeroActionBtn(Icons.star_border, "Shortlist", () => vm.addShortlist!(user: member.userId)),
                _buildHeroActionBtn(Icons.favorite_border, "Interest", () => vm.expressInterest(userId: member.userId), isPrimary: true),
                _buildHeroActionBtn(Icons.visibility_outlined, "View", () {
                  AIZRoute.push(
                    context,
                    UserPublicProfile(userId: member.userId),
                    middleware: ProfileViewMiddleware(
                      context: context,
                      user: store.state.authState?.userData,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sanket: Changed to column layout (icon + label) with fixed width to eliminate Row overflow on narrow screens
  Widget _buildHeroActionBtn(IconData icon, String label, VoidCallback onTap, {bool isPrimary = false}) {
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
            Icon(icon, color: isPrimary ? MyTheme.primary : MyTheme.text_secondary, size: 18),
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
                "तुमच्यासाठी निवडलेले जुळणारे प्रोफाइल",
                style: Styles.h2,
              ),
              const SizedBox(height: 4),
              Text(
                "Handpicked based on your interests",
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
                errorBuilder: (context, error, stackTrace) => Container(color: MyTheme.border),
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
                  style: Styles.caption.copyWith(color: MyTheme.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReelMatchCard(BuildContext context, dynamic member, HomeViewModel vm) {
    return Container(
      color: Colors.black, // Dark background behind image
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image(
            image: MyImage.imageProvider(member.photo),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: MyTheme.border),
          ),
          // Gradient Overlay to ensure text readability
          Container(
            decoration: BoxDecoration(
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
          // Info Block (Bottom Left)
          Positioned(
            bottom: 32,
            left: 16,
            right: 80, // Leave space for the action buttons
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "${member.name ?? ''}, ${member.age ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.h1.copyWith(color: MyTheme.white, fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (member.membership != null && member.membership != 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: MyTheme.primary,
                          borderRadius: BorderRadius.circular(Styles.br_pill),
                        ),
                        child: const Text(
                          "Premium",
                          style: TextStyle(color: MyTheme.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: MyTheme.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      member.country ?? 'India',
                      style: Styles.body.copyWith(color: MyTheme.white.withOpacity(0.9)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.work, color: MyTheme.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      member.profession ?? 'Professional',
                      style: Styles.body.copyWith(color: MyTheme.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Buttons (Bottom Right)
          Positioned(
            bottom: 32,
            right: 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionBtn(
                  icon: Icons.close,
                  color: Colors.white.withOpacity(0.2),
                  iconColor: Colors.white,
                  onTap: () {
                    // Assuming ignoreUser removes from the local list
                    if (vm.ignoreUser != null) {
                      vm.ignoreUser!(user: member);
                    }
                  },
                ),
                const SizedBox(height: 20),
                _buildActionBtn(
                  icon: Icons.favorite,
                  color: MyTheme.primary,
                  iconColor: Colors.white,
                  onTap: () {
                    vm.expressInterest(userId: member.userId);
                  },
                ),
                const SizedBox(height: 20),
                _buildActionBtn(
                  icon: Icons.person,
                  color: Colors.white.withOpacity(0.2),
                  iconColor: Colors.white,
                  onTap: () {
                    _showFullProfileSheet(context, member, vm);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn({required IconData icon, required Color color, required Color iconColor, required VoidCallback onTap}) {
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

  void _showFullProfileSheet(BuildContext context, dynamic member, HomeViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.90, // Takes up 90% of screen height
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
            Platform.isAndroid ? SystemNavigator.pop() : exit(0);
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
  final PageController? controller;
  final TextEditingController? reportController;
  final void Function({dynamic user, dynamic reason})? userReport;
  final void Function({dynamic user})? addShortlist;
  final void Function({required int userId}) expressInterest;
  final void Function({dynamic user})? ignoreUser;
  final void Function()? goToNext;
  final void Function()? goToPrev;

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
    this.controller,
    this.reportController,
    this.goToNext,
    this.goToPrev,
  });

  static fromStore(Store<AppState> store) {
    bool isLoading = store.state.accountState?.profileData == null;

    return HomeViewModel(
      isAccountDataLoading: isLoading,
      isDeactivated: store.state.authState?.userData?.deactivated == 1,
      isFullProfileView: settingIsActive(
        "full_profile_show_according_to_membership",
        "1",
      ),
      activeMembers: store.state.homeState!.homeDataList,
      activeNowList: store.state.homeState!.homeDataList, // TODO: Assuming standard list for now, will refine if there's a specific 'activeNow' list in state later.
      isFetch: store.state.homeState!.isFetching,
      packageExpire:
      store.state.accountState!.profileData?.currentPackageInfo?.packageExpiry,
      myInterestStateLoading: store.state.myInterestState?.isLoading,
      shortlistStateLoading: store.state.shortlistState?.isLoading,
      myMembershipType: store.state.packageDetailsState?.data?.name,
      controller: store.state.homeState?.controller,
      reportController: store.state.homeState?.reportController,
      userReport: ({dynamic user, dynamic reason}) =>
          store.dispatch(reportMiddleware(userId: user, reason: reason)),
      addShortlist: ({dynamic user}) =>
          store.dispatch(addShortlistMiddleware(userId: user)),
      expressInterest: ({required int userId}) =>
          store.dispatch(expressInterestMiddleware(userId: userId)),
      ignoreUser: ({dynamic user}) =>
          store.dispatch(AddToIgnoreListFromHome(user: user)),
      goToNext: () => store.dispatch(GoNextPage()),
      goToPrev: () => store.dispatch(GoPrevPage()),
    );
  }
}