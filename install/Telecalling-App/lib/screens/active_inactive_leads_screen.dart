import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../services/customer_service.dart';
import '../widgets/glass_container.dart';
import 'lead_details_screen.dart';

class ActiveInactiveLeadsScreen extends StatefulWidget {
  const ActiveInactiveLeadsScreen({Key? key}) : super(key: key);

  @override
  State<ActiveInactiveLeadsScreen> createState() => _ActiveInactiveLeadsScreenState();
}

class _ActiveInactiveLeadsScreenState extends State<ActiveInactiveLeadsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                Tab(text: 'Active'),
                Tab(text: 'Deactivated'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                const CustomerList(isActive: true),
                const CustomerList(isActive: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerList extends StatefulWidget {
  final bool isActive;
  const CustomerList({Key? key, required this.isActive}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final CustomerService _customerService = CustomerService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  List<dynamic> _customers = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isFetchingMore) {
        if (_currentPage < _lastPage) {
          _fetchMoreCustomers();
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

  Future<void> _fetchCustomers({bool reset = false}) async {
    // Sanket: Guard before any setState to prevent lifecycle crashes
    if (!mounted) return;
    if (reset) {
      setState(() {
        _currentPage = 1;
        _customers.clear();
        _isLoading = true;
      });
    } else {
      if (mounted) setState(() => _isLoading = _customers.isEmpty);
    }

    final response = await _customerService.getCustomers(
      isActive: widget.isActive,
      page: _currentPage,
      search: _searchController.text.trim(),
    );

    // Sanket: Single mounted check after all async activity
    if (!mounted) return;
    setState(() {
      if (response['result'] == true) {
        if (reset) {
          _customers = response['data'];
        } else {
          _customers.addAll(response['data']);
        }
        _currentPage = response['current_page'];
        _lastPage = response['last_page'];
      }
      _isLoading = false;
      _isFetchingMore = false;
    });
  }

  Future<void> _fetchMoreCustomers() async {
    if (!mounted) return;
    setState(() => _isFetchingMore = true);
    _currentPage++;
    await _fetchCustomers();
  }

  void _onSearchChanged(String query) {
    _fetchCustomers(reset: true);
  }
  
  String _formatStatus(String status) {
    if (status.isEmpty) return 'Unknown';
    return status.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search by name or mobile...',
                hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: _onSearchChanged,
            ),
          ),
        ),
        
        Expanded(
          child: _isLoading && _customers.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
              : RefreshIndicator(
                  onRefresh: () => _fetchCustomers(reset: true),
                  color: AppColors.bluePrimary,
                  backgroundColor: AppColors.surface(context),
                  child: _customers.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _customers.length + (_isFetchingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _customers.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(child: CircularProgressIndicator(color: AppColors.bluePrimary)),
                              );
                            }
                            
                            final customer = _customers[index];
                            final status = customer['status'] ?? '';
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => LeadDetailsScreen(lead: customer)
                                  ));
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
                                              (customer['name'] ?? 'Unnamed Subject').toString(),
                                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryColor(context)),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: (widget.isActive ? AppColors.success : AppColors.danger).withValues(alpha: 0.08),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              _formatStatus(status),
                                              style: GoogleFonts.inter(color: widget.isActive ? AppColors.success : AppColors.danger, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone_iphone_rounded, size: 14, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              customer['mobile'] ?? 'N/A', 
                                              style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              customer['city'] ?? 'Unknown', 
                                              style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
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
                child: const Icon(Icons.person_off_rounded, size: 48, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                'No leads found',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// Sanket
