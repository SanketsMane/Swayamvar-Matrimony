import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants.dart';
import '../screens/profile_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/login_screen.dart';
import '../screens/commission_history_screen.dart';
import '../screens/support_tickets_screen.dart';
import '../screens/manual_lead_screen.dart';
import '../screens/change_password_screen.dart'; // Sanket: Change Password screen
import '../screens/call_history_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background(context),
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                _drawerItem(
                  icon: Icons.dashboard_rounded,
                  text: 'Dashboard',
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _drawerItem(
                  icon: context.watch<ThemeProvider>().isDarkMode 
                      ? Icons.light_mode_rounded 
                      : Icons.dark_mode_rounded,
                  text: context.watch<ThemeProvider>().isDarkMode ? 'Light Mode' : 'Dark Mode',
                  context: context,
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'MANAGEMENT',
                    style: GoogleFonts.inter(
                      color: Colors.grey, 
                      fontSize: 11, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 1.2
                    ),
                  ),
                ),
                _drawerItem(
                  icon: Icons.person_outline_rounded,
                  text: 'My Profile',
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  },
                ),
                _drawerItem(
                  icon: Icons.notifications_none_rounded,
                  text: 'Alerts & Updates',
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertsScreen()));
                  },
                ),
                _drawerItem(
                  icon: Icons.history_rounded,
                  text: 'Call History',
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CallHistoryScreen()));
                  },
                ),
                _drawerItem(
                  icon: Icons.account_balance_wallet_outlined,
                  text: 'My Incentives',
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CommissionHistoryScreen()));
                  },
                ),
                _drawerItem(
                  icon: Icons.support_agent_rounded,
                  text: 'Support Tickets',
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportTicketsScreen()));
                  },
                ),
                _drawerItem(
                  icon: Icons.person_add_alt_1_rounded,
                  text: 'Manual Lead',
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualLeadScreen()));
                  },
                ),
                _drawerItem(
                  icon: Icons.lock_reset_rounded,
                  text: 'Change Password',
                  context: context,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Divider(color: Colors.black12, thickness: 1),
                ),
                _drawerItem(
                  icon: Icons.logout_rounded,
                  text: 'Logout',
                  context: context,
                  textColor: AppColors.danger,
                  iconColor: AppColors.danger,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.bluePrimary.withValues(alpha: 0.1),
                child: Text(
                  user?['name']?[0]?.toUpperCase() ?? 'S',
                  style: GoogleFonts.inter(color: AppColors.bluePrimary, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?['name']?.toString() ?? 'Sanket Mane',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimaryColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user?['email']?.toLowerCase() ?? 'agent@swayamvar.ai',
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                'System Online',
                style: GoogleFonts.inter(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required BuildContext context,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: iconColor ?? Colors.grey, size: 20),
        title: Text(
          text,
          style: GoogleFonts.inter(
            color: textColor ?? AppColors.textPrimaryColor(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        dense: true,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Version 2.0.26',
            style: GoogleFonts.inter(color: Colors.grey.withValues(alpha: 0.5), fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'SECURED BY SWAYAMVAR AI',
            style: GoogleFonts.inter(color: Colors.grey.withValues(alpha: 0.3), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Confirm Logout',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textPrimaryColor(context)),
        ),
        content: Text(
          'Are you sure you want to end your active session?',
          style: GoogleFonts.inter(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Logout', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
// Sanket
