import 'dart:typed_data';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/models_response/others/common_response.dart';
import 'package:active_matrimonial_flutter_app/models_response/verification_form/verification_form_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class VerifyRepository {
  Future<List<VerificationFormResponse>> fetchVerificationForm() async {
    try {
      var url = Uri.parse("${AppConfig.BASE_URL}/member/verification_form");
      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $getToken",
        },
      );
      return verificationFormResponseFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Sanket: Bug 3 — accepts both File paths (mobile) and bytes (Web)
  Future<CommonResponse> submitVerifyForm({
    required String idType,
    required String idNumber,
    dynamic idFront,
    dynamic idBack,
    dynamic selfie,
    Uint8List? idFrontBytes,
    Uint8List? idBackBytes,
    Uint8List? selfieBytes,
  }) async {
    try {
      var url = Uri.parse(
        "${AppConfig.BASE_URL}/member/verification-info-store",
      );
      var request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        "Authorization": "Bearer $getToken",
        "Accept": "application/json",
      });

      request.fields['id_type'] = idType;
      request.fields['id_number'] = idNumber;

      // Sanket: Web uses bytes; mobile uses file path
      if (kIsWeb) {
        if (idFrontBytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'id_front',
            idFrontBytes,
            filename: 'id_front.jpg',
          ));
        }
        if (idBackBytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'id_back',
            idBackBytes,
            filename: 'id_back.jpg',
          ));
        }
        if (selfieBytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'selfie',
            selfieBytes,
            filename: 'selfie.jpg',
          ));
        }
      } else {
        if (idFront != null) {
          request.files.add(
            await http.MultipartFile.fromPath('id_front', idFront.path),
          );
        }
        if (idBack != null) {
          request.files.add(
            await http.MultipartFile.fromPath('id_back', idBack.path),
          );
        }
        if (selfie != null) {
          request.files.add(
            await http.MultipartFile.fromPath('selfie', selfie.path),
          );
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return commonResponseFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
