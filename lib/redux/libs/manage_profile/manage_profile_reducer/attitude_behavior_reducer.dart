import 'package:active_matrimonial_flutter_app/enums/enums.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/attitude_behavior_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/attitude_behavior_state.dart';
import 'package:flutter/material.dart';


class AttitudeBehaviorLoader {}

AttitudeBehaviorState? attitude_behavior_reducer(
  AttitudeBehaviorState? state,
  dynamic action,
) {
  if (action is AttitudeBehaviorLoader) {
    state!.isLoading = !state.isLoading!;
    return state;
  }

  if (action is AttitudeBehaviorStoreAction) {
    state!.attitudeBehaviorData = action.payload!.data;
    setAttitudeBehaviour(state);
  }

  if (action == UpdateInfo.attitudeBehaviour) {
    FocusManager.instance.primaryFocus?.unfocus();
    // Sanket: Side effect removed from reducer.
    // store.dispatch(attitudeBehaviorUpdateMiddleware(...)) must be called from the UI or a thunk.
  }

  return state;
}

void setAttitudeBehaviour(AttitudeBehaviorState? state) {
  state!.affectionController!.text = state.attitudeBehaviorData!.affection;
  state.humorController!.text = state.attitudeBehaviorData!.humor;
  state.religiousServiceController!.text =
      state.attitudeBehaviorData!.religiousService;
  state.politicalViewsController!.text =
      state.attitudeBehaviorData!.politicalViews;
}

// actions
class AttitudeBehaviorStoreAction {
  AttitudeBehaviorGetResponse? payload;

  AttitudeBehaviorStoreAction({this.payload});

  @override
  String toString() {
    return 'AttitudeBehaviorStoreAction{payload: $payload}';
  }
}
