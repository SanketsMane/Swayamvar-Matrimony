import 'package:active_matrimonial_flutter_app/models_response/account_response.dart';
import 'package:flutter/material.dart';

class AccountState {
  ProfileData? profileData;
  String? error;
  PageController matched_profile_controller = PageController();
  ScrollController gridScrollController = ScrollController();

  AccountState({
    this.error,
    this.profileData,
    required this.matched_profile_controller,
    required this.gridScrollController,
  });

  AccountState.initialState()
    : profileData = null,
      error = '',
      matched_profile_controller = PageController(),
      gridScrollController = ScrollController();
  AccountState copyWith({ProfileData? profileData, String? error}) {
    return AccountState(
      profileData: profileData ?? this.profileData,
      error: error ?? this.error,
      matched_profile_controller: matched_profile_controller,
      gridScrollController: gridScrollController,
    );
  }

  @override
  String toString() {
    return 'AccountState{profileData: $profileData, error: $error}';
  }
}
