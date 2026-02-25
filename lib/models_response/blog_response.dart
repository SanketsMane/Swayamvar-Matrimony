// To parse this JSON data, do
//
//     final blogResponse = blogResponseFromJson(jsonString);

import 'dart:convert';

BlogResponse blogResponseFromJson(String str) =>
    BlogResponse.fromJson(json.decode(str));

String blogResponseToJson(BlogResponse data) => json.encode(data.toJson());

class BlogResponse {
  BlogResponse({
    this.data,
    this.result,
  });

  List<dynamic>? data;
  bool? result;

  factory BlogResponse.fromJson(Map<String, dynamic> json) => BlogResponse(
        data: json["data"] == null
            ? null
            : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "result": result,
      };
}

class Data {
  Data({
    this.id,
    this.title,
    this.slug,
    this.banner,
    this.categoryName,
    this.shortDescription,
    this.description,
  });

  int? id;
  String? title;
  String? slug;
  String? banner;
  String? categoryName;
  String? shortDescription;
  String? description;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        banner: json["banner"],
        categoryName: json["category_name"],
        shortDescription: json["short_description"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "banner": banner,
        "category_name": categoryName,
        "short_description": shortDescription,
        "description": description,
      };
}
