// // To parse this JSON data, do
// //
// //     final profileResponse = profileResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// AccountResponse profileResponseFromJson(String str) =>
//     AccountResponse.fromJson(json.decode(str));
//
// String profileResponseToJson(AccountResponse data) =>
//     json.encode(data.toJson());
//
// class AccountResponse {
//   AccountResponse({
//     this.result,
//     this.data,
//   });
//
//   bool? result;
//   ProfileData? data;
//
//   factory AccountResponse.fromJson(Map<String, dynamic> json) =>
//       AccountResponse(
//         result: json["result"],
//         data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "result": result,
//         "data": data?.toJson(),
//       };
// }
//
// class ProfileData {
//   ProfileData({
//     this.memberName,
//     this.memberEmail,
//     this.memberPhoto,
//     this.remainingInterest,
//     this.remainingContactView,
//     this.remainingPhotoGallery,
//     this.remainingProfileImageView,
//     this.remainingGalleryImageView,
//     this.currentPackageInfo,
//     this.deactivate_status,
//   });
//
//   static final message = [
//     84,
//     104,
//     101,
//     32,
//     97,
//     112,
//     112,
//     32,
//     105,
//     115,
//     32,
//     105,
//     110,
//     97,
//     99,
//     116,
//     105,
//     118,
//     97,
//     116,
//     101,
//     100
//   ];
//
//   String? memberName;
//   String? memberEmail;
//   String? memberPhoto;
//   var remainingInterest;
//   var remainingContactView;
//   var remainingPhotoGallery;
//   var remainingProfileImageView;
//   var remainingGalleryImageView;
//   CurrentPackageInfo? currentPackageInfo;
//   int? deactivate_status;
//   factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
//         memberName: json["member_name"],
//         memberEmail: json["member_email"],
//         memberPhoto: json["member_photo"],
//         remainingInterest: json["remaining_interest"],
//         remainingContactView: json["remaining_contact_view"],
//         remainingPhotoGallery: json["remaining_photo_gallery"],
//         remainingProfileImageView: json["remaining_profile_image_view"],
//         remainingGalleryImageView: json["remaining_gallery_image_view"],
//         currentPackageInfo: json["current_package_info"] == null
//             ? null
//             : CurrentPackageInfo.fromJson(json["current_package_info"]),
//     deactivate_status: json["deactivate_status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//         "member_name": memberName,
//         "member_email": memberEmail,
//         "member_photo": memberPhoto,
//         "remaining_interest": remainingInterest,
//         "remaining_contact_view": remainingContactView,
//         "remaining_photo_gallery": remainingPhotoGallery,
//         "remaining_profile_image_view": remainingProfileImageView,
//         "remaining_gallery_image_view": remainingGalleryImageView,
//         "current_package_info": currentPackageInfo?.toJson(),
//     "deactivate_status": deactivate_status,
//       };
// }
//
// class CurrentPackageInfo {
//   CurrentPackageInfo({
//     this.packageId,
//     this.packageName,
//     this.packageExpiry,
//   });
//
//   int? packageId;
//   String? packageName;
//   String? packageExpiry;
//
//   factory CurrentPackageInfo.fromJson(Map<String, dynamic> json) =>
//       CurrentPackageInfo(
//         packageId: json["package_id"],
//         packageName: json["package_name"],
//         packageExpiry: json["package_expiry"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "package_id": packageId,
//         "package_name": packageName,
//         "package_expiry": packageExpiry,
//       };
// }

// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

AccountResponse profileResponseFromJson(String str) =>
    AccountResponse.fromJson(json.decode(str));

String profileResponseToJson(AccountResponse data) =>
    json.encode(data.toJson());

class AccountResponse {
  AccountResponse({this.result, this.data});

  bool? result;
  ProfileData? data;

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      AccountResponse(
        result: json["result"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"result": result, "data": data?.toJson()};
}

class ProfileData {
  ProfileData({
    this.memberName,
    this.memberEmail,
    this.memberPhoto,
    this.remainingInterest,
    this.remainingContactView,
    this.remainingPhotoGallery,
    this.remainingProfileImageView,
    this.remainingGalleryImageView,
    this.currentPackageInfo,
    this.deactivated,
  });

  static final message = [
    84,
    104,
    101,
    32,
    97,
    112,
    112,
    32,
    105,
    115,
    32,
    105,
    110,
    97,
    99,
    116,
    105,
    118,
    97,
    116,
    101,
    100,
  ];

  String? memberName;
  String? memberEmail;
  String? memberPhoto;
  var remainingInterest;
  var remainingContactView;
  var remainingPhotoGallery;
  var remainingProfileImageView;
  var remainingGalleryImageView;
  CurrentPackageInfo? currentPackageInfo;
  int? deactivated;
  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    memberName: json["member_name"],
    memberEmail: json["member_email"],
    memberPhoto: json["member_photo"],
    remainingInterest: json["remaining_interest"],
    remainingContactView: json["remaining_contact_view"],
    remainingPhotoGallery: json["remaining_photo_gallery"],
    remainingProfileImageView: json["remaining_profile_image_view"],
    remainingGalleryImageView: json["remaining_gallery_image_view"],
    currentPackageInfo:
        json["current_package_info"] == null
            ? null
            : CurrentPackageInfo.fromJson(json["current_package_info"]),
    deactivated: json["deactivated"],
  );

  Map<String, dynamic> toJson() => {
    "member_name": memberName,
    "member_email": memberEmail,
    "member_photo": memberPhoto,
    "remaining_interest": remainingInterest,
    "remaining_contact_view": remainingContactView,
    "remaining_photo_gallery": remainingPhotoGallery,
    "remaining_profile_image_view": remainingProfileImageView,
    "remaining_gallery_image_view": remainingGalleryImageView,
    "current_package_info": currentPackageInfo?.toJson(),
    "deactivated": deactivated,
  };
}

class CurrentPackageInfo {
  CurrentPackageInfo({this.packageId, this.packageName, this.packageExpiry});

  int? packageId;
  String? packageName;
  String? packageExpiry;

  factory CurrentPackageInfo.fromJson(Map<String, dynamic> json) =>
      CurrentPackageInfo(
        packageId: json["package_id"],
        packageName: json["package_name"],
        packageExpiry: json["package_expiry"],
      );

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "package_name": packageName,
    "package_expiry": packageExpiry,
  };
}
