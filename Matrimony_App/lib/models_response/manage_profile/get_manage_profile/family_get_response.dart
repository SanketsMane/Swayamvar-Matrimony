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
  FamilyData({
    this.father,
    this.mother,
    this.sibling,
    this.noOfBrothers,
    this.marriedBrothers,
    this.noOfSisters,
    this.marriedSisters,
    this.parentsOccupation,
    this.propertyDetails,
  });

  String? father;
  String? mother;
  String? sibling;
  dynamic noOfBrothers;
  dynamic marriedBrothers;
  dynamic noOfSisters;
  dynamic marriedSisters;
  String? parentsOccupation;
  String? propertyDetails;

  factory FamilyData.fromJson(Map<String, dynamic> json) => FamilyData(
        father: json["father"],
        mother: json["mother"],
        sibling: json["sibling"],
        noOfBrothers: json["no_of_brothers"],
        marriedBrothers: json["married_brothers"],
        noOfSisters: json["no_of_sisters"],
        marriedSisters: json["married_sisters"],
        parentsOccupation: json["parents_occupation"],
        propertyDetails: json["property_details"],
      );

  Map<String, dynamic> toJson() => {
        "father": father,
        "mother": mother,
        "sibling": sibling,
        "no_of_brothers": noOfBrothers,
        "married_brothers": marriedBrothers,
        "no_of_sisters": noOfSisters,
        "married_sisters": marriedSisters,
        "parents_occupation": parentsOccupation,
        "property_details": propertyDetails,
      };
}
