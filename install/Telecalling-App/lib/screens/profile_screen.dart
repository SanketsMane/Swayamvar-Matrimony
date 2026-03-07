import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../services/dashboard_service.dart';
import '../widgets/glass_container.dart';

class ProfileScreen extends StatefulWidget {
  final bool? hideAppBar;
  const ProfileScreen({Key? key, this.hideAppBar = false}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DashboardService _dashboardService = DashboardService();
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final response = await _dashboardService.getDashboardStats();
    // Sanket: Guard against setState on disposed widget
    if (!mounted) return;
    setState(() {
      if (response['result'] == true) {
        _profileData = response['kpis'];
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    // Sanket: Show back button only when pushed via Navigator (e.g., from drawer)
    final canGoBack = Navigator.of(context).canPop();

    if (widget.hideAppBar ?? false) {
      return SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
            : _buildProfileContent(user),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: canGoBack
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: AppColors.textPrimaryColor(context),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                'My Profile',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor(context),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
            : _buildProfileContent(user),
      ),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic>? user) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(user),
          const SizedBox(height: 32),
          _buildStatsGrid(),
          const SizedBox(height: 32),
          _buildActionList(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic>? user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.bluePrimary.withValues(alpha: 0.1),
          backgroundImage: user?['photo'] != null ? NetworkImage(user!['photo']) : null,
          child: user?['photo'] == null 
            ? const Icon(Icons.person_rounded, size: 36, color: AppColors.bluePrimary)
            : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?['name']?.toString().toUpperCase() ?? 'SANKET MANE',
                style: GoogleFonts.inter(
                  color: AppColors.textPrimaryColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user?['email']?.toLowerCase() ?? 'agent@swayamvar.ai',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondaryColor(context),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bluePrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "SALES EXECUTIVE",
                  style: GoogleFonts.inter(
                    color: AppColors.bluePrimary, 
                    fontSize: 10, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERFORMANCE OVERVIEW',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondaryColor(context),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _statCard('Conversion', '${_profileData?['conversion_rate'] ?? 0}%', Icons.analytics_rounded, AppColors.success),
            _statCard('Tasks', '${_profileData?['follow_ups'] ?? 0}', Icons.bolt_rounded, AppColors.warning),
            _statCard('Active', '${_profileData?['active_customers'] ?? 0}', Icons.hub_rounded, AppColors.bluePrimary),
            _statCard('Total', '${_profileData?['total_assigned'] ?? 0}', Icons.storage_rounded, AppColors.textSecondaryColor(context)),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11, 
                  color: AppColors.textSecondaryColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: AppColors.textPrimaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCOUNT SETTINGS',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondaryColor(context),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _actionItem('Security & Privacy', Icons.shield_outlined),
        _actionItem('System Preferences', Icons.tune_rounded),
        _actionItem('Knowledge Base', Icons.help_outline_rounded),
        _actionItem('Logout', Icons.logout_rounded, isDanger: true, onTap: () {
           Provider.of<AuthProvider>(context, listen: false).logout();
           Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }),
      ],
    );
  }

  Widget _actionItem(String title, IconData icon, {bool isDanger = false, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: onTap ?? () {},
        leading: Icon(icon, color: isDanger ? AppColors.danger : AppColors.bluePrimary, size: 20),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14, 
            fontWeight: FontWeight.w500,
            color: isDanger ? AppColors.danger : AppColors.textPrimaryColor(context),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
