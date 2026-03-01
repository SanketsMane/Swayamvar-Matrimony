import 'package:active_matrimonial_flutter_app/enums/enums.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/introduction_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/introduction_state.dart';
import 'package:flutter/material.dart';


IntroductionState? introduction_reducer(IntroductionState? state, action) {
  if (action == SaveChanges.introduction) {
    state!.isLoading = !state.isLoading!;
    return state;
  }

  if (action is IntroductionStoreAction) {
    state!.introData = action.payload!.data;
    setIntro(state);
    return state;
  }
  if (action == UpdateInfo.intro) {
    FocusManager.instance.primaryFocus?.unfocus();
    // Sanket: Side effect removed from reducer.
    // store.dispatch(introUpdateMiddleware(...)) must be called from the UI or a thunk.
  }
  return state;
}

void setIntro(IntroductionState? state) {
  state!.textController!.text = state.introData!.introduction!;
}

// actions
class IntroductionStoreAction {
  IntroductionGetResponse? payload;

  IntroductionStoreAction({this.payload});

  @override
  String toString() {
    return 'IntroductionStoreAction{payload: $payload}';
  }
}
