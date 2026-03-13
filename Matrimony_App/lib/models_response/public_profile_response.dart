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
    this.firstName,
    this.middleName, // Added by Sanket
    this.lastName,
    this.surname, // Added by Sanket
    this.code,
    this.age,
    this.religionId, // Added by Sanket
    this.religion,
    this.casteId, // Added by Sanket
    this.caste,
    this.subCasteId, // Added by Sanket
    this.dateOfBirth,
    this.onbehalf,
    this.noOfChildren,
    this.gender,
    this.phone,
    this.maritialStatus,
    this.photo,
    this.mothereTongue,
    this.approved,
    this.about, // Added by Sanket
    this.bio, // Added by Sanket
    this.annualIncome, // Added by Sanket
    this.height, // Added by Sanket
    this.weight, // Added by Sanket
    this.complexion, // Added by Sanket
    this.bloodGroup, // Added by Sanket
    this.disability, // Added by Sanket
    this.diet, // Added by Sanket
    this.manglik, // Added by Sanket
  });

  String? firstName;
  String? middleName; // Added by Sanket
  String? lastName;
  String? surname; // Added by Sanket
  String? code;
  dynamic age;
  int? religionId; // Added by Sanket
  String? religion;
  int? casteId; // Added by Sanket
  String? caste;
  int? subCasteId; // Added by Sanket
  DateTime? dateOfBirth;
  MotherTongue? onbehalf;
  dynamic noOfChildren;
  String? gender;
  String? phone;
  String? maritialStatus;
  String? photo;
  String? mothereTongue;
  dynamic approved;
  String? about; // Added by Sanket
  String? bio; // Added by Sanket
  String? annualIncome; // Added by Sanket
  String? height; // Added by Sanket
  String? weight; // Added by Sanket
  String? complexion; // Added by Sanket
  String? bloodGroup; // Added by Sanket
  dynamic disability; // Added by Sanket
  String? diet; // Added by Sanket
  dynamic manglik; // Added by Sanket

  factory BasicInfo.fromJson(Map<String, dynamic> json) => BasicInfo(
    firstName: json["first_name"] ?? json["firs_name"],
    middleName: json["middle_name"], // Sanket
    lastName: json["last_name"],
    surname: json["surname"] ?? json["last_name"], // Sanket
    code: json["code"],
    age: json["age"],
    religionId: json["religion_id"], // Sanket
    religion: json["religion"],
    casteId: json["caste_id"], // Sanket
    caste: json["caste"],
    subCasteId: json["sub_caste_id"], // Sanket
    dateOfBirth:
        json["date_of_birth"] == null
            ? null
            : DateTime.tryParse(json["date_of_birth"]),
    onbehalf:
        json["onbehalf"] == null ? null : MotherTongue.fromJson(json["onbehalf"]),
    noOfChildren: json["no_of_children"],
    gender: json["gender"],
    phone: json["phone"],
    maritialStatus: json["maritial_status"],
    photo: json["photo"],
    mothereTongue: json["mothere_tongue"]?.toString(),
    approved: json["approved"],
    about: json["about"], // Sanket
    bio: json["bio"], // Sanket
    annualIncome: json["annual_income"]?.toString(), // Sanket
    height: json["height"]?.toString(), // Sanket
    weight: json["weight"]?.toString(), // Sanket
    complexion: json["complexion"], // Sanket
    bloodGroup: json["blood_group"], // Sanket
    disability: json["disability"], // Sanket
    diet: json["diet"], // Sanket
    manglik: json["manglik"], // Sanket
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "firs_name": firstName,
    "middle_name": middleName, // Sanket
    "last_name": lastName,
    "surname": surname, // Sanket
    "code": code,
    "age": age,
    "religion_id": religionId, // Sanket
    "religion": religion,
    "caste_id": casteId, // Sanket
    "caste": caste,
    "sub_caste_id": subCasteId, // Sanket
    "date_of_birth": dateOfBirth?.toIso8601String(),
    "onbehalf": onbehalf?.toJson(),
    "no_of_children": noOfChildren,
    "gender": gender,
    "phone": phone,
    "maritial_status": maritialStatus,
    "photo": photo,
    "mothere_tongue": mothereTongue,
    "approved": approved,
    "about": about, // Sanket
    "bio": bio, // Sanket
    "annual_income": annualIncome, // Sanket
    "height": height, // Sanket
    "weight": weight, // Sanket
    "complexion": complexion, // Sanket
    "blood_group": bloodGroup, // Sanket
    "disability": disability, // Sanket
    "diet": diet, // Sanket
    "manglik": manglik, // Sanket
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
    this.maritalStatusId, // Added by Sanket
    this.childrenAcceptable,
    this.residenceCountryId,
    this.residenceCountry, // Added by Sanket
    this.religionId,
    this.religion, // Added by Sanket
    this.casteId,
    this.caste, // Added by Sanket
    this.subCasteId,
    this.subCaste, // Added by Sanket
    this.education,
    this.expectedEducation, // Added by Sanket
    this.profession,
    this.smokingAcceptable,
    this.drinkingAcceptable,
    this.diet,
    this.bodyType,
    this.personalValue,
    this.manglik,
    this.partnerManglik, // Added by Sanket
    this.language,
    this.familyValueId,
    this.preferredCountryId,
    this.preferredStateId,
    this.complexion,
    this.expectedIncome, // Added by Sanket
    this.divorceAccepted, // Added by Sanket
    this.partnerIntercaste, // Added by Sanket
  });

  String? general;
  var height;
  var weight;
  String? maritalStatus;
  int? maritalStatusId; // Added by Sanket
  dynamic childrenAcceptable;
  dynamic residenceCountryId;
  String? residenceCountry; // Added by Sanket
  dynamic religionId;
  String? religion; // Added by Sanket
  dynamic casteId;
  String? caste; // Added by Sanket
  dynamic subCasteId;
  String? subCaste; // Added by Sanket
  String? education;
  String? expectedEducation; // Added by Sanket
  String? profession;
  dynamic smokingAcceptable;
  dynamic drinkingAcceptable;
  String? diet;
  String? bodyType;
  String? personalValue;
  dynamic manglik;
  dynamic partnerManglik; // Added by Sanket
  String? language;
  String? familyValueId;
  dynamic preferredCountryId;
  dynamic preferredStateId;
  String? complexion;
  String? expectedIncome; // Added by Sanket
  dynamic divorceAccepted; // Added by Sanket
  dynamic partnerIntercaste; // Added by Sanket

  factory PartnerExpectation.fromJson(Map<String, dynamic> json) =>
      PartnerExpectation(
        general: json["general"],
        height: json["height"],
        weight: json["weight"],
        maritalStatus: json["marital_status"],
        maritalStatusId: json["marital_status_id"], // Sanket
        childrenAcceptable: json["children_acceptable"],
        residenceCountryId: json["residence_country_id"],
        residenceCountry: json["residence_country"], // Sanket
        religionId: json["religion_id"],
        religion: json["religion"], // Sanket
        casteId: json["caste_id"],
        caste: json["caste"], // Sanket
        subCasteId: json["sub_caste_id"],
        subCaste: json["sub_caste"], // Sanket
        education: json["education"],
        expectedEducation: json["expected_education"] ?? json["education"], // Sanket
        profession: json["profession"],
        smokingAcceptable: json["smoking_acceptable"],
        drinkingAcceptable: json["drinking_acceptable"],
        diet: json["diet"],
        bodyType: json["body_type"],
        personalValue: json["personal_value"],
        manglik: json["manglik"],
        partnerManglik: json["partner_manglik"] ?? json["manglik"], // Sanket
        language: json["language"],
        familyValueId: json["family_value_id"]?.toString(),
        preferredCountryId: json["preferred_country_id"],
        preferredStateId: json["preferred_state_id"],
        complexion: json["complexion"],
        expectedIncome: json["expected_income"]?.toString(), // Sanket
        divorceAccepted: json["divorce_accepted"], // Sanket
        partnerIntercaste: json["partner_intercaste"], // Sanket
      );

  Map<String, dynamic> toJson() => {
    "general": general,
    "height": height,
    "weight": weight,
    "marital_status": maritalStatus,
    "marital_status_id": maritalStatusId, // Sanket
    "children_acceptable": childrenAcceptable,
    "residence_country_id": residenceCountryId,
    "residence_country": residenceCountry, // Sanket
    "religion_id": religionId,
    "religion": religion, // Sanket
    "caste_id": casteId,
    "caste": caste, // Sanket
    "sub_caste_id": subCasteId,
    "sub_caste": subCaste, // Sanket
    "education": education,
    "expected_education": expectedEducation, // Sanket
    "profession": profession,
    "smoking_acceptable": smokingAcceptable,
    "drinking_acceptable": drinkingAcceptable,
    "diet": diet,
    "body_type": bodyType,
    "personal_value": personalValue,
    "manglik": manglik,
    "partner_manglik": partnerManglik, // Sanket
    "language": language,
    "family_value_id": familyValueId,
    "preferred_country_id": preferredCountryId,
    "preferred_state_id": preferredStateId,
    "complexion": complexion,
    "expected_income": expectedIncome, // Sanket
    "divorce_accepted": divorceAccepted, // Sanket
    "partner_intercaste": partnerIntercaste, // Sanket
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
    this.subCaste, // Added by Sanket
    this.ethnicity,
    this.personalValue,
    this.familyValueId,
    this.familyValue, // Added by Sanket
    this.communityValue,
    this.manglik, // Added by Sanket
    this.intercasteAccepted, // Added by Sanket
  });

  String? religionId;
  String? casteId;
  String? subCasteId;
  String? subCaste; // Added by Sanket
  String? ethnicity;
  String? personalValue;
  String? familyValueId;
  String? familyValue; // Added by Sanket
  String? communityValue;
  dynamic manglik; // Added by Sanket
  dynamic intercasteAccepted; // Added by Sanket

  factory SpiritualBackgrounds.fromJson(Map<String, dynamic> json) =>
      SpiritualBackgrounds(
        religionId: json["religion_id"]?.toString(),
        casteId: json["caste_id"]?.toString(),
        subCasteId: json["sub_caste_id"]?.toString(),
        subCaste: json["sub_caste"], // Sanket
        ethnicity: json["ethnicity"],
        personalValue: json["personal_value"],
        familyValueId: json["family_value_id"]?.toString(),
        familyValue: json["family_value"], // Sanket
        communityValue: json["community_value"],
        manglik: json["manglik"], // Sanket
        intercasteAccepted: json["intercaste_accepted"], // Sanket
      );

  Map<String, dynamic> toJson() => {
    "religion_id": religionId,
    "caste_id": casteId,
    "sub_caste_id": subCasteId,
    "sub_caste": subCaste, // Sanket
    "ethnicity": ethnicity,
    "personal_value": personalValue,
    "family_value_id": familyValueId,
    "family_value": familyValue, // Sanket
    "community_value": communityValue,
    "manglik": manglik, // Sanket
    "intercaste_accepted": intercasteAccepted, // Sanket
  };
}
