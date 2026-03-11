import 'package:active_matrimonial_flutter_app/enums/enums.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/physical_attributes_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/physical_attr_state.dart';
import 'package:flutter/material.dart';


class PhysicalAttrLoader {}

PhysicalAttrState? physical_attr_reducer(
  PhysicalAttrState? state,
  dynamic action,
) {
  if (action is PhysicalAttrLoader) {
    state?.isLoading = !(state?.isLoading ?? false);
    return state!;
  }

  if (action is PhysicalAttrStoreAction) {
    state?.physicalAttrData = action.payload?.data;
    if (state != null) {
      setPhysicalAttr(state);
    }
    return state!;
  }

  if (action == UpdateInfo.physicalAttr) {
    FocusManager.instance.primaryFocus?.unfocus();
    // Sanket: Side effect removed from reducer.
    // store.dispatch(physicalAttrMiddleware(...)) must be called from the UI or a thunk.
  }

  return state;
}

void setPhysicalAttr(PhysicalAttrState? state) {
  final d = state?.physicalAttrData;
  state?.heightController?.text = d?.height?.toString() ?? "";
  state?.weightController?.text = d?.weight?.toString() ?? "";
  state?.eyeColorController?.text = d?.eyeColor?.toString() ?? "";
  state?.hairColorController?.text = d?.hairColor?.toString() ?? "";
  state?.complexionController?.text = d?.complexion?.toString() ?? "";
  state?.bodyTypeController?.text = d?.bodyType?.toString() ?? "";
  state?.bodyArtController?.text = d?.bodyArt?.toString() ?? "";
  state?.disabilityController?.text = d?.disability?.toString() ?? "";
  state?.bloodController?.text = d?.bloodGroup?.toString() ?? "";
}

// actions
class PhysicalAttrStoreAction {
  PhysicalAttributesGetResponse? payload;

  PhysicalAttrStoreAction({this.payload});

  @override
  String toString() {
    return 'PhysicalAttrStoreAction{payload: $payload}';
  }
}
