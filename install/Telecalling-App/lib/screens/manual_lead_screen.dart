import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/lead_service.dart';

class ManualLeadScreen extends StatefulWidget {
  const ManualLeadScreen({super.key});

  @override
  State<ManualLeadScreen> createState() => _ManualLeadScreenState();
}

class _ManualLeadScreenState extends State<ManualLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _leadService = LeadService();
  
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _businessTypeController = TextEditingController();
  
  List<dynamic> _campaigns = [];
  int? _selectedCampaignId;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchCampaigns();
  }

  Future<void> _fetchCampaigns() async {
    setState(() => _isLoading = true);
    final response = await _leadService.getCampaigns();
    if (!mounted) return;
    if (response['result'] == true) {
      setState(() {
        _campaigns = response['data'];
        if (_campaigns.isNotEmpty) {
          _selectedCampaignId = _campaigns[0]['id'];
        }
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveLead() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCampaignId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a campaign')),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    final data = {
      'name': _nameController.text,
      'mobile': _mobileController.text,
      'email': _emailController.text,
      'city': _cityController.text,
      'pincode': _pincodeController.text,
      'campaign_id': _selectedCampaignId.toString(),
      'business_type': _businessTypeController.text,
      'source': 'Mobile App Portal',
    };

    final response = await _leadService.storeManualLead(data);
    
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (response['result'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lead added successfully')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to add lead')),
      );
    }
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
          'Manual Lead Entry',
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryColor(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('BASIC INFORMATION'),
                  const SizedBox(height: 16),
                  
                  _buildFlatField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => v!.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildFlatField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    icon: Icons.smartphone_rounded,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'Mobile is required' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildFlatField(
                    controller: _emailController,
                    label: 'Email (Optional)',
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),

                  _buildSectionHeader('CAMPAIGN & TARGET'),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedCampaignId,
                        isExpanded: true,
                        dropdownColor: AppColors.surface(context),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                        items: _campaigns.map((c) => DropdownMenuItem<int>(
                          value: c['id'],
                          child: Text(
                            c['name'] ?? 'Untitled Campaign', 
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimaryColor(context), 
                              fontSize: 14,
                            ),
                          ),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedCampaignId = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionHeader('LOCATION & BUSINESS'),
                  const SizedBox(height: 16),

                  _buildFlatField(
                    controller: _cityController,
                    label: 'City',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),

                  _buildFlatField(
                    controller: _pincodeController,
                    label: 'Pincode',
                    icon: Icons.pin_drop_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildFlatField(
                    controller: _businessTypeController,
                    label: 'Business Type',
                    icon: Icons.business_center_outlined,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bluePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: _isSaving ? null : _saveLead,
                      child: _isSaving 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
                            'Initialize Lead'.toUpperCase(), 
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title, 
      style: GoogleFonts.inter(
        color: AppColors.textSecondaryColor(context), 
        fontSize: 11, 
        letterSpacing: 1.2, 
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFlatField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 14),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
          floatingLabelStyle: GoogleFonts.inter(color: AppColors.bluePrimary),
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
// Sanket
