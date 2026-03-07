import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../services/commission_service.dart';

class CommissionHistoryScreen extends StatefulWidget {
  const CommissionHistoryScreen({super.key});

  @override
  State<CommissionHistoryScreen> createState() => _CommissionHistoryScreenState();
}

class _CommissionHistoryScreenState extends State<CommissionHistoryScreen> {
  final _commissionService = CommissionService();
  bool _isLoading = true;
  List<dynamic> _history = [];
  double _totalCommission = 0;
  String _couponCode = 'N/A';

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory({int page = 1}) async {
    setState(() => _isLoading = true);
    final response = await _commissionService.getCommissionStats(page: page);
    if (!mounted) return;
    if (response['result'] == true) {
      setState(() {
        _history = response['commission_history'];
        _totalCommission = (response['total_commission'] ?? 0).toDouble();
        _couponCode = response['coupon_code'] ?? 'N/A';
      });
    }
    setState(() => _isLoading = false);
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
          'Commission History',
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryColor(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSummaryHeader(),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
              : _history.isEmpty 
                ? _buildEmptyState()
                : _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            'TOTAL EARNINGS', 
            style: GoogleFonts.inter(
              color: AppColors.textSecondaryColor(context), 
              fontSize: 11, 
              letterSpacing: 1.5, 
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '₹${_totalCommission.toStringAsFixed(2)}', 
            style: GoogleFonts.inter(
              color: AppColors.bluePrimary, 
              fontSize: 36, 
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _summaryStat('COUPON', _couponCode),
              Container(width: 1, height: 24, color: Colors.grey.withValues(alpha: 0.2)),
              _summaryStat('REFERS', _history.length.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label, 
            style: GoogleFonts.inter(
              color: AppColors.textSecondaryColor(context), 
              fontSize: 10, 
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value, 
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryColor(context), 
              fontSize: 15, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 56, color: Colors.grey.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            'No commissions earned yet', 
            style: GoogleFonts.inter(color: AppColors.textSecondaryColor(context), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_task_rounded, color: AppColors.success, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['user']['name'] ?? 'Unknown Member', 
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimaryColor(context), 
                          fontSize: 15, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Coupon: ${item['coupon_code']}', 
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondaryColor(context), 
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+₹${item['commission_amount']}', 
                      style: GoogleFonts.inter(
                        color: AppColors.success, 
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['created_at'].split('T')[0], 
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondaryColor(context), 
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// Sanket
