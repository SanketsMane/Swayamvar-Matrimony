import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class CallHistoryService {
  Future<Map<String, dynamic>> getCallHistory({int page = 1, String search = ''}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final url = Uri.parse('${AppConfig.baseUrl}/telecaller/call-history?page=$page&search=$search');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to load call history'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getLeadCallHistory(int leadId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final url = Uri.parse('${AppConfig.baseUrl}/telecaller/call-history/lead/$leadId');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to load lead history'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
