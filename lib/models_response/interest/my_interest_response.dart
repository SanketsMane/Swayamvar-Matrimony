import 'dart:convert';

MyInterestResponse myInterestResponseFromJson(String str) =>
    MyInterestResponse.fromJson(json.decode(str));

String interestResponseToJson(MyInterestResponse data) =>
    json.encode(data.toJson());

class MyInterestResponse {
  MyInterestResponse({this.data, this.links, this.meta, this.result});

  List<Data>? data;
  Links? links;
  Meta? meta;
  bool? result;

  factory MyInterestResponse.fromJson(Map<String, dynamic> json) {
    json["data"].removeWhere((element) {
      return element == null;
    });
    return MyInterestResponse(
      data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      links: json["links"] == null ? null : Links.fromJson(json["links"]),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      result: json["result"],
    );
  }

  Map<String, dynamic> toJson() => {
    "data":
        data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
    "result": result,
  };
}

class Data {
  Data({
    this.userId,
    this.packageUpdateAlert,
    this.photo,
    this.name,
    this.age,
    this.religion,
    this.country,
    this.mothereTongue,
    this.status,
  });

  int? userId;
  bool? packageUpdateAlert;
  String? photo;
  String? name;
  int? age;
  String? religion;
  String? country;
  String? mothereTongue;
  String? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    packageUpdateAlert: json["package_update_alert"],
    photo: json["photo"],
    name: json["name"],
    age: json["age"],
    religion: json["religion"],
    country: json["country"],
    mothereTongue: json["mothere_tongue"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "package_update_alert": packageUpdateAlert,
    "photo": photo,
    "name": name,
    "age": age,
    "religion": religion,
    "country": country,
    "mothere_tongue": mothereTongue,
    "status": status,
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
