import 'package:active_matrimonial_flutter_app/models_response/drop_down/caste.dart';
import 'package:active_matrimonial_flutter_app/models_response/drop_down/subcaste.dart';
import 'package:active_matrimonial_flutter_app/models_response/drop_down/state.dart' as ds;
import 'package:active_matrimonial_flutter_app/models_response/drop_down/city.dart' as dc;
import 'package:active_matrimonial_flutter_app/screens/search_screens/basic_search_state.dart';

import '../../enums/enums.dart';
import 'search_action.dart';

BasicSearchState? basic_search_reducer(
  BasicSearchState? state,
  dynamic action,
) {
  // store search data
  if (action is SearchStoreAction) {
    return state!.copyWith(
      isFetching: false,
      searchList: action.payload!.data!.members,
    );
  }
  if (action is SearchFailureAction) {
    return state!.copyWith(error: action.error);
  }
  if (action == Reset.search) {
    state = BasicSearchState.initialState();
    return state;
  }
  //others
  if (action is CasteResponse) {
    return caste_response(state!, action);
  }

  if (action is SubcasteResponse) {
    return sub_caste_response(state!, action);
  }

  if (action is SearchGetStateValueAction) {
    return state_response(state!, action);
  }
  if (action is SearchGetCityValueAction) {
    return city_response(state!, action);
  }
  if (action is SearchAddCasteValueAction) {
    return state!.copyWith(caste_value: action.value);
  }
  if (action is SearchAddReligionValueAction) {
    return state!.copyWith(religion_value: action.value);
  }
  if (action is SearchAddSubCasteValueAction) {
    return state!.copyWith(sub_caste_value: action.value);
  }

  if (action is SearchCountryAddValueAction) {
    return state!.copyWith(country_value: action.value);
  }
  if (action is SearchStateAddValueAction) {
    return state!.copyWith(state_value: action.value);
  }
  if (action is SearchCityAddValueAction) {
    return state!.copyWith(city_value: action.value);
  }
  if (action is SearchEmptyCaste) {
    return empty_caste(state!, action);
  }
  if (action is SearchEmptySubCaste) {
    return empty_sub_caste(state!, action);
  }
  if (action is SearchEmptyState) {
    return empty_state(state!, action);
  }
  if (action is SearchEmptyCity) {
    return empty_city(state!, action);
  }

  if (action is SearchSetFiltersAction) {
    return state!.copyWith(
      minAge: action.minAge,
      maxAge: action.maxAge,
      religion_value: action.religion,
      caste_value: action.caste,
      marital_status_value: action.maritalStatus,
      country_value: action.country,
      state_value: action.state,
      city_value: action.city,
      quickFilters: action.quickFilters,
      diet: action.diet,
      smoking: action.smoking,
      drinking: action.drinking,
      searchText: action.searchText,
      education: action.education,
      income: action.income,
      isManglik: action.isManglik,
      isIntercaste: action.isIntercaste,
      isDisabled: action.isDisabled,
      hasPhoto: action.hasPhoto,
      recentlyJoined: action.recentlyJoined,
    );
  }

  if (action is SearchSaveAdvancedFiltersAction) {
    return state!.copyWith(
      minAge: action.minAge,
      maxAge: action.maxAge,
      religion_value: action.religion,
      caste_value: action.caste,
      marital_status_value: action.maritalStatus,
      country_value: action.country,
      state_value: action.state,
      city_value: action.city,
      quickFilters: action.quickFilters,
      education: action.education,
      income: action.income,
      isManglik: action.isManglik,
      isIntercaste: action.isIntercaste,
      isDisabled: action.isDisabled,
      hasPhoto: action.hasPhoto,
      recentlyJoined: action.recentlyJoined,
    );
  }

  if (action is SearchClearFiltersAction) {
    var newState = BasicSearchState.initialState();
    // Keep responses but clear values
    return newState;
  }

  // Sanket: Handle restored actions
  if (action is BasicSearchReligionAdd) {
    return addReligionValue(state!, action);
  }

  if (action is BasicSearchMotherTongueAdd) {
    return addMotherTongue(state!, action);
  }

  if (action == BasicSearchRemove.motherTongueClear) {
    return basic_search_mother_tongue_clear(state!, action);
  }
  if (action == BasicSearchRemove.religionClear) {
    return basic_search_religion_clear(state!, action);
  }

  return state;
}

BasicSearchState addReligionValue(BasicSearchState state, BasicSearchReligionAdd action) {
  return state.copyWith(religion_value: action.value);
}

BasicSearchState addMotherTongue(BasicSearchState state, BasicSearchMotherTongueAdd action) {
  return state.copyWith(mother_tongue: action.value);
}

BasicSearchState basic_search_mother_tongue_clear(BasicSearchState state, dynamic action) {
  return state.copyWith(mother_tongue: null);
}

BasicSearchState basic_search_religion_clear(BasicSearchState state, dynamic action) {
  return state.copyWith(religion_value: null);
}

/// empty caste value
BasicSearchState empty_caste(BasicSearchState state, SearchEmptyCaste action) {
  return state.copyWith(
    casteResponse: CasteResponse(data: []),
    caste_value: null,
  );
}

BasicSearchState empty_sub_caste(BasicSearchState state, SearchEmptySubCaste action) {
  return state.copyWith(
    subcasteResponse: SubcasteResponse(data: []),
    sub_caste_value: null,
  );
}

BasicSearchState empty_state(BasicSearchState state, SearchEmptyState action) {
  return state.copyWith(
    stateResponse: ds.StateResponse(data: []),
    state_value: null,
  );
}

BasicSearchState empty_city(BasicSearchState state, SearchEmptyCity action) {
  return state.copyWith(
    cityResponse: dc.CityResponse(data: []),
    city_value: null,
  );
}

///-----------------------------------------------------------------------------

BasicSearchState caste_response(BasicSearchState state, CasteResponse action) {
  return state.copyWith(casteResponse: action);
}

BasicSearchState sub_caste_response(BasicSearchState state, SubcasteResponse action) {
  return state.copyWith(subcasteResponse: action);
}

BasicSearchState state_response(BasicSearchState state, SearchGetStateValueAction action) {
  return state.copyWith(stateResponse: ds.StateResponse(data: action.data));
}

BasicSearchState city_response(BasicSearchState state, SearchGetCityValueAction action) {
  return state.copyWith(cityResponse: dc.CityResponse(data: action.data));
}

///classes
