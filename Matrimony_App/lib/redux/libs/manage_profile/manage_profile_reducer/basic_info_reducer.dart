import 'dart:io';

import 'package:active_matrimonial_flutter_app/models_response/manage_profile/get_manage_profile/basic_Info_get_response.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/manage_profile/manage_profiles_state/basic_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models_response/drop_down/profile_dropdown_response.dart';
import '../../../../screens/core.dart';
import '../manage_profile_middleware/manage_profile_update_middlewares.dart';

BasicInfoState? basic_info_reducer(BasicInfoState? state, dynamic action) {
  if (action == SaveChanges.basicInfo) {
    state?.isloading = !(state?.isloading ?? false);
    return state!;
  }

  if (action is BasicInfoStoreAction) {
    if (state != null) {
      bir_basic_info_get_response(state, action);
    }
  }
  if (action is SetBasicGalImage) {

    if (state != null) {
      state.image = action.image;
      state.imageName = action.imageName;
    }
    return state!;
  }

  if (action == UpdateInfo.basicInfo) {
    FocusManager.instance.primaryFocus?.unfocus();
    final currentState = state;
    if (currentState?.formKey.currentState?.validate() == true) {
      store.dispatch(
        basicInfoUpdateMiddleware(
          f_name: currentState?.f_nameController?.text,
          l_name: currentState?.l_nameController?.text,
          gender: currentState?.gendervalue?.toLowerCase() == "male" ? 1 : 2,
          dob: currentState?.date.toString(),
          phone: currentState?.phoneController?.text,
          onbehalf: currentState?.on_behalves_value?.id,
          m_status: currentState?.marital_status_value?.id,
          noofChild: currentState?.no_childController?.text,
          photo: currentState?.image,
        ),
      );
    }
    return state;
  }

  if (action is SetBasicDate) {
    state!.date = action.payload!;
    return state;
  }

  return state;
}

BasicInfoState bir_basic_info_get_response(
  BasicInfoState state,
  BasicInfoStoreAction action,
) {
  // store data to store
  state.basicInfo = action.payload!.data;

  // Sanket: Side effects removed from reducer.
  // authMiddleware() and dropdown mapping moved to basicInfoGetMiddleware.

  return setBasicInfo(state);
}

BasicInfoState setBasicInfo(BasicInfoState state) {

  if (state.basicInfo != null) {
    state.f_nameController!.text = state.basicInfo!.firstName ?? '';
    state.l_nameController!.text = state.basicInfo!.lastName ?? '';
    state.no_childController!.text = state.basicInfo!.noOfChildren?.toString() ?? '0';
    state.phoneController!.text = state.basicInfo!.phone ?? '';
    state.gendervalue = state.basicInfo!.gender ?? '';
    if (state.basicInfo?.dateOfBirth != null) {
      state.date = state.basicInfo!.dateOfBirth!;
    }
  }
  return state;
}

ThunkAction<AppState> getBasicGalleryImageAction() {
  return (Store<AppState> store) async {
    try {
      final image = await store
          .state
          .manageProfileCombineState!
          .basicInfoState!
          .picker
          .pickImage(
            source: ImageSource.gallery,
            maxWidth: 1000,
            maxHeight: 1000,
            imageQuality: 85,
          );
      if (image == null) return;
      final tmpImage = File(image.path);
      store.dispatch(
        SetBasicGalImage(
          imageName: tmpImage.path.split('/').last,
          image: tmpImage,
        ),
      );
    } on PlatformException catch (e) {
      print("Failed to pick Image: $e");
    }
  };
}

class BasicInfoStoreAction {
  BasicInfoGetResponse? payload;

  BasicInfoStoreAction({this.payload});

  @override
  String toString() {
    return 'BasicInfoStoreAction{payload: $payload}';
  }
}

class SetBasicGalImage {
  String? imageName;
  File? image;

  SetBasicGalImage({this.imageName, this.image});

  @override
  String toString() {
    return 'SetBasicGalImage{imageName: $imageName, image: $image}';
  }
}

class BasicProfiledropdownResponse {
  ProfiledropdownResponseData? data;
  bool? result;
  BasicProfiledropdownResponse({this.data, this.result});
}

class SetBasicDate {
  DateTime? payload;

  SetBasicDate({this.payload});

  @override
  String toString() {
    return 'SetBasicDate{payload: $payload}';
  }
}
