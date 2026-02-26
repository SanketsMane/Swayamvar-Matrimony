// To parse this JSON data, do
//
//     final physicalAttributesGetResponse = physicalAttributesGetResponseFromJson(jsonString);

import 'dart:convert';

PhysicalAttributesGetResponse physicalAttributesGetResponseFromJson(
        String str) =>
    PhysicalAttributesGetResponse.fromJson(json.decode(str));

String physicalAttributesGetResponseToJson(
        PhysicalAttributesGetResponse data) =>
    json.encode(data.toJson());

class PhysicalAttributesGetResponse {
  PhysicalAttributesGetResponse({this.data, this.result});

  PhysicalAttrData? data;
  bool? result;

  factory PhysicalAttributesGetResponse.fromJson(Map<String, dynamic> json) =>
      PhysicalAttributesGetResponse(
        data: json["data"] == null
            ? null
            : PhysicalAttrData.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "result": result,
      };
}

class PhysicalAttrData {
  PhysicalAttrData({
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
    this.complexion,
    this.bloodGroup,
    this.bodyType,
    this.bodyArt,
    this.disability,
  });

  double? height;
  int? weight;
  String? eyeColor;
  String? hairColor;
  String? complexion;
  String? bloodGroup;
  String? bodyType;
  String? bodyArt;
  String? disability;

  factory PhysicalAttrData.fromJson(Map<String, dynamic> json) =>
      PhysicalAttrData(
        height: json["height"]?.toDouble(),
        weight: json["weight"],
        eyeColor: json["eye_color"],
        hairColor: json["hair_color"],
        complexion: json["complexion"],
        bloodGroup: json["blood_group"],
        bodyType: json["body_type"],
        bodyArt: json["body_art"],
        disability: json["disability"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "weight": weight,
        "eye_color": eyeColor,
        "hair_color": hairColor,
        "complexion": complexion,
        "blood_group": bloodGroup,
        "body_type": bodyType,
        "body_art": bodyArt,
        "disability": disability,
      };
}
