import 'package:active_matrimonial_flutter_app/models_response/drop_down/caste.dart';
import 'package:active_matrimonial_flutter_app/models_response/drop_down/state.dart';
import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/partner_expectation_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/partner_expectation_state.dart';
import 'partner_expectation_action.dart';

PartnerExpectationState? partner_expectation_reducer(
  PartnerExpectationState? state,
  dynamic action,
) {
  if (action is Pexloader) {
    return pex_loader_toggler(state!, action);
  }
  if (action is Pexsave) {
    return pex_save_toggler(state!, action.loaderValue);
  }
  if (action is CasteResponseForPartnerPref) {
    return pex_caste_response(state!, action);
  }
  if (action is PartnerPrefSubCasteResponse) {
    return pex_sub_caste_response(state!, action);
  }
  if (action is StateResponseFromPartnerPref) {
    return pex_state_response(state!, action);
  }

  if (action is PartnerExpectationGetResponse) {
    return pex_partnerexpectation_get_response(state!, action);
  }

  if (action is PexReligionAddValueAction) {
    return pex_add_religion(state!, action);
  }

  if (action is PexCasteAddValueAction) {
    return pex_add_caste(state!, action);
  }
  if (action is PexSubCasteAddValueAction) {
    pex_add_sub_caste(state!, action);
  }

  if (action is PexEmptyCaste) {
    return pex_caste_list_clear(state!, action);
  }
  if (action is PexEmptySubCaste) {
    return pex_sub_caste_list_clear(state!, action);
  }
  if (action is PexPreferredCountryAddValueAction) {
    return pex_add_preferred_country(state!, action);
  }
  if (action is PexPreferredStateAddValueAction) {
    pex_add_preferred_state(state!, action);
  }
  if (action is PexEmptyPreferredState) {
    pex_state_state_list_clear(state!, action);
  }

  if (action is PexManglikAddValueAction) {
    return pex_add_manglik(state!, action);
  }
  if (action is PexResidencyCountryAddValueAction) {
    return pex_add_residency_country(state!, action);
  }
  if (action is PexMaritalStatusAddValueAction) {
    return pex_marital_status_value_add(state!, action);
  }
  return state;
}

PartnerExpectationState pex_marital_status_value_add(
  PartnerExpectationState state,
  PexMaritalStatusAddValueAction action,
) {
  state.martial_status_val = action.value;
  return state;
}

PartnerExpectationState pex_add_residency_country(
  PartnerExpectationState state,
  PexResidencyCountryAddValueAction action,
) {
  state.residency_country_val = action.value;
  return state;
}

PartnerExpectationState pex_add_manglik(
  PartnerExpectationState state,
  PexManglikAddValueAction action,
) {
  state.manglik_val = action.value;
  return state;
}

PartnerExpectationState pex_state_state_list_clear(
  PartnerExpectationState state,
  PexEmptyPreferredState action,
) {
  state.stateResponse!.data!.clear();
  state.preferred_state = null;
  return state;
}

PartnerExpectationState pex_add_preferred_state(
  PartnerExpectationState state,
  PexPreferredStateAddValueAction action,
) {
  state.preferred_state = action.value;

  return state;
}

PartnerExpectationState pex_add_preferred_country(
  PartnerExpectationState state,
  PexPreferredCountryAddValueAction action,
) {
  state.preferred_country = action.value;
  return state;
}

PartnerExpectationState pex_sub_caste_list_clear(
  PartnerExpectationState state,
  PexEmptySubCaste action,
) {
  state.subcasteResponse!.data!.clear();
  state.sub_caste_val = null;
  return state;
}

PartnerExpectationState pex_caste_list_clear(PartnerExpectationState state, PexEmptyCaste action) {
  state.casteResponse!.data!.clear();
  state.caste_val = null;
  return state;
}

PartnerExpectationState pex_add_religion(
  PartnerExpectationState state,
  PexReligionAddValueAction action,
) {
  state.religion_val = action.value;
  return state;
}

PartnerExpectationState pex_add_caste(PartnerExpectationState state, PexCasteAddValueAction action) {
  state.caste_val = action.value;
  return state;
}

