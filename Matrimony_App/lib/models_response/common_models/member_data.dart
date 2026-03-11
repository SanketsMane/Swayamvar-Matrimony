class MemberData {
  MemberData({
    this.userId,
    this.code,
    this.membership,
    this.name,
    this.photo,
    this.age,
    this.country,
    this.height,
    this.maritalStatus,
    this.religion,
    this.caste,
    this.profession,
    this.packageUpdateAlert,
    this.interestStatus,
    this.shortlistStatus,
    this.reportStatus,
    this.profileViewRequestStatus,
    this.galleryViewRequestStatus,
    this.expressInterest,
    this.mothereTongue,
    this.education,
    this.job,
    this.income,
  });

  int? userId;
  String? code;
  var membership;
  String? name;
  String? photo;
  var age;
  String? country;
  dynamic height;
  String? maritalStatus;
  String? religion;
  String? caste;
  String? profession; // Sanket: added missing field accessed in home hero card
  String? education;
  String? job;
  String? income;
  bool? packageUpdateAlert;
  String? interestStatus;
  int? shortlistStatus;
  bool? reportStatus;
  bool? profileViewRequestStatus;
  bool? galleryViewRequestStatus;
  bool? expressInterest;
  String? mothereTongue;

  factory MemberData.fromJson(Map<String, dynamic> json) => MemberData(
    userId: json["user_id"] != null ? int.tryParse(json["user_id"].toString()) : null,
    code: json["code"]?.toString(),
    membership: json["membership"],
    name: json["name"]?.toString(),
    photo: json["photo"]?.toString(),
    age: json["age"],
    country: json["country"]?.toString(),
    height: json["height"],
    maritalStatus: json["marital_status"]?.toString(),
    religion: json["religion"]?.toString(),
    caste: json["caste"]?.toString(),
    profession: json["profession"]?.toString(),
    packageUpdateAlert: json["package_update_alert"],
    interestStatus: json["interest_status"]?.toString(),
    shortlistStatus: json["shortlist_status"] != null ? int.tryParse(json["shortlist_status"].toString()) : null,
    reportStatus: json["report_status"],
    profileViewRequestStatus: json["profile_view_resquest_status"],
    galleryViewRequestStatus: json["gallery_view_resquest_status"],
    expressInterest: json["express_interest"],
    mothereTongue: json["mothere_tongue"]?.toString(),
    education: json["education"]?.toString(),
    job: json["job"]?.toString(),
    income: json["income"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "code": code,
    "membership": membership,
    "name": name,
    "photo": photo,
    "age": age,
    "country": country,
    "height": height,
    "marital_status": maritalStatus,
    "religion": religion,
    "caste": caste,
    "profession": profession,
    "package_update_alert": packageUpdateAlert,
    "interest_status": interestStatus,
    "shortlist_status": shortlistStatus,
    "report_status": reportStatus,
    "profile_view_resquest_status": profileViewRequestStatus,
    "gallery_view_resquest_status": galleryViewRequestStatus,
    "express_interest": expressInterest,
    "mothere_tongue": mothereTongue,
    "education": education,
    "job": job,
    "income": income,
  };
}
