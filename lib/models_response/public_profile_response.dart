// To parse this JSON data, do
//
//     final publicProfileResponse = publicProfileResponseFromJson(jsonString);

import 'dart:convert';

PublicProfileResponse publicProfileResponseFromJson(String str) =>
    PublicProfileResponse.fromJson(json.decode(str));

String publicProfileResponseToJson(PublicProfileResponse data) =>
    json.encode(data.toJson());

class PublicProfileResponse {
  PublicProfileResponse({this.result, this.data});

  bool? result;
  Data? data;

  factory PublicProfileResponse.fromJson(Map<String, dynamic> json) =>
      PublicProfileResponse(
        result: json["result"],
        data:
            json["data"] is Map<String, dynamic>
                ? Data.fromJson(json["data"])
                : null, // Sanket: Harden
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": data?.toJson(), // Sanket: Use null safety
  };
}

class Data {
  Data({
    this.introduction,
    this.basicInfo,
    this.presentAddress,
    this.contactDetails,
    this.education,
    this.career,
    this.physicalAttributes,
    this.knownLanguages,
    this.motherTongue,
    this.hobbiesInterest,
    this.attitudeBehavior,
    this.residenceInfo,
    this.spiritualBackgrounds,
    this.lifestyles,
    this.astrologies,
    this.permanentAddress,
    this.familiesInformation,
    this.partnerExpectation,
    this.photoGallery,
    this.profileMatch,
    this.viewContactCheck,
    this.profilePicRequest,
  });

  Introduction? introduction;
  BasicInfo? basicInfo;
  var presentAddress;
  ContactDetails? contactDetails;
  List<Education>? education;
  List<Career>? career;
  PhysicalAttributes? physicalAttributes;
  List<MotherTongue>? knownLanguages;
  MotherTongue? motherTongue;
  HobbiesInterest? hobbiesInterest;
  AttitudeBehavior? attitudeBehavior;
  var residenceInfo;
  SpiritualBackgrounds? spiritualBackgrounds;
  Lifestyles? lifestyles;
  Astrologies? astrologies;
  var permanentAddress;
  FamiliesInformation? familiesInformation;
  PartnerExpectation? partnerExpectation;
  List<PhotoGallery>? photoGallery;
  int? profileMatch;
  bool? viewContactCheck;
  bool? profilePicRequest;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    introduction:
        json["introduction"] is Map<String, dynamic>
            ? Introduction.fromJson(json["introduction"])
            : null, // Sanket: Fixed typo and hardened with type check
    basicInfo:
        json["basic_info"] is Map<String, dynamic>
            ? BasicInfo.fromJson(json["basic_info"])
            : null,
    presentAddress:
        json["present_address"] is Map<String, dynamic>
            ? EntAddress.fromJson(json["present_address"])
            : null,
    contactDetails:
        json["contact_details"] is Map<String, dynamic>
            ? ContactDetails.fromJson(json["contact_details"])
            : null,
    education:
        json["education"] is List
            ? List<Education>.from(
              json["education"].map((x) => Education.fromJson(x)),
            )
            : [],
    career:
        json["career"] is List
            ? List<Career>.from(json["career"].map((x) => Career.fromJson(x)))
            : [],
    physicalAttributes:
        json["physical_attributes"] is Map<String, dynamic>
            ? PhysicalAttributes.fromJson(json["physical_attributes"])
            : null,
    knownLanguages:
        json["known_languages"] is List
            ? List<MotherTongue>.from(
              json["known_languages"].map((x) => MotherTongue.fromJson(x)),
            )
            : [],
    motherTongue:
        json["mother_tongue"] is Map<String, dynamic>
            ? MotherTongue.fromJson(json["mother_tongue"])
            : null,
    hobbiesInterest:
        json["hobbies_interest"] is Map<String, dynamic>
            ? HobbiesInterest.fromJson(json["hobbies_interest"])
            : null,
    attitudeBehavior:
        json["attitude_behavior"] is Map<String, dynamic>
            ? AttitudeBehavior.fromJson(json["attitude_behavior"])
            : null,
    residenceInfo:
        json["residence_info"] is Map<String, dynamic>
            ? ResidenceInfo.fromJson(json["residence_info"])
            : null,
    spiritualBackgrounds:
        json["spiritual_backgrounds"] is Map<String, dynamic>
            ? SpiritualBackgrounds.fromJson(json["spiritual_backgrounds"])
            : null,
    lifestyles:
        json["lifestyles"] is Map<String, dynamic>
            ? Lifestyles.fromJson(json["lifestyles"])
            : null,
    astrologies:
        json["astrologies"] is Map<String, dynamic>
            ? Astrologies.fromJson(json["astrologies"])
            : null,
    permanentAddress:
        json["permanent_address"] is Map<String, dynamic>
            ? EntAddress.fromJson(json["permanent_address"])
            : null,
    familiesInformation:
        json["families_information"] is Map<String, dynamic>
            ? FamiliesInformation.fromJson(json["families_information"])
            : null,
    partnerExpectation:
        json["partner_expectation"] is Map<String, dynamic>
            ? PartnerExpectation.fromJson(json["partner_expectation"])
            : null,
    photoGallery:
        json["photo_gallery"] is List
            ? List<PhotoGallery>.from(
              json["photo_gallery"].map((x) => PhotoGallery.fromJson(x)),
            )
            : [],
    profileMatch: json["profile_match"],
    viewContactCheck: json["view_contact_check"],
    profilePicRequest: json["profile_pic_request"],
  );

  Map<String, dynamic> toJson() => {
    "introduction": introduction?.toJson(), // Sanket: Use null safety
    "basic_info": basicInfo?.toJson(),
    "present_address": presentAddress?.toJson(),
    "contact_details": contactDetails?.toJson(),
    "education":
        education == null
            ? null
            : List<dynamic>.from(education!.map((x) => x.toJson())),
    "career":
        career == null
            ? null
            : List<dynamic>.from(career!.map((x) => x.toJson())),
    "physical_attributes": physicalAttributes?.toJson(),
    "known_languages":
        knownLanguages == null
            ? null
            : List<dynamic>.from(knownLanguages!.map((x) => x.toJson())),
    "mother_tongue": motherTongue?.toJson(),
    "hobbies_interest": hobbiesInterest?.toJson(),
    "attitude_behavior": attitudeBehavior?.toJson(),
    "residence_info": residenceInfo?.toJson(),
    "spiritual_backgrounds": spiritualBackgrounds?.toJson(),
    "lifestyles": lifestyles?.toJson(),
    "astrologies": astrologies?.toJson(),
    "permanent_address": permanentAddress?.toJson(),
    "families_information": familiesInformation?.toJson(),
    "partner_expectation": partnerExpectation?.toJson(),
    "photo_gallery":
        photoGallery == null
            ? null
            : List<dynamic>.from(photoGallery!.map((x) => x.toJson())),
    "profile_match": profileMatch,
    "view_contact_check": viewContactCheck,
    "profile_pic_request": profilePicRequest,
  };
}

