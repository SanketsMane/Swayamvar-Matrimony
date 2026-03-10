import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/repository/chat_repository.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_details_action.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> chatDetailsMiddleware({chatId, int? userId}) {
  return (Store<AppState> store) async {
    try {
      // Sanket: Send userId fallback for null chat cases
      var data = await ChatRepository().fetchChatDetails(chatId: chatId, userId: userId);

      store.dispatch(ChatDetailsStoreAction(payload: data));
    } catch (e) {
      //debugPrint(e);
      store.dispatch(ChatDetailsFailureAction(error: e.toString()));
      return;
    }
  };
}