PartnerExpectationState pex_add_sub_caste(
  PartnerExpectationState state,
  PexSubCasteAddValueAction action,
) {
  state.sub_caste_val = action.value;
  return state;
}

PartnerExpectationState pex_partnerexpectation_get_response(
  PartnerExpectationState state,
  PartnerExpectationGetResponse action,
) {
  // print(state.partnerExpectationGetResponse?.data?.toJson());
  state.partnerExpectationGetResponse!.data = action.data;
  state.general_requirement_controller.text =
      state.partnerExpectationGetResponse!.data!.general!;
  state.min_height_controller.text =
      "${state.partnerExpectationGetResponse!.data!.height ?? ''}";
  state.max_weight_controller.text =
      "${state.partnerExpectationGetResponse!.data!.weight ?? ''}";
  state.education_controller.text =
      "${state.partnerExpectationGetResponse!.data!.education ?? ''}";
  state.profession_controller.text =
      "${state.partnerExpectationGetResponse!.data!.profession ?? ''}";
  state.personal_value_controller.text =
      "${state.partnerExpectationGetResponse!.data!.personalValue ?? ''}";
  state.complexion_controller.text =
      "${state.partnerExpectationGetResponse!.data!.complexion ?? ''}";
  state.body_controller.text =
      "${state.partnerExpectationGetResponse!.data!.bodyType ?? ''}";
  // Sanket: Mapping now handled in partnerExpectationGetMiddleware.
  // pexprofile_drop_down_response(state);
  //store.dispatch(profiledropdownMiddleware());

  // state.preferred_country= DDown(id: 0,name: "Bangladesh");

  return state;
}

PartnerExpectationState pex_state_response(
  PartnerExpectationState state,
  StateResponseFromPartnerPref action,
) {
  state.stateResponse!.data!.addAll(action.data!);

  state.preferred_state = state.stateResponse!.data!.first;
  if (state.partnerExpectationGetResponse!.data?.preferredStateId != null) {
    for (var element in state.stateResponse!.data!) {
      if (element.name ==
          state.partnerExpectationGetResponse!.data!.preferredStateId) {
        state.preferred_state = element;
      }
    }
  }

  return state;
}

PartnerExpectationState pex_sub_caste_response(
  PartnerExpectationState state,
  PartnerPrefSubCasteResponse action,
) {
  // print("PartnerPrefSubCasteResponse");
  state.subcasteResponse!.data!.clear();
  state.sub_caste_val = null;

  state.subcasteResponse!.data!.addAll(action.data!);
  if (state.subcasteResponse!.data != null) {
    state.sub_caste_val = state.subcasteResponse!.data!.first;
    if (state.partnerExpectationGetResponse!.data?.subCasteId != null) {
      for (var element in state.subcasteResponse!.data!) {
        if (element.name ==
            state.partnerExpectationGetResponse!.data!.subCasteId) {
          state.sub_caste_val = element;
        }
      }
    }
  }
  return state;
}

PartnerExpectationState pex_caste_response(
  PartnerExpectationState state,
  CasteResponseForPartnerPref action,
) {
  state.casteResponse!.data!.clear();

  state.casteResponse!.data!.addAll(action.data!);

  if (state.casteResponse!.data != null &&
      state.casteResponse!.data!.isNotEmpty) {
    state.caste_val = state.casteResponse!.data!.first;
    if (state.partnerExpectationGetResponse!.data?.casteId != null) {
      for (var element in state.casteResponse!.data!) {
        if (element.name ==
            state.partnerExpectationGetResponse!.data!.casteId) {
          state.caste_val = element;
        }
      }
    }
    // Sanket: Side effect removed from reducer.
    // store.dispatch(subcasteMiddleware(...)) moved to middleware.
  }
  return state;
}

PartnerExpectationState pex_save_toggler(PartnerExpectationState state, bool value) {
  state.partner_expectation_save_changes =
      !state.partner_expectation_save_changes!;
  return state;
}