class Astrologies {
  Astrologies({
    this.sunSign,
    this.moonSign,
    this.timeOfBirth,
    this.cityOfBirth,
  });

  String? sunSign;
  String? moonSign;
  String? timeOfBirth;
  String? cityOfBirth;

  factory Astrologies.fromJson(Map<String, dynamic> json) => Astrologies(
    sunSign: json["sun_sign"],
    moonSign: json["moon_sign"],
    timeOfBirth: json["time_of_birth"],
    cityOfBirth: json["city_of_birth"],
  );

  Map<String, dynamic> toJson() => {
    "sun_sign": sunSign,
    "moon_sign": moonSign,
    "time_of_birth": timeOfBirth,
    "city_of_birth": cityOfBirth,
  };
}

class AttitudeBehavior {
  AttitudeBehavior({
    this.affection,
    this.humor,
    this.politicalViews,
    this.religiousService,
  });

  String? affection;
  String? humor;
  String? politicalViews;
  String? religiousService;

  factory AttitudeBehavior.fromJson(Map<String, dynamic> json) =>
      AttitudeBehavior(
        affection: json["affection"],
        humor: json["humor"],
        politicalViews: json["political_views"],
        religiousService: json["religious_service"],
      );

  Map<String, dynamic> toJson() => {
    "affection": affection,
    "humor": humor,
    "political_views": politicalViews,
    "religious_service": religiousService,
  };
}

