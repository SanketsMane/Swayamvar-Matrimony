import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class LeadService {
  Future<Map<String, dynamic>> getAssignedLeads({int page = 1, String search = '', String status = ''}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      // Construct URL with query parameters
      String url = '${AppConfig.baseUrl}/telecaller/leads?page=$page';
      if (search.isNotEmpty) url += '&search=$search';
      if (status.isNotEmpty) url += '&status=$status';

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
        return {'result': false, 'message': 'Failed to fetch leads'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateLeadStatus(int leadId, String status, String notes, {String? followupDate}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final Map<String, dynamic> body = {
        'status': status,
        'notes': notes,
      };

      if (followupDate != null && followupDate.isNotEmpty) {
        body['followup_date'] = followupDate;
      }

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/telecaller/leads/$leadId/update-status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to update lead status'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCampaigns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/campaigns'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to fetch campaigns'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> storeManualLead(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/telecaller/leads/store'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to save lead'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
