// Sanket: Matches screen — fully redesigned 2026 premium matrimony layout
import 'dart:math';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';

import '../../../components/my_images.dart';
import '../../../helpers/aiz_route.dart';
import '../../user_pages/user_public_profile.dart';
import '../../search_screens/advanced_search.dart';
import '../../search_screens/search_action.dart';
import '../../search_screens/search_middleware.dart';
import '../../search_screens/search_middleware.dart';
import '../../notifications/notifications.dart';
import 'explore_middleware.dart';

import '../../../components/main_drawer.dart';
import '../../my_dashboard_pages/shortlist/add_shortlist_middleware.dart';
import '../../my_dashboard_pages/interest/express_interest_middleware.dart';
import '../home/home_action.dart';
import '../../account/account_middleware.dart';
import '../../auth/signin/phone_login.dart';
import '../../../middleware/profile_view_middleware.dart';
import '../../manage_profiles/manage_profile.dart'; // For MyProfile import if needed, but it's used in home.dart

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final TextEditingController _searchController = TextEditingController();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {}); // Force rebuild to update header position
    });
  }

  // Mock configs
  final List<String> _mockNames = [
    'Akash Patil',
    'Rohit Kulkarni',
    'Snehal Jadhav',
    'Pooja More',
    'Rahul Desai',
    'Neha Sharma',
    'Vikram Singh',
    'Priya Gupta',
    'Karan Mehta',
    'Anjali Rao',
  ];
  final List<String> _mockCities = [
    'Pune',
    'Mumbai',
    'Nagpur',
    'Kolhapur',
    'Nashik',
  ];
  final List<String> _mockReasons = [
    '✔ Same Religion\n✔ Same City\n✔ Similar Education',
    '✔ Same Caste\n✔ Highly Compatible Profession',
    '✔ Same Religion\n✔ Matches Partner Preferences',
  ];
  final List<int> _mockMatchScores = [96, 92, 88, 75, 82, 65, 90, 85];

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _getName(MemberData m, int index) {
    if (m.name == null ||
        m.name!.trim().isEmpty ||
        m.name!.toLowerCase() == 'dummy' ||
        m.name!.toLowerCase() == 'test') {
      return _mockNames[index % _mockNames.length];
    }
    return m.name!;
  }

  String _getCity(MemberData m, int index) {
    if (m.country == null ||
        m.country!.trim().isEmpty ||
        m.country!.toLowerCase().contains('dummy')) {
      return _mockCities[index % _mockCities.length];
    }
    return m.country!;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ExploreViewModel>(
      converter: (store) => ExploreViewModel.fromStore(store),
      onInit:
          (store) => [
            store.dispatch(fetchPremiumMembersAction()),
            store.dispatch(fetchNewMembersAction()),
            if (store.state.basicSearchState?.searchText != null)
              _searchController.text =
                  store.state.basicSearchState!.searchText!,
          ],
      builder: (_, vm) {
        // Ensure data is loaded
        if (vm.premiumMembersList == null || vm.newMemberList == null) {
          return Scaffold(
            backgroundColor: MyTheme.background,
            body: Column(
              children: [
                _buildHeader(context, vm),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: MyTheme.primary),
                  ),
                ),
              ],
            ),
          );
        }

        List<MemberData> rawMembers = [];
        rawMembers.addAll(vm.premiumMembersList!);
        rawMembers.addAll(vm.newMemberList!);

        final seen = <int>{};
        List<MemberData> uniqueMembers =
            rawMembers.where((m) {
              if (m.userId == null) return false;
              return seen.add(m.userId!);
            }).toList();

        List<MemberData> activeNowMatches = [];

        if (uniqueMembers.length >= 8) {
          activeNowMatches = uniqueMembers.take(8).toList();
        } else {
          activeNowMatches = uniqueMembers;
        }

        bool isSearching =
            vm.isFilterActive || _searchController.text.isNotEmpty;
        final searchResults = vm.searchList ?? [];

        double headerOffset = 0.0;
        if (_pageController.hasClients) {
          // Increased offset to 300.0 to ensure App Bar + Active Now are fully hidden
          headerOffset = -(_pageController.offset).clamp(0.0, 300.0);
        }

        return WillPopScope(
          onWillPop: () async {
            final shouldPop =
                (await OneContext().showDialog<bool>(
                  builder: (BuildContext context) => exit_alert_dialog(context),
                ))!;
            return shouldPop;
          },
          child: Scaffold(
            backgroundColor: Colors.black, // Dark background for Reels
            drawer: const MainDrawer(),
            body: RefreshIndicator(
              color: MyTheme.primary,
              onRefresh: () async {
                StoreProvider.of<AppState>(
                  context,
                ).dispatch(fetchPremiumMembersAction());
                StoreProvider.of<AppState>(
                  context,
                ).dispatch(fetchNewMembersAction());
              },
              child: Stack(
                children: [
                  // Layer 1: The Reels (PageView)
                  if (uniqueMembers.isEmpty)
                    _buildEmptyState(context)
                  else
                    PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      itemCount: uniqueMembers.length,
                      itemBuilder: (context, index) {
                        return _buildReelMatchCard(
                          context,
                          uniqueMembers[index],
                          vm,
                        );
                      },
                    ),

                  // Layer 2: The Sliding Header (App Bar + Active Now)
                  if (!isSearching)
                    Positioned(
                      top: headerOffset,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: MyTheme.white, // Opaque background
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeader(context, vm),
                            if (activeNowMatches.isNotEmpty)
                              _buildActiveNow(context, activeNowMatches),
                          ],
                        ),
                      ),
                    ),

                  // Layer 3: Search Results Overlay (If searching)
                  if (isSearching)
                    Positioned.fill(
                      child: Container(
                        color: MyTheme.background,
                        child: Column(
                          children: [
                            _buildHeader(context, vm),
                            Expanded(
                              child: SingleChildScrollView(
                                child: _buildFilteredGrid(
                                  context,
                                  searchResults,
                                  vm,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 48),
          Icon(Icons.people_alt_outlined, size: 64, color: MyTheme.border),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.explore_no_matches,
            style: Styles.h2.copyWith(color: MyTheme.text_primary),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.explore_adjust_prefs,
            style: Styles.body.copyWith(color: MyTheme.text_secondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => AIZRoute.push(context, AdvancedSearch()),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Styles.br_btn),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              AppLocalizations.of(context)!.explore_edit_prefs,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ExploreViewModel vm) {
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
            _headerIconBtn(
              Icons.tune_rounded,
              onTap: () => AIZRoute.push(context, AdvancedSearch()),
            ),
            const Spacer(),
            Text(
              AppLocalizations.of(context)!.explore_page_title,
              style: Styles.bold_arsenic_16.copyWith(
                color: MyTheme.text_primary,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            _headerIconBtn(
              Icons.notifications_none_rounded,
              onTap: () => AIZRoute.push(context, const Notifications()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerIconBtn(
    IconData icon, {
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? MyTheme.primary : MyTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? MyTheme.primary : MyTheme.border,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? MyTheme.white : MyTheme.text_primary,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCompBadge(int match) {
    Color bColor;
    if (match >= 85)
      bColor = MyTheme.success;
    else if (match >= 60)
      bColor = Colors.orange;
    else
      bColor = MyTheme.text_secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$match% ${match >= 85
            ? AppLocalizations.of(context)!.explore_match_high
            : match >= 60
            ? AppLocalizations.of(context)!.explore_match_medium
            : AppLocalizations.of(context)!.explore_match_low}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTopMatches(List<MemberData> matches, ExploreViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.explore_top_matches,
            style: Styles.bold_arsenic_16.copyWith(
              fontSize: 18,
              color: MyTheme.text_primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: min(matches.length, 3),
          itemBuilder:
              (ctx, idx) => _buildTopMatchCard(context, matches[idx], idx, vm),
        ),
      ],
    );
  }

  Widget _buildTopMatchCard(
    BuildContext context,
    MemberData m,
    int idx,
    ExploreViewModel vm,
  ) {
    int score = _mockMatchScores[idx % _mockMatchScores.length];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyTheme.border),
        boxShadow: [
          BoxShadow(
            color: MyTheme.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MyImages.normalImage(m.photo, alignment: Alignment.topCenter),
                  Positioned(top: 12, left: 12, child: _buildCompBadge(score)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_getName(m, idx)}, ${m.age ?? '25'}",
                  style: Styles.bold_arsenic_16.copyWith(
                    fontSize: 20,
                    color: MyTheme.text_primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCity(m, idx),
                  style: Styles.regular_gull_grey_12.copyWith(
                    color: MyTheme.text_secondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoChips(m),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MyTheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _mockReasons[idx % _mockReasons.length],
                    style: Styles.bold_arsenic_12.copyWith(
                      color: MyTheme.text_primary,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _actionBtn(
                        AppLocalizations.of(context)!.explore_interest,
                        Icons.favorite,
                        MyTheme.primary,
                        () => vm.expressInterest(userId: m.userId!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _actionBtn(
                        AppLocalizations.of(context)!.explore_shortlist,
                        Icons.star_border,
                        MyTheme.text_secondary,
                        () => vm.addShortlist(user: m.userId!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _actionBtn(
                        AppLocalizations.of(context)!.explore_view,
                        Icons.person_outline,
                        MyTheme.text_secondary,
                        () => AIZRoute.push(
                          context,
                          UserPublicProfile(userId: m.userId ?? 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color == MyTheme.primary ? color : MyTheme.border,
          ),
          color:
              color == MyTheme.primary
                  ? MyTheme.primary.withOpacity(0.05)
                  : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: Styles.bold_arsenic_12.copyWith(
                color: color,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyMatches(List<MemberData> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.explore_nearby,
            style: Styles.bold_arsenic_16.copyWith(
              fontSize: 18,
              color: MyTheme.text_primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: matches.length,
            itemBuilder:
                (ctx, idx) => _buildNearbyCard(context, matches[idx], idx),
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyCard(BuildContext context, MemberData m, int idx) {
    return GestureDetector(
      onTap: () => AIZRoute.push(context, UserPublicProfile(userId: m.userId!)),
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MyTheme.border),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: MyImages.normalImage(
                  m.photo,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_getName(m, idx)}, ${m.age ?? '25'}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.bold_arsenic_12.copyWith(
                      color: MyTheme.text_primary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${idx * 2 + 1} km",
                    style: Styles.caption.copyWith(
                      color: MyTheme.text_secondary,
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

  Widget _buildActiveNow(BuildContext context, List<MemberData> matches) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4.0),
        title: Text(
          "🟢 ${AppLocalizations.of(context)!.explore_active_now} (${matches.length})",
          style: Styles.bold_arsenic_12.copyWith(
            fontSize: 14,
            color: MyTheme.text_primary,
            letterSpacing: 0.2,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 12),
        children: [
          SizedBox(
            height: 90,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: matches.length,
              itemBuilder: (ctx, idx) {
                final m = matches[idx];
                return GestureDetector(
                  onTap:
                      () => AIZRoute.push(
                        context,
                        UserPublicProfile(userId: m.userId ?? 0),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: MyTheme.primary.withOpacity(0.1),
                                  width: 1.5,
                                ),
                                image: DecorationImage(
                                  image: MyImage.imageProvider(m.photo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1CB14D),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: MyTheme.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${AppLocalizations.of(ctx)!.explore_active_ago} ${idx * 5 + 1}m",
                          style: const TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
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
      ),
    );
  }

  Widget _buildReelMatchCard(
    BuildContext context,
    MemberData member,
    ExploreViewModel vm,
  ) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MyImages.normalImage(member.photo, alignment: Alignment.topCenter),
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
          Positioned(
            bottom: 25,
            left: 16,
            right: 80,
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
                        style: Styles.h1.copyWith(
                          color: MyTheme.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: MyTheme.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      member.country ?? 'India',
                      style: Styles.body.copyWith(
                        color: MyTheme.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoChips(member, isDarkTheme: true),
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            right: 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionBtn(
                  icon: Icons.close,
                  color: Colors.white.withOpacity(0.2),
                  iconColor: Colors.white,
                  onTap: () {
                    if (member.userId != null) {
                      vm.ignoreUser(user: member);
                    }
                  },
                ),
                const SizedBox(height: 20),
                _buildActionBtn(
                  icon: Icons.favorite,
                  color: MyTheme.primary,
                  iconColor: Colors.white,
                  onTap: () {
                    if (member.userId != null) {
                      vm.expressInterest(userId: member.userId!);
                    }
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
    MemberData member,
    ExploreViewModel vm,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
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
                  child: UserPublicProfile(userId: member.userId ?? 0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewMatchesGrid(List<MemberData> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "New Matches",
            style: Styles.bold_arsenic_16.copyWith(
              fontSize: 18,
              color: MyTheme.text_primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: matches.length,
          itemBuilder:
              (ctx, idx) => _buildNewMatchCard(context, matches[idx], idx),
        ),
      ],
    );
  }

  Widget _buildNewMatchCard(BuildContext context, MemberData m, int idx) {
    return GestureDetector(
      onTap: () => AIZRoute.push(context, UserPublicProfile(userId: m.userId!)),
      child: Container(
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MyTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: MyImages.normalImage(
                    m.photo,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getName(m, idx),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.bold_arsenic_12.copyWith(
                      color: MyTheme.text_primary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Joined ${idx + 1}d ago",
                    style: Styles.caption.copyWith(
                      color: MyTheme.primary,
                      fontWeight: FontWeight.bold,
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

  Widget _buildFilteredGrid(
    BuildContext context,
    List<dynamic> results,
    ExploreViewModel vm,
  ) {
    if (results.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Search Results (${results.length})",
            style: Styles.bold_arsenic_16.copyWith(
              color: MyTheme.text_primary,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (ctx, idx) {
            final m =
                results[idx] is MemberData
                    ? results[idx] as MemberData
                    : MemberData();
            return _buildNewMatchCard(context, m, idx);
          },
        ),
      ],
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
          child: Text(
            AppLocalizations.of(context)!.common_yes,
            style: Styles.body,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            AppLocalizations.of(context)!.common_no,
            style: Styles.body,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChips(MemberData m, {bool isDarkTheme = false}) {
    final l = AppLocalizations.of(context)!;
    final na = l.explore_chip_na;
    final List<String> chips = [];

    chips.add(
      (m.height != null && m.height.toString().isNotEmpty)
          ? "${m.height} ${l.explore_ft}"
          : "${l.explore_chip_height}: $na",
    );
    chips.add(
      (m.caste != null && m.caste!.isNotEmpty)
          ? m.caste!
          : "${l.explore_chip_caste}: $na",
    );
    chips.add(
      (m.education != null && m.education!.isNotEmpty)
          ? m.education!
          : "${l.explore_chip_edu}: $na",
    );
    chips.add(
      (m.job != null && m.job!.isNotEmpty)
          ? m.job!
          : "${l.explore_chip_job}: $na",
    );
    chips.add(
      (m.income != null && m.income!.toString().isNotEmpty)
          ? "${l.explore_chip_income}: ${m.income}"
          : "${l.explore_chip_income}: $na",
    );

    final Color bgColor =
        isDarkTheme
            ? Colors.white.withOpacity(0.15)
            : MyTheme.primary.withOpacity(0.08);
    final Color borderColor =
        isDarkTheme
            ? Colors.white.withOpacity(0.3)
            : MyTheme.primary.withOpacity(0.2);
    final Color textColor = isDarkTheme ? Colors.white : MyTheme.primary;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children:
          chips
              .map(
                (c) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    c,
                    style: TextStyle(
                      fontSize: 11,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class ExploreViewModel {
  final bool isLogin;
  final bool? isDeactivated;
  final List<MemberData>? premiumMembersList;
  final List<MemberData>? newMemberList;
  final List<dynamic>? searchList;
  final bool isFilterActive;
  final void Function({dynamic user}) addShortlist;
  final void Function({required int userId}) expressInterest;
  final void Function({required MemberData user}) ignoreUser;

  ExploreViewModel({
    required this.isLogin,
    this.isDeactivated,
    this.premiumMembersList,
    this.newMemberList,
    this.searchList,
    required this.isFilterActive,
    required this.addShortlist,
    required this.expressInterest,
    required this.ignoreUser,
  });

  static ExploreViewModel fromStore(Store<AppState> store) {
    return ExploreViewModel(
      isLogin: store.state.authState?.userData?.id != null,
      isDeactivated: store.state.authState?.userData?.deactivated == 1,
      premiumMembersList: store.state.exploreState?.premiumMemberList,
      newMemberList: store.state.exploreState?.newMemberList,
      searchList: store.state.basicSearchState?.searchList,
      isFilterActive: store.state.basicSearchState?.isFilterActive ?? false,
      addShortlist:
          ({dynamic user}) =>
              store.dispatch(addShortlistMiddleware(userId: user)),
      expressInterest:
          ({required int userId}) =>
              store.dispatch(expressInterestMiddleware(userId: userId)),
      ignoreUser:
          ({required MemberData user}) =>
              store.dispatch(AddToIgnoreListFromHome(user: user)),
    );
  }
}
