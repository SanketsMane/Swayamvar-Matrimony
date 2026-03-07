import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../services/lead_service.dart';
import '../widgets/glass_container.dart';
import 'lead_details_screen.dart';

class AssignedLeadsScreen extends StatefulWidget {
  const AssignedLeadsScreen({Key? key}) : super(key: key);

  @override
  State<AssignedLeadsScreen> createState() => _AssignedLeadsScreenState();
}

class _AssignedLeadsScreenState extends State<AssignedLeadsScreen> {
  final LeadService _leadService = LeadService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  List<dynamic> _leads = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;
  String _currentStatusFilter = '';
  
  final List<String> _statusOptions = [
    '',
    'new',
    'calling_done',
    'in_progress',
    'interested',
    'not_interested',
    'follow_up',
    'converted',
    'rejected'
  ];

  @override
  void initState() {
    super.initState();
    _fetchLeads();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isFetchingMore) {
        if (_currentPage < _lastPage) {
          _fetchMoreLeads();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchLeads({bool reset = false}) async {
    // Sanket: Guard before any setState to prevent lifecycle crashes
    if (!mounted) return;
    if (reset) {
      setState(() {
        _currentPage = 1;
        _leads.clear();
        _isLoading = true;
      });
    }

    final response = await _leadService.getAssignedLeads(
      page: _currentPage,
      search: _searchController.text.trim(),
      status: _currentStatusFilter,
    );

    // Sanket: Single mounted check + single setState after async activity
    if (!mounted) return;
    setState(() {
      if (response['result'] == true) {
        if (reset) {
          _leads = response['data'];
        } else {
          _leads.addAll(response['data']);
        }
        _currentPage = response['current_page'];
        _lastPage = response['last_page'];
      }
      _isLoading = false;
      _isFetchingMore = false;
    });
  }

  Future<void> _fetchMoreLeads() async {
    if (!mounted) return;
    setState(() => _isFetchingMore = true);
    _currentPage++;
    await _fetchLeads();
  }

  void _onSearchChanged(String query) {
    _fetchLeads(reset: true);
  }

  void _onStatusFilterChanged(String? newStatus) {
    setState(() {
      _currentStatusFilter = newStatus ?? '';
    });
    _fetchLeads(reset: true);
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return 'Unknown';
    return status.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  Color _getStatusColor(String status) {
    status = status.toLowerCase(); // Sanket: Normalize to lowercase
    switch (status) {
      case 'new': return AppColors.info;
      case 'assigned': return AppColors.bluePrimary;
      case 'calling_done': return AppColors.success; // Sanket: Green for Calling Done
      case 'in_progress': return Colors.blueGrey;
      case 'interested': return Colors.teal;
      case 'not_interested': return AppColors.danger;
      case 'follow_up': return AppColors.warning; // Sanket: Yellow for Follow Up (Call Back Later)
      case 'converted': return Colors.tealAccent;
      case 'rejected': return Colors.white24;
      default: return AppColors.textSecondary(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchHeader(),
        Expanded(
          child: _isLoading && _leads.isEmpty
              ? Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
              : RefreshIndicator(
                  onRefresh: () => _fetchLeads(reset: true),
                  color: AppColors.primary(context),
                  backgroundColor: AppColors.surface(context),
                  child: _leads.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _leads.length + (_isFetchingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _leads.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(child: CircularProgressIndicator(color: AppColors.bluePrimary)),
                              );
                            }
                            final lead = _leads[index];
                            return _buildLeadCard(lead);
                          },
                        ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Center(
          child: Column(
            children: [
              Icon(Icons.hourglass_empty_rounded, size: 48, color: Colors.grey.withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              Text(
                'NO LEADS FOUND',
                style: GoogleFonts.inter(
                  fontSize: 12, 
                  color: AppColors.textSecondaryColor(context), 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search leads...',
                  hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: _onSearchChanged,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentStatusFilter,
                dropdownColor: AppColors.surface(context),
                icon: const Icon(Icons.filter_list_rounded, color: AppColors.bluePrimary, size: 20),
                items: _statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value == '' ? 'ALL' : _formatStatus(value).toUpperCase(),
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                onChanged: _onStatusFilterChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadCard(Map<String, dynamic> lead) {
    String status = (lead['status'] ?? 'new').toString().toLowerCase(); // Sanket: Normalize
    Color statusColor = _getStatusColor(status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LeadDetailsScreen(lead: lead)),
          );
        },
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
                      (lead['name'] ?? 'UNNAMED').toString().toUpperCase(),
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
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _formatStatus(status).toUpperCase(),
                      style: GoogleFonts.inter(
                        color: statusColor, 
                        fontSize: 10, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone_iphone_rounded, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      lead['mobile'] ?? 'N/A', 
                      style: GoogleFonts.inter(color: AppColors.textSecondaryColor(context), fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      lead['city'] ?? 'Location N/A', 
                      style: GoogleFonts.inter(color: AppColors.textSecondaryColor(context), fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Last activity: 2m ago',
                    style: GoogleFonts.inter(
                      fontSize: 11, 
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
// Sanket
// Sanket