class BasicInfo {
  BasicInfo({
    this.firsName,
    this.lastName,
    this.code,
    this.age,
    this.religion,
    this.caste,
    this.dateOfBirth,
    this.onbehalf,
    this.noOfChildren,
    this.gender,
    this.phone,
    this.maritialStatus,
    this.photo,
    this.mothereTongue, // Sanket: Added for compatibility
  });

  String? firsName;
  String? lastName;
  String? code;
  var age;
  String? religion;
  String? caste;
  DateTime? dateOfBirth;
  MotherTongue? onbehalf;
  var noOfChildren;
  String? gender;
  String? phone;
  String? maritialStatus;
  String? photo;
  String? mothereTongue; // Sanket: Alias to prevent crashes

  factory BasicInfo.fromJson(Map<String, dynamic> json) => BasicInfo(
    firsName: json["firs_name"],
    lastName: json["last_name"],
    code: json["code"],
    age: json["age"],
    religion: json["religion"],
    caste: json["caste"],
    dateOfBirth:
        json["date_of_birth"] == null
            ? null
            : DateTime.tryParse(json["date_of_birth"]),
    onbehalf:
        json["onbehalf"] == null
            ? null
            : MotherTongue.fromJson(json["onbehalf"]),
    noOfChildren: json["no_of_children"],
    gender: json["gender"],
    phone: json["phone"],
    maritialStatus: json["maritial_status"],
    photo: json["photo"],
    mothereTongue: json["mothere_tongue"]?.toString(), // Sanket: Alias
  );

  Map<String, dynamic> toJson() => {
    "firs_name": firsName,
    "last_name": lastName,
    "code": code,
    "age": age,
    "religion": religion,
    "caste": caste,
    "date_of_birth": dateOfBirth?.toIso8601String(), // Sanket: Null safety
    "onbehalf": onbehalf?.toJson(),
    "no_of_children": noOfChildren,
    "gender": gender,
    "phone": phone,
    "maritial_status": maritialStatus,
    "photo": photo,
    "mothere_tongue": mothereTongue,
  };
}

class MotherTongue {
  MotherTongue({this.id, this.name});

  var id;
  String? name;

