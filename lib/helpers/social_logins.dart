// import 'package:active_matrimonial_flutter_app/redux/libs/auth/social_login_middleware.dart';
// import 'package:active_matrimonial_flutter_app/social_config.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import '../redux/store.dart';

// class SocialLogins {
//   onPressedGoogleLogin(BuildContext context) async {
//     try {
//       final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;

//       GoogleSignInAuthentication googleSignInAuthentication =
//           await googleUser.authentication;
//       String? accessToken = googleSignInAuthentication.accessToken;

//       // print("accessToken $accessToken");
//       // print("displayName ${googleUser.displayName}");
//       // print("email ${googleUser.email}");
//       // print("googleUser.id ${googleUser.id}");

//       // var loginResponse = await AuthRepository().getSocialLoginResponse(
//       //     "google", googleUser.displayName, googleUser.email, googleUser.id,
//       //     access_token: accessToken);

//       store.dispatch(
//         socialLoginMiddleware(
//           context: context,
//           social_provider: "google",
//           email: googleUser.email,
//           name: googleUser.displayName,
//           provider: googleUser.id,
//           access_token: accessToken,
//         ),
//       );
//     } on Exception catch (e) {
//       print("error is ....... $e");
//     }
//   }

//   onPressedFacebookLogin(BuildContext context) async {
//     final facebookLogin = await FacebookAuth.instance.login(
//       loginBehavior: LoginBehavior.webOnly,
//     );

//     if (facebookLogin.status == LoginStatus.success) {
//       // get the user data
//       // by default we get the userId, email,name and picture
//       final userData = await FacebookAuth.instance.getUserData();

//       // var loginResponse = await AuthRepository().getSocialLoginResponse(
//       //     "facebook",

//       store.dispatch(
//         socialLoginMiddleware(
//           context: context,
//           social_provider: "facebook",
//           email: userData['email'],
//           name: userData['name'].toString(),
//           provider: userData['id'].toString(),
//           access_token: facebookLogin.accessToken!.tokenString,
//         ),
//       );
//     } else {
//       print("....Facebook auth Failed.........");
//       print(facebookLogin.status);
//       print(facebookLogin.message);
//     }
//   }

// }

import 'package:active_matrimonial_flutter_app/redux/libs/auth/social_login_middleware.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../redux/store.dart';

class SocialLogins {
  Future<void> onPressedGoogleLogin(BuildContext context) async {
    // 1. Create an instance of GoogleSignIn
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // 2. Start the sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // 3. Handle if the user cancelled the sign-in
      if (googleUser == null) {
        print("Google Sign-In was cancelled by the user.");
        return; // Exit the function if sign-in was cancelled
      }

      // 4. Get the authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken =
          googleAuth.accessToken; // This is the correct way to get the token

      // Ensure you have an access token before proceeding
      if (accessToken == null) {
        print("Failed to retrieve Google access token.");
        return;
      }

      // 5. Dispatch your Redux action
      store.dispatch(
        socialLoginMiddleware(
          context: context,
          social_provider: "google",
          email: googleUser.email,
          name: googleUser.displayName,
          provider: googleUser.id,
          access_token: accessToken,
        ),
      );
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  // Your onPressedFacebookLogin method remains the same
  Future<void> onPressedFacebookLogin(BuildContext context) async {
    // ... your existing code
  }
}
