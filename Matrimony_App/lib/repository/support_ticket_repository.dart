import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../helpers/main_helpers.dart';
import '../models_response/others/common_response.dart';
import '../models_response/support/my_support_categories_response.dart';
import '../models_response/support/my_ticket_response.dart';

class SupportTicketRepository {
  Future<MyTicketResponse> fetchTickets({page = 1}) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/my-tickets";
    var accessToken = getToken;

    var response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    var data = myTicketResponseFromJson(response.body);
    print('my_supppppoooo--${response.body}');
    return data;
  }

  Future<MyTicketCategoriesResponse> fetchTicketsCategories() async {
    var baseUrl = "${AppConfig.BASE_URL}/member/support-ticket/categories";
    var accessToken = getToken;

    var response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    var data = myTicketCategoriesResponseFromJson(response.body);
    return data;
  }

  Future<CommonResponse> createSupportTicket({
    dynamic subject,
    dynamic category,
    dynamic details,
    dynamic image,
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/support-ticket/store";
    var accessToken = getToken;

    final uri = Uri.parse(baseUrl);
    var request = http.MultipartRequest('POST', uri);
    request.fields["subject"] = subject;
    request.fields["support_category_id"] = category;
    request.fields["description"] = details;
    if (image != null) {
      if (kIsWeb) {
        // Sanket: Use fromBytes for web
        var pic = http.MultipartFile.fromBytes(
          "attachment",
          await image.readAsBytes(),
          filename: image.name,
        );
        request.files.add(pic);
      } else {
        // Sanket: Use fromPath for mobile
        var pic = await http.MultipartFile.fromPath("attachment", image.path);
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

  Future<CommonResponse> replySupportTicket({
    ticket_id,
    reply,
    attachment,
  }) async {
    var baseUrl = "${AppConfig.BASE_URL}/member/ticket-reply";
    var accessToken = getToken;

    final uri = Uri.parse(baseUrl);
    var request = http.MultipartRequest('POST', uri);

    request.fields["support_ticket_id"] = ticket_id.toString();
    request.fields["reply"] = reply;

    if (attachment != null) {
      if (kIsWeb) {
        // Sanket: Use fromBytes for web
        var pic = http.MultipartFile.fromBytes(
          "attachment",
          await attachment.readAsBytes(),
          filename: attachment.name,
        );
        request.files.add(pic);
      } else {
        // Sanket: Use fromPath for mobile
        var pic = await http.MultipartFile.fromPath(
          "attachment",
          attachment.path,
        );
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
