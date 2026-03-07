import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class PermissionService {
  // Request all necessary permissions for the app [Sanket]
  static Future<void> requestAllPermissions() async {
    // [Sanket] Early return for web as permissions are handled by the browser
    if (kIsWeb) return;

    // Request Storage permissions
    if (Platform.isAndroid) {
      await [
        Permission.storage,
        Permission.photos,
        Permission.videos,
      ].request();
    }

    // Request Notification permission (Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // Check if storage permission is granted [Sanket]
  static Future<bool> hasStoragePermission() async {
    if (kIsWeb) return true;
    return await Permission.storage.isGranted || 
           await Permission.photos.isGranted;
  }

  // Check if notification permission is granted [Sanket]
  static Future<bool> hasNotificationPermission() async {
    if (kIsWeb) return true;
    return await Permission.notification.isGranted;
  }
}
