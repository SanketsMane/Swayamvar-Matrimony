import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../../repository/auth_repository.dart';
import '../helpers/show_message_state.dart';

class UpdateDeactivatedStatusAction {
  final int newStatus;
  UpdateDeactivatedStatusAction({required this.newStatus});
}

ThunkAction<AppState> deactivateMiddleware({required int deactivate_status}) {
  return (Store<AppState> store) async {
    try {
      var response = await AuthRepository().deactivate(
        deactivate_status: deactivate_status,
      );

      if (response.result) {
        store.dispatch(
          ShowMessageAction(msg: response.message, color: MyTheme.success),
        );

        store.dispatch(
          UpdateDeactivatedStatusAction(newStatus: deactivate_status),
        );
      } else {
        store.dispatch(
          ShowMessageAction(msg: response.message, color: MyTheme.failure),
        );
      }
    } catch (e) {
      debugPrint("DEACTIVATE MIDDLEWARE ERROR: ${e.toString()}");
      store.dispatch(
        ShowMessageAction(msg: "Something went wrong.", color: MyTheme.failure),
      );
      return;
    }
  };
}
