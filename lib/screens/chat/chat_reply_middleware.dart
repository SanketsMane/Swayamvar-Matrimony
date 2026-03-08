import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/repository/chat_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_details_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_middleware.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> chatReplyMiddleware({
  int? id,
  int? receiverId,
  String? text,
  dynamic attachment,
}) {
  return (Store<AppState> store) async {
    try {
      var data = await ChatRepository().postChatReply(
        id: id,
        receiverId: receiverId,
        attachment: attachment,
        text: text,
      );

      if (data.result == true) {
        // Sanket: Send userId fallback for null chat refresh
        store.dispatch(chatDetailsMiddleware(chatId: id, userId: receiverId));
        store.dispatch(chatMiddleware());
      }
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  };
}
