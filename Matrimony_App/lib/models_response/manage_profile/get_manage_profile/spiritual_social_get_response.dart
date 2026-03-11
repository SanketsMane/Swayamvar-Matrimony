// To parse this JSON data, do
//
//     final spiritualSocialGetResponse = spiritualSocialGetResponseFromJson(jsonString);

import 'dart:convert';

SpiritualSocialGetResponse spiritualSocialGetResponseFromJson(String str) =>
    SpiritualSocialGetResponse.fromJson(json.decode(str));

String spiritualSocialGetResponseToJson(SpiritualSocialGetResponse data) =>
    json.encode(data.toJson());

class SpiritualSocialGetResponse {
  SpiritualSocialGetResponse({this.data, this.result});

  Data? data;
  bool? result;

  factory SpiritualSocialGetResponse.fromJson(Map<String, dynamic> json) =>
      SpiritualSocialGetResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};

  SpiritualSocialGetResponse.initialState()
    : data = Data.initialState(),
      result = false;
}

class Data {
  Data({
    this.religionId,
    this.casteId,
    this.subCasteId,
    this.ethnicity,
    this.personalValue,
    this.familyValueId,
    this.communityValue,
    this.manglik,
    this.intercaste,
  });

  String? religionId;
  String? casteId;
  String? subCasteId;
  dynamic ethnicity;
  dynamic personalValue;
  String? familyValueId;
  dynamic communityValue;
  dynamic manglik;
  dynamic intercaste;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        religionId: json["religion_id"]?.toString(),
        casteId: json["caste_id"]?.toString(),
        subCasteId: json["sub_caste_id"]?.toString(),
        ethnicity: json["ethnicity"],
        personalValue: json["personal_value"],
        familyValueId: json["family_value_id"]?.toString(),
        communityValue: json["community_value"],
        manglik: json["manglik"],
        intercaste: json["intercaste"],
      );

  Map<String, dynamic> toJson() => {
        "religion_id": religionId,
        "caste_id": casteId,
        "sub_caste_id": subCasteId,
        "ethnicity": ethnicity,
        "personal_value": personalValue,
        "family_value_id": familyValueId,
        "community_value": communityValue,
        "manglik": manglik,
        "intercaste": intercaste,
      };

  Data.initialState()
      : religionId = '',
        casteId = '',
        subCasteId = '',
        ethnicity = '',
        personalValue = '',
        familyValueId = '',
        manglik = '',
        intercaste = '',
        communityValue = '';
}
