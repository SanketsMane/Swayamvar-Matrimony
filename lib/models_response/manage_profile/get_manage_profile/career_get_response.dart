// // To parse this JSON data, do
// //
// //     final careerGetResponse = careerGetResponseFromJson(jsonString);

// import 'dart:convert';

// CareerGetResponse careerGetResponseFromJson(String str) =>
//     CareerGetResponse.fromJson(json.decode(str));

// String careerGetResponseToJson(CareerGetResponse data) =>
//     json.encode(data.toJson());

// class CareerGetResponse {
//   CareerGetResponse({
//     this.data,
//     this.result,
//   });

//   List<Data>? data;
//   bool? result;

//   factory CareerGetResponse.fromJson(Map<String, dynamic> json) =>
//       CareerGetResponse(
//         data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
//         result: json["result"],
//       );

//   Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//         "result": result,
//       };
// }

// class Data {
//   Data({
//     this.id,
//     this.designation,
//     this.company,
//     this.start,
//     this.end,
//     this.present,
//   });

//   int? id;
//   String? designation;
//   String? company;
//   String? start;
//   dynamic end;
//   dynamic present;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         designation: json["designation"],
//         company: json["company"],
//         start: json["start"],
//         end: json["end"],
//         present: json["present"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "designation": designation,
//         "company": company,
//         "start": start,
//         "end": end,
//         "present": present,
//       };
// }

import 'dart:convert';

CareerGetResponse careerGetResponseFromJson(String str) =>
    CareerGetResponse.fromJson(json.decode(str));

String careerGetResponseToJson(CareerGetResponse data) =>
    json.encode(data.toJson());

class CareerGetResponse {
  CareerGetResponse({
    this.data,
    this.result,
  });

  List<Data>? data;
  bool? result;

  factory CareerGetResponse.fromJson(Map<String, dynamic> json) =>
      CareerGetResponse(
        data: json["data"] != null
            ? List<Data>.from(json["data"].map((x) => Data.fromJson(x)))
            : [],
        result:
            json["result"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "result": result,
      };

  CareerGetResponse.initialState()
      : data = [],
        result = false;
}

class Data {
  Data({
    this.id,
    this.designation,
    this.company,
    this.start,
    this.end,
    this.present,
  });

  int? id;
  String? designation;
  String? company;
  String? start;
  dynamic end;
  bool? present;

  factory Data.fromJson(Map<String, dynamic> json) => Data(

        id: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"].toString()) ?? 0,

        designation: json["designation"] is String
            ? json["designation"]
            : json["designation"]?.toString() ??
                "",
        company: json["company"] is String
            ? json["company"]
            : json["company"]?.toString() ??
                "",
        start: json["start"] is String
            ? json["start"]
            : json["start"]?.toString() ??
                "",
        end: json["end"] is String
            ? json["end"]
            : json["end"]?.toString() ?? "",
        present:
            json["present"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "designation": designation,
        "company": company,
        "start": start,
        "end": end,
        "present": present,
      };
}
