// To parse this JSON data, do
//
//     final basicInfoGetResponse = basicInfoGetResponseFromJson(jsonString);

import 'dart:convert';

BasicInfoGetResponse basicInfoGetResponseFromJson(String str) =>
    BasicInfoGetResponse.fromJson(json.decode(str));

String basicInfoGetResponseToJson(BasicInfoGetResponse data) =>
    json.encode(data.toJson());

class BasicInfoGetResponse {
  BasicInfoGetResponse({this.data, this.result});

  BasicInfoData? data;
  bool? result;

  factory BasicInfoGetResponse.fromJson(Map<String, dynamic> json) =>
      BasicInfoGetResponse(
        data: json["data"] == null ? null : BasicInfoData.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "result": result
  };
}

class BasicInfoData {
  BasicInfoData({
    this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.onbehalf,
    this.noOfChildren,
    this.gender,
    this.phone,
    this.maritialStatus,
    this.religionId,
    this.religion,
    this.casteId,
    this.caste,
    this.photo,
  });

  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? dateOfBirth;
  dynamic onbehalf;
  dynamic noOfChildren;
  dynamic gender;
  dynamic phone;
  dynamic maritialStatus;
  int? religionId;
  String? religion;
  int? casteId;
  String? caste;
  dynamic photo;

  factory BasicInfoData.fromJson(Map<String, dynamic> json) => BasicInfoData(
        firstName: json["first_name"] ?? json["firs_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.tryParse(json["date_of_birth"]),
        onbehalf: json["onbehalf"] == null ? null : Onbehalf.fromJson(json["onbehalf"]),
        noOfChildren: json["no_of_children"]?.toString(),
        gender: json["gender"]?.toString(),
        phone: json["phone"]?.toString(),
        maritialStatus: json["maritial_status"]?.toString(),
        religionId: json["religion_id"] == null || json["religion_id"].toString().isEmpty
            ? null
            : int.tryParse(json["religion_id"].toString()),
        religion: json["religion"],
        casteId: json["caste_id"] == null || json["caste_id"].toString().isEmpty
            ? null
            : int.tryParse(json["caste_id"].toString()),
        caste: json["caste"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "firs_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "onbehalf": onbehalf?.toJson(),
        "no_of_children": noOfChildren,
        "gender": gender,
        "phone": phone,
        "maritial_status": maritialStatus,
        "religion_id": religionId,
        "religion": religion,
        "caste_id": casteId,
        "caste": caste,
        "photo": photo,
      };
}

class Onbehalf {
  Onbehalf({this.id, this.name});

  int? id;
  String? name;

  factory Onbehalf.fromJson(Map<String, dynamic> json) =>
      Onbehalf(
        id: json["id"] == null || json["id"].toString().isEmpty ? null : int.tryParse(json["id"].toString()), 
        name: json["name"]
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
