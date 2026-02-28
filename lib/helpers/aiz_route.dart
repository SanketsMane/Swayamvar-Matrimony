import 'package:active_matrimonial_flutter_app/middleware/middleware.dart';
import 'package:flutter/material.dart';

class AIZRoute {
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Widget route, {
    Middleware<bool, T>? middleware,
  }) {
    if (middleware != null) {
      if (!middleware.next()) {
        return Future(() => null);
      }
    }
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => route),
    );
  }
}
