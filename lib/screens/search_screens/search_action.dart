import 'package:active_matrimonial_flutter_app/models_response/search/basic_search_response.dart';

import '../../models_response/common_models/ddown.dart';

class SearchStoreAction {
  BasicSearchResponse? payload;

  SearchStoreAction({this.payload});

  @override
  String toString() {
    return 'SearchStoreAction{payload: $payload}';
  }
}

class SearchFailureAction {
  String? error;

  SearchFailureAction({this.error});

  @override
  String toString() {
    return 'SearchFailureAction{error: $error}';
  }
}

/// classes

class SearchGetStateValueAction {
  List<DDown>? data;

  SearchGetStateValueAction(this.data);
}

class SearchGetCityValueAction {
  List<DDown>? data;

  SearchGetCityValueAction(this.data);
}

class SearchAddCasteValueAction {
  var value;

  SearchAddCasteValueAction({this.value});
}

class SearchAddReligionValueAction {
  var value;

  SearchAddReligionValueAction({this.value});
}

class SearchAddSubCasteValueAction {
  var value;

  SearchAddSubCasteValueAction({this.value});
}

class SearchCountryAddValueAction {
  var value;

  SearchCountryAddValueAction({this.value});
}

class SearchStateAddValueAction {
  var value;

  SearchStateAddValueAction({this.value});
}

class SearchCityAddValueAction {
  var value;

  SearchCityAddValueAction({this.value});
}

class SearchEmptyCaste {}

class SearchEmptySubCaste {}

class SearchEmptyState {}

class SearchEmptyCity {}

class SearchSetFiltersAction {
  final double? minAge;
  final double? maxAge;
  final dynamic religion;
  final dynamic caste;
  final dynamic maritalStatus;
  final dynamic country;
  final dynamic state;
  final dynamic city;
  final List<String>? quickFilters;
  final String? diet;
  final String? smoking;
  final String? drinking;
  final String? searchText;

  SearchSetFiltersAction({
    this.minAge,
    this.maxAge,
    this.religion,
    this.caste,
    this.maritalStatus,
    this.country,
    this.state,
    this.city,
    this.quickFilters,
    this.diet,
    this.smoking,
    this.drinking,
    this.searchText,
    this.education,
    this.income,
    this.isManglik,
    this.isIntercaste,
    this.isDisabled,
    this.hasPhoto,
    this.recentlyJoined,
  });

  final dynamic education;
  final dynamic income;
  final bool? isManglik;
  final bool? isIntercaste;
  final bool? isDisabled;
  final bool? hasPhoto;
  final bool? recentlyJoined;
}

class SearchSaveAdvancedFiltersAction {
  final double? minAge;
  final double? maxAge;
  final dynamic religion;
  final dynamic caste;
  final dynamic maritalStatus;
  final dynamic country;
  final dynamic state;
  final dynamic city;
  final List<String>? quickFilters;
  final dynamic education;
  final dynamic income;
  final bool? isManglik;
  final bool? isIntercaste;
  final bool? isDisabled;
  final bool? hasPhoto;
  final bool? recentlyJoined;

  SearchSaveAdvancedFiltersAction({
    this.minAge,
    this.maxAge,
    this.religion,
    this.caste,
    this.maritalStatus,
    this.country,
    this.state,
    this.city,
    this.quickFilters,
    this.education,
    this.income,
    this.isManglik,
    this.isIntercaste,
    this.isDisabled,
    this.hasPhoto,
    this.recentlyJoined,
  });
}

class SearchClearFiltersAction {}

class BasicSearchReligionAdd {
  final dynamic value;
  BasicSearchReligionAdd({this.value});
}

class BasicSearchMotherTongueAdd {
  final dynamic value;
  BasicSearchMotherTongueAdd({this.value});
}

enum BasicSearchRemove { motherTongueClear, religionClear }

// author: Sanket
