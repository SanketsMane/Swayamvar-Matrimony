import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../core/constants.dart';

class NotificationService {
  FirebaseMessaging? _firebaseMessaging;

  Future<void> initialize() async {
    if (kIsWeb) return; // Skip notification setup on web for now as config is missing
    
    try {
      _firebaseMessaging = FirebaseMessaging.instance;
    } catch (e) {
      print("Firebase Messaging not available: $e");
      return;
    }
    
    // Request permission for iOS and Android 13+
    NotificationSettings settings = await _firebaseMessaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
      
      // Get the token each time the application loads
      String? token = await _firebaseMessaging?.getToken();
      
      if (token != null) {
        print("FCM Token: $token");
        await _saveTokenToServer(token);
      }

      // Any time the token refreshes, store this in the database too.
      _firebaseMessaging?.onTokenRefresh.listen((newToken) {
         _saveTokenToServer(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
          // Note: In a real production app, you would use flutter_local_notifications here
          // to show a persistent banner. For now, we log it for the AI core.
        }
      });

    } else {
      print('User declined or has not accepted notification permissions');
    }
  }

  Future<void> _saveTokenToServer(String fcmToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('telecaller_token');

      // Only send if the user is logged in
      if (userToken == null) return;

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/telecaller/update-fcm-token'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
        body: {
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        print('FCM Token synced with server successfully');
      } else {
        print('Failed to sync FCM token: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  Future<Map<String, dynamic>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('telecaller_token');

      if (token == null) return {'result': false, 'message': 'Not authenticated'};

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/telecaller/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'result': false, 'message': 'Failed to fetch notifications'};
      }
    } catch (e) {
      return {'result': false, 'message': e.toString()};
    }
  }
}
