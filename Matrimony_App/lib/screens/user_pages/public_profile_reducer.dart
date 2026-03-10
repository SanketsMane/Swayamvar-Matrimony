import 'package:active_matrimonial_flutter_app/enums/enums.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/public_profile_action.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/public_profile_state.dart';
import 'package:flutter/material.dart';

import '../../components/full_screen_image_viewer.dart';

class PublicProfileLoader {}

PublicProfileState? public_profile_reducer(
  PublicProfileState? state,
  dynamic action,
) {
  if (action is PublicProfileStoreAction) {
    return store(state!, action);
  }
  if (action is PublicProfileFailureAction) {
    state!.isFetching = false;
    state.error = action.error;
    return state;
  }
  if (action == Reset.publicProfile) {
    state = PublicProfileState.initialState();
    return state;
  }
  if (action is ImageFullViewAction) {
    Navigator.push(
      action.contextPayload!,
      MaterialPageRoute(
        builder:
            (context) => FullScreenImageViewer(
              state!.photogallery![action.indexPayload].imagePath,
            ),
      ),
    );
  }

  return state;
}

PublicProfileState store(PublicProfileState state, PublicProfileStoreAction action) {
  state.isFetching = false;
  state.introduction =
      action.data.introduction; // Fixed typo and renamed state field
  state.basic = action.data.basicInfo;
  state.contact = action.data.contactDetails;
  state.presentAddress = action.data.presentAddress;
  state.permanentAddress = action.data.permanentAddress;
  state.education = action.data.education;
  state.career = action.data.career;
  state.physical = action.data.physicalAttributes;
  state.language = action.data.knownLanguages;
  state.motherTongue = action.data.motherTongue;
  state.hobbies = action.data.hobbiesInterest;
  state.attitude = action.data.attitudeBehavior;
  state.residency = action.data.residenceInfo;
  state.spiritual = action.data.spiritualBackgrounds;
  state.lifeStyle = action.data.lifestyles;
  state.astronomy = action.data.astrologies;
  state.partnerExpectation = action.data.partnerExpectation;
  state.photogallery = action.data.photoGallery;
  state.profilematch = action.data.profileMatch;
  state.family = action.data.familiesInformation;
  state.viewContactCheck = action.data.viewContactCheck;
  state.profilePicRequest = action.data.profilePicRequest;
  return state;
}
