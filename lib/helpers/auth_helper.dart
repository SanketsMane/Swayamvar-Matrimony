import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/models_response/auth/signin_response.dart';
import 'package:active_matrimonial_flutter_app/services/auth_service.dart';

void setUserData(SignInResponse request) {
  if (request.result == true) {
    SharedPref().isLoggedIn = true;
    SharedPref().accessToken = request.accessToken ?? '';
    SharedPref().userName = request.user?.name ?? 'Unknown';
    SharedPref().userEmail = request.user?.email ?? 'Unknown';

    // Sanket: Synchronize with AuthService for login persistence across restarts
    if (request.accessToken != null) {
      AuthService().login(request.accessToken!);
    }
  }
}

void clearUserData() {
  SharedPref().clear();
  // Sanket: Clear secure storage session
  AuthService().logout();
}
