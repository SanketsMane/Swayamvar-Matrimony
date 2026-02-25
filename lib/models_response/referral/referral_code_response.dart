// To parse this JSON data, do
//
//     final referralCodeResponse = referralCodeResponseFromJson(jsonString);

import 'dart:convert';

ReferralCodeResponse referralCodeResponseFromJson(String str) =>
    ReferralCodeResponse.fromJson(json.decode(str));

String referralCodeResponseToJson(ReferralCodeResponse data) =>
    json.encode(data.toJson());

class ReferralCodeResponse {
  ReferralCodeResponse({
    this.result,
    this.data,
  });

  bool? result;
  Data? data;

  factory ReferralCodeResponse.fromJson(Map<String, dynamic> json) =>
      ReferralCodeResponse(
        result: json["result"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.referralCode,
  });

  String? referralCode;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        referralCode: json["referral_code"],
      );

  Map<String, dynamic> toJson() => {
        "referral_code": referralCode,
      };
}
