// To parse this JSON data, do
//
//     final appInfoResponse = appInfoResponseFromJson(jsonString);

import 'dart:convert';

AppInfoResponse appInfoResponseFromJson(String str) =>
    AppInfoResponse.fromJson(json.decode(str));

String appInfoResponseToJson(AppInfoResponse data) =>
    json.encode(data.toJson());

class AppInfoResponse {
  AppInfoResponse({this.result, this.data});

  bool? result;
  Data? data;

  factory AppInfoResponse.fromJson(Map<String, dynamic> json) =>
      AppInfoResponse(
        result: json["result"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"result": result, "data": data?.toJson()};
}

class Data {
  Data({
    this.websiteName,
    this.systemLogo,
    this.howItWorksTitle,
    this.howItWorksSubTitle,
    this.howItWorks,
    this.recaptchaSiteKey,
  });

  String? websiteName;
  String? systemLogo;
  String? howItWorksTitle;
  String? howItWorksSubTitle;
  List<HowItWork>? howItWorks;
  String? recaptchaSiteKey;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    websiteName: json["website_name"],
    systemLogo: json["system_logo"],
    howItWorksTitle: json["how_it_works_title"],
    howItWorksSubTitle: json["how_it_works_sub_title"],
    howItWorks:
        json["how_it_works"] == null
            ? null
            : List<HowItWork>.from(
              json["how_it_works"].map((x) => HowItWork.fromJson(x)),
            ),
    recaptchaSiteKey: json["recaptcha_site_key"],
  );

  Map<String, dynamic> toJson() => {
    "website_name": websiteName,
    "system_logo": systemLogo,
    "how_it_works_title": howItWorksTitle,
    "how_it_works_sub_title": howItWorksSubTitle,
    "how_it_works":
        howItWorks == null
            ? null
            : List<dynamic>.from(howItWorks!.map((x) => x.toJson())),
    "recaptcha_site_key": recaptchaSiteKey,
  };
}

class HowItWork {
  HowItWork({
    this.steps,
    this.howItWorksStepsTitles,
    this.howItWorksStepsSubTitles,
    this.howItWorksStepsIcons,
  });

  int? steps;
  String? howItWorksStepsTitles;
  String? howItWorksStepsSubTitles;
  String? howItWorksStepsIcons;

  factory HowItWork.fromJson(Map<String, dynamic> json) => HowItWork(
    steps: json["steps"],
    howItWorksStepsTitles: json["how_it_works_steps_titles"],
    howItWorksStepsSubTitles: json["how_it_works_steps_sub_titles"],
    howItWorksStepsIcons: json["how_it_works_steps_icons"],
  );

  Map<String, dynamic> toJson() => {
    "steps": steps,
    "how_it_works_steps_titles": howItWorksStepsTitles,
    "how_it_works_steps_sub_titles": howItWorksStepsSubTitles,
    "how_it_works_steps_icons": howItWorksStepsIcons,
  };
}
