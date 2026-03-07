import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../services/call_history_service.dart';
import '../widgets/glass_container.dart';
import 'lead_details_screen.dart';

class CallHistoryScreen extends StatefulWidget {
  final bool? hideAppBar;
  const CallHistoryScreen({Key? key, this.hideAppBar = false}) : super(key: key);

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  final CallHistoryService _historyService = CallHistoryService();
  final List<dynamic> _logs = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _logs.clear();
    }

    setState(() {
      if (refresh) _isLoading = true;
      else _isFetchingMore = true;
    });

    final response = await _historyService.getCallHistory(page: _currentPage);
    
    if (!mounted) return;
    if (response['result'] == true) {
      setState(() {
        _logs.addAll(response['data']);
        _lastPage = response['last_page'];
        _isLoading = false;
        _isFetchingMore = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  void _loadMore() {
    if (_currentPage < _lastPage && !_isFetchingMore) {
      _currentPage++;
      _fetchHistory();
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      DateTime dt = DateTime.parse(dateStr);
      return "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateStr;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'interested': return AppColors.success;
      case 'not_interested': return AppColors.danger;
      case 'follow_up': return AppColors.primary(context);
      case 'converted': return Colors.tealAccent;
      case 'rejected': return Colors.white24;
      case 'new': return AppColors.info;
      default: return AppColors.textSecondary(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hideAppBar ?? false) {
      return _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
          : _buildHistoryContent();
    }

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
          'Call History',
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryColor(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
          : _buildHistoryContent(),
    );
  }

  Widget _buildHistoryContent() {
    return RefreshIndicator(
      onRefresh: () => _fetchHistory(refresh: true),
      color: AppColors.bluePrimary,
      backgroundColor: AppColors.surface(context),
      child: _logs.isEmpty
          ? _buildEmptyState()
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  _loadMore();
                }
                return false;
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _logs.length + (_isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _logs.length) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator(color: AppColors.bluePrimary, strokeWidth: 2)),
                    );
                  }

                  final log = _logs[index];
                  final lead = log['lead'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: InkWell(
                      onTap: lead != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LeadDetailsScreen(lead: lead)),
                              );
                            }
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    (lead?['name'] ?? 'UNNAMED').toString().toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimaryColor(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(log['status'] ?? '').withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    (log['status'] ?? 'NEW').toString().toUpperCase(),
                                    style: GoogleFonts.inter(
                                      color: _getStatusColor(log['status'] ?? ''),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.schedule_rounded, size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  _formatDate(log['call_time']),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondaryColor(context),
                                  ),
                                ),
                              ],
                            ),
                            if (log['notes'] != null && log['notes'].toString().isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  log['notes'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textPrimaryColor(context),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_rounded, size: 48, color: Colors.grey.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          Text(
            'NO CALL LOGS',
            style: GoogleFonts.inter(
              fontSize: 14, 
              color: Colors.grey, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
// Sanket
