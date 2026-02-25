// To parse this JSON data, do
//
//     final presentAddressGetResponse = presentAddressGetResponseFromJson(jsonString);

import 'dart:convert';

PresentAddressGetResponse presentAddressGetResponseFromJson(String str) =>
    PresentAddressGetResponse.fromJson(json.decode(str));

String presentAddressGetResponseToJson(PresentAddressGetResponse data) =>
    json.encode(data.toJson());

class PresentAddressGetResponse {
  PresentAddressGetResponse({this.data, this.result});

  PresentAddressData? data;
  bool? result;

  factory PresentAddressGetResponse.fromJson(Map<String, dynamic> json) =>
      PresentAddressGetResponse(
        data: json["data"] == null
            ? null
            : PresentAddressData.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "result": result,
      };
}

class PresentAddressData {
  PresentAddressData({
    this.country,
    this.state,
    this.city,
    this.postalCode,
  });

  String? country;
  String? state;
  String? city;
  String? postalCode;

  factory PresentAddressData.fromJson(Map<String, dynamic> json) =>
      PresentAddressData(
        country: json["country"],
        state: json["state"],
        city: json["city"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "state": state,
        "city": city,
        "postal_code": postalCode,
      };
}
