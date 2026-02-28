// // To parse this JSON data, do
// //
// //     final homeResponse = homeResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
// import 'package:active_matrimonial_flutter_app/models_response/gallery_picture_view_request_get_response.dart';
//
// HomeResponse homeResponseFromJson(String str) =>
//     HomeResponse.fromJson(json.decode(str));
//
// String homeResponseToJson(HomeResponse data) => json.encode(data.toJson());
//
// class HomeResponse {
//   HomeResponse({
//     this.data,
//     this.result,
//   });
//
//   List<MemberData>? data;
//   bool? result;
//
//   factory HomeResponse.fromJson(Map<String, dynamic> json) {
//     ca();
//     // json["data"].removeWhere((element) {
//     //   return element == null;
//     // });
//     return HomeResponse(
//       data: List<MemberData>.from(
//           json["data"].map((x) => MemberData.fromJson(x))),
//       result: json["result"],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//         "result": result,
//       };
// }
// /*
// class ActiveMemberData {
//   ActiveMemberData({
//     this.userId,
//     this.code,
//     this.membership,
//     this.name,
//     this.photo,
//     this.age,
//     this.country,
//     this.height,
//     this.packageUpdateAlert,
//     this.interestStatus,
//     this.shortlistStatus,
//     this.reportStatus,
//     this.profileViewRequestStatus,
//     this.galleryViewRequestStatus,
//   });
//
//   int? userId;
//   String? code;
//   int? membership;
//   String? name;
//   String? photo;
//   int? age;
//   String? country;
//   dynamic height;
//   bool? packageUpdateAlert;
//   String? interestStatus;
//   int? shortlistStatus;
//   bool? reportStatus;
//   bool? profileViewRequestStatus;
//   bool? galleryViewRequestStatus;
//
//   factory ActiveMemberData.fromJson(Map<String, dynamic> json) =>
//       ActiveMemberData(
//         userId: json["user_id"] == null ? null : json["user_id"],
//         code: json["code"] == null ? null : json["code"],
//         membership: json["membership"] == null ? null : json["membership"],
//         name: json["name"] == null ? null : json["name"],
//         photo: json["photo"] == null ? null : json["photo"],
//         age: json["age"] == null ? null : json["age"],
//         country: json["country"] == null ? null : json["country"],
//         height: json["height"],
//         packageUpdateAlert: json["package_update_alert"] == null
//             ? null
//             : json["package_update_alert"],
//         interestStatus:
//             json["interest_status"] == null ? null : json["interest_status"],
//         shortlistStatus:
//             json["shortlist_status"] == null ? null : json["shortlist_status"],
//         reportStatus:
//             json["report_status"] == null ? null : json["report_status"],
//         profileViewRequestStatus: json["profile_view_resquest_status"],
//         galleryViewRequestStatus: json["gallery_view_resquest_status"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "user_id": userId == null ? null : userId,
//         "code": code == null ? null : code,
//         "membership": membership == null ? null : membership,
//         "name": name == null ? null : name,
//         "photo": photo == null ? null : photo,
//         "age": age == null ? null : age,
//         "country": country == null ? null : country,
//         "height": height,
//         "package_update_alert":
//             packageUpdateAlert == null ? null : packageUpdateAlert,
//         "interest_status": interestStatus == null ? null : interestStatus,
//         "shortlist_status": shortlistStatus == null ? null : shortlistStatus,
//         "report_status": reportStatus == null ? null : reportStatus,
//         "profile_view_resquest_status": profileViewRequestStatus,
//         "gallery_view_resquest_status": galleryViewRequestStatus,
//       };
// }*/

import 'dart:convert';
import 'package:active_matrimonial_flutter_app/models_response/common_models/member_data.dart';
import 'package:active_matrimonial_flutter_app/models_response/gallery_picture_view_request_get_response.dart';

HomeResponse homeResponseFromJson(String str) =>
    HomeResponse.fromJson(json.decode(str));

String homeResponseToJson(HomeResponse data) => json.encode(data.toJson());

class HomeResponse {
  HomeResponse({
    this.data,
    this.result,
    this.heroMatch,
    this.verified,
    this.activeNow,
    this.newMatches,
  });

  // Legacy field — mapped to new_matches for backward compatibility
  List<MemberData>? data;
  bool? result;

  // Sanket: New segmented fields from the refactored home_with_login API
  List<MemberData>? heroMatch;
  List<MemberData>? verified;
  List<MemberData>? activeNow;
  List<MemberData>? newMatches;

  // Helper to parse a list of MemberData from json safely
  static List<MemberData> _parseMembers(dynamic jsonList) {
    if (jsonList == null || jsonList is! List) return [];
    return (jsonList as List<dynamic>)
        .where((item) => item != null)
        .map((x) => MemberData.fromJson(x))
        .toList();
  }

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    // Sanket: Support both old flat-list format and new segmented API format
    final isSegmented =
        json.containsKey('hero_match') ||
        json.containsKey('new_matches') ||
        json.containsKey('verified') ||
        json.containsKey('active_now');

    if (isSegmented) {
      final newMatchesList = _parseMembers(json['new_matches']);
      return HomeResponse(
        result: json['result'],
        heroMatch: _parseMembers(json['hero_match']),
        verified: _parseMembers(json['verified']),
        activeNow: _parseMembers(json['active_now']),
        newMatches: newMatchesList,
        // Backward compat: data = new_matches
        data: newMatchesList,
      );
    }

    // Fallback: legacy API format returns data as a flat list
    return HomeResponse(
      data: _parseMembers(json['data']),
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from((data ?? []).map((x) => x.toJson())),
    "result": result,
  };
}
