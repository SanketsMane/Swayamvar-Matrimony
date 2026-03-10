// To parse this JSON data, do
//
//     final referralWithdrawRequestHistoryResponse = referralWithdrawRequestHistoryResponseFromJson(jsonString);

import 'dart:convert';

ReferralWithdrawRequestHistoryResponse
referralWithdrawRequestHistoryResponseFromJson(String str) =>
    ReferralWithdrawRequestHistoryResponse.fromJson(json.decode(str));

String referralWithdrawRequestHistoryResponseToJson(
  ReferralWithdrawRequestHistoryResponse data,
) => json.encode(data.toJson());

class ReferralWithdrawRequestHistoryResponse {
  ReferralWithdrawRequestHistoryResponse({
    this.data,
    this.links,
    this.meta,
    this.result,
  });

  List<Data>? data;
  Links? links;
  Meta? meta;
  bool? result;

  factory ReferralWithdrawRequestHistoryResponse.fromJson(
    Map<String, dynamic> json,
  ) => ReferralWithdrawRequestHistoryResponse(
    data:
        json["data"] == null
            ? null
            : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "data":
        data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
    "result": result,
  };
}

class Data {
  Data({this.amount, this.status, this.details, this.date});

  String? amount;
  String? status;
  String? details;
  String? date;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    amount: json["amount"],
    status: json["status"],
    details: json["details"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "status": status,
    "details": details,
    "date": date,
  };
}

class Links {
  Links({this.first, this.last, this.prev, this.next});

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
    links:
        json["links"] == null
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
    "links":
        links == null
            ? null
            : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  Link({this.url, this.label, this.active});

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
