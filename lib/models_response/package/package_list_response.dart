// To parse this JSON data, do
//
//     final packageListResponse = packageListResponseFromJson(jsonString);

import 'dart:convert';

PackageListResponse packageListResponseFromJson(String str) =>
    PackageListResponse.fromJson(json.decode(str));

String packageListResponseToJson(PackageListResponse data) =>
    json.encode(data.toJson());

class PackageListResponse {
  PackageListResponse({
    this.data,
    this.result,
  });

  List<Data>? data;
  bool? result;

  factory PackageListResponse.fromJson(Map<String, dynamic> json) =>
      PackageListResponse(
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
    this.packageId,
    this.name,
    this.image,
    this.expressInterest,
    this.photoGallery,
    this.contact,
    this.profileImageView,
    this.galleryImageView,
    this.autoProfileMatch,
    this.price,
    this.priceText,
    this.validity,
  });

  int? packageId;
  String? name;
  String? image;
  int? expressInterest;
  int? photoGallery;
  int? contact;
  int? profileImageView;
  int? galleryImageView;
  int? autoProfileMatch;
  int? price;
  String? priceText;
  int? validity;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        packageId: json["package_id"],
        name: json["name"],
        image: json["image"],
        expressInterest: json["express_interest"],
        photoGallery: json["photo_gallery"],
        contact: json["contact"],
        profileImageView: json["profile_image_view"],
        galleryImageView: json["gallery_image_view"],
        autoProfileMatch: json["auto_profile_match"],
        price: json["price"],
        priceText: json["price_text"],
        validity: json["validity"],
      );

  Map<String, dynamic> toJson() => {
        "package_id": packageId,
        "name": name,
        "image": image,
        "express_interest": expressInterest,
        "photo_gallery": photoGallery,
        "contact": contact,
        "profile_image_view": profileImageView,
        "gallery_image_view": galleryImageView,
        "auto_profile_match": autoProfileMatch,
        "price": price,
        "priceText": price == null ? null : priceText,
        "validity": validity,
      };
}