PartnerExpectationState pex_loader_toggler(PartnerExpectationState state, Pexloader action) {
  state.isloading = !state.isloading!;
  return state;
}

PartnerExpectationState pexprofile_drop_down_response(
  PartnerExpectationState state,
  dynamic dropdownData,
) {
  // Sanket: Direct store access removed. Dropdown data passed as argument.

  if (state.partnerExpectationGetResponse!.data?.residenceCountryId != null &&
      dropdownData?.countryList != null) {
    for (var element in dropdownData.countryList!) {
      if (element.name ==
          state.partnerExpectationGetResponse!.data!.residenceCountryId) {
        state.residency_country_val = element;
      }
    }
  }

  if (state.partnerExpectationGetResponse!.data?.maritalStatusId != null &&
      dropdownData?.maritialStatus != null) {
    for (var element in dropdownData.maritialStatus!) {
      if (element.name ==
          state.partnerExpectationGetResponse!.data!.maritalStatusId) {
        state.martial_status_val = element;
      }
    }
  }

  state.children_value = state.commonYesNoList.first;

  if (state.partnerExpectationGetResponse!.data?.childrenAcceptable != null) {
    for (var element in state.commonYesNoList) {
      if (element.key ==
          state.partnerExpectationGetResponse!.data!.childrenAcceptable) {
        state.children_value = element;
      }
    }
  }

  if (state.partnerExpectationGetResponse!.data?.religionId != null &&
      dropdownData?.religionList != null) {
    for (var element in dropdownData.religionList!) {
      if (element.name ==
          state.partnerExpectationGetResponse!.data!.religionId) {
        state.religion_val = element;
        // Sanket: Side effect removed from here.
        // store.dispatch(casteMiddleware(...)) handled in middleware.
      }
    }
  }

  if (state.partnerExpectationGetResponse!.data?.languageId != null &&
      dropdownData?.languageList != null) {
    for (var element in dropdownData.languageList!) {
      if (element.name ==
          state.partnerExpectationGetResponse!.data!.languageId) {
        state.language_value = element;
      }
    }
  }

  state.smoking_value = state.commonYesNoList.first;
  if (state.partnerExpectationGetResponse!.data?.smokingAcceptable != null) {
    for (var element in state.commonYesNoList) {
      if (element.key ==
          state.partnerExpectationGetResponse!.data!.smokingAcceptable) {
        state.smoking_value = element;
      }
    }
  }

  state.drinking_value = state.commonYesNoList.first;
  if (state.partnerExpectationGetResponse!.data?.drinkingAcceptable != null) {
    for (var element in state.commonYesNoList) {
      if (element.key ==
          state.partnerExpectationGetResponse!.data!.drinkingAcceptable) {
        state.drinking_value = element;
      }
    }
  }
  state.diet_value = state.commonYesNoList.first;
  if (state.partnerExpectationGetResponse!.data?.diet != null) {
    for (var element in state.commonYesNoList) {
      if (element.key == state.partnerExpectationGetResponse!.data!.diet) {
        state.diet_value = element;
      }
    }
  }
  state.manglik_val = state.commonYesNoList.first;
  if (state.partnerExpectationGetResponse!.data?.manglik != null) {
    for (var element in state.commonYesNoList) {
      if (element.key == state.partnerExpectationGetResponse!.data!.manglik) {
        state.manglik_val = element;
      }
    }
  }

  if (state.partnerExpectationGetResponse!.data?.preferredCountryId != null &&
      dropdownData?.countryList != null) {
    for (var element in dropdownData.countryList!) {
      if (element.name ==
          state.partnerExpectationGetResponse!.data!.preferredCountryId) {
        state.preferred_country = element;
        // Sanket: Side effect removed from here.
        // store.dispatch(stateMiddleware(...)) handled in middleware.
      }
    }
  }

  if (state.partnerExpectationGetResponse!.data?.familyValueId != null &&
      dropdownData?.familyValueList != null) {
    for (var element in dropdownData.familyValueList!) {
      if (element.name ==
          state.partnerExpectationGetResponse!.data!.familyValueId) {
        state.family_value = element;
      }
    }
  }

  return state;
}
