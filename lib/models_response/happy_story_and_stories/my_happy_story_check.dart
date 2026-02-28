// To parse this JSON data, do
//
//     final myHappyStoryCheckResponse = myHappyStoryCheckResponseFromJson(jsonString);

import 'dart:convert';

MyHappyStoryCheckResponse myHappyStoryCheckResponseFromJson(String str) =>
    MyHappyStoryCheckResponse.fromJson(json.decode(str));

String myHappyStoryCheckResponseToJson(MyHappyStoryCheckResponse data) =>
    json.encode(data.toJson());

class MyHappyStoryCheckResponse {
  MyHappyStoryCheckResponse({this.result, this.data});

  bool? result;
  MyHappyStoryData? data;

  factory MyHappyStoryCheckResponse.fromJson(
    Map<String, dynamic> json,
  ) => MyHappyStoryCheckResponse(
    result: json["result"],
    data: json["data"] == null ? null : MyHappyStoryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"result": result, "data": data?.toJson()};
}

class MyHappyStoryData {
  MyHappyStoryData({
    this.id,
    this.userId,
    this.packageUpdateAlert,
    this.userFirstName,
    this.userLastName,
    this.partnerName,
    this.title,
    this.details,
    this.date,
    this.thumbImg,
    this.photos,
    this.videoProvider,
    this.videoLink,
  });

  int? id;
  int? userId;
  bool? packageUpdateAlert;
  String? userFirstName;
  String? userLastName;
  String? partnerName;
  String? title;
  String? details;
  String? date;
  String? thumbImg;
  List<String>? photos;
  String? videoProvider;
  String? videoLink;

  factory MyHappyStoryData.fromJson(Map<String, dynamic> json) =>
      MyHappyStoryData(
        id: json["id"],
        userId: json["user_id"],
        packageUpdateAlert: json["package_update_alert"],
        userFirstName: json["user_first_name"],
        userLastName: json["user_last_name"],
        partnerName: json["partner_name"],
        title: json["title"],
        details: json["details"],
        date: json["date"],
        thumbImg: json["thumb_img"],
        photos:
            json["photos"] == null
                ? null
                : List<String>.from(json["photos"].map((x) => x)),
        videoProvider: json["video_provider"],
        videoLink: json["video_link"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "package_update_alert": packageUpdateAlert,
    "user_first_name": userFirstName,
    "user_last_name": userLastName,
    "partner_name": partnerName,
    "title": title,
    "details": details,
    "date": date,
    "thumb_img": thumbImg,
    "photos": photos == null ? null : List<dynamic>.from(photos!.map((x) => x)),
    "video_provider": videoProvider,
    "video_link": videoLink,
  };
}
