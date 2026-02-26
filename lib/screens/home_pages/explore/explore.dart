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

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final TextEditingController _searchController = TextEditingController();

  // Mock configs
  final List<String> _mockNames = ['Akash Patil', 'Rohit Kulkarni', 'Snehal Jadhav', 'Pooja More', 'Rahul Desai', 'Neha Sharma', 'Vikram Singh', 'Priya Gupta', 'Karan Mehta', 'Anjali Rao'];
  final List<String> _mockCities = ['Pune', 'Mumbai', 'Nagpur', 'Kolhapur', 'Nashik'];
  final List<String> _mockReasons = ['✔ Same Religion\n✔ Same City\n✔ Similar Education', '✔ Same Caste\n✔ Highly Compatible Profession', '✔ Same Religion\n✔ Matches Partner Preferences'];
  final List<int> _mockMatchScores = [96, 92, 88, 75, 82, 65, 90, 85];
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getName(MemberData m, int index) {
    if (m.name == null || m.name!.trim().isEmpty || m.name!.toLowerCase() == 'dummy' || m.name!.toLowerCase() == 'test') {
      return _mockNames[index % _mockNames.length];
    }
    return m.name!;
  }

  String _getCity(MemberData m, int index) {
    if (m.country == null || m.country!.trim().isEmpty || m.country!.toLowerCase().contains('dummy')) {
      return _mockCities[index % _mockCities.length];
    }
    return m.country!;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ExploreViewModel>(
      converter: (store) => ExploreViewModel.fromStore(store),
      onInit: (store) => [
        store.dispatch(fetchPremiumMembersAction()),
        store.dispatch(fetchNewMembersAction()),
        if (store.state.basicSearchState?.searchText != null)
          _searchController.text = store.state.basicSearchState!.searchText!,
      ],
      builder: (_, vm) {
        
        // Ensure data is loaded
        if (vm.premiumMembersList == null || vm.newMemberList == null) {
           return Scaffold(
             backgroundColor: MyTheme.background,
             body: Column(
               children: [
                 _buildHeader(context, vm),
                 const Expanded(child: Center(child: CircularProgressIndicator(color: MyTheme.primary))),
               ],
             ),
           );
        }

        List<MemberData> rawMembers = [];
        rawMembers.addAll(vm.premiumMembersList!);
        rawMembers.addAll(vm.newMemberList!);
        
        final seen = <int>{};
        List<MemberData> uniqueMembers = rawMembers.where((m) {
          if (m.userId == null) return false;
          return seen.add(m.userId!);
        }).toList();

        List<MemberData> topMatches = [];
        List<MemberData> nearbyMatches = [];
        List<MemberData> activeNowMatches = [];
        List<MemberData> newMatches = [];

        if (uniqueMembers.length >= 3) {
           topMatches = uniqueMembers.take(3).toList();
           uniqueMembers = uniqueMembers.skip(3).toList();
        } else {
           topMatches = uniqueMembers;
           uniqueMembers = [];
        }

        if (uniqueMembers.length >= 5) {
           nearbyMatches = uniqueMembers.take(5).toList();
           uniqueMembers = uniqueMembers.skip(5).toList();
        } else {
           nearbyMatches = uniqueMembers;
           uniqueMembers = [];
        }

        if (uniqueMembers.length >= 5) {
           activeNowMatches = uniqueMembers.take(5).toList();
           uniqueMembers = uniqueMembers.skip(5).toList();
        } else {
           activeNowMatches = uniqueMembers;
           uniqueMembers = [];
        }
        
        newMatches = uniqueMembers.take(8).toList();

        bool isSearching = vm.isFilterActive || _searchController.text.isNotEmpty;
        final searchResults = vm.searchList ?? [];

        return WillPopScope(
          onWillPop: () async {
            final shouldPop = (await OneContext().showDialog<bool>(
              builder: (BuildContext context) => exit_alert_dialog(context),
            ))!;
            return shouldPop;
          },
          child: Scaffold(
            backgroundColor: MyTheme.background,
            drawer: const MainDrawer(),
          body: Column(
            children: [
              _buildHeader(context, vm),
              Expanded(
                child: RefreshIndicator(
                  color: MyTheme.primary,
                  onRefresh: () async {
                    StoreProvider.of<AppState>(context).dispatch(fetchPremiumMembersAction());
                    StoreProvider.of<AppState>(context).dispatch(fetchNewMembersAction());
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildSearchSection(context, vm),
                        const SizedBox(height: 16),
                        
                        if (isSearching) ...[
                           _buildFilteredGrid(context, searchResults, vm),
                        ] else ...[
                           _buildMatchSummary(rawMembers.length),
                           if (topMatches.isNotEmpty) _buildTopMatches(topMatches, vm),
                           if (nearbyMatches.isNotEmpty) _buildNearbyMatches(nearbyMatches),
                           if (activeNowMatches.isNotEmpty) _buildRecentlyActive(activeNowMatches),
                           if (newMatches.isNotEmpty) _buildNewMatchesGrid(newMatches),
                           if (topMatches.isEmpty && nearbyMatches.isEmpty && newMatches.isEmpty) _buildEmptyState(),
                        ],
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 48),
          Icon(Icons.people_alt_outlined, size: 64, color: MyTheme.border),
          const SizedBox(height: 16),
          Text("No matches found.", style: Styles.h2.copyWith(color: MyTheme.text_primary)),
          const SizedBox(height: 8),
          Text("Adjust your preferences to see more profiles.", style: Styles.body.copyWith(color: MyTheme.text_secondary)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => AIZRoute.push(context, AdvancedSearch()),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Styles.br_btn)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Edit Preferences", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            Builder(
              builder: (context) => _headerIconBtn(Icons.menu, onTap: () => Scaffold.of(context).openDrawer()),
            ),
            const Spacer(),
            Image.asset(
              'assets/logo/app_logo.png',
              height: 36.0,
              color: MyTheme.primary,
            ),
            const Spacer(),
            _headerIconBtn(Icons.notifications_none_rounded, onTap: () => AIZRoute.push(context, const Notifications())),
          ],
        ),
      ),
    );
  }

  Widget _headerIconBtn(IconData icon, {VoidCallback? onTap, bool isActive = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? MyTheme.primary : MyTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? MyTheme.primary : MyTheme.border),
        ),
        child: Icon(icon, color: isActive ? MyTheme.white : MyTheme.text_primary, size: 20),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context, ExploreViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: MyTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyTheme.border),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (val) {
                  store.dispatch(SearchSetFiltersAction(searchText: val));
                  store.dispatch(Reset.search);
                  store.dispatch(searchMiddleware(searchText: val));
                },
                style: Styles.regular_arsenic_14.copyWith(color: MyTheme.text_primary),
                decoration: InputDecoration(
                  hintText: "Search by name or city",
                  hintStyle: Styles.regular_arsenic_14.copyWith(color: MyTheme.text_secondary),
                  prefixIcon: const Icon(Icons.search_rounded, color: MyTheme.text_secondary, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          if (vm.isFilterActive || _searchController.text.isNotEmpty) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                _searchController.clear();
                store.dispatch(SearchClearFiltersAction());
              },
              child: const Text("Clear", style: TextStyle(color: MyTheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchSummary(int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MyTheme.border),
          boxShadow: [BoxShadow(color: MyTheme.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You have $total Matches", style: Styles.bold_arsenic_16.copyWith(color: MyTheme.text_primary)),
                const SizedBox(height: 4),
                Text("6 New Matches This Week", style: Styles.regular_gull_grey_12.copyWith(color: MyTheme.text_secondary, fontWeight: FontWeight.w500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: MyTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text("View All", style: Styles.bold_arsenic_12.copyWith(color: MyTheme.primary)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCompBadge(int match) {
    Color bColor;
    if (match >= 85) bColor = MyTheme.success;
    else if (match >= 60) bColor = Colors.orange;
    else bColor = MyTheme.text_secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bColor, borderRadius: BorderRadius.circular(12)),
      child: Text('$match% ${match >= 85 ? "High" : match >= 60 ? "Medium" : "Low"} Match', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTopMatches(List<MemberData> matches, ExploreViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Top Matches For You", style: Styles.bold_arsenic_16.copyWith(fontSize: 18, color: MyTheme.text_primary)),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: min(matches.length, 3),
          itemBuilder: (ctx, idx) => _buildTopMatchCard(matches[idx], idx, vm),
        )
      ],
    );
  }

  Widget _buildTopMatchCard(MemberData m, int idx, ExploreViewModel vm) {
    int score = _mockMatchScores[idx % _mockMatchScores.length];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyTheme.border),
        boxShadow: [BoxShadow(color: MyTheme.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
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
                    MyImages.normalImage(m.photo),
                    Positioned(
                      top: 12, left: 12,
                      child: _buildCompBadge(score)
                    )
                 ]
               )
            )
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${_getName(m, idx)}, ${m.age ?? '25'}", style: Styles.bold_arsenic_16.copyWith(fontSize: 20, color: MyTheme.text_primary)),
                const SizedBox(height: 4),
                Text(_getCity(m, idx), style: Styles.regular_gull_grey_12.copyWith(color: MyTheme.text_secondary, fontSize: 13)),
                const SizedBox(height: 12),
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: MyTheme.background, borderRadius: BorderRadius.circular(8)),
                  child: Text(_mockReasons[idx % _mockReasons.length], style: Styles.bold_arsenic_12.copyWith(color: MyTheme.text_primary, height: 1.5)),
                ),
                
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _actionBtn("Interest", Icons.favorite, MyTheme.primary, () => vm.expressInterest(userId: m.userId!))),
                    const SizedBox(width: 8),
                    Expanded(child: _actionBtn("Shortlist", Icons.star_border, MyTheme.text_secondary, () => vm.addShortlist(user: m.userId!))),
                    const SizedBox(width: 8),
                    Expanded(child: _actionBtn("View", Icons.person_outline, MyTheme.text_secondary, () => AIZRoute.push(context, UserPublicProfile(userId: m.userId!)))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _actionBtn(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color == MyTheme.primary ? color : MyTheme.border),
          color: color == MyTheme.primary ? MyTheme.primary.withOpacity(0.05) : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(title, style: Styles.bold_arsenic_12.copyWith(color: color, fontSize: 11)),
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
           child: Text("Matches Near You", style: Styles.bold_arsenic_16.copyWith(fontSize: 18, color: MyTheme.text_primary)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: matches.length,
            itemBuilder: (ctx, idx) => _buildNearbyCard(matches[idx], idx),
          ),
        )
      ],
    );
  }

  Widget _buildNearbyCard(MemberData m, int idx) {
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: MyImages.normalImage(m.photo),
               )
            ),
            Padding(
               padding: const EdgeInsets.all(10),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("${_getName(m, idx)}, ${m.age ?? '25'}", maxLines: 1, overflow: TextOverflow.ellipsis, style: Styles.bold_arsenic_12.copyWith(color: MyTheme.text_primary, fontSize: 13)),
                     const SizedBox(height: 2),
                     Text("${idx * 2 + 1} km away", style: Styles.caption.copyWith(color: MyTheme.text_secondary)),
                  ],
               ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyActive(List<MemberData> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16),
           child: Text("Active Now", style: Styles.bold_arsenic_16.copyWith(fontSize: 18, color: MyTheme.text_primary)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: matches.length,
            itemBuilder: (ctx, idx) {
              final m = matches[idx];
              return GestureDetector(
                onTap: () => AIZRoute.push(context, UserPublicProfile(userId: m.userId!)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                     children: [
                        Stack(
                          children: [
                             ClipRRect(
                               borderRadius: BorderRadius.circular(35),
                               child: SizedBox(
                                 width: 70, height: 70,
                                 child: MyImages.normalImage(m.photo)
                               )
                             ),
                             Positioned(
                               bottom: 0, right: 0,
                               child: Container(
                                  width: 16, height: 16,
                                  decoration: BoxDecoration(
                                     color: MyTheme.success,
                                     shape: BoxShape.circle,
                                     border: Border.all(color: Colors.white, width: 2)
                                  ),
                               )
                             )
                          ]
                        ),
                        const SizedBox(height: 6),
                        Text("Active ${idx * 5 + 1}m ago", style: Styles.caption.copyWith(color: MyTheme.text_secondary, fontSize: 10)),
                     ]
                  )
                )
              );
            }
          ),
        )
      ],
    );
  }

  Widget _buildNewMatchesGrid(List<MemberData> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16),
           child: Text("New Matches", style: Styles.bold_arsenic_16.copyWith(fontSize: 18, color: MyTheme.text_primary)),
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
             mainAxisSpacing: 12
          ),
          itemCount: matches.length,
          itemBuilder: (ctx, idx) => _buildNewMatchCard(matches[idx], idx),
        ),
      ],
    );
  }

  Widget _buildNewMatchCard(MemberData m, int idx) {
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(width: double.infinity, child: MyImages.normalImage(m.photo))
               )
            ),
            Padding(
               padding: const EdgeInsets.all(12),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(_getName(m, idx), maxLines: 1, overflow: TextOverflow.ellipsis, style: Styles.bold_arsenic_12.copyWith(color: MyTheme.text_primary, fontSize: 13)),
                     const SizedBox(height: 4),
                     Text("Joined ${idx + 1}d ago", style: Styles.caption.copyWith(color: MyTheme.primary, fontWeight: FontWeight.bold)),
                  ],
               ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredGrid(BuildContext context, List<dynamic> results, ExploreViewModel vm) {
    if (results.isEmpty) {
       return _buildEmptyState();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Search Results (${results.length})", style: Styles.bold_arsenic_16.copyWith(color: MyTheme.text_primary, fontSize: 16)),
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
             mainAxisSpacing: 12
          ),
          itemBuilder: (ctx, idx) {
             final m = results[idx] is MemberData ? results[idx] as MemberData : MemberData(); 
             return _buildNewMatchCard(m, idx);
          }
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

class ExploreViewModel {
  final bool isLogin;
  final bool? isDeactivated;
  final List<MemberData>? premiumMembersList;
  final List<MemberData>? newMemberList;
  final List<dynamic>? searchList;
  final bool isFilterActive;
  final void Function({dynamic user}) addShortlist;
  final void Function({required int userId}) expressInterest;

  ExploreViewModel({
    required this.isLogin,
    this.isDeactivated,
    this.premiumMembersList,
    this.newMemberList,
    this.searchList,
    required this.isFilterActive,
    required this.addShortlist,
    required this.expressInterest,
  });

  static ExploreViewModel fromStore(Store<AppState> store) {
    return ExploreViewModel(
      isLogin: store.state.authState?.userData?.id != null,
      isDeactivated: store.state.authState?.userData?.deactivated == 1,
      premiumMembersList: store.state.exploreState?.premiumMemberList,
      newMemberList: store.state.exploreState?.newMemberList,
      searchList: store.state.basicSearchState?.searchList,
      isFilterActive: store.state.basicSearchState?.isFilterActive ?? false,
      addShortlist: ({dynamic user}) => store.dispatch(addShortlistMiddleware(userId: user)),
      expressInterest: ({required int userId}) => store.dispatch(expressInterestMiddleware(userId: userId)),
    );
  }
}
