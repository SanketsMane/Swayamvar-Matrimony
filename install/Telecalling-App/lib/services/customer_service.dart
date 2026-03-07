import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class CustomerService {
  Future<Map<String, dynamic>> getCustomers({required bool isActive, int page = 1, String search = ''}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      String endpoint = isActive ? 'active' : 'inactive';
      String url = '${AppConfig.baseUrl}/telecaller/leads/$endpoint?page=$page';
      if (search.isNotEmpty) url += '&search=$search';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to fetch customers'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
