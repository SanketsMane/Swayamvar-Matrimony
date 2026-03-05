import 'package:flutter/material.dart';

import '../screens/core.dart';

// Sanket: This helper ONLY navigates — approval status no longer gates app access.
// Any registered user can access all app features. isApprove is only used for
// displaying the verified badge on profiles.
Future<void> checkUserVerificationAndNavigate(
  BuildContext context,
  dynamic page,
) async {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}
