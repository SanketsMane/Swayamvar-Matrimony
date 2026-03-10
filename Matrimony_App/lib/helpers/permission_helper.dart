import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Request initial permissions needed for the app to function properly
  static Future<void> requestInitialPermissions() async {
    // Sanket: Skip permission requests on Web to avoid Platform exception
    if (kIsWeb) return;

    // Basic setup of permissions to request
    List<Permission> permissions = [
      Permission.camera,
      Permission.notification,
    ];

    // Android specific storage permissions
    if (Platform.isAndroid) {
      // For Android 13 (API 33) and above, we use READ_MEDIA permissions
      // For older versions, we use STORAGE permission
      permissions.add(Permission.photos);
      
      // Also request notification permission explicitly for Android 13+
      permissions.add(Permission.notification);
    } else if (Platform.isIOS) {
      permissions.add(Permission.photos);
    }

    // Request permissions
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    
    // Log statuses for debugging if needed
    statuses.forEach((permission, status) {
      if (kDebugMode) {
        print("${permission.toString()} status: ${status.toString()}");
      }
    });
  }
}

