import 'package:active_matrimonial_flutter_app/models_response/common_models/ddown.dart';

// Sanket: Actions separated to break circular dependencies
class Pexloader {}

class Pexsave {
  bool loaderValue;
  Pexsave(this.loaderValue);
}

class PexReligionAddValueAction {
  var value;
  PexReligionAddValueAction({this.value});
}

class PexCasteAddValueAction {
  var value;
  PexCasteAddValueAction({this.value});
}

class PexSubCasteAddValueAction {
  var value;
  PexSubCasteAddValueAction({this.value});
}

class PexPreferredCountryAddValueAction {
  var value;
  PexPreferredCountryAddValueAction({this.value});
}

class PexPreferredStateAddValueAction {
  var value;
  PexPreferredStateAddValueAction({this.value});
}

class PexManglikAddValueAction {
  var value;
  PexManglikAddValueAction({this.value});
}

class PexResidencyCountryAddValueAction {
  var value;
  PexResidencyCountryAddValueAction({this.value});
}

class PexMaritalStatusAddValueAction {
  var value;
  PexMaritalStatusAddValueAction({this.value});
}

class PexEmptyCaste {}

class PexEmptySubCaste {}

class PexEmptyPreferredState {}

class PartnerPrefInitValue {}

class PartnerPrefSubCasteResponse {
  List<DDown>? data;
  PartnerPrefSubCasteResponse({this.data});
}
