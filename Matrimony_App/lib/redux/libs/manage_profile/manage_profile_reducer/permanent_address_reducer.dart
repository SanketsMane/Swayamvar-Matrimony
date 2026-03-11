import 'package:active_matrimonial_flutter_app/enums/enums.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/ddown.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/permanent_address_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/city_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/permanent_address_state.dart';

class IsLoading {}

class PermanentAddressSaveChanges {}

class PEmptyStateValueAction {}

class PEmptyCityValueAction {}

class PermanentAddressStateListAction {
  List<DDown>? data;
  PermanentAddressStateListAction(this.data);
}

class PermanentAddressCityListAction {
  List<DDown>? data;
  PermanentAddressCityListAction(this.data);
}

class PAddStateValueAction {
  var value;

  PAddStateValueAction({this.value});
}

class PAddCityValueAction {
  var value;

  PAddCityValueAction({this.value});
}

class PAddCountryValueAction {
  var value;

  PAddCountryValueAction({this.value});
}

///--------------------#############@#$*&^%$#@
PermanentAddressState? permanent_address_reducer(
  PermanentAddressState? state,
  dynamic action,
) {
  if (action is IsLoading) {
    return is_loading_toggler(state!, action);
  }
  if (action is PermanentAddressSaveChanges) {
    return permanent_address_save_changes_toggler(state!, action);
  }
  if (action is PermanentAddressCityListAction) {
    return city_responose(state!, action);
  }
  if (action is PermanentAddressStateListAction) {
    return state_response(state!, action);
  }

  if (action is PermanentGetResponse) {
    return permanent_get_response(state!, action);
  }

  if (action is PEmptyStateValueAction) {
    return state_list_clear(state!, action);
  }
  if (action is PEmptyCityValueAction) {
    return city_list_clear(state!, action);
  }

  return state;
}

PermanentAddressState permanent_get_response(
  PermanentAddressState state,
  PermanentGetResponse action,
) {
  state.permanentGetResponse ??= PermanentGetResponse();
  state.permanentGetResponse!.result = action.result;
  state.permanentGetResponse!.data = action.data;
  return state;
}

PermanentAddressState state_response(
  PermanentAddressState state,
  PermanentAddressStateListAction action,
) {
  state.stateResponse ??= PermanentAddressStateListAction([]);
  state.stateResponse!.data ??= [];
  state.stateResponse!.data!.addAll(action.data ?? []);
  if (state.stateResponse!.data!.isNotEmpty) {
    state.selected_state = state.stateResponse!.data!.first;

    // Default to Maharashtra (ID 22) if country is India and no state is previously selected [Sanket]
    for (var element in state.stateResponse!.data!) {
      if (element.name == state.permanentGetResponse!.data?.state ||
          (state.permanentGetResponse!.data?.state == null && (element.id == '22' || element.name == 'Maharashtra'))) {
        state.selected_state = element;
        if (element.name == state.permanentGetResponse!.data?.state) break; // Exact match found
      }
    }

    store.dispatch(
      cityMiddleware(state.selected_state!.id, AppStates.permanentAddress),
    );
  }
  return state;
}

PermanentAddressState city_responose(
  PermanentAddressState state,
  PermanentAddressCityListAction action,
) {
  state.cityResponse!.data!.addAll(action.data!);
  if (state.cityResponse!.data!.isNotEmpty) {
    state.selected_city = state.cityResponse!.data!.first;
    for (var element in state.cityResponse!.data!) {
      if (element.name == state.permanentGetResponse!.data?.city) {
        state.selected_city = element;
      }
    }
  }

  return state;
}

PermanentAddressState permanent_address_save_changes_toggler(
  PermanentAddressState state,
  PermanentAddressSaveChanges action,
) {
  state.permanent_address_save_changes = !(state.permanent_address_save_changes ?? false);
  return state;
}

PermanentAddressState is_loading_toggler(PermanentAddressState state, IsLoading action) {
  state.is_loading = !(state.is_loading ?? false);
  return state;
}

PermanentAddressState state_list_clear(PermanentAddressState state, PEmptyStateValueAction action) {
  state.stateResponse!.data!.clear();
  // state.state_val = null;
  state.selected_state = null;
  return state;
}

PermanentAddressState city_list_clear(PermanentAddressState state, PEmptyCityValueAction action) {
  state.cityResponse!.data!.clear();
  // state.city_val = null;
  state.selected_city = null;
  return state;
}
