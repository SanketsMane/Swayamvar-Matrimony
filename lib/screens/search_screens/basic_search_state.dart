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
  double? minHeight;
  double? maxHeight;
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
        (minHeight != null && minHeight != 5.0) ||
        (maxHeight != null && maxHeight != 6.2) ||
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
