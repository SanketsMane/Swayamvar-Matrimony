import 'dart:convert';

IsApprovedResponse isApprovedResponseFromJson(String str) =>
    IsApprovedResponse.fromJson(json.decode(str));

String isApprovedResponseToJson(IsApprovedResponse data) =>
    json.encode(data.toJson());

// Sanket: Model for the /member/is-approved API response
class IsApprovedResponse {
  int? isApproved;
  bool? verificationInfo;
  // Lifecycle: pending | approved | rejected | query
  String? verificationStatus;
  // Admin's reason on rejection or query — shown to user in the app
  String? adminMessage;

  IsApprovedResponse({
    this.isApproved,
    this.verificationInfo,
    this.verificationStatus,
    this.adminMessage,
  });

  factory IsApprovedResponse.fromJson(Map<String, dynamic> json) =>
      IsApprovedResponse(
        isApproved: json["is_approved"],
        verificationInfo: json["verification_info"],
        verificationStatus: json["verification_status"],
        adminMessage: json["admin_message"],
      );

  Map<String, dynamic> toJson() => {
        "is_approved": isApproved,
        "verification_info": verificationInfo,
        "verification_status": verificationStatus,
        "admin_message": adminMessage,
      };
}
