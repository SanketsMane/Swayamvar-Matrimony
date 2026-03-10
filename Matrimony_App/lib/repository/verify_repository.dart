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

  Future<CommonResponse> submitVerifyForm({
    required String idType,
    required String idNumber,
    dynamic idFront,
    dynamic idBack,
    dynamic selfie,
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

      if (idFront != null) {
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'id_front',
            await idFront.readAsBytes(),
            filename: idFront.name,
          ));
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('id_front', idFront.path),
          );
        }
      }
      if (idBack != null) {
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'id_back',
            await idBack.readAsBytes(),
            filename: idBack.name,
          ));
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('id_back', idBack.path),
          );
        }
      }
      if (selfie != null) {
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'selfie',
            await selfie.readAsBytes(),
            filename: selfie.name,
          ));
        } else {
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
