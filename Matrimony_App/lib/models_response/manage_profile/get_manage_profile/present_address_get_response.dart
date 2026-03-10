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
        data:
            json["data"] == null
                ? null
                : PresentAddressData.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};
}

class PresentAddressData {
  PresentAddressData({
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.address,
    this.govIdType,
    this.govIdNumber,
  });

  String? country;
  String? state;
  String? city;
  String? postalCode;
  String? address;
  String? govIdType;
  String? govIdNumber;

  factory PresentAddressData.fromJson(Map<String, dynamic> json) =>
      PresentAddressData(
        country: json["country"],
        state: json["state"],
        city: json["city"],
        postalCode: json["postal_code"],
        address: json["address"],
        govIdType: json["gov_id_type"],
        govIdNumber: json["gov_id_number"],
      );

  Map<String, dynamic> toJson() => {
    "country": country,
    "state": state,
    "city": city,
    "postal_code": postalCode,
    "address": address,
    "gov_id_type": govIdType,
    "gov_id_number": govIdNumber,
  };
}
