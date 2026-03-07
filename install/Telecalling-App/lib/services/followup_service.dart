import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class FollowupService {
  Future<Map<String, dynamic>> getFollowups({int page = 1, String type = 'today'}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/followups?page=$page&type=$type'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to fetch followups'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
