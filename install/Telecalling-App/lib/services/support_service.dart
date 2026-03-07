import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class SupportService {
  Future<Map<String, dynamic>> getSupportTickets({int page = 1}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/support-tickets?page=$page'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to fetch tickets'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> replyToTicket(int ticketId, String reply) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/telecaller/support-tickets/$ticketId/reply'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {'reply': reply},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to send reply'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
// Sanket
