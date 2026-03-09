import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/models_response/auth/signin_response.dart';
import 'package:active_matrimonial_flutter_app/services/auth_service.dart';

Future<void> setUserData(SignInResponse request) async {
  if (request.result == true) {
    SharedPref().isLoggedIn = true;
    SharedPref().accessToken = request.accessToken ?? '';
    SharedPref().userName = request.user?.name ?? 'Unknown';
    SharedPref().userEmail = request.user?.email ?? 'Unknown';

    // Sanket: Synchronize with AuthService for login persistence across restarts
    if (request.accessToken != null) {
      await AuthService().login(request.accessToken!);
    }
  }
}

Future<void> clearUserData() async {
  SharedPref().clear();
  // Sanket: Clear secure storage session
  await AuthService().logout();
}
