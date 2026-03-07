import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../services/followup_service.dart';
import '../widgets/glass_container.dart';
import 'lead_details_screen.dart';

class FollowupScreen extends StatefulWidget {
  const FollowupScreen({Key? key}) : super(key: key);

  @override
  State<FollowupScreen> createState() => _FollowupScreenState();
}

class _FollowupScreenState extends State<FollowupScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const SizedBox(height: 70), // TopNavBar spacing
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              indicatorColor: AppColors.bluePrimary,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              labelColor: AppColors.bluePrimary,
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: 'Today'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Overdue'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                const FollowupList(type: 'today'),
                const FollowupList(type: 'upcoming'),
                const FollowupList(type: 'overdue'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FollowupList extends StatefulWidget {
  final String type;
  const FollowupList({Key? key, required this.type}) : super(key: key);

  @override
  State<FollowupList> createState() => _FollowupListState();
}

class _FollowupListState extends State<FollowupList> {
  final FollowupService _followupService = FollowupService();
  final ScrollController _scrollController = ScrollController();
  
  List<dynamic> _followups = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchFollowups();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isFetchingMore) {
        if (_currentPage < _lastPage) {
          _fetchMoreFollowups();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchFollowups({bool reset = false}) async {
    if (reset) {
      setState(() {
        _currentPage = 1;
        _followups.clear();
        _isLoading = true;
      });
    } else {
        setState(() => _isLoading = _followups.isEmpty);
    }

    final response = await _followupService.getFollowups(
      page: _currentPage,
      type: widget.type,
    );

    if (response['result'] == true) {
      setState(() {
        if (reset) {
          _followups = response['data'];
        } else {
          _followups.addAll(response['data']);
        }
        _currentPage = response['current_page'];
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

  Future<void> _fetchMoreFollowups() async {
    setState(() => _isFetchingMore = true);
    _currentPage++;
    await _fetchFollowups();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _followups.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary));
    }

    return RefreshIndicator(
      onRefresh: () => _fetchFollowups(reset: true),
      color: AppColors.bluePrimary,
      backgroundColor: AppColors.surface(context),
      child: _followups.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _followups.length + (_isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _followups.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator(color: AppColors.bluePrimary)),
                  );
                }
                
                final item = _followups[index];
                final lead = item['lead'] ?? {};
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                       if (lead.isNotEmpty) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => LeadDetailsScreen(lead: lead)
                          ));
                       }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  (lead['name'] ?? 'Unnamed Subject').toString(),
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryColor(context)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                item['followup_date'] ?? '',
                                style: GoogleFonts.inter(
                                  color: widget.type == 'overdue' ? AppColors.danger : AppColors.bluePrimary, 
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone_iphone_rounded, size: 14, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(lead['mobile'] ?? 'N/A', style: GoogleFonts.inter(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                          if (item['notes'] != null && item['notes'].toString().isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                               width: double.infinity,
                               padding: const EdgeInsets.all(12),
                               decoration: BoxDecoration(
                                 color: Colors.grey.withValues(alpha: 0.05),
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: Text(
                                 "${item['notes']}", 
                                 style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.event_available_rounded, size: 48, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                'No pending followups',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'All protocols are currently up to date.', 
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// Sanket
