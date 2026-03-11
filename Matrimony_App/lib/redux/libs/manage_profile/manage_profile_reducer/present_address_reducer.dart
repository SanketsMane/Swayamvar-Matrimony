import 'package:active_matrimonial_flutter_app/enums/enums.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/ddown.dart';
import 'package:active_matrimonial_flutter_app/models_response/drop_down/state.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/present_address_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/city_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/present_addres_state.dart';

class PresentAddressStoreAction {
  PresentAddressGetResponse? payload;

  PresentAddressStoreAction({this.payload});

  @override
  String toString() {
    return 'PresentAddressStoreAction{payload: $payload}';
  }
}

class PresentAddressLoader {}

class PresentAddressSaveChanges {}

class CityResponseForPresentAddress {
  List<DDown>? data;
  CityResponseForPresentAddress(this.data);
}

/// actions

class EmptyCityAction {}

class EmptyStateAction {}

class AddStateValueAction {
  var value;

  AddStateValueAction({this.value});
}

class AddCityValueAction {
  var value;

  AddCityValueAction({this.value});
}

class AddCountryValueAction {
  var value;

  AddCountryValueAction({this.value});
}

PresentAddressState? present_address_reducer(
  PresentAddressState? state,
  dynamic action,
) {
  if (action is PresentAddressLoader) {
    state?.isLoading = !(state?.isLoading ?? false);
    return state!;
  }

  if (action is PresentAddressSaveChanges) {
    state!.save_chagnes_toogler();
    return state;
  }

  if (action is PresentAddressLoader) {
    state?.page_loader_toogler();
    return state!;
  }

  if (action is StateResponse) {
    print(state);
    return state_response(state!, action);
  }

  if (action is CityResponseForPresentAddress) {
    return city_response(state!, action);
  }

  if (action is PresentAddressStoreAction) {
    state?.presentAddressData = action.payload?.data;
    state?.result = action.payload?.result;
    return state!;
  }

  if (action is EmptyStateAction) {
    return state_list_clear(state!, action);
  }
  if (action is EmptyCityAction) {
    return city_list_clear(state!, action);
  }

  return state;
}

/// city
PresentAddressState city_response(PresentAddressState state, CityResponseForPresentAddress action) {
  state.cityResponse?.data?.addAll(action.data ?? []);
  state.selected_city = (state.cityResponse?.data?.isNotEmpty == true) ? state.cityResponse!.data!.first : null;

  if (state.presentAddressData?.city != null) {
    for (var element in state.cityResponse!.data!) {
      if (element.name == state.presentAddressData!.city) {
        state.selected_city = element;
        // state.selected_city_id = element.id;
      }
    }
  }

  return state;
}

PresentAddressState state_response(PresentAddressState state, StateResponse action) {
  state.stateResponse?.data?.addAll(action.data ?? []);
  if (action.data?.isNotEmpty == true) {
    state.selected_state = action.data!.first;

    // Default to Maharashtra (ID 22) if country is India and no state is previously selected [Sanket]
    for (var element in state.stateResponse!.data!) {
      if (element.name == state.presentAddressData?.state ||
          (state.presentAddressData?.state == null && (element.id == '22' || element.name == 'Maharashtra'))) {
        state.selected_state = element;
        if (element.name == state.presentAddressData?.state) break; // Exact match found
      }
    }

    store.dispatch(
      cityMiddleware(state.selected_state!.id, AppStates.presentAddress),
    );
  }

  return state;
}

PresentAddressState state_list_clear(PresentAddressState state, EmptyStateAction action) {
  state.stateResponse!.data!.clear();
  // state.state_value = null;
  state.selected_state = null;
  return state;
}

///cities

PresentAddressState city_list_clear(PresentAddressState state, EmptyCityAction action) {
  state.cityResponse!.data!.clear();
  // state.city_value = null;
  state.selected_city = null;
  return state;
}
