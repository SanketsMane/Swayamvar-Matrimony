// To parse this JSON data, do
//
//     final packageHistoryResponse = packageHistoryResponseFromJson(jsonString);

import 'dart:convert';

PackageHistoryResponse packageHistoryResponseFromJson(String str) =>
    PackageHistoryResponse.fromJson(json.decode(str));

String packageHistoryResponseToJson(PackageHistoryResponse data) =>
    json.encode(data.toJson());

class PackageHistoryResponse {
  PackageHistoryResponse({
    this.data,
    this.links,
    this.meta,
    this.result,
  });

  List<ProfileHistoryData>? data;
  Links? links;
  Meta? meta;
  bool? result;

  factory PackageHistoryResponse.fromJson(Map<String, dynamic> json) =>
      PackageHistoryResponse(
        data: json["data"] == null
            ? null
            : List<ProfileHistoryData>.from(
                json["data"].map((x) => ProfileHistoryData.fromJson(x))),
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

class ProfileHistoryData {
  ProfileHistoryData({
    this.packagePaymentId,
    this.paymentCode,
    this.packageName,
    this.paymentMethod,
    this.amount,
    this.paymentStatus,
    this.date,
  });

  int? packagePaymentId;
  String? paymentCode;
  String? packageName;
  String? paymentMethod;
  String? amount;
  String? paymentStatus;
  String? date;

  factory ProfileHistoryData.fromJson(Map<String, dynamic> json) =>
      ProfileHistoryData(
        packagePaymentId: json["package_payment_id"],
        paymentCode: json["payment_code"],
        packageName: json["package_name"],
        paymentMethod: json["payment_method"],
        amount: json["amount"],
        paymentStatus: json["payment_status"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "package_payment_id": packagePaymentId,
        "payment_code": paymentCode,
        "package_name": packageName,
        "payment_method": paymentMethod,
        "amount": amount,
        "payment_status": paymentStatus,
        "date": date,
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
