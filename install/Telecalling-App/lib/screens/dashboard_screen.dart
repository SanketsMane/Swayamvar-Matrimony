import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../services/dashboard_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'lead_details_screen.dart';
import 'manual_lead_screen.dart';
import 'call_history_screen.dart';
import 'fill_biodata_screen.dart';
import 'alerts_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/lead_service.dart';

// Sanket: Primary color palette for 2026 CRM design
const _kPrimary = Color(0xFF4F46E5);
const _kSecondary = Color(0xFF6366F1);
const _kPrimaryGradient = LinearGradient(
  colors: [_kPrimary, _kSecondary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  final DashboardService _dashboardService = DashboardService();
  final LeadService _leadService = LeadService();
  bool _isLoading = true;
  bool _callLaunched = false;

  Map<String, dynamic> _kpis = {
    'todays_leads': 0,
    'pending_calls': 0,
    'follow_ups': 0,
    'active_customers': 0,
    'inactive_customers': 0,
    'conversion_rate': 0,
  };

  Map<String, dynamic>? _priorityLead;
  List<dynamic> _timeline = [];
  List<dynamic> _performanceChart = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchDashboardData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _callLaunched) {
      _callLaunched = false;
      _fetchDashboardData();
    }
  }

  Future<void> _fetchDashboardData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final response = await _dashboardService.getDashboardStats();
      if (!mounted) return;
      if (response['result'] == true) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final lead = response['priority_lead'];
        setState(() {
          _kpis = Map<String, dynamic>.from(response['kpis'] ?? _kpis);
          _priorityLead = lead;
          _timeline = response['upcoming_followups'] ?? [];
          _performanceChart = response['performance_chart'] ?? [];
          _isLoading = false;
        });
        authProvider.setPriorityLead(lead);
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Sanket: Determine greeting based on current time
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background(context),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: _kPrimary,
                strokeWidth: 2,
              ),
            )
          : _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _fetchDashboardData,
      color: _kPrimary,
      backgroundColor: AppColors.surface(context),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildGreetingHeader()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProgressCard(),
                const SizedBox(height: 28),
                _buildSectionLabel('NEXT LEAD'),
                const SizedBox(height: 12),
                _buildPriorityLeadCard(),
                const SizedBox(height: 28),
                _buildSectionLabel('QUICK ACTIONS'),
                const SizedBox(height: 12),
                _buildQuickActionsGrid(),
                const SizedBox(height: 28),
                _buildSectionLabel('PERFORMANCE'),
                const SizedBox(height: 12),
                _buildAnalyticsRow(),
                if (_performanceChart.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildPerformanceChart(),
                ],
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ─── GREETING HEADER ──────────────────────────────────────────────────────

  Widget _buildGreetingHeader() {
    final user = context.watch<AuthProvider>().user;
    final name = user?['name'] ?? 'Telecaller';
    // Sanket: Show first name only for cleanliness
    final firstName = name.toString().split(' ').first;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting() + ', $firstName 👋',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryColor(context),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your leads are waiting. Let\'s close some deals.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondaryColor(context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SECTION LABEL ────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondaryColor(context),
        letterSpacing: 1.5,
      ),
    );
  }

  // ─── TODAY'S PROGRESS CARD ────────────────────────────────────────────────

  Widget _buildProgressCard() {
    final followUps = (_kpis['follow_ups'] ?? 0) as num;
    final totalTarget = 50;
    final progress = (followUps / totalTarget).clamp(0.0, 1.0).toDouble();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _kPrimaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Progress",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${followUps.toInt()}',
                      style: GoogleFonts.inter(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/ $totalTarget calls',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    color: Colors.white,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  progress == 0
                      ? "Let's start reaching today's leads"
                      : progress >= 1
                          ? '🎉 Daily goal achieved!'
                          : '${(progress * 100).round()}% of daily goal complete',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Sanket: Circular progress ring
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(
              painter: _CircularProgressPainter(progress: progress),
              child: Center(
                child: Text(
                  '${(progress * 100).round()}%',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── NEXT LEAD CARD ───────────────────────────────────────────────────────

  Widget _buildPriorityLeadCard() {
    if (_priorityLead == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _kPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person_search_rounded, color: _kPrimary, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              'No priority lead assigned',
              style: GoogleFonts.inter(
                color: AppColors.textSecondaryColor(context),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    final leadName = (_priorityLead!['name'] ?? 'Unknown Lead').toString();
    final city = _priorityLead!['city'] ?? '';
    final state = _priorityLead!['state'] ?? '';
    final location = [city, state].where((s) => s.toString().isNotEmpty).join(', ');
    final mobile = _priorityLead!['mobile'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with name + priority badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leadName.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimaryColor(context),
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (location.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondaryColor(context)),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                location,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondaryColor(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Sanket: Lead priority badge
                _buildPriorityBadge('HIGH'),
              ],
            ),
            const SizedBox(height: 8),
            // Lead score row
            Row(
              children: [
                Icon(Icons.star_rounded, size: 14, color: Colors.amber.shade600),
                const SizedBox(width: 4),
                Text(
                  'Score: HIGH · Lead #${_priorityLead!['id'] ?? '—'}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondaryColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 20),
            // CTA Buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildCallButton(mobile),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildOutlinedCTA(
                    label: 'Details',
                    icon: Icons.info_outline_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LeadDetailsScreen(lead: _priorityLead!)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildGhostCTA(
                    label: 'Skip',
                    icon: Icons.skip_next_rounded,
                    onPressed: () {
                      if (_priorityLead != null) {
                        _leadService.updateLeadStatus(
                          _priorityLead!['id'], 
                          'calling_done', 
                          'Lead skipped from Dashboard'
                        );
                      }
                      _fetchDashboardData();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    // Sanket: Color map for priority levels
    final colors = {
      'HIGH': const Color(0xFFEF4444),
      'MEDIUM': const Color(0xFFF59E0B),
      'LOW': const Color(0xFF16A34A),
    };
    final color = colors[priority.toUpperCase()] ?? _kPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCallButton(String mobile) {
    return GestureDetector(
      onTap: () async {
        if (mobile.isNotEmpty && _priorityLead != null) {
          final uri = Uri(scheme: 'tel', path: mobile);
          if (await canLaunchUrl(uri)) {
             // Sanket: Auto-mark as calling_done so the next lead appears on refresh
             _leadService.updateLeadStatus(
               _priorityLead!['id'], 
               'calling_done', 
               'Priority call initiated from Dashboard'
             );
             _callLaunched = true;
             await launchUrl(uri);
          }
        }
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: _kPrimaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _kPrimary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'CALL',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedCTA({required String label, required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondaryColor(context)),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGhostCTA({required String label, required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── QUICK ACTIONS GRID ───────────────────────────────────────────────────

  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickAction(
        icon: Icons.person_add_alt_1_rounded,
        label: 'Add Biodata',
        color: const Color(0xFF4F46E5),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FillBiodataScreen())),
      ),
      _QuickAction(
        icon: Icons.upload_file_rounded,
        label: 'Import Leads',
        color: const Color(0xFF0EA5E9),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualLeadScreen())),
      ),
      _QuickAction(
        icon: Icons.bar_chart_rounded,
        label: 'View Reports',
        color: const Color(0xFF16A34A),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallHistoryScreen())),
      ),
    ];

    return Row(
      children: actions
          .map((action) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: actions.indexOf(action) < actions.length - 1 ? 12 : 0,
                  ),
                  child: _buildActionCard(action),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActionCard(_QuickAction action) {
    return SizedBox(
      height: 110, // Sanket: Fixed height ensures all cards are even
      child: Material(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: action.color.withValues(alpha: 0.08),
          highlightColor: action.color.withValues(alpha: 0.04),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(action.icon, color: action.color, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── ANALYTICS ROW ────────────────────────────────────────────────────────

  Widget _buildAnalyticsRow() {
    final stats = [
      _StatCard(
        label: 'Calls Today',
        value: '${_kpis['todays_leads'] ?? 0}',
        icon: Icons.phone_in_talk_rounded,
        color: _kPrimary,
      ),
      _StatCard(
        label: 'Conversion',
        value: '${_kpis['conversion_rate'] ?? 0}%',
        icon: Icons.trending_up_rounded,
        color: const Color(0xFF16A34A),
      ),
      _StatCard(
        label: 'Pending',
        value: '${_kpis['pending_calls'] ?? 0}',
        icon: Icons.pending_actions_rounded,
        color: const Color(0xFFF59E0B),
      ),
    ];

    return Row(
      children: stats
          .map((stat) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: stats.indexOf(stat) < stats.length - 1 ? 12 : 0,
                  ),
                  child: _buildStatCard(stat),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildStatCard(_StatCard stat) {
    return SizedBox(
      height: 110, // Sanket: Fixed height keeps performance cards uniform
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: stat.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(stat.icon, color: stat.color, size: 14),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.value,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryColor(context),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  stat.label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textSecondaryColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── PERFORMANCE CHART ────────────────────────────────────────────────────

  Widget _buildPerformanceChart() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.withValues(alpha: 0.08), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= _performanceChart.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _performanceChart[idx]['date'].toString().split('-').last,
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(_performanceChart.length, (i) {
                return FlSpot(i.toDouble(), (_performanceChart[i]['count'] ?? 0).toDouble());
              }),
              isCurved: true,
              color: _kPrimary,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [_kPrimary.withValues(alpha: 0.15), _kPrimary.withValues(alpha: 0.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── CIRCULAR PROGRESS PAINTER ────────────────────────────────────────────────

// Sanket: Custom painter for the circular progress indicator in the progress card
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;
    const strokeWidth = 5.0;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) => oldDelegate.progress != progress;
}

// ─── DATA MODELS ─────────────────────────────────────────────────────────────

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});
}

class _StatCard {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  _StatCard({required this.label, required this.value, required this.icon, required this.color});
}
// Sanket
