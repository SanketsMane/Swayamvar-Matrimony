import 'package:flutter/material.dart';

import '../const/my_theme.dart';
import '../screens/core.dart';
import 'package:active_matrimonial_flutter_app/redux/store.dart';

Future<void> checkUserVerificationAndNavigate(
  BuildContext context,
  dynamic page,
) async {
  if (store.state.userVerifyState?.isApprove != true) {
    OneContext().pop();
    store.dispatch(
      ShowMessageAction(
        msg: "Please verify your account",
        color: MyTheme.failure,
      ),
    );
  } else {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}
