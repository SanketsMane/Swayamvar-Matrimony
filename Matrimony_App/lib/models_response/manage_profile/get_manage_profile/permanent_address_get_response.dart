// To parse this JSON data, do
//
//     final permanentGetResponse = permanentGetResponseFromJson(jsonString);

import 'dart:convert';

PermanentGetResponse permanentGetResponseFromJson(String str) =>
    PermanentGetResponse.fromJson(json.decode(str));

String permanentGetResponseToJson(PermanentGetResponse data) =>
    json.encode(data.toJson());

class PermanentGetResponse {
  PermanentGetResponse({this.data, this.result});

  Data? data;
  bool? result;

  factory PermanentGetResponse.fromJson(Map<String, dynamic> json) =>
      PermanentGetResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};

  PermanentGetResponse.initialState()
    : data = Data.initialState(),
      result = false;
}

class Data {
  Data({this.country, this.state, this.city, this.postalCode});

  String? country;
  String? state;
  String? city;
  String? postalCode;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    country: json["country"]?.toString(),
    state: json["state"]?.toString(),
    city: json["city"]?.toString(),
    postalCode: json["postal_code"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "state": state,
    "city": city,
    "postal_code": postalCode,
  };

  Data.initialState() : country = '', state = '', city = '', postalCode = '';
}
