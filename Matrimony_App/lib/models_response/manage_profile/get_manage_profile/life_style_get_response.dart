// To parse this JSON data, do
//
//     final lifeStyleGetResponse = lifeStyleGetResponseFromJson(jsonString);

import 'dart:convert';

LifeStyleGetResponse lifeStyleGetResponseFromJson(String str) =>
    LifeStyleGetResponse.fromJson(json.decode(str));

String lifeStyleGetResponseToJson(LifeStyleGetResponse data) =>
    json.encode(data.toJson());

class LifeStyleGetResponse {
  LifeStyleGetResponse({this.data, this.result});

  Data? data;
  bool? result;

  factory LifeStyleGetResponse.fromJson(Map<String, dynamic> json) =>
      LifeStyleGetResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};

  LifeStyleGetResponse.initialState()
    : data = Data.initialState(),
      result = false;
}

class Data {
  Data({this.diet, this.drink, this.smoke, this.livingWith});

  String? diet;
  String? drink;
  String? smoke;
  String? livingWith;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    diet: json["diet"]?.toString(),
    drink: json["drink"]?.toString(),
    smoke: json["smoke"]?.toString(),
    livingWith: json["living_with"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "diet": diet,
    "drink": drink,
    "smoke": smoke,
    "living_with": livingWith,
  };

  Data.initialState() : diet = '', drink = '', smoke = '', livingWith = '';
}
