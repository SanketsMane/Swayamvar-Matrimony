
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/models_response/chat/chat_details_response.dart';
import 'package:active_matrimonial_flutter_app/models_response/chat/chat_response.dart';
import 'package:active_matrimonial_flutter_app/models_response/others/common_response.dart';
import 'package:http/http.dart' as http;

import '../helpers/shared_pref.dart';

class ChatRepository {
  Future<ChatResponse> fetchChatList() async {
    var baseUrl = "${AppConfig.BASE_URL}/member/chat-list";
    var accessToken = SharedPref().accessToken;

    var response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    var data = chatResponseFromJson(response.body);

    return data;
  }

  Future<ChatDetailsResponse> fetchChatDetails({chatId}) async {
    // print(userId);
    var baseUrl = "${AppConfig.BASE_URL}/member/chat-view/$chatId";
    var accessToken = SharedPref().accessToken;

    var response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    var data = chatDetailsResponseFromJson(response.body);
    return data;
  }

  Future<CommonResponse> postChatReply({
    int? id,
    String? text,
    dynamic attachment,
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/chat-reply";
    var accessToken = SharedPref().accessToken;

    var uri = Uri.parse(baseUrl);
    var request = http.MultipartRequest('POST', uri);

    request.fields["chat_thread_id"] = id.toString();
    request.fields["message"] = text ?? "";

    if (attachment != null) {
      if (attachment is List) {
        for (var file in attachment) {
          var pic = await http.MultipartFile.fromPath("attachment[]", file.path);
          request.files.add(pic);
        }
      } else {
        var pic = await http.MultipartFile.fromPath("attachment[]", attachment.path);
        request.files.add(pic);
      }
    }

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken",
    });

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    var data = commonResponseFromJson(responseString);

    return data;
  }
}
