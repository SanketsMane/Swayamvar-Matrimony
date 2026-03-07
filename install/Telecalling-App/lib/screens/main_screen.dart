import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_drawer.dart';
import 'dashboard_screen.dart';
import 'assigned_leads_screen.dart';
import 'call_history_screen.dart';
import 'profile_screen.dart';
import 'alerts_screen.dart';

// Sanket: 2026 CRM Main Screen with premium floating bottom nav
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    DashboardScreen(),
    AssignedLeadsScreen(),
    CallHistoryScreen(hideAppBar: true),
    ProfileScreen(hideAppBar: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.background(context),
      body: Column(
        children: [
          _buildTopNavBar(),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  // Sanket: Floating pill-style bottom navigation bar
  Widget _buildFloatingNavBar() {
    const navItems = [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.people_rounded, label: 'Leads'),
      _NavItem(icon: Icons.bar_chart_rounded, label: 'Reports'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navItems.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isActive = _currentIndex == idx;

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _currentIndex = idx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: isActive ? Colors.white : AppColors.textSecondaryColor(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? Colors.white : AppColors.textSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.menu_rounded, color: AppColors.textPrimaryColor(context), size: 22),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            // Center tab title
            Text(
              _getTabTitle(_currentIndex),
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor(context),
              ),
            ),
            IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.notifications_outlined, color: AppColors.textPrimaryColor(context), size: 22),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AlertsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0: return 'Dashboard';
      case 1: return 'My Leads';
      case 2: return 'Reports';
      case 3: return 'Profile';
      default: return 'Dashboard';
    }
  }
}

// Sanket: Simple data class for nav items
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
// Sanket