  factory MotherTongue.fromJson(Map<String, dynamic> json) =>
      MotherTongue(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Career {
  Career({
    this.id,
    this.designation,
    this.company,
    this.income, // Sanket: Add to constructor
    this.start,
    this.end,
    this.present,
  });

  var id;
  String? designation;
  String? company;
  String? income; // Sanket: Added for UI compatibility
  var start;
  var end;
  bool? present;

  factory Career.fromJson(Map<String, dynamic> json) => Career(
    id: json["id"],
    designation: json["designation"],
    company: json["company"],
    income: json["income"]?.toString(), // Sanket
    start: json["start"],
    end: json["end"],
    present: json["present"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "designation": designation,
    "company": company,
    "income": income,
    "start": start,
    "end": end,
    "present": present,
  };
}

class ContactDetails {
  ContactDetails({this.email, this.phone});

  String? email;
  String? phone;

  factory ContactDetails.fromJson(Map<String, dynamic> json) =>
      ContactDetails(email: json["email"], phone: json["phone"]);

  Map<String, dynamic> toJson() => {"email": email, "phone": phone};
}

class Education {
  Education({
    this.id,
    this.degree,
    this.institution,
    this.start,
    this.end,
    this.present,
  });

  var id;
  String? degree;
  String? institution;
  var start;
  var end;
  bool? present;

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json["id"],
    degree: json["degree"],
    institution: json["institution"],
    start: json["start"],
    end: json["end"],
    present: json["present"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "degree": degree,
    "institution": institution,
    "start": start,
    "end": end,
    "present": present,
  };
}

class FamiliesInformation {
  FamiliesInformation({this.father, this.mother, this.sibling});

  String? father;
  String? mother;
  String? sibling;

  factory FamiliesInformation.fromJson(Map<String, dynamic> json) =>
      FamiliesInformation(
        father: json["father"],
        mother: json["mother"],
        sibling: json["sibling"],
      );

  Map<String, dynamic> toJson() => {
    "father": father,
    "mother": mother,
    "sibling": sibling,
  };
}

class HobbiesInterest {
  HobbiesInterest({
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

  factory HobbiesInterest.fromJson(Map<String, dynamic> json) =>
      HobbiesInterest(
        hobbies: json["hobbies"],
        interests: json["interests"],
        music: json["music"],
        books: json["books"],
        movies: json["movies"],
        tvShows: json["tv_shows"],
        sports: json["sports"],
        fitnessActivities: json["fitness_activities"],
        cuisines: json["cuisines"],
        dressStyles: json["dress_styles"],
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

class Introduction {
  Introduction({this.introduction});

  String? introduction;

  factory Introduction.fromJson(Map<String, dynamic> json) => Introduction(
    introduction: json["introduction"]?.toString(), // Sanket: Ensure string
  );

  Map<String, dynamic> toJson() => {"introduction": introduction};
}

class Lifestyles {
  Lifestyles({this.diet, this.drink, this.smoke, this.livingWith});

  String? diet;
  String? drink;
  String? smoke;
  String? livingWith;

  factory Lifestyles.fromJson(Map<String, dynamic> json) => Lifestyles(
    diet: json["diet"],
    drink: json["drink"],
    smoke: json["smoke"],
    livingWith: json["living_with"],
  );

  Map<String, dynamic> toJson() => {
    "diet": diet,
    "drink": drink,
    "smoke": smoke,
    "living_with": livingWith,
  };
}

class PartnerExpectation {
  PartnerExpectation({
    this.general,
    this.height,
    this.weight,
    this.maritalStatus,
    this.childrenAcceptable,
    this.residenceCountryId,
    this.religionId,
    this.casteId,
    this.subCasteId,
    this.education,
    this.profession,
    this.smokingAcceptable,
    this.drinkingAcceptable,
    this.diet,
    this.bodyType,
    this.personalValue,
    this.manglik,
    this.language,
    this.familyValueId,
    this.preferredCountryId,
    this.preferredStateId,
    this.complexion,
  });

  String? general;
  var height;
  var weight;
  String? maritalStatus;
  String? childrenAcceptable;
  String? residenceCountryId;
  String? religionId;
  String? casteId;
  String? subCasteId;
  String? education;
  String? profession;
  String? smokingAcceptable;
  String? drinkingAcceptable;
  String? diet;
  String? bodyType;
  String? personalValue;
  String? manglik;
  String? language;
  String? familyValueId;
  String? preferredCountryId;
  String? preferredStateId;
  String? complexion;

  factory PartnerExpectation.fromJson(Map<String, dynamic> json) =>
      PartnerExpectation(
        general: json["general"],
        height: json["height"],
        weight: json["weight"],
        maritalStatus: json["marital_status"],
        childrenAcceptable: json["children_acceptable"],
        residenceCountryId: json["residence_country_id"],
        religionId: json["religion_id"],
        casteId: json["caste_id"],
        subCasteId: json["sub_caste_id"],
        education: json["education"],
        profession: json["profession"],
        smokingAcceptable: json["smoking_acceptable"],
        drinkingAcceptable: json["drinking_acceptable"],
        diet: json["diet"],
        bodyType: json["body_type"],
        personalValue: json["personal_value"],
        manglik: json["manglik"],
        language: json["language"],
        familyValueId: json["family_value_id"],
        preferredCountryId: json["preferred_country_id"],
        preferredStateId: json["preferred_state_id"],
        complexion: json["complexion"],
      );

  // Sanket: Getters for 2026 UI compatibility
  String get expectedEducation => education ?? "-";
  String get expectedIncome => "-"; // Not in current backend
  String get preferredCity => "-"; // Not in current backend
  bool get divorceAccepted =>
      maritalStatus?.toLowerCase().contains("divorce") ?? false;
  bool get partnerManglik => manglik?.toLowerCase() == "yes";

  Map<String, dynamic> toJson() => {
    "general": general,
    "height": height,
    "weight": weight,
    "marital_status": maritalStatus,
    "children_acceptable": childrenAcceptable,
    "residence_country_id": residenceCountryId,
    "religion_id": religionId,
    "caste_id": casteId,
    "sub_caste_id": subCasteId,
    "education": education,
    "profession": profession,
    "smoking_acceptable": smokingAcceptable,
    "drinking_acceptable": drinkingAcceptable,
    "diet": diet,
    "body_type": bodyType,
    "personal_value": personalValue,
    "manglik": manglik,
    "language": language,
    "family_value_id": familyValueId,
    "preferred_country_id": preferredCountryId,
    "preferred_state_id": preferredStateId,
    "complexion": complexion,
  };
}

class EntAddress {
  EntAddress({this.country, this.state, this.city, this.postalCode});

  String? country;
  String? state;
  String? city;
  String? postalCode;

  factory EntAddress.fromJson(Map<String, dynamic> json) => EntAddress(
    country: json["country"],
    state: json["state"],
    city: json["city"],
    postalCode: json["postal_code"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "state": state,
    "city": city,
    "postal_code": postalCode,
  };
}

class PhotoGallery {
  PhotoGallery({this.imagePath});

  String? imagePath;

  factory PhotoGallery.fromJson(Map<String, dynamic> json) =>
      PhotoGallery(imagePath: json["image_path"]);

  Map<String, dynamic> toJson() => {"image_path": imagePath};
}

class PhysicalAttributes {
  PhysicalAttributes({
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
    this.complexion,
    this.bloodGroup,
    this.bodyType,
    this.bodyArt,
    this.disability,
  });

  var height;
  var weight;
  String? eyeColor;
  String? hairColor;
  String? complexion;
  String? bloodGroup;
  String? bodyType;
  String? bodyArt;
  String? disability;

  factory PhysicalAttributes.fromJson(Map<String, dynamic> json) =>
      PhysicalAttributes(
        height: json["height"],
        weight: json["weight"],
        eyeColor: json["eye_color"],
        hairColor: json["hair_color"],
        complexion: json["complexion"],
        bloodGroup: json["blood_group"],
        bodyType: json["body_type"],
        bodyArt: json["body_art"],
        disability: json["disability"]?.toString(), // Sanket: Harden
      );

  // Sanket: Getters for 2026 UI compatibility
  bool get physicalDisability =>
      disability != null &&
      disability!.toLowerCase() != "no" &&
      disability!.toLowerCase() != "none";

  Map<String, dynamic> toJson() => {
    "height": height,
    "weight": weight,
    "eye_color": eyeColor,
    "hair_color": hairColor,
    "complexion": complexion,
    "blood_group": bloodGroup,
    "body_type": bodyType,
    "body_art": bodyArt,
    "disability": disability,
  };
}

class ResidenceInfo {
  ResidenceInfo({
    this.birthCountry,
    this.recidencyCountry,
    this.growupCountry,
    this.immigrationStatus,
  });

  String? birthCountry;
  String? recidencyCountry;
  String? growupCountry;
  String? immigrationStatus;

  factory ResidenceInfo.fromJson(Map<String, dynamic> json) => ResidenceInfo(
    birthCountry: json["birth_country"],
    recidencyCountry: json["recidency_country"],
    growupCountry: json["growup_country"],
    immigrationStatus: json["immigration_status"],
  );

  Map<String, dynamic> toJson() => {
    "birth_country": birthCountry,
    "recidency_country": recidencyCountry,
    "growup_country": growupCountry,
    "immigration_status": immigrationStatus,
  };
}

class SpiritualBackgrounds {
  SpiritualBackgrounds({
    this.religionId,
    this.casteId,
    this.subCasteId,
    this.ethnicity,
    this.personalValue,
    this.familyValueId,
    this.communityValue,
  });

  String? religionId;
  String? casteId;
  String? subCasteId;
  String? ethnicity;
  String? personalValue;
  String? familyValueId;
  String? communityValue;

  factory SpiritualBackgrounds.fromJson(Map<String, dynamic> json) =>
      SpiritualBackgrounds(
        religionId: json["religion_id"],
        casteId: json["caste_id"],
        subCasteId: json["sub_caste_id"],
        ethnicity: json["ethnicity"],
        personalValue: json["personal_value"],
        familyValueId: json["family_value_id"],
        communityValue: json["community_value"],
      );

  Map<String, dynamic> toJson() => {
    "religion_id": religionId,
    "caste_id": casteId,
    "sub_caste_id": subCasteId,
    "ethnicity": ethnicity,
    "personal_value": personalValue,
    "family_value_id": familyValueId,
    "community_value": communityValue,
  };

  // Sanket: Getters for 2026 UI compatibility
  bool get manglik => false; // Not in current backend spiritual info
  bool get intercasteAccepted => true; // Defaulting for search/match
}
