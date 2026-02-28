// To parse this JSON data, do
//
//     final basicSearchResponse = basicSearchResponseFromJson(jsonString);

import 'dart:convert';

BasicSearchResponse basicSearchResponseFromJson(String str) =>
    BasicSearchResponse.fromJson(json.decode(str));

String basicSearchResponseToJson(BasicSearchResponse data) =>
    json.encode(data.toJson());

class BasicSearchResponse {
  BasicSearchResponse({this.result, this.data});

  bool? result;
  Data? data;

  factory BasicSearchResponse.fromJson(Map<String, dynamic> json) =>
      BasicSearchResponse(
        result: json["result"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"result": result, "data": data?.toJson()};
}

class Data {
  Data({
    this.members,
    this.ageFrom,
    this.ageTo,
    this.memberCode,
    this.maritalStatus,
    this.religionId,
    this.casteId,
    this.subCasteId,
    this.motherTongue,
    this.profession,
    this.countryId,
    this.stateId,
    this.cityId,
    this.minHeight,
    this.maxHeight,
    this.memberType,
  });

  List<Member>? members;
  dynamic ageFrom;
  dynamic ageTo;
  dynamic memberCode;
  dynamic maritalStatus;
  dynamic religionId;
  dynamic casteId;
  dynamic subCasteId;
  dynamic motherTongue;
  dynamic profession;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic minHeight;
  dynamic maxHeight;
  dynamic memberType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    members:
        json["members"] == null
            ? null
            : List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
    ageFrom: json["age_from"],
    ageTo: json["age_to"],
    memberCode: json["member_code"],
    maritalStatus: json["marital_status"],
    religionId: json["religion_id"],
    casteId: json["caste_id"],
    subCasteId: json["sub_caste_id"],
    motherTongue: json["mother_tongue"],
    profession: json["profession"],
    countryId: json["country_id"],
    stateId: json["state_id"],
    cityId: json["city_id"],
    minHeight: json["min_height"],
    maxHeight: json["max_height"],
    memberType: json["member_type"],
  );

  Map<String, dynamic> toJson() => {
    "members":
        members == null
            ? null
            : List<dynamic>.from(members!.map((x) => x.toJson())),
    "age_from": ageFrom,
    "age_to": ageTo,
    "member_code": memberCode,
    "marital_status": maritalStatus,
    "religion_id": religionId,
    "caste_id": casteId,
    "sub_caste_id": subCasteId,
    "mother_tongue": motherTongue,
    "profession": profession,
    "country_id": countryId,
    "state_id": stateId,
    "city_id": cityId,
    "min_height": minHeight,
    "max_height": maxHeight,
    "member_type": memberType,
  };
}

class Member {
  Member({
    this.userId,
    this.code,
    this.membership,
    this.firstName,
    this.lastName,
    this.name,
    this.photo,
    this.age,
    this.country,
    this.height,
    this.religion,
    this.mothereTongue,
    this.maritalStatus,
    this.caste,
    this.packageUpdateAlert,
    this.interestStatus,
    this.interestText,
    this.shortlistStatus,
    this.shortlistText,
    this.reportStatus,
    this.profileViewRequestStatus,
    this.galleryViewRequestStatus,
  });

  int? userId;
  String? code;
  int? membership;
  String? firstName;
  String? lastName;
  String? name;
  String? photo;
  int? age;
  String? country;
  var height;
  String? religion;
  String? mothereTongue;
  String? maritalStatus;
  String? caste;
  bool? packageUpdateAlert;
  int? interestStatus;
  String? interestText;
  int? shortlistStatus;
  String? shortlistText;
  bool? reportStatus;
  bool? profileViewRequestStatus;
  bool? galleryViewRequestStatus;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    userId: json["user_id"],
    code: json["code"],
    membership: json["membership"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    name:
        json["name"] ??
        ((json["first_name"] ?? "") + " " + (json["last_name"] ?? "")).trim(),
    photo: json["photo"],
    age: json["age"],
    country: json["country"],
    height: json["height"],
    religion: json["religion"],
    mothereTongue: json["mothere_tongue"],
    maritalStatus: json["marital_status"],
    caste: json["caste"],
    packageUpdateAlert: json["package_update_alert"],
    interestStatus: json["interest_status"],
    interestText: json["interest_text"],
    shortlistStatus: json["shortlist_status"],
    shortlistText: json["shortlist_text"],
    reportStatus: json["report_status"],
    profileViewRequestStatus: json["profile_view_resquest_status"],
    galleryViewRequestStatus: json["gallery_view_resquest_status"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "code": code,
    "membership": membership,
    "first_name": firstName,
    "last_name": lastName,
    "name": name,
    "photo": photo,
    "age": age,
    "country": country,
    "height": height,
    "religion": religion,
    "mothere_tongue": mothereTongue,
    "marital_status": maritalStatus,
    "caste": caste,
    "package_update_alert": packageUpdateAlert,
    "interest_status": interestStatus,
    "interest_text": interestText,
    "shortlist_status": shortlistStatus,
    "shortlist_text": shortlistText,
    "report_status": reportStatus,
    "profile_view_resquest_status": profileViewRequestStatus,
    "gallery_view_resquest_status": galleryViewRequestStatus,
  };
}
