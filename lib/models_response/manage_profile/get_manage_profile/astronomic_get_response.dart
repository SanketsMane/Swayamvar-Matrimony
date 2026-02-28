// To parse this JSON data, do
//
//     final astronomicGetResponse = astronomicGetResponseFromJson(jsonString);

import 'dart:convert';

AstronomicGetResponse astronomicGetResponseFromJson(String str) =>
    AstronomicGetResponse.fromJson(json.decode(str));

String astronomicGetResponseToJson(AstronomicGetResponse data) =>
    json.encode(data.toJson());

class AstronomicGetResponse {
  AstronomicGetResponse({this.data, this.result});

  Data? data;
  bool? result;

  factory AstronomicGetResponse.fromJson(Map<String, dynamic> json) =>
      AstronomicGetResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};

  AstronomicGetResponse.initialState()
    : data = Data.initialState(),
      result = false;
}

class Data {
  Data({this.sunSign, this.moonSign, this.timeOfBirth, this.cityOfBirth});

  String? sunSign;
  String? moonSign;
  var timeOfBirth;
  var cityOfBirth;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sunSign: json["sun_sign"],
    moonSign: json["moon_sign"],
    timeOfBirth: json["time_of_birth"],
    cityOfBirth: json["city_of_birth"],
  );

  Map<String, dynamic> toJson() => {
    "sun_sign": sunSign,
    "moon_sign": moonSign,
    "time_of_birth": timeOfBirth,
    "city_of_birth": cityOfBirth,
  };

  Data.initialState()
    : sunSign = '',
      moonSign = '',
      timeOfBirth = '',
      cityOfBirth = '';
}
