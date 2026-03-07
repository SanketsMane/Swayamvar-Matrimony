import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../widgets/glass_container.dart';
import '../services/notification_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<dynamic> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);
    final response = await _notificationService.getNotifications();
    if (response['result'] == true) {
      setState(() {
        _alerts = response['data'] ?? [];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.bluePrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryColor(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Dismiss All',
              style: GoogleFonts.inter(
                color: AppColors.bluePrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
        : _alerts.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _alerts.length,
            itemBuilder: (context, index) {
              final alert = _alerts[index];
              return _buildAlertTile(alert);
            },
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_rounded, size: 64, color: Colors.grey.withValues(alpha: 0.2)),
          ),
          const SizedBox(height: 24),
          Text(
            'All Caught Up',
            style: GoogleFonts.inter(
              fontSize: 20,
              color: AppColors.textPrimaryColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No new intelligence at this moment.',
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTile(Map<String, dynamic> alert) {
    final bool isRead = alert['read_at'] != null && alert['read_at'] != 'null';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead ? Colors.grey.withValues(alpha: 0.05) : AppColors.bluePrimary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(alert['type'] ?? ''),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (alert['type'] ?? 'SYSTEM').toString().toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isRead ? Colors.grey : AppColors.bluePrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.bluePrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert['message'] ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textPrimaryColor(context),
                      height: 1.4,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        alert['time'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;
    Color color;

    switch (type.toLowerCase()) {
      case 'new_lead':
        icon = Icons.person_add_rounded;
        color = AppColors.bluePrimary;
        break;
      case 'followup':
        icon = Icons.event_repeat_rounded;
        color = const Color(0xFFF59E0B); // Warning
        break;
      case 'system':
        icon = Icons.settings_suggest_rounded;
        color = const Color(0xFF10B981); // Success
        break;
      default:
        icon = Icons.notifications_active_rounded;
        color = AppColors.bluePrimary;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
// Sanket
