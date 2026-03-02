import 'dart:convert';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_api_request.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/models_response/auth/signin_response.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/user.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../helpers/shared_pref.dart';
import '../models_response/auth/mail_verify_response.dart';
import '../models_response/others/common_response.dart';

class AuthRepository {
  Future<SignInResponse?> signIn({email, password}) async {
    var baseUrl = "${AppConfig.BASE_URL}/signin";
    var postBody = jsonEncode({
      "email_or_phone": email,
      "password": password,
      "identity_matrix": AppConfig.purshase_code,
    });

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: postBody,
    );
    var signInResponse = signInResponseFromJson(response.body);
    if (signInResponse.result == true && signInResponse.user != null) {
      SharedPref().deactivated = signInResponse.user!.deactivated.toString();
    }

    return signInResponse;
  }

  Future<CommonResponse> changePassword({old, new_, confirm}) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/change/password";
    var accessToken = SharedPref().accessToken;

    var postBody = jsonEncode({
      "old_password": old,
      "password": new_,
      "password_confirmation": confirm,
    });

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

  Future<CommonResponse> deactivate({deactivate_status}) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/account/deactivate";
    var accessToken = SharedPref().accessToken;
    var postBody = jsonEncode({"deacticvation_status": deactivate_status});

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }

  Future<CommonResponse> resetPassword({
    required String sendBy,
    required String emailOrPhone,
    password,
    confirm_password,
    required String otp,
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/reset/password";

    var postBody = jsonEncode({
      "send_code_by": sendBy,
      "email_or_phone": emailOrPhone,
      "verification_code": otp,
      "password": password,
      "password_confirmation": confirm_password,
    });

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }

  Future<CommonResponse> logout() async {
    var baseUrl = "${AppConfig.BASE_URL}/logout";

    var accessToken = SharedPref().accessToken;

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }

  Future<CommonResponse> accountDelete() async {
    var baseUrl = "${AppConfig.BASE_URL}/member/account/delete";

    var accessToken = SharedPref().accessToken;

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }

  Future<SignInResponse> postSignUp({
    firstName,
    lastName,
    email,
    phone,
    onBehalf,
    gender,
    dateOfBirth,
    password,
    passwordConfirmation,
    recapthca,
    referral,
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/signup";
    var postBody = jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'on_behalf': onBehalf,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'referral_code': referral,
      'g-recaptcha-response': recapthca,
    });
    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: postBody,
    );

    return signInResponseFromJson(response.body);
  }

  Future<CommonResponse> verify({code}) async {
    var baseUrl = "${AppConfig.BASE_URL}/verify/code";
    var postBody = jsonEncode({"verification_code": code});

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $getToken",
      },
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }

  Future<CommonResponse> resendVerifyCode() async {
    var baseUrl = "${AppConfig.BASE_URL}/resend-verify/code";

    var response = await AizApi.get(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $getToken",
      },
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }

  Future<CommonResponse> forgetPassword({send_by, email}) async {
    var baseUrl = "${AppConfig.BASE_URL}/forgot/password";

    var postBody = jsonEncode({
      "send_code_by": send_by,
      "email_or_phone": email,
    });

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: postBody,
    );

    var data = commonResponseFromJson(response.body);
    return data;
  }


  Future<CommonResponse> sendOtp({required String phone}) async {
    var baseUrl = "${AppConfig.BASE_URL}/otp/send";
    var postBody = jsonEncode({
      "phone": phone,
    });

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: postBody,
    );

    return commonResponseFromJson(response.body);
  }

  Future<SignInResponse> verifyOtp({required String phone, required String otp}) async {
    var baseUrl = "${AppConfig.BASE_URL}/otp/verify";
    var postBody = jsonEncode({
      "phone": phone,
      "otp": otp,
    });

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: postBody,
    );

    var data = signInResponseFromJson(response.body);
    if (data.result == true && data.user != null) {
      SharedPref().deactivated = data.user!.deactivated.toString();
    }
    return data;
  }

  Future<SignInResponse> socialLogin({
    email,
    name,
    provider,
    secret_token = "",
    social_provider,
    access_token = "",
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/social-login";

    var postBody = jsonEncode({
      "email": email,
      "name": name,
      "provider": provider,
      "social_provider": social_provider,
      "secret_token": secret_token,
      "access_token": access_token,
    });

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: postBody,
    );

    var data = signInResponseFromJson(response.body);
    return data;
  }

  Future<User> getAuthData() async {
    var baseUrl = "${AppConfig.BASE_URL}/user-by-token";
    var accessToken = SharedPref().accessToken;

    var response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    var data = userFromJson(response.body);
    return data;
  }

  Future<VerifyMailResponse> sendCode({
    String? identifier,
    PhoneNumber? phoneNumber,
    required String sendBy,
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/registration/verification-code-send";

    Map<String, dynamic> postBodyMap;
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    if (sendBy == 'phone' && phoneNumber != null) {
      postBodyMap = {
        'country_code': phoneNumber.dialCode!.replaceAll('+', ''),
        'phone': phoneNumber.phoneNumber!.substring(
          phoneNumber.dialCode!.length,
        ),
      };
    } else {
      postBodyMap = {'email': identifier};
    }

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(postBodyMap),
    );

    return verifyMailResponseFromJson(response.body);
  }

  Future<VerifyMailResponse> verifyCode({
    String? identifier,
    PhoneNumber? phoneNumber,
    required String sendBy,
    required String code,
  }) async {
    var baseUrl =
        "${AppConfig.BASE_URL}/registration/verification-code-confirmation";

    Map<String, dynamic> postBodyMap;
    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (sendBy == 'phone' && phoneNumber != null) {
      postBodyMap = {'code': code, 'phone': phoneNumber.phoneNumber};
    } else {
      postBodyMap = {'code': code, 'email': identifier};
    }

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(postBodyMap),
    );

    return verifyMailResponseFromJson(response.body);
  }
}
