// To parse this JSON data, do
//
//     final partnerExpectationGetResponse = partnerExpectationGetResponseFromJson(jsonString);

import 'dart:convert';

PartnerExpectationGetResponse partnerExpectationGetResponseFromJson(
  String str,
) => PartnerExpectationGetResponse.fromJson(json.decode(str));

String partnerExpectationGetResponseToJson(
  PartnerExpectationGetResponse data,
) => json.encode(data.toJson());

class PartnerExpectationGetResponse {
  PartnerExpectationGetResponse({this.data, this.result});

  Data? data;
  bool? result;

  factory PartnerExpectationGetResponse.fromJson(Map<String, dynamic> json) =>
      PartnerExpectationGetResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};

  PartnerExpectationGetResponse.initialState() : data = Data.initialState();
}

class Data {
  Data({
    this.general,
    this.height,
    this.weight,
    this.maritalStatusId,
    this.childrenAcceptable,
    this.residenceCountryId,
    this.religionId,
    this.religion,
    this.casteId,
    this.caste,
    this.subCasteId,
    this.subCaste,
    this.education,
    this.profession,
    this.smokingAcceptable,
    this.drinkingAcceptable,
    this.diet,
    this.bodyType,
    this.personalValue,
    this.manglik,
    this.languageId,
    this.familyValueId,
    this.preferredCountryId,
    this.preferredStateId,
    this.complexion,
    this.expectedIncome,
    this.partnerIntercaste,
  });

  String? general;
  dynamic height;
  dynamic weight;
  dynamic maritalStatusId;
  String? childrenAcceptable;
  String? residenceCountryId;
  String? religionId;
  String? religion;
  String? casteId;
  String? caste;
  String? subCasteId;
  String? subCaste;
  dynamic education;
  dynamic profession;
  String? smokingAcceptable;
  String? drinkingAcceptable;
  dynamic diet;
  dynamic bodyType;
  dynamic personalValue;
  dynamic manglik;
  dynamic languageId;
  String? familyValueId;
  String? preferredCountryId;
  String? preferredStateId;
  dynamic complexion;
  dynamic expectedIncome;
  dynamic partnerIntercaste;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    general: json["general"] ?? json["general_info"],
    height: json["height"],
    weight: json["weight"],
    maritalStatusId: json["marital_status"] ?? json["partner_marital_status"],
    childrenAcceptable: json["children_acceptable"] ?? json["partner_children_acceptable"],
    residenceCountryId: json["residence_country_id"],
    religionId: json["religion_id"]?.toString() ?? json["partner_religion_id"]?.toString(),
    religion: json["religion"],
    casteId: json["caste_id"]?.toString() ?? json["partner_caste_id"]?.toString(),
    caste: json["caste"],
    subCasteId: json["sub_caste_id"]?.toString() ?? json["partner_sub_caste_id"]?.toString(),
    subCaste: json["sub_caste"],
    education: json["education"] ?? json["expected_education"] ?? json["pertner_education"],
    profession: json["profession"],
    smokingAcceptable: json["smoking_acceptable"],
    drinkingAcceptable: json["drinking_acceptable"],
    diet: json["diet"],
    bodyType: json["body_type"],
    personalValue: json["personal_value"],
    manglik: json["manglik"] ?? json["partner_manglik"],
    languageId: json["language"],
    familyValueId: json["family_value_id"],
    preferredCountryId: json["preferred_country_id"],
    preferredStateId: json["preferred_state_id"],
    complexion: json["complexion"],
    expectedIncome: json["expected_income"] ?? json["partner_income"],
    partnerIntercaste: json["partner_intercaste"] ?? json["intercaste"],
  );

  Map<String, dynamic> toJson() => {
    "general": general,
    "height": height,
    "weight": weight,
    "marital_status": maritalStatusId,
    "children_acceptable": childrenAcceptable,
    "residence_country_id": residenceCountryId,
    "religion_id": religionId,
    "religion": religion,
    "caste_id": casteId,
    "caste": caste,
    "sub_caste_id": subCasteId,
    "sub_caste": subCaste,
    "education": education,
    "profession": profession,
    "smoking_acceptable": smokingAcceptable,
    "drinking_acceptable": drinkingAcceptable,
    "diet": diet,
    "body_type": bodyType,
    "personal_value": personalValue,
    "manglik": manglik,
    "language": languageId,
    "family_value_id": familyValueId,
    "preferred_country_id": preferredCountryId,
    "preferred_state_id": preferredStateId,
    "complexion": complexion,
    "expected_income": expectedIncome,
    "partner_intercaste": partnerIntercaste,
  };

  Data.initialState()
    : general = '',
      height = '',
      weight = '',
      maritalStatusId = '',
      childrenAcceptable = '',
      residenceCountryId = '',
      religionId = '',
      religion = '',
      casteId = '',
      caste = '',
      subCasteId = '',
      subCaste = '',
      education = '',
      profession = '',
      smokingAcceptable = '',
      drinkingAcceptable = '',
      diet = '',
      bodyType = '',
      personalValue = '',
      manglik = '',
      languageId = '',
      preferredCountryId = '',
      preferredStateId = '',
      complexion = '',
      expectedIncome = '',
      partnerIntercaste = '';
}
