import 'package:active_matrimonial_flutter_app/models_response/drop_down/caste.dart';
import 'package:active_matrimonial_flutter_app/models_response/drop_down/subcaste.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/spiritual_social_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/spiritual_social_state.dart';

class SLoader {}

class SpiritualSaveChanges {}

SpiritualSocialState? spiritual_reducer(
  SpiritualSocialState? state,
  dynamic action,
) {
  if (action is SLoader) {
    // Sanket: Side effect removed from reducer.
    // Repository call moved out.
    return state;
  }

  if (action is SpiritualSaveChanges) {
    state?.set_sp_save_change();
    return state!;
  }

  if (action is CasteResponse) {
    // print("spirtual");
    return caste_response(state!, action);
  }
  if (action is SubcasteResponse) {
    return sub_caste_response(state!, action);
  }

  if (action is SpiritualSocialGetResponse) {
    return spiritual_social_get_response(state!, action);
  }
  if (action is AddReligionValueAction) {
    return add_religion_value(state!, action);
  }

  if (action is AddCasteValueAction) {
    return add_caste_value(state!, action);
  }

  if (action is AddSubCasteValueAction) {
    return add_sub_caste_value(state!, action);
  }

  if (action is AddFamilyValueAction) {
    return add_family_value(state!, action);
  }

  if (action is EmptyCasteAction) {
    return caste_list_clear(state!, action);
  }

  if (action is EmptySubCasteAction) {
    return subcaste_list_clear(state!, action);
  }

  return state;
}

/// profile drop down response

/// spiritual social get response
SpiritualSocialState spiritual_social_get_response(
  SpiritualSocialState state,
  SpiritualSocialGetResponse action,
) {
  state.spiritualSocialGetResponse ??= SpiritualSocialGetResponse();
  state.spiritualSocialGetResponse!.data = action.data;
  state.spiritualSocialGetResponse!.result = action.result;
  return state;
}

///set values;
SpiritualSocialState add_religion_value(SpiritualSocialState state, AddReligionValueAction action) {
  state.religion_val = action.value;
  return state;
}

SpiritualSocialState add_family_value(SpiritualSocialState state, AddFamilyValueAction action) {
  state.family_val = action.value;
  return state;
}

///caste
SpiritualSocialState caste_response(SpiritualSocialState state, CasteResponse action) {
  state.casteResponse ??= CasteResponse(data: []);
  state.casteResponse!.data ??= [];
  state.casteResponse!.data!.addAll(action.data ?? []);

  if (state.casteResponse!.data!.isNotEmpty) {
    state.caste_val = state.casteResponse!.data!.first;
    if (state.spiritualSocialGetResponse?.result == true) {
      for (var element in state.casteResponse!.data!) {
        if (element.name == state.spiritualSocialGetResponse!.data?.casteId?.toString()) {
          state.caste_val = element;
        }
      }
    }
    // Sanket: Side effect removed from reducer.
    // store.dispatch(subcasteMiddleware(...)) should be handled in a thunk or UI.
  }
  return state;
}

SpiritualSocialState add_caste_value(SpiritualSocialState state, AddCasteValueAction action) {
  // state.set_caste_val(action.value);
  state.caste_val = action.value;
  return state;
}

/// subcaste
SpiritualSocialState sub_caste_response(SpiritualSocialState state, SubcasteResponse action) {
  state.subcasteResponse!.data!.addAll(action.data!);

  if (state.subcasteResponse!.data!.isNotEmpty) {
    state.sub_caste_val = state.subcasteResponse!.data!.first;

    if (state.spiritualSocialGetResponse!.result!) {
      for (var element in state.subcasteResponse!.data!) {
        if (element.name ==
            state.spiritualSocialGetResponse!.data!.subCasteId) {
          state.sub_caste_val = element;
        }
      }
    }
  }
  return state;
}

SpiritualSocialState add_sub_caste_value(SpiritualSocialState state, AddSubCasteValueAction action) {
  state.sub_caste_val = action.value;
  return state;
}

SpiritualSocialState caste_list_clear(SpiritualSocialState state, EmptyCasteAction action) {
  state.casteResponse!.data!.clear();
  state.caste_val = null;
  return state;
}

SpiritualSocialState subcaste_list_clear(SpiritualSocialState state, EmptySubCasteAction action) {
  state.subcasteResponse?.data?.clear();
  state.sub_caste_val = null;
  return state;
}

/// classes
class EmptyCasteAction {}

class EmptySubCasteAction {}

class AddReligionValueAction {
  var value;

  AddReligionValueAction({this.value});
}

class AddCasteValueAction {
  var value;

  AddCasteValueAction({this.value});
}

class AddSubCasteValueAction {
  var value;

  AddSubCasteValueAction({this.value});
}

class AddFamilyValueAction {
  var value;

  AddFamilyValueAction({this.value});
}
