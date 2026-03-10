import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../helpers/main_helpers.dart';
import '../models_response/others/common_response.dart';

class ProfileAndGalleryViewRequestRepository {
  Future<CommonResponse> sendProfilePictureViewRequest({
    required int id,
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/profile-picture-view-request";
    var accessToken = getToken;

    var postBody = jsonEncode({"id": id});

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);

    return data;
  }

  Future<CommonResponse> profilePictureViewRequestAccept({id}) async {
    var baseUrl =
        "${AppConfig.BASE_URL}/member/profile-picture-view-request/accept";
    var accessToken = getToken;

    var postBody = jsonEncode({"profile_pic_view_request_id": id});
    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);

    return data;
  }

  Future<CommonResponse> profilePictureViewRequestReject({id}) async {
    var baseUrl =
        "${AppConfig.BASE_URL}/member/profile-picture-view-request/reject";
    var accessToken = getToken;

    var postBody = jsonEncode({"profile_pic_view_request_id": id});
    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);

    return data;
  }

  Future<CommonResponse> postGalleryPictureViewRequest({
    required int id,
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/gallery-image-view-request";
    var accessToken = getToken;

    var postBody = jsonEncode({"id": id});

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }

  Future<CommonResponse> postGalleryPictureAcceptReject({
    isAcceptReject,
    id,
  }) async {
    var baseUrl =
        "${AppConfig.BASE_URL}/member/gallery-image-view-request/$isAcceptReject";
    var accessToken = getToken;

    var postBody = jsonEncode({"gallery_image_view_request_id": id});

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }
}
