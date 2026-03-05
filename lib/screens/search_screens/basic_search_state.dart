import 'package:active_matrimonial_flutter_app/models_response/drop_down/caste.dart';
import 'package:active_matrimonial_flutter_app/models_response/drop_down/city.dart';
import 'package:active_matrimonial_flutter_app/models_response/drop_down/state.dart';
import 'package:active_matrimonial_flutter_app/models_response/drop_down/subcaste.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';

class BasicSearchState {
  bool? isFetching;
  List? searchList = [];
  String? error;

  final CasteResponse? casteResponse;
  final SubcasteResponse? subcasteResponse;
  final StateResponse? stateResponse;
  final CityResponse? cityResponse;

  var religion_value;
  var caste_value;
  var sub_caste_value;
  var country_value;
  var state_value;
  var city_value;
  var mother_tongue;
  var marital_status_value;

  // Sanket: Extended filter persistence
  double? minAge;
  double? maxAge;
  String? minHeight;
  String? maxHeight;
  List<String>? quickFilters;
  String? searchText;
  String? diet;
  String? smoking;
  String? drinking;

  // Sanket: Advanced filters
  dynamic education;
  dynamic income;
  bool? isManglik;
  bool? isIntercaste;
  bool? isDisabled;
  bool? hasPhoto;
  bool? recentlyJoined;

  bool? search_loader;

  // Sanket: Helper to detect if any filters are currently applied
  bool get isFilterActive {
    return (minAge != null && minAge != 21) ||
        (maxAge != null && maxAge != 40) ||
        (minHeight != null && minHeight != "5.0") ||
        (maxHeight != null && maxHeight != "6.2") ||
        (religion_value != null) ||
        (marital_status_value != null) ||
        (country_value != null) ||
        (state_value != null) ||
        (city_value != null) ||
        (caste_value != null) ||
        (mother_tongue != null) ||
        (quickFilters != null && quickFilters!.isNotEmpty) ||
        (searchText != null && searchText!.isNotEmpty) ||
        (diet != null && diet != "Veg") ||
        (smoking != null && smoking != "No") ||
        (drinking != null && drinking != "No") ||
        (education != null) ||
        (income != null) ||
        (isManglik == true) ||
        (isIntercaste == true) ||
        (isDisabled == true) ||
        (hasPhoto == true) ||
        (recentlyJoined == true);
  }

  BasicSearchState copyWith({
    bool? isFetching,
    List? searchList,
    String? error,
    CasteResponse? casteResponse,
    SubcasteResponse? subcasteResponse,
    StateResponse? stateResponse,
    CityResponse? cityResponse,
    dynamic religion_value,
    dynamic caste_value,
    dynamic sub_caste_value,
    dynamic country_value,
    dynamic state_value,
    dynamic city_value,
    dynamic mother_tongue,
    dynamic marital_status_value,
    double? minAge,
    double? maxAge,
    String? minHeight,
    String? maxHeight,
    List<String>? quickFilters,
    String? searchText,
    String? diet,
    String? smoking,
    String? drinking,
    dynamic education,
    dynamic income,
    bool? isManglik,
    bool? isIntercaste,
    bool? isDisabled,
    bool? hasPhoto,
    bool? recentlyJoined,
    bool? search_loader,
  }) {
    return BasicSearchState(
      isFetching: isFetching ?? this.isFetching,
      searchList: searchList ?? this.searchList,
      error: error ?? this.error,
      casteResponse: casteResponse ?? this.casteResponse,
      subcasteResponse: subcasteResponse ?? this.subcasteResponse,
      stateResponse: stateResponse ?? this.stateResponse,
      cityResponse: cityResponse ?? this.cityResponse,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      quickFilters: quickFilters ?? this.quickFilters,
      diet: diet ?? this.diet,
      smoking: smoking ?? this.smoking,
      drinking: drinking ?? this.drinking,
      searchText: searchText ?? this.searchText,
      education: education ?? this.education,
      income: income ?? this.income,
      isManglik: isManglik ?? this.isManglik,
      isIntercaste: isIntercaste ?? this.isIntercaste,
      isDisabled: isDisabled ?? this.isDisabled,
      hasPhoto: hasPhoto ?? this.hasPhoto,
      recentlyJoined: recentlyJoined ?? this.recentlyJoined,
    )
      ..religion_value = religion_value ?? this.religion_value
      ..caste_value = caste_value ?? this.caste_value
      ..sub_caste_value = sub_caste_value ?? this.sub_caste_value
      ..country_value = country_value ?? this.country_value
      ..state_value = state_value ?? this.state_value
      ..city_value = city_value ?? this.city_value
      ..mother_tongue = mother_tongue ?? this.mother_tongue
      ..marital_status_value = marital_status_value ?? this.marital_status_value
      ..search_loader = search_loader ?? this.search_loader;
  }

  BasicSearchState({
    this.casteResponse,
    this.subcasteResponse,
    this.stateResponse,
    this.cityResponse,
    this.isFetching,
    this.searchList,
    this.error,
    this.minAge = 21,
    this.maxAge = 40,
    this.quickFilters = const [],
    this.diet = "Veg",
    this.smoking = "No",
    this.drinking = "No",
    this.searchText = "",
    this.education,
    this.income,
    this.isManglik = false,
    this.isIntercaste = false,
    this.isDisabled = false,
    this.hasPhoto = false,
    this.recentlyJoined = false,
  });

  BasicSearchState.initialState()
    : casteResponse = CasteResponse.initialState(),
      isFetching = false,
      searchList = [],
      error = '',
      subcasteResponse = SubcasteResponse.initialState(),
      search_loader = false,
      stateResponse = StateResponse.initialState(),
      cityResponse = CityResponse.initialState(),
      minAge = 21,
      maxAge = 40,
      quickFilters = [],
      diet = "Veg",
      smoking = "No",
      drinking = "No",
      education = null,
      income = null,
      isManglik = false,
      isIntercaste = false,
      isDisabled = false,
      searchText = "",
      religion_value = SharedPref().advReligionId,
      caste_value = SharedPref().advCasteId,
      country_value = SharedPref().advCountryId,
      state_value = SharedPref().advStateId,
      city_value = SharedPref().advCityId,
      marital_status_value = SharedPref().advMaritalStatus;
}

// author: Sanket
