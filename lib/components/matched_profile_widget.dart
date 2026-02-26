// Sanket: Matched profiles horizontal row for Inbox screen
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import '../const/const.dart';
import '../const/my_theme.dart';
import '../const/style.dart';
import '../redux/app/app_state.dart';
import '../screens/user_pages/user_public_profile.dart';

class MatchedProfileWidget extends StatelessWidget {
  const MatchedProfileWidget({
    super.key,
    required this.matched_profile_controller,
    required this.state,
  });

  final PageController matched_profile_controller;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    if (state.matchedProfileState?.isFetching ?? true) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(color: MyTheme.primary)),
      );
    }

    final profiles = state.matchedProfileState?.matchedProfiles ?? [];

    if (profiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Your Matches ❤️",
            style: Styles.bold_arsenic_16.copyWith(
              fontSize: 17,
              color: MyTheme.text_primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: profiles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final user = profiles[index];
              return _buildProfileItem(context, user);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(BuildContext context, dynamic user) {
    return GestureDetector(
      onTap: () {
        AIZRoute.push(
          context,
          UserPublicProfile(userId: user.userId!),
          middleware: ProfileViewMiddleware(
            context: context,
            user: state.authState?.userData,
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              // Circular Profile Image (64px)
              Container(
                height: 64,
                width: 64,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: MyTheme.primary.withOpacity(0.3), width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    user.photo ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: MyTheme.background),
                  ),
                ),
              ),
              // Online Indicator
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: MyTheme.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: MyTheme.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 68,
            child: Text(
              user.name?.split(' ').first ?? "",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.regular_arsenic_11.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: MyTheme.text_primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
