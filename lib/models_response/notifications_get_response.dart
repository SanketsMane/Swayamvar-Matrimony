// To parse this JSON data, do
//
//     final notificationsGetResponse = notificationsGetResponseFromJson(jsonString);

import 'dart:convert';

NotificationsGetResponse notificationsGetResponseFromJson(String str) =>
    NotificationsGetResponse.fromJson(json.decode(str));

String notificationsGetResponseToJson(NotificationsGetResponse data) =>
    json.encode(data.toJson());

class NotificationsGetResponse {
  NotificationsGetResponse({
    this.data,
    this.links,
    this.meta,
    this.result,
  });

  List<NotificationData>? data;
  Links? links;
  Meta? meta;
  bool? result;

  factory NotificationsGetResponse.fromJson(Map<String, dynamic> json) =>
      NotificationsGetResponse(
        data: json["data"] == null
            ? null
            : List<NotificationData>.from(
                json["data"].map((x) => NotificationData.fromJson(x))),
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

class NotificationData {
  NotificationData({
    this.check,
    this.notificationId,
    this.type,
    this.notifyBy,
    this.photo,
    this.message,
    this.time,
    this.readAt,
  });

  bool? check;
  int? notificationId;
  String? type;
  int? notifyBy;
  String? photo;
  String? message;
  String? time;
  String? readAt;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        check: json["check"],
        notificationId: json["notification_id"],
        type: json["type"],
        notifyBy: json["notify_by"],
        photo: json["photo"],
        message: json["message"],
        time: json["time"],
        readAt: json["read_at"],
      );

  Map<String, dynamic> toJson() => {
        "check": check,
        "notification_id": notificationId,
        "type": type,
        "photo": photo,
        "notify_by": notifyBy,
        "message": message,
        "time": time,
        "read_at": readAt,
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
  String? next;

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
