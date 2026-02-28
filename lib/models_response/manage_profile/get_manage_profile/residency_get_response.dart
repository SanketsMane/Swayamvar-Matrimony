// To parse this JSON data, do
//
//     final residencyGetResponse = residencyGetResponseFromJson(jsonString);

import 'dart:convert';

ResidencyGetResponse residencyGetResponseFromJson(String str) =>
    ResidencyGetResponse.fromJson(json.decode(str));

String residencyGetResponseToJson(ResidencyGetResponse data) =>
    json.encode(data.toJson());

class ResidencyGetResponse {
  ResidencyGetResponse({this.data, this.result});

  Data? data;
  bool? result;

  factory ResidencyGetResponse.fromJson(Map<String, dynamic> json) =>
      ResidencyGetResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};

  ResidencyGetResponse.initialState()
    : data = Data.initialState(),
      result = false;
}

class Data {
  Data({
    this.birthCountry,
    this.recidencyCountry,
    this.growupCountry,
    this.immigrationStatus,
  });

  String? birthCountry;
  String? recidencyCountry;
  String? growupCountry;
  String? immigrationStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    birthCountry: json["birth_country"],
    recidencyCountry: json["recidency_country"],
    growupCountry: json["growup_country"],
    immigrationStatus: json["immigration_status"],
  );

  Map<String, dynamic> toJson() => {
    "birth_country": birthCountry,
    "recidency_country": recidencyCountry,
    "growup_country": growupCountry,
    "immigration_status": immigrationStatus,
  };

  Data.initialState()
    : birthCountry = '',
      recidencyCountry = '',
      growupCountry = '',
      immigrationStatus = '';
}
