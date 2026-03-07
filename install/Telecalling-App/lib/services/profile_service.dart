import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class ProfileService {
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to fetch profile'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/telecaller/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      // We return true regardless of server failure because we want to force local logout
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
