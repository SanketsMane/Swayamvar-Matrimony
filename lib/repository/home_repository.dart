// import 'package:active_matrimonial_flutter_app/app_config.dart';
// import 'package:active_matrimonial_flutter_app/models_response/home_response.dart';
// import 'package:http/http.dart' as http;
//
// import '../helpers/main_helpers.dart';
//
// class HomeRepository {
//   // fetch home info list
//
//   Future<HomeResponse> fetchHome() async {
//     var baseUrl = "${AppConfig.BASE_URL}/member/home-with-login";
//     var accessToken = getToken;
//
//     var response = await http.get(Uri.parse(baseUrl), headers: {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $accessToken"
//     });
//
//     var data = homeResponseFromJson(response.body);
//     print("home data -------${response.body}");
//     return data;
//   }
// }
//}

import 'dart:convert';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/models_response/home_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<HomeResponse> fetchHome() async {
    var baseUrl = "${AppConfig.BASE_URL}/member/home-with-login";
    var accessToken = getToken;

    var response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Home Response Success: ${response.body}");
      return homeResponseFromJson(response.body);
    } else {
      debugPrint("Home Response Error: ${response.statusCode}");
      debugPrint("Error Body: ${response.body}");

      throw Exception(
        "Failed to load home data: ${jsonDecode(response.body)['message'] ?? response.body}",
      );
    }
  }
}
