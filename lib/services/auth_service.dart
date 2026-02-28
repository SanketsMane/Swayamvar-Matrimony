import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();
  final _tokenKey = 'auth_token';

  // Cache the token in memory for faster access
  String? _cachedToken;

  /// Initialize and load token into memory
  Future<void> init() async {
    _cachedToken = await _storage.read(key: _tokenKey);
  }

  /// Check if user is logged in
  bool get isLoggedIn => _cachedToken != null && _cachedToken!.isNotEmpty;

  /// Get the current token
  String? get token => _cachedToken;

  /// Login: Save token securely
  Future<void> login(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _cachedToken = token;
  }

  /// Logout: Clear token and navigation stack
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _cachedToken = null;

    // Optional: Clear SharedPreferences if needed, but keep Onboarding status
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear(); // CAUTION: This might clear onboarding status too!
  }
}
