import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class CommissionService {
  Future<Map<String, dynamic>> getCommissionStats({int page = 1}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/commissions?page=$page'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to fetch commissions'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
// Sanket
