import 'dart:convert';

VerifyMailResponse verifyMailResponseFromJson(String str) =>
    VerifyMailResponse.fromJson(json.decode(str));

String verifyMailResponseToJson(VerifyMailResponse data) =>
    json.encode(data.toJson());

class VerifyMailResponse {
  VerifyMailResponse({
    this.result = false,
    this.message,
    this.errors,
    this.status,
  });

  bool result;
  var errors;
  var message;
  int? status;

  factory VerifyMailResponse.fromJson(Map<String, dynamic> json) =>
      VerifyMailResponse(
        result: json["result"] ?? false,
        message: json["message"],
        errors: json["errors"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "status": status,
  };
}
