import 'package:active_matrimonial_flutter_app/components/common_app_bar.dart';
import 'package:active_matrimonial_flutter_app/components/my_images.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

class NewMatchesPage extends StatelessWidget {
  const NewMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder:
          (_, vm) => Scaffold(
            backgroundColor: MyTheme.background,
            appBar: CommonAppBar(
              text: AppLocalizations.of(context)!.home_new_profiles_available,
            ).build(context),
            body:
                vm.newMatches.isEmpty
                    ? _buildEmptyState(context)
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: vm.newMatches.length,
                      itemBuilder: (context, index) {
                        return _buildMemberCard(context, vm.newMatches[index]);
                      },
                    ),
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 64,
            color: MyTheme.storm_grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No new matches currently",
            style: Styles.h2.copyWith(color: MyTheme.storm_grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, MemberData member) {
    return InkWell(
      onTap:
          () => AIZRoute.push(
            context,
            UserPublicProfile(userId: member.userId ?? 0),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MyImages.normalImage(member.photo),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name ?? "User",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.bold_arsenic_14,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${member.age ?? '25'} yrs • ${member.country ?? 'India'}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.regular_gull_grey_10.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: MyTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "New Member",
                      style: TextStyle(
                        color: MyTheme.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
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
}

class _ViewModel {
  final List<MemberData> newMatches;

  _ViewModel({required this.newMatches});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(newMatches: store.state.homeState?.newMatches ?? []);
  }
}
