import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../services/lead_service.dart';
import '../services/offline_sync_service.dart';
import '../widgets/glass_container.dart';

class LeadDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> lead;
  
  const LeadDetailsScreen({Key? key, required this.lead}) : super(key: key);

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  late Map<String, dynamic> lead;

  @override
  void initState() {
    super.initState();
    lead = widget.lead;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
      if (!mounted) return;
      _showUpdateStatusBottomSheet();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TERMINAL ERROR: LINK FAILURE')));
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    String formattedNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (!formattedNumber.startsWith('91') && formattedNumber.length == 10) {
      formattedNumber = '91$formattedNumber'; 
    }
    final Uri launchUri = Uri.parse('https://wa.me/$formattedNumber');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('WA PROTOCOL: OFFLINE')));
    }
  }

  void _showUpdateStatusBottomSheet() {
    String currentStatus = (lead['status'] ?? 'new').toString().toLowerCase();
    // Sanket: Ensure currentStatus matches a dropdown item to prevent assertion failure
    const allowedStatuses = ['new', 'assigned', 'calling_done', 'in_progress', 'interested', 'not_interested', 'follow_up', 'converted', 'rejected'];
    String selectedStatus = allowedStatuses.contains(currentStatus) ? currentStatus : 'new';
    
    final notesController = TextEditingController();
    DateTime? followupDate;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                top: 12, left: 24, right: 24
              ),
              decoration: BoxDecoration(
                color: AppColors.background(context),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4, 
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    Text(
                      'Update Lead Status',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimaryColor(context), 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Current Progress'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatus,
                          isExpanded: true,
                          dropdownColor: AppColors.surface(context),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                          style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontWeight: FontWeight.normal, fontSize: 14),
                          items: const [
                            DropdownMenuItem(value: 'new', child: Text('New Discovery')),
                            DropdownMenuItem(value: 'calling_done', child: Text('Calling Done (Green)')),
                            DropdownMenuItem(value: 'in_progress', child: Text('In Analysis')),
                            DropdownMenuItem(value: 'interested', child: Text('High Potential')),
                            DropdownMenuItem(value: 'not_interested', child: Text('Low Signal')),
                            DropdownMenuItem(value: 'follow_up', child: Text('Call Back Later (Yellow)')),
                            DropdownMenuItem(value: 'converted', child: Text('Converted')),
                            DropdownMenuItem(value: 'rejected', child: Text('Terminated')),
                          ],
                          onChanged: (val) => setModalState(() => selectedStatus = val!),
                        ),
                      ),
                    ),
                    if (selectedStatus == 'follow_up') ...[
                      const SizedBox(height: 24),
                      _buildSectionHeader('Followup Date'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                           final DateTime? picked = await showDatePicker(
                             context: context,
                             initialDate: DateTime.now().add(const Duration(days: 1)),
                             firstDate: DateTime.now(),
                             lastDate: DateTime.now().add(const Duration(days: 365)),
                             builder: (context, child) {
                               return Theme(
                                 data: Theme.of(context).copyWith(
                                   colorScheme: ColorScheme.light(
                                     primary: AppColors.bluePrimary,
                                     onPrimary: Colors.white,
                                     surface: AppColors.surface(context),
                                     onSurface: AppColors.textPrimaryColor(context),
                                   ),
                                 ),
                                 child: child!,
                               );
                             }
                           );
                           if (picked != null) setModalState(() => followupDate = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                             color: AppColors.surface(context),
                             borderRadius: BorderRadius.circular(12),
                             border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                followupDate != null ? "${followupDate!.toLocal()}".split(' ')[0] : 'Select Date',
                                style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                              ),
                              const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.bluePrimary),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    _buildSectionHeader('Interaction Notes'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      maxLines: 4,
                      style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Enter call details...',
                        hintStyle: GoogleFonts.inter(color: Colors.grey.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: AppColors.surface(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.bluePrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bluePrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isSaving ? null : () async {
                           if (selectedStatus == 'follow_up' && followupDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a followup date')));
                              return;
                           }
                           setModalState(() => isSaving = true);
                           final service = LeadService();
                           final response = await service.updateLeadStatus(
                             lead['id'], selectedStatus, notesController.text.trim(),
                             followupDate: followupDate != null ? "${followupDate!.toLocal()}".split(' ')[0] : null
                           );
                           setModalState(() => isSaving = false);
                           if (!mounted) return;
                            if (mounted) {
                              if (response['result'] == true) {
                                Navigator.pop(context);
                                setState(() {
                                  lead['status'] = selectedStatus;
                                  if (notesController.text.trim().isNotEmpty) {
                                    lead['notes'] = notesController.text.trim() + "\n" + (lead['notes'] ?? '');
                                  }
                                });
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lead status updated successfully'), backgroundColor: AppColors.success));
                                }
                              } else {
                                  await offlineSyncService.addToQueue(lead['id'], {
                                    'status': selectedStatus, 'notes': notesController.text.trim(),
                                    'followupDate': followupDate != null ? "${followupDate!.toLocal()}".split(' ')[0] : null
                                  });
                                  if (mounted) {
                                    Navigator.pop(context);
                                    setState(() => lead['status'] = selectedStatus);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cached: Sync pending'), backgroundColor: AppColors.warning));
                                  }
                              }
                            }
                        },
                        child: isSaving 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('UPDATE STATUS', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return 'Unknown';
    return status.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new': return AppColors.bluePrimary;
      case 'calling_done': return AppColors.success; // Sanket: Green
      case 'in_progress': return Colors.blueGrey;
      case 'interested': return Colors.teal;
      case 'not_interested': return const Color(0xFFEF4444);
      case 'follow_up': return AppColors.warning; // Sanket: Yellow (Call Back Later)
      case 'converted': return const Color(0xFF10B981);
      case 'rejected': return Colors.grey;
      default: return AppColors.textSecondaryColor(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String status = lead['status'] ?? 'new';
    Color statusColor = _getStatusColor(status);
    
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.bluePrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Lead Details',
          style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu_rounded, color: AppColors.bluePrimary),
            onPressed: _showUpdateStatusBottomSheet,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.bluePrimary.withValues(alpha: 0.1), width: 1),
                      ),
                      child: CircleAvatar(
                         radius: 40,
                         backgroundColor: AppColors.bluePrimary.withValues(alpha: 0.05),
                         child: Text(
                           (lead['name'] ?? 'U')[0].toUpperCase(),
                           style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.bluePrimary),
                         ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      (lead['name'] ?? 'Unnamed Lead').toString(),
                      style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryColor(context)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatStatus(status),
                        style: GoogleFonts.inter(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionCircle(Icons.phone_rounded, 'Call', const Color(0xFF10B981), () => _makePhoneCall(lead['mobile'] ?? '')),
                        _buildActionCircle(Icons.message_rounded, 'WhatsApp', const Color(0xFF25D366), () => _openWhatsApp(lead['mobile'] ?? '')),
                        _buildActionCircle(Icons.edit_calendar_rounded, 'Update', AppColors.bluePrimary, _showUpdateStatusBottomSheet),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            _buildDataBlock('Contact Information', [
              _buildInfoTile(Icons.phone_iphone_rounded, 'MOBILE', lead['mobile'] ?? 'N/A'),
              _buildInfoTile(Icons.alternate_email_rounded, 'EMAIL', lead['email'] ?? 'N/A'),
              _buildInfoTile(Icons.location_on_rounded, 'LOCATION', lead['city'] ?? 'Unknown'),
              _buildInfoTile(Icons.pin_drop_rounded, 'PINCODE', lead['pincode'] ?? 'N/A'),
            ]),

            _buildDataBlock('Lead Attribution', [
              _buildInfoTile(Icons.hub_rounded, 'SOURCE', lead['source'] ?? 'Manual Entry'),
              _buildInfoTile(Icons.person_pin_rounded, 'ASSIGNED BY', lead['assigned_by'] ?? 'System'),
              _buildInfoTile(Icons.calendar_today_rounded, 'CREATED ON', lead['created_at'] ?? 'N/A'),
            ]),

            _buildDataBlock('Communication History', [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  lead['notes'] ?? 'No notes available for this lead.',
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 14, height: 1.6),
                ),
              ),
            ]),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCircle(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.inter(color: AppColors.textSecondaryColor(context), fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDataBlock(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title.toUpperCase(), 
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bluePrimary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.bluePrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
// Sanket
