// To parse this JSON data, do
//
//     final hobbiesInterestGetResponse = hobbiesInterestGetResponseFromJson(jsonString);

import 'dart:convert';

HobbiesInterestGetResponse hobbiesInterestGetResponseFromJson(String str) =>
    HobbiesInterestGetResponse.fromJson(json.decode(str));

String hobbiesInterestGetResponseToJson(HobbiesInterestGetResponse data) =>
    json.encode(data.toJson());

class HobbiesInterestGetResponse {
  HobbiesInterestGetResponse({this.data, this.result});

  HobbiesInterestData? data;
  bool? result;

  factory HobbiesInterestGetResponse.fromJson(Map<String, dynamic> json) =>
      HobbiesInterestGetResponse(
        data:
            json["data"] == null
                ? null
                : HobbiesInterestData.fromJson(json["data"]),
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson(), "result": result};
}

class HobbiesInterestData {
  HobbiesInterestData({
    this.hobbies,
    this.interests,
    this.music,
    this.books,
    this.movies,
    this.tvShows,
    this.sports,
    this.fitnessActivities,
    this.cuisines,
    this.dressStyles,
  });

  String? hobbies;
  String? interests;
  String? music;
  String? books;
  String? movies;
  String? tvShows;
  String? sports;
  String? fitnessActivities;
  String? cuisines;
  String? dressStyles;

  factory HobbiesInterestData.fromJson(Map<String, dynamic> json) =>
      HobbiesInterestData(
        hobbies: json["hobbies"]?.toString(),
        interests: json["interests"]?.toString(),
        music: json["music"]?.toString(),
        books: json["books"]?.toString(),
        movies: json["movies"]?.toString(),
        tvShows: json["tv_shows"]?.toString(),
        sports: json["sports"]?.toString(),
        fitnessActivities: json["fitness_activities"]?.toString(),
        cuisines: json["cuisines"]?.toString(),
        dressStyles: json["dress_styles"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "hobbies": hobbies,
    "interests": interests,
    "music": music,
    "books": books,
    "movies": movies,
    "tv_shows": tvShows,
    "sports": sports,
    "fitness_activities": fitnessActivities,
    "cuisines": cuisines,
    "dress_styles": dressStyles,
  };
}
