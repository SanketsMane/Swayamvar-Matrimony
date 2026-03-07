import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../services/support_service.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  final _supportService = SupportService();
  bool _isLoading = true;
  List<dynamic> _tickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets({int page = 1}) async {
    setState(() => _isLoading = true);
    final response = await _supportService.getSupportTickets(page: page);
    if (!mounted) return;
    if (response['result'] == true) {
      setState(() {
        _tickets = response['data'];
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
          'Support Tickets',
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryColor(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
        : _tickets.isEmpty 
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _tickets.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final ticket = _tickets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(ticket['status'] ?? '').withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (ticket['status'] ?? 'UNKNOWN').toString().toUpperCase(), 
                                style: GoogleFonts.inter(
                                  color: _getStatusColor(ticket['status'] ?? ''), 
                                  fontSize: 10, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '#${ticket['ticket_id']}', 
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondaryColor(context), 
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ticket['subject'] ?? 'No Subject', 
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimaryColor(context), 
                            fontSize: 15, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ticket['description'] ?? '', 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondaryColor(context), 
                            fontSize: 13, 
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              ticket['created_at'].toString().split('T')[0], 
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondaryColor(context), 
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            if (ticket['status'].toString().toLowerCase() != 'closed')
                              TextButton(
                                onPressed: () => _showReplyDialog(ticket['id'], ticket['subject']),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.bluePrimary.withValues(alpha: 0.05),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                ),
                                child: Text(
                                  'REPLY', 
                                  style: GoogleFonts.inter(
                                    color: AppColors.bluePrimary, 
                                    fontSize: 12, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showReplyDialog(int ticketId, String subject) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reply to Ticket', 
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryColor(context), 
            fontSize: 16, 
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject: $subject', 
              style: GoogleFonts.inter(
                color: AppColors.textSecondaryColor(context), 
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 4,
              style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Type your reply here...',
                hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(
              'CANCEL', 
              style: GoogleFonts.inter(color: AppColors.textSecondaryColor(context), fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              final res = await _supportService.replyToTicket(ticketId, controller.text);
              if (!mounted) return;
              Navigator.pop(context);
              if (res['result'] == true) {
                _fetchTickets();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply sent successfully')));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bluePrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'SEND REPLY', 
              style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    status = status.toLowerCase();
    if (status == 'open') return AppColors.info;
    if (status == 'replied') return AppColors.success;
    if (status == 'closed') return AppColors.textSecondaryColor(context);
    return AppColors.warning;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.confirmation_number_outlined, size: 56, color: Colors.grey.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            'No support tickets assigned', 
            style: GoogleFonts.inter(color: AppColors.textSecondaryColor(context), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
// Sanket
