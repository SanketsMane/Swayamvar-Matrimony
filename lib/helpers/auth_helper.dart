import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/models_response/auth/signin_response.dart';

void setUserData(SignInResponse request) {
  if (request.result == true) {
    SharedPref().isLoggedIn = true;
    SharedPref().accessToken = request.accessToken ?? '';
    SharedPref().userName = request.user?.name ?? 'Unknown';
    SharedPref().userEmail = request.user?.email ?? 'Unknown';
  }
}

void clearUserData() {
  SharedPref().clear();
}
