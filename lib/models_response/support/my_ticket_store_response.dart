// To parse this JSON data, do
//
//     final myTicketStoreResponse = myTicketStoreResponseFromJson(jsonString);

import 'dart:convert';

MyTicketStoreResponse myTicketStoreResponseFromJson(String str) =>
    MyTicketStoreResponse.fromJson(json.decode(str));

String myTicketStoreResponseToJson(MyTicketStoreResponse data) =>
    json.encode(data.toJson());

class MyTicketStoreResponse {
  MyTicketStoreResponse({
    this.result,
    this.data,
  });

  bool? result;
  String? data;

  factory MyTicketStoreResponse.fromJson(Map<String, dynamic> json) =>
      MyTicketStoreResponse(
        result: json["result"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data,
      };
}
