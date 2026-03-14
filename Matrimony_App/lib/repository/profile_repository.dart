import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/models_response/account_response.dart';
import 'package:http/http.dart' as http;

import '../helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_request_response.dart';

class AccountRepository {
  // fetch profile

  Future<AccountResponse> fetchAccountInfo() async {
    var baseUrl = "${AppConfig.BASE_URL}/member/dashboard";
    var accessToken = getToken;

    var response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    
    // Check for "un_verified" or "blocked"
    AizRequestResponse.check(response);


    var data = profileResponseFromJson(response.body);

    if (data.result == false && data.data == null) {
       throw Exception("Failed to load profile data: un_verified");
    }

    return data;
  }
}
