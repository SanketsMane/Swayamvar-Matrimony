import 'package:flutter/foundation.dart';

class PushNotificationService {
  Future<void> initNotifications() async {
    // Sanket: Firebase Messaging removed as per request to remove all Firebase dependencies
    debugPrint("Sanket: PushNotificationService init (Firebase Disabled)");
  }
}
