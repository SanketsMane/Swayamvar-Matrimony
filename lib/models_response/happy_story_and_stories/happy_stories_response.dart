// To parse this JSON data, do
//
//     final happyStoriesResponse = happyStoriesResponseFromJson(jsonString);

import 'dart:convert';

HappyStoriesResponse happyStoriesResponseFromJson(String str) =>
    HappyStoriesResponse.fromJson(json.decode(str));

String happyStoriesResponseToJson(HappyStoriesResponse data) =>
    json.encode(data.toJson());

class HappyStoriesResponse {
  HappyStoriesResponse({
    this.data,
    this.links,
    this.meta,
    this.result,
  });

  List<Data>? data;
  Links? links;
  Meta? meta;
  bool? result;

  factory HappyStoriesResponse.fromJson(Map<String, dynamic> json) =>
      HappyStoriesResponse(
        data: json["data"] == null
            ? null
            : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
        "result": result,
      };
}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        photos: json["photos"] == null
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
        "photos":
            photos == null ? null : List<dynamic>.from(photos!.map((x) => x)),
        "video_provider": videoProvider,
        "video_link": videoLink,
      };
}

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: json["links"] == null
            ? null
            : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": links == null
            ? null
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
