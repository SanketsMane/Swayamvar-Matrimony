import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/user.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/matched_profile/matched_profile_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest/express_interest_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:flutter/material.dart';

import '../../components/common_app_bar.dart';
import '../../l10n/app_localizations.dart';

class MatchedProfileScreen extends StatefulWidget {
  const MatchedProfileScreen({super.key});

  @override
  State<MatchedProfileScreen> createState() => _MatchedProfileScreenState();
}

class _MatchedProfileScreenState extends State<MatchedProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(context).dispatch(matchedProfileFetchAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        text: AppLocalizations.of(context)!.profile_screen_profile_match,
      ).build(context),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        builder: (BuildContext context, _ViewModel vm) {
          if (vm.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error.isNotEmpty) {
            return Center(child: Text("Error: ${vm.error}"));
          }

          if (vm.profiles.isEmpty) {
            return const Center(child: Text("No matched profiles found."));
          }

          // Using ListView.builder for a vertical list of styled cards
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
            itemCount: vm.profiles.length,
            itemBuilder: (context, index) {
              final profile = vm.profiles[index];
              return _buildProfileCard(context, vm, profile);
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    _ViewModel vm,
    MemberData profile,
  ) {
    return GestureDetector(
      onTap: () {
        AIZRoute.push(
          context,
          UserPublicProfile(userId: profile.userId!),
          middleware: ProfileViewMiddleware(
            context: context,
            user: vm.currentUser,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.8, 1),
            colors: [MyTheme.gradient_color_1, MyTheme.gradient_color_2],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              // Square Profile Image
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  image: DecorationImage(
                    image: NetworkImage(profile.photo ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Const.width15,
              // Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name ?? "",
                      style: Styles.bold_white_14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Const.height10,
                    Text(
                      '${profile.age} yrs, ${profile.height} ft, ${profile.maritalStatus ?? ""}',
                      style: Styles.regular_white_12,
                    ),
                    Text(
                      '${profile.religion}, ${profile.caste}',
                      style: Styles.regular_white_12,
                    ),
                  ],
                ),
              ),
              // Interest Button
              //   buildInterestButton(vm, profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInterestButton(_ViewModel vm, MemberData profile) {
    if (vm.myInterestStateLoading!) {
      return const SizedBox(
        height: 30,
        width: 30,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        profile.interestStatus == 'sent' || profile.interestStatus == 'accepted'
            ? Icons.favorite
            : Icons.favorite_border,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        if (vm.isUserVerified == false) {
          StoreProvider.of<AppState>(context).dispatch(
            ShowMessageAction(
              msg: "Please verify your account",
              color: MyTheme.failure,
            ),
          );
          return;
        }
        if (vm.packageExpiry == "Expired") {
          StoreProvider.of<AppState>(
            context,
          ).dispatch(ShowMessageAction(msg: "Please update your package."));
          return;
        }
        if (vm.isFullProfileView!) {
          StoreProvider.of<AppState>(
            context,
          ).dispatch(ShowMessageAction(msg: "Please update your package."));
          return;
        }
        vm.expressInterest(userId: profile.userId!);
      },
    );
  }
}

class _ViewModel {
  final bool isFetching;
  final List<MemberData> profiles;
  final String error;
  final User? currentUser;
  final bool? myInterestStateLoading;
  final bool? isUserVerified;
  final String? packageExpiry;
  final bool? isFullProfileView;
  final Function({required int userId}) expressInterest;

  _ViewModel({
    required this.isFetching,
    required this.profiles,
    required this.error,
    required this.currentUser,
    required this.myInterestStateLoading,
    required this.isUserVerified,
    required this.packageExpiry,
    required this.isFullProfileView,
    required this.expressInterest,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isFetching: store.state.matchedProfileState!.isFetching ?? false,
      profiles: store.state.matchedProfileState!.matchedProfiles ?? [],
      error: store.state.matchedProfileState!.error ?? '',
      currentUser: store.state.authState?.userData,
      myInterestStateLoading: store.state.myInterestState?.isLoading,
      isUserVerified: store.state.userVerifyState?.isApprove,
      packageExpiry:
          store
              .state
              .accountState!
              .profileData
              ?.currentPackageInfo
              ?.packageExpiry,
      isFullProfileView: settingIsActive(
        "full_profile_show_according_to_membership",
        "1",
      ),
      expressInterest:
          ({required int userId}) =>
              store.dispatch(expressInterestMiddleware(userId: userId)),
    );
  }
}
