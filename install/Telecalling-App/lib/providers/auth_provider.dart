import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _token;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _priorityLead;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  Map<String, dynamic>? get priorityLead => _priorityLead;

  void setPriorityLead(Map<String, dynamic>? lead) {
    _priorityLead = lead;
    notifyListeners();
  }

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('telecaller_token');
      final userData = prefs.getString('telecaller_user');
      
      if (_token != null && _token!.isNotEmpty) {
        _isAuthenticated = true;
        if (userData != null) {
          _user = json.decode(userData);
        }
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String identity, String password) async {
    try {
      final response = await _authService.login(identity, password);
      if (response['result'] == true) {
        _token = response['access_token'];
        _user = response['user'];
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('telecaller_token', _token!);
        if (_user != null) {
          await prefs.setString('telecaller_user', json.encode(_user));
        }
        
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
    return false;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _token = null;
    _user = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('telecaller_token');
    await prefs.remove('telecaller_user');
    
    notifyListeners();
  }
}
