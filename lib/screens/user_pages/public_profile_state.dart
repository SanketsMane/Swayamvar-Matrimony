import 'package:flutter/material.dart';

class PublicProfileState {
  bool? isFetching;
  BuildContext? loadingContext;
  late BuildContext galleryLoadingContext;
  var introduction;
  var basic;
  var presentAddress;
  var permanentAddress;
  var education;
  var career;
  var physical;
  var language;
  var motherTongue;
  var hobbies;
  var attitude;
  var residency;
  var spiritual;
  var lifeStyle;
  var astronomy;
  var family;
  var partnerExpectation;
  bool profilePicRequest = false;
  List? photogallery = [];
  var profilematch;
  var contact;
  String? error;

  var viewContactCheck;

  PublicProfileState.initialState()
    : isFetching = true,
      error = '',
      photogallery = [];

  PublicProfileState({
    this.loadingContext,
    this.isFetching,
    this.introduction,
    this.basic,
    this.presentAddress,
    this.permanentAddress,
    this.education,
    this.error,
    this.career,
    this.viewContactCheck,
    this.physical,
    this.language,
    this.motherTongue,
    this.hobbies,
    this.attitude,
    this.residency,
    this.spiritual,
    this.lifeStyle,
    this.astronomy,
    this.family,
    this.partnerExpectation,
    this.photogallery,
    this.profilematch,
    this.profilePicRequest = false,
    this.contact,
  });
}
