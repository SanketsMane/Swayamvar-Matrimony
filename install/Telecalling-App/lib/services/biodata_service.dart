import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

// Sanket: Service to handle biodata creation calls to the production API
class BiodataService {
  // Fetches dropdown data: genders, religions, castes, packages, etc.
  Future<Map<String, dynamic>> getDropdowns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/biodata/dropdowns'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'result': false, 'message': 'Failed to load dropdown data'};
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  // Fetches states by country ID
  Future<Map<String, dynamic>> getStates(String countryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/biodata/get-states/$countryId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'result': false, 'message': 'Failed to load states'};
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  // Fetches cities by state ID
  Future<Map<String, dynamic>> getCities(String stateId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/biodata/get-cities/$stateId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'result': false, 'message': 'Failed to load cities'};
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  // Submits the completed biodata form to create a new member profile [Sanket]
  Future<Map<String, dynamic>> submitBiodata(Map<String, String> data, {http.MultipartFile? image, http.MultipartFile? idProof, List<http.MultipartFile>? otherPhotos}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.baseUrl}/telecaller/biodata/create'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields.addAll(data);

      if (image != null) {
        request.files.add(image);
      }
      
      if (idProof != null) {
        request.files.add(idProof);
      }
      
      if (otherPhotos != null && otherPhotos.isNotEmpty) {
        request.files.addAll(otherPhotos);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return json.decode(response.body);
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  // Fetches previously submitted profiles by this telecaller
  Future<Map<String, dynamic>> getMyProfiles({int page = 1, String search = ''}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final uri = Uri.parse('${AppConfig.baseUrl}/telecaller/biodata/my-profiles')
          .replace(queryParameters: {'page': '$page', 'search': search});

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'result': false, 'message': 'Failed to load profiles'};
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
