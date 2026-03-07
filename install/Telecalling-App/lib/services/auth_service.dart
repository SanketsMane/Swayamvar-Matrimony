import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String identity, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/telecaller/login'),
        body: {
          'identity': identity,
          'password': password,
        },
      );
      
      return json.decode(response.body);
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/telecaller/send-otp'),
        body: {'phone': phone},
      );
      
      return json.decode(response.body);
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/telecaller/verify-otp'),
        body: {
          'phone': phone,
          'otp': otp,
        },
      );
      
      return json.decode(response.body);
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
