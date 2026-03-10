import 'dart:convert';

EducationGetResponse educationGetResponseFromJson(String str) =>
    EducationGetResponse.fromJson(json.decode(str));

String educationGetResponseToJson(EducationGetResponse data) =>
    json.encode(data.toJson());

class EducationGetResponse {
  EducationGetResponse({this.data, this.result});

  List<Data>? data;
  bool? result;

  factory EducationGetResponse.fromJson(Map<String, dynamic> json) =>
      EducationGetResponse(
        data:
            json["data"] != null
                ? List<Data>.from(json["data"].map((x) => Data.fromJson(x)))
                : [],
        result: json["result"] ?? false,
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "result": result,
  };

  EducationGetResponse.initialState() : data = [], result = false;
}

class Data {
  Data({
    this.id,
    this.degree,
    this.institution,
    this.start,
    this.end,
    this.present,
  });

  int? id;
  String? degree;
  String? institution;
  String? start;
  String? end;
  bool? present;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id:
        json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"].toString()) ?? 0,
    degree:
        json["degree"] is String
            ? json["degree"]
            : json["degree"]?.toString() ?? "",
    institution:
        json["institution"] is String
            ? json["institution"]
            : json["institution"]?.toString() ?? "",
    start:
        json["start"] is String
            ? json["start"]
            : json["start"]?.toString() ?? "",
    end: json["end"] is String ? json["end"] : json["end"]?.toString() ?? "",
    present: json["present"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "degree": degree,
    "institution": institution,
    "start": start,
    "end": end,
    "present": present,
  };
}
