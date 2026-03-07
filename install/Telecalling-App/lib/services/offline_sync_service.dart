import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';
import 'lead_service.dart';

class OfflineSyncService {
  static const String queueBoxName = 'offline_queue';
  final LeadService _leadService = LeadService();

  Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(queueBoxName);
    
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        print("Internet connection restored. Starting sync...");
        syncQueue();
      }
    });
  }

  Future<void> addToQueue(int leadId, Map<String, dynamic> data) async {
    var box = Hive.box(queueBoxName);
    String key = 'update_$leadId\_${DateTime.now().millisecondsSinceEpoch}';
    await box.put(key, {
      'leadId': leadId,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
    print("Added lead update $leadId to offline queue.");
  }

  Future<void> syncQueue() async {
    var box = Hive.box(queueBoxName);
    if (box.isEmpty) return;

    print("Syncing ${box.length} offline updates...");
    
    // Check connectivity again just to be safe
    var connectivityResults = await Connectivity().checkConnectivity();
    if (connectivityResults.isEmpty || connectivityResults.first == ConnectivityResult.none) {
      print("Sync aborted: No internet connection.");
      return;
    }

    List<String> keysToRemove = [];
    
    for (var key in box.keys) {
      var entry = box.get(key);
      int leadId = entry['leadId'];
      Map<String, dynamic> data = Map<String, dynamic>.from(entry['data']);

      try {
        final result = await _leadService.updateLeadStatus(
          leadId, 
          data['status'], 
          data['notes'] ?? '',
          followupDate: data['followupDate']
        );

        if (result['result'] == true) {
          keysToRemove.add(key.toString());
          print("Successfully synced update for lead $leadId");
        }
      } catch (e) {
        print("Failed to sync update for lead $leadId: $e");
        // We leave it in the box to try again next time
      }
    }

    for (var key in keysToRemove) {
      await box.delete(key);
    }
    
    print("Sync finished. ${keysToRemove.length} updates processed.");
  }

  int get pendingCount {
    return Hive.box(queueBoxName).length;
  }
}

final OfflineSyncService offlineSyncService = OfflineSyncService();
// Sanket
