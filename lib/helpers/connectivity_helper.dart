import 'package:active_matrimonial_flutter_app/screens/others/offline/offline.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  Future<bool> checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> abortIfNotConnected(context, onPop) async {
    if (await checkInternetConnection() == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Offline();
          },
        ),
      ).then((value) {
        onPop(value);
      });
    }
  }
}
