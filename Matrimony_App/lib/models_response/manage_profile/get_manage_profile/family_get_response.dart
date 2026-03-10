// To parse this JSON data, do
//
//     final familyGetResponse = familyGetResponseFromJson(jsonString);

import 'dart:convert';

FamilyGetResponse familyGetResponseFromJson(String str) =>
    FamilyGetResponse.fromJson(json.decode(str));

String familyGetResponseToJson(FamilyGetResponse data) =>
    json.encode(data.toJson());

class FamilyGetResponse {
  FamilyGetResponse({this.data, this.result, this.message});

  FamilyData? data;
  bool? result;

  String? message;

  factory FamilyGetResponse.fromJson(Map<String, dynamic> json) =>
      FamilyGetResponse(
        data: json["data"] == null ? null : FamilyData.fromJson(json["data"]),
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "result": result,
    "message": message,
  };
}

class FamilyData {
  FamilyData({this.father, this.mother, this.sibling});

  String? father;
  String? mother;
  String? sibling;

  factory FamilyData.fromJson(Map<String, dynamic> json) => FamilyData(
    father: json["father"],
    mother: json["mother"],
    sibling: json["sibling"],
  );

  Map<String, dynamic> toJson() => {
    "father": father,
    "mother": mother,
    "sibling": sibling,
  };
}
