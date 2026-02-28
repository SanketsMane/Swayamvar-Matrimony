import 'package:active_matrimonial_flutter_app/models_response/chat/chat_response.dart';

class ChatStoreAction {
  ChatResponse? payload;

  @override
  String toString() {
    return 'ChatStoreAction{payload: $payload}';
  }

  ChatStoreAction({this.payload});
}

class ChatFailureAction {
  String? error;

  ChatFailureAction({this.error});

  @override
  String toString() {
    return 'ChatFailureAction{error: $error}';
  }
}
