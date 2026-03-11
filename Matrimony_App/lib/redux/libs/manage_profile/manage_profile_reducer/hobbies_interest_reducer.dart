import 'package:active_matrimonial_flutter_app/enums/enums.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/hobbies_interest_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/hobbies_interest_state.dart';
import 'package:flutter/material.dart';


class HobbiesInterestLoader {}

HobbiesInterestState? hobbies_interest_reducer(
  HobbiesInterestState? state,
  dynamic action,
) {
  if (action is HobbiesInterestLoader) {
    state?.isLoading = !(state?.isLoading ?? false);
    return state!;
  }

  if (action is HobbiesInterestStoreAction) {
    state?.hobbiesInterestData = action.payload?.data;
    if (state != null) {
      setHobbiesInterest(state);
    }
    return state!;
  }

  //update info
  if (action == UpdateInfo.hobbiesInterest) {
    FocusManager.instance.primaryFocus?.unfocus();
    // Sanket: Side effect removed from reducer.
    // store.dispatch(hobbiesInterestUpdateMiddleware(...)) must be called from the UI or a thunk.
  }

  return state;
}

void setHobbiesInterest(HobbiesInterestState? state) {
  state?.hobbiesController?.text = state.hobbiesInterestData?.hobbies ?? "";
  state?.interestsController?.text = state.hobbiesInterestData?.interests ?? "";
  state?.musicController?.text = state.hobbiesInterestData?.music ?? "";
  state?.booksController?.text = state.hobbiesInterestData?.books ?? "";
  state?.moviesController?.text = state.hobbiesInterestData?.movies ?? "";
  state?.tvShowController?.text = state.hobbiesInterestData?.tvShows ?? "";
  state?.sportsController?.text = state.hobbiesInterestData?.sports ?? "";
  state?.fitnessActivitiesController?.text =
      state.hobbiesInterestData?.fitnessActivities ?? "";
  state?.cuisinesController?.text = state.hobbiesInterestData?.cuisines ?? "";
  state?.dressStylesController?.text = state.hobbiesInterestData?.dressStyles ?? "";
}

// action
class HobbiesInterestStoreAction {
  HobbiesInterestGetResponse? payload;

  HobbiesInterestStoreAction({this.payload});

  @override
  String toString() {
    return 'HobbiesInterestStoreAction{payload: $payload}';
  }
}
