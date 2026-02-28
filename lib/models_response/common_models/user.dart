import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  var id;
  String? type;
  String? name;
  var membership;
  var emailVerifiedAt;
  var photoApproved;
  var blocked;
  var deactivated;
  var approved;
  String? email;
  var birthday;
  var height;
  MaritalStatusId? maritalStatusId;
  String? avatar;
  String? avatarOriginal;
  String? phone;

  User({
    this.id,
    this.type,
    this.name,
    this.membership,
    this.emailVerifiedAt,
    this.photoApproved,
    this.blocked,
    this.deactivated,
    this.approved,
    this.email,
    this.birthday,
    this.height,
    this.maritalStatusId,
    this.avatar,
    this.avatarOriginal,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    membership: json["membership"],
    emailVerifiedAt:
        json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
    photoApproved: json["photo_approved"],
    blocked: json["blocked"],
    deactivated: json["deactivated"],
    approved: json["approved"],
    email: json["email"],
    birthday: json["birthday"],
    height: json["height"],
    maritalStatusId:
        json["marital_status_id"] == null
            ? null
            : MaritalStatusId.fromJson(json["marital_status_id"]),
    avatar: json["avatar"],
    avatarOriginal: json["avatar_original"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "membership": membership,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "photo_approved": photoApproved,
    "blocked": blocked,
    "deactivated": deactivated,
    "approved": approved,
    "email": email,
    "birthday": birthday,
    "height": height,
    "marital_status_id": maritalStatusId?.toJson(),
    "avatar": avatar,
    "avatar_original": avatarOriginal,
    "phone": phone,
  };
}

class MaritalStatusId {
  int? id;
  String? name;

  MaritalStatusId({this.id, this.name});

  factory MaritalStatusId.fromJson(Map<String, dynamic> json) =>
      MaritalStatusId(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

//
// import 'dart:convert';
//
// User userFromJson(String str) => User.fromJson(json.decode(str));
//
// String userToJson(User data) => json.encode(data.toJson());
//
// class User {
//   // 🎯 CORRECTION: Used specific, nullable types instead of 'var' for type safety.
//   // 🎯 CORRECTION: Made all fields 'final' for immutability.
//   final int? id;
//   final String? type;
//   final String? name;
//   final int? membership;
//   final DateTime? emailVerifiedAt;
//   final int? photoApproved;
//   final int? blocked;
//   final int? deactivated;
//   final int? approved;
//   final String? email;
//   final int? birthday;
//   final int? height;
//   final MaritalStatusId? maritalStatusId;
//   final String? avatar;
//   final String? avatarOriginal;
//   final String? phone;
//
//   // 🎯 CORRECTION: Added a 'const' constructor.
//   const User({
//     this.id,
//     this.type,
//     this.name,
//     this.membership,
//     this.emailVerifiedAt,
//     this.photoApproved,
//     this.blocked,
//     this.deactivated,
//     this.approved,
//     this.email,
//     this.birthday,
//     this.height,
//     this.maritalStatusId,
//     this.avatar,
//     this.avatarOriginal,
//     this.phone,
//   });
//
//   // ✨ IMPROVEMENT: Added a copyWith method for easier state management.
//   User copyWith({
//     int? id,
//     String? type,
//     String? name,
//     int? membership,
//     DateTime? emailVerifiedAt,
//     int? photoApproved,
//     int? blocked,
//     int? deactivated,
//     int? approved,
//     String? email,
//     int? birthday,
//     int? height,
//     MaritalStatusId? maritalStatusId,
//     String? avatar,
//     String? avatarOriginal,
//     String? phone,
//   }) {
//     return User(
//       id: id ?? this.id,
//       type: type ?? this.type,
//       name: name ?? this.name,
//       membership: membership ?? this.membership,
//       emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
//       photoApproved: photoApproved ?? this.photoApproved,
//       blocked: blocked ?? this.blocked,
//       deactivated: deactivated ?? this.deactivated,
//       approved: approved ?? this.approved,
//       email: email ?? this.email,
//       birthday: birthday ?? this.birthday,
//       height: height ?? this.height,
//       maritalStatusId: maritalStatusId ?? this.maritalStatusId,
//       avatar: avatar ?? this.avatar,
//       avatarOriginal: avatarOriginal ?? this.avatarOriginal,
//       phone: phone ?? this.phone,
//     );
//   }
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     type: json["type"],
//     name: json["name"],
//     membership: json["membership"],
//     emailVerifiedAt: json["email_verified_at"] == null
//         ? null
//         : DateTime.parse(json["email_verified_at"]),
//     photoApproved: json["photo_approved"],
//     blocked: json["blocked"],
//     deactivated: json["deactivated"],
//     approved: json["approved"],
//     email: json["email"],
//     birthday: json["birthday"],
//     height: json["height"],
//     maritalStatusId: json["marital_status_id"] == null
//         ? null
//         : MaritalStatusId.fromJson(json["marital_status_id"]),
//     avatar: json["avatar"],
//     avatarOriginal: json["avatar_original"],
//     phone: json["phone"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "type": type,
//     "name": name,
//     "membership": membership,
//     "email_verified_at": emailVerifiedAt?.toIso8601String(),
//     "photo_approved": photoApproved,
//     "blocked": blocked,
//     "deactivated": deactivated,
//     "approved": approved,
//     "email": email,
//     "birthday": birthday,
//     "height": height,
//     "marital_status_id": maritalStatusId?.toJson(),
//     "avatar": avatar,
//     "avatar_original": avatarOriginal,
//     "phone": phone,
//   };
// }
//
// class MaritalStatusId {
//   // 🎯 CORRECTION: Made fields final and constructor const.
//   final int? id;
//   final String? name;
//
//   const MaritalStatusId({
//     this.id,
//     this.name,
//   });
//
//   factory MaritalStatusId.fromJson(Map<String, dynamic> json) =>
//       MaritalStatusId(
//         id: json["id"],
//         name: json["name"],
//       );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//   };
// }
