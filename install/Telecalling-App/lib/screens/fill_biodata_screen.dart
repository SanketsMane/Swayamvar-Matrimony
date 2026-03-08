import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../services/biodata_service.dart';

class FillBiodataScreen extends StatefulWidget {
  const FillBiodataScreen({super.key});

  @override
  State<FillBiodataScreen> createState() => _FillBiodataScreenState();
}

class _FillBiodataScreenState extends State<FillBiodataScreen> {
  final _biodataService = BiodataService();
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  int _currentStep = 0;
  bool _isLoadingDropdowns = true;
  bool _isSaving = false;

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  XFile? _idProofImage;
  List<XFile> _galleryImages = [];

  // Controllers
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobile2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _weightController = TextEditingController();
  final _disabilityDetailsController = TextEditingController();
  final _noOfBrothersController = TextEditingController();
  final _marriedBrothersController = TextEditingController();
  final _noOfSistersController = TextEditingController();
  final _marriedSistersController = TextEditingController();
  final _parentsOccupationController = TextEditingController();
  final _occupationTypeController = TextEditingController();
  final _occupationDetailsController = TextEditingController();
  final _addressDetailsController = TextEditingController();
  final _expectedEducationController = TextEditingController();
  final _annualIncomeController = TextEditingController();
  final _propertyDetailsController = TextEditingController();
  final _expectedIncomeController = TextEditingController();

  // Dropdown Lists
  List<Map<String, String>> _genders = [];
  List<Map<String, String>> _onBehalves = [];
  List<Map<String, String>> _maritalStatuses = [];
  List<Map<String, String>> _languages = [];
  List<Map<String, String>> _religions = [];
  List<Map<String, dynamic>> _allCastes = [];
  List<Map<String, dynamic>> _filteredCastes = [];
  List<Map<String, String>> _bloodGroups = [];
  List<Map<String, String>> _complexions = [];
  List<Map<String, String>> _cities = []; // Now called Districts
  List<Map<String, String>> _packages = [];
  List<Map<String, String>> _educations = [];
  List<Map<String, String>> _heights = [];
  List<Map<String, dynamic>> _allSubCastes = [];
  List<Map<String, dynamic>> _filteredSubCastes = [];
  List<Map<String, String>> _familyValues = [];
  List<Map<String, String>> _states = [];
  List<Map<String, String>> _paymentMethods = []; // New [Sanket]
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  // Selections
  String? _selectedGender;
  String? _selectedOnBehalf;
  String? _selectedMaritalStatus;
  String? _selectedLanguage;
  String? _selectedReligion;
  String? _selectedCaste;
  String? _selectedHeight;
  String? _selectedEducation;
  String? _selectedBloodGroup;
  String? _selectedComplexion;
  String? _selectedCity;
  String? _selectedPackage;
  String? _selectedSubCaste;
  String? _selectedFamilyValue;
  String? _selectedState;
  String? _selectedPaymentMethod; // New [Sanket]
  String? _selectedCountry = '101'; // Default to India [Sanket]
  DateTime? _selectedDob;

  // Yes/No Bools (Stored as String 'true'/'false')
  String? _selectedManglik = 'false';
  String? _selectedIntercasteAccepted = 'false';
  String? _selectedPhysicalDisability = 'false';
  String? _selectedFatherAlive = 'true';
  String? _selectedMotherAlive = 'true';
  String? _selectedPartnerManglik = 'false';
  String? _selectedDivorceAccepted = 'false';
  String? _selectedPartnerIntercaste = 'false';

  @override
  void initState() {
    super.initState();
    _fetchDropdowns();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _mobile2Controller.dispose();
    _emailController.dispose();
    _weightController.dispose();
    _disabilityDetailsController.dispose();
    _noOfBrothersController.dispose();
    _marriedBrothersController.dispose();
    _noOfSistersController.dispose();
    _marriedSistersController.dispose();
    _parentsOccupationController.dispose();
    _occupationTypeController.dispose();
    _occupationDetailsController.dispose();
    _addressDetailsController.dispose();
    _expectedEducationController.dispose();
    _annualIncomeController.dispose();
    _propertyDetailsController.dispose();
    _expectedIncomeController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _toStringList(List<dynamic>? raw) {
    if (raw == null) return [];
    return raw.map<Map<String, String>>((item) => {
      'id': item['id']?.toString() ?? '',
      'name': (item['name'] ?? '').toString(),
    }).toList();
  }

  Future<void> _fetchDropdowns() async {
    final response = await _biodataService.getDropdowns();
    if (response['result'] == true && mounted) {
      final data = response['data'] as Map<String, dynamic>;

      final allCastes = (data['castes'] as List<dynamic>? ?? []).map<Map<String, dynamic>>((c) => {
        'id': c['id'].toString(),
        'name': (c['name'] ?? '').toString(),
        'religion_id': c['religion_id']?.toString() ?? '',
      }).toList();

      setState(() {
        _genders = _toStringList(data['genders'] ?? []);
        _onBehalves = _toStringList(data['on_behalves'] ?? []);
        _maritalStatuses = _toStringList(data['marital_statuses'] ?? []);
        _languages = _toStringList(data['languages'] ?? []);
        _religions = _toStringList(data['religions'] ?? []);
        _educations = _toStringList(data['educations'] ?? []); // New Array
        _heights = _toStringList(data['heights'] ?? []);       // New Array
        _bloodGroups = _toStringList(data['blood_groups'] ?? []);
        _complexions = _toStringList(data['complexions'] ?? []);
        _allCastes = allCastes;
        _filteredCastes = allCastes;

        final allSubCastes = (data['sub_castes'] as List<dynamic>? ?? []).map<Map<String, dynamic>>((s) => {
          'id': s['id'].toString(),
          'name': (s['name'] ?? '').toString(),
          'caste_id': s['caste_id']?.toString() ?? '',
        }).toList();
        _allSubCastes = allSubCastes;
        _filteredSubCastes = allSubCastes;

        _familyValues = _toStringList(data['family_values'] ?? []);
        _paymentMethods = _toStringList(data['manual_payment_methods'] ?? []); // New [Sanket]

        _packages = (data['packages'] as List<dynamic>? ?? []).map<Map<String, String>>((p) => {
          'id': p['id'].toString(),
          'name': (p['name'] ?? '').toString(),
          'price': p['price']?.toString() ?? '0',
        }).toList();

        _heights = _heights.isNotEmpty ? _heights : [
          {'id': '1', 'name': '4\' 5" (135 cm)'},
          {'id': '2', 'name': '4\' 6" (137 cm)'},
          {'id': '3', 'name': '4\' 7" (140 cm)'},
          {'id': '4', 'name': '4\' 8" (142 cm)'},
          {'id': '5', 'name': '4\' 9" (145 cm)'},
          {'id': '6', 'name': '4\' 10" (147 cm)'},
          {'id': '7', 'name': '4\' 11" (150 cm)'},
          {'id': '8', 'name': '5\' 0" (152 cm)'},
          {'id': '9', 'name': '5\' 1" (155 cm)'},
          {'id': '10', 'name': '5\' 2" (157 cm)'},
          {'id': '11', 'name': '5\' 3" (160 cm)'},
          {'id': '12', 'name': '5\' 4" (162 cm)'},
          {'id': '13', 'name': '5\' 5" (165 cm)'},
          {'id': '14', 'name': '5\' 6" (167 cm)'},
          {'id': '15', 'name': '5\' 7" (170 cm)'},
          {'id': '16', 'name': '5\' 8" (172 cm)'},
          {'id': '17', 'name': '5\' 9" (175 cm)'},
          {'id': '18', 'name': '5\' 10" (177 cm)'},
          {'id': '19', 'name': '5\' 11" (180 cm)'},
          {'id': '20', 'name': '6\' 0" (182 cm)'},
        ];

        _educations = _educations.isNotEmpty ? _educations : [
          {'id': '1', 'name': '10th Std'},
          {'id': '2', 'name': '12th Std (HSC)'},
          {'id': '3', 'name': 'Diploma'},
          {'id': '4', 'name': 'B.A'},
          {'id': '5', 'name': 'B.Com'},
          {'id': '6', 'name': 'B.Sc'},
          {'id': '7', 'name': 'B.Tech / B.E'},
          {'id': '8', 'name': 'B.C.A'},
          {'id': '9', 'name': 'M.A'},
          {'id': '10', 'name': 'M.Com'},
          {'id': '11', 'name': 'M.Sc'},
          {'id': '12', 'name': 'M.Tech / M.E'},
          {'id': '13', 'name': 'M.C.A'},
          {'id': '14', 'name': 'MBA'},
          {'id': '15', 'name': 'PhD'},
        ];

        // Defaults
        if (_genders.isNotEmpty) _selectedGender = _genders[0]['id'];
        if (_packages.isNotEmpty) _selectedPackage = _packages[0]['id'];
        _isLoadingDropdowns = false;
      });

      // Fetch States for India (101) and set Maharashtra (22) as default [Sanket]
      await _fetchStates('101');

    } else if (mounted) {
      setState(() => _isLoadingDropdowns = false);
    }
  }

  void _onReligionChanged(String? value) {
    setState(() {
      _selectedReligion = value;
      _selectedCaste = null;
      _filteredCastes = value == null
          ? _allCastes
          : _allCastes.where((c) => c['religion_id'] == value).toList();
    });
  }

  void _onCasteChanged(String? value) {
    setState(() {
      _selectedCaste = value;
      _selectedSubCaste = null;
      _filteredSubCastes = value == null
          ? _allSubCastes
          : _allSubCastes.where((s) => s['caste_id'] == value).toList();
    });
  }

  Future<void> _onStateChanged(String? value) async {
    setState(() {
      _selectedState = value;
      _selectedCity = null;
      _cities = [];
    });
    if (value == null) return;

    setState(() => _isLoadingCities = true);
    final response = await _biodataService.getCities(value);
    setState(() => _isLoadingCities = false);

    if (response['result'] == true && mounted) {
      setState(() {
        _cities = _toStringList(response['data'] ?? []);
      });
    }
  }

  Future<void> _fetchStates(String countryId) async {
    setState(() => _isLoadingStates = true);
    final response = await _biodataService.getStates(countryId);
    setState(() => _isLoadingStates = false);

    if (response['result'] == true && mounted) {
      setState(() {
        _states = _toStringList(response['data'] ?? []);
        // Set Maharashtra (22) as default if available [Sanket]
        if (_selectedState == null && _states.isNotEmpty) {
          final maharashtra = _states.firstWhere((s) => s['id'] == '22', orElse: () => _states[0]);
          _selectedState = maharashtra['id'];
          _onStateChanged(_selectedState);
        }
      });
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 18),
      helpText: 'SELECT DATE OF BIRTH',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.bluePrimary,
            onPrimary: Colors.white,
            surface: AppColors.surface(context),
            onSurface: AppColors.textPrimaryColor(context),
          ).copyWith(secondary: AppColors.bluePrimary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() => _profileImage = image);
    }
  }

  Future<void> _pickIdProof() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() => _idProofImage = image);
    }
  }

  Future<void> _pickGalleryImages() async {
    final List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 70,
    );
    if (images.isNotEmpty) {
      setState(() => _galleryImages.addAll(images));
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12)),
        backgroundColor: isError ? AppColors.danger : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKeys[3].currentState!.validate()) return;
    
    // Explicit Validation for Stage 1 & 2 specifics
    if (_selectedDob == null) { _showSnack('Please select Date of Birth', isError: true); return; }
    if (_selectedReligion == null) { _showSnack('Religion is mandatory', isError: true); return; }
    if (_selectedCaste == null) { _showSnack('Caste is mandatory', isError: true); return; }
    if (_selectedPackage == null) { _showSnack('Please select a Package', isError: true); return; }

    setState(() => _isSaving = true);

    final data = {
      // Stage 1: Basic
      'first_name': _firstNameController.text.trim(),
      'middle_name': _middleNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'mobile2': _mobile2Controller.text.trim(),
      'email': _emailController.text.trim(),
      'gender': _selectedGender ?? 'Male',
      'date_of_birth': '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}',
      'on_behalf': _selectedOnBehalf ?? '',
      'marital_status': _selectedMaritalStatus ?? '',
      'language': _selectedLanguage ?? '',
      
      // Stage 2: Spiritual & Physical
      'religion': _selectedReligion ?? '',
      'caste': _selectedCaste ?? '',
      'sub_caste': _selectedSubCaste ?? '',
      'manglik': _selectedManglik ?? 'false',
      'intercaste_accepted': _selectedIntercasteAccepted ?? 'false',
      'family_value': _selectedFamilyValue ?? '',
      'height': _selectedHeight ?? '',
      'weight': _weightController.text.trim(),
      'blood_group': _selectedBloodGroup ?? '',
      'complexion': _selectedComplexion ?? '',
      'physical_disability': _selectedPhysicalDisability ?? 'false',
      'disability_details': _disabilityDetailsController.text.trim(),
      
      // Stage 3: Education & Career
      'education_level': _selectedEducation ?? '',
      'occupation_type': _occupationTypeController.text.trim(),
      'occupation_details': _occupationDetailsController.text.trim(),
       'annual_income': _annualIncomeController.text.trim(),
      'country': _selectedCountry ?? '101',
      'state': _selectedState ?? '',
      'city': _selectedCity ?? '',
      'address': _addressDetailsController.text.trim(),
      
      // Stage 4: Family & Expectations
      'father_alive': _selectedFatherAlive ?? 'true',
      'mother_alive': _selectedMotherAlive ?? 'true',
      'parents_occupation': _parentsOccupationController.text.trim(),
      'no_of_brothers': _noOfBrothersController.text.trim(),
      'married_brothers': _marriedBrothersController.text.trim(),
      'no_of_sisters': _noOfSistersController.text.trim(),
      'married_sisters': _marriedSistersController.text.trim(),
      'property_details': _propertyDetailsController.text.trim(),
      'partner_manglik': _selectedPartnerManglik ?? 'false',
      'expected_education': _expectedEducationController.text.trim(),
      'expected_income': _expectedIncomeController.text.trim(),
      'divorce_accepted': _selectedDivorceAccepted ?? 'false',
      'partner_intercaste': _selectedPartnerIntercaste ?? 'false',

      'package': _selectedPackage!,
      'payment_method_id': _selectedPaymentMethod ?? '',
    };

    http.MultipartFile? imageFile;
    if (_profileImage != null) {
      imageFile = await http.MultipartFile.fromPath('photo', _profileImage!.path);
    }

    http.MultipartFile? idProofFile;
    if (_idProofImage != null) {
      idProofFile = await http.MultipartFile.fromPath('id_proof', _idProofImage!.path);
    }
    
    List<http.MultipartFile> otherPhotos = [];
    for (var img in _galleryImages) {
      otherPhotos.add(await http.MultipartFile.fromPath('other_photos[]', img.path));
    }

    final response = await _biodataService.submitBiodata(
      data, 
      image: imageFile, 
      idProof: idProofFile,
      otherPhotos: otherPhotos,
    );
    setState(() => _isSaving = false);

    if (!mounted) return;

    if (response['result'] == true) {
      _showSuccessDialog(
        matrimonyId: response['matrimony_id']?.toString() ?? 'N/A',
        password: response['temporary_password']?.toString() ?? 'N/A',
      );
    } else {
      _showSnack(response['message'] ?? 'Failed to submit biodata', isError: true);
    }
  }

  void _showSuccessDialog({required String matrimonyId, required String password}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
            const SizedBox(height: 12),
            Text('Submission Successful!', textAlign: TextAlign.center, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The candidate has been onboarded successfully. Please share these credentials with them:', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 20),
            _infoRow('Matrimony ID', matrimonyId, Icons.badge_rounded),
            const SizedBox(height: 12),
            _infoRow('Temp Password', password, Icons.lock_open_rounded),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.withValues(alpha: 0.1))),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Candidate can now login to Matrimony App using these details.', style: GoogleFonts.inter(color: Colors.blue[700], fontSize: 11, fontWeight: FontWeight.w500))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Go back home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: Text('Return to Home', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500)),
                Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.blue),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              _showSnack('$label copied!', isError: false);
            },
          ),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    bool isRequired = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 11),
          floatingLabelStyle: GoogleFonts.inter(color: AppColors.bluePrimary),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, right: 6),
            child: Icon(icon, color: Colors.grey, size: 16),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        validator: isRequired ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: items.where((i) => i.value == value).isNotEmpty ? value : null,
        dropdownColor: AppColors.surface(context),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 16),
        style: GoogleFonts.inter(color: AppColors.textPrimaryColor(context), fontSize: 12),
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 10),
          floatingLabelStyle: GoogleFonts.inter(color: AppColors.bluePrimary),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8, right: 4),
            child: Icon(icon, color: Colors.grey, size: 14),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        ),
        items: items.isEmpty
            ? [DropdownMenuItem(value: '', child: Text('No options', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)))]
            : items.map((item) {
                return DropdownMenuItem<String>(
                  value: item.value,
                  child: Text(
                    item.child is Text ? (item.child as Text).data! : '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                );
              }).toList(),
        onChanged: items.isEmpty ? null : onChanged,
        validator: isRequired ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
      ),
    );
  }

  // --- Step Content Builders ---

  List<Step> _buildSteps() {
    return [
      Step(
        isActive: _currentStep >= 0,
        title: Text('Basic Info', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: _currentStep == 0 ? 14 : 12, color: _currentStep == 0 ? AppColors.primary(context) : AppColors.textSecondary(context))),
        content: Form(
          key: _formKeys[0],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Personal Identity',
                icon: Icons.person_rounded,
                children: [
                  _input(controller: _firstNameController, label: 'First Name', icon: Icons.person_rounded, isRequired: true),
                  const SizedBox(height: 12),
                  _input(controller: _lastNameController, label: 'Last Name', icon: Icons.person_outline_rounded, isRequired: true),
                  const SizedBox(height: 12),
                  _dropdown(
                    label: 'Gender', icon: Icons.person_pin_circle_rounded,
                    value: _selectedGender,
                    items: _genders.map((g) => DropdownMenuItem<String>(value: g['id'], child: Text(g['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedGender = v ?? ''),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickDob,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 16),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDob == null
                                ? 'Date of Birth *'
                                : '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}',
                            style: GoogleFonts.inter(
                              color: _selectedDob == null ? Colors.grey : AppColors.textPrimary(context),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Contact Details',
                icon: Icons.contact_phone_rounded,
                children: [
                  _input(controller: _phoneController, label: 'Mobile Number', icon: Icons.phone_rounded, isNumber: true, isRequired: true),
                  const SizedBox(height: 12),
                  _input(controller: _mobile2Controller, label: 'Alternate Mobile', icon: Icons.phone_android_rounded, isNumber: true),
                  const SizedBox(height: 12),
                  _input(controller: _emailController, label: 'Email Address', icon: Icons.email_rounded),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Profile Attributes',
                icon: Icons.settings_accessibility_rounded,
                children: [
                  _dropdown(
                    label: 'Profile Created By', icon: Icons.family_restroom_rounded,
                    value: _selectedOnBehalf,
                    items: _onBehalves.map((o) => DropdownMenuItem<String>(value: o['id'], child: Text(o['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedOnBehalf = v),
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                  _dropdown(
                    label: 'Marital Status', icon: Icons.favorite_border_rounded,
                    value: _selectedMaritalStatus,
                    items: _maritalStatuses.map((m) => DropdownMenuItem<String>(value: m['id'], child: Text(m['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedMaritalStatus = v),
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                  _dropdown(
                    label: 'Mother Tongue', icon: Icons.translate_rounded,
                    value: _selectedLanguage,
                    items: _languages.map((l) => DropdownMenuItem<String>(value: l['id'], child: Text(l['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedLanguage = v),
                    isRequired: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: Text('Spiritual & Physical', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: _currentStep == 1 ? 14 : 12, color: _currentStep == 1 ? AppColors.primary(context) : AppColors.textSecondary(context))),
        content: Form(
          key: _formKeys[1],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Spiritual Identity',
                icon: Icons.temple_hindu_rounded,
                children: [
                  _dropdown(
                    label: 'Religion', icon: Icons.temple_hindu_rounded,
                    value: _selectedReligion,
                    items: _religions.map((r) => DropdownMenuItem<String>(value: r['id'], child: Text(r['name'] ?? ''))).toList(),
                    onChanged: _onReligionChanged,
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                  _dropdown(
                    label: 'Caste', icon: Icons.group_work_rounded,
                    value: _selectedCaste,
                    items: _filteredCastes.map((c) => DropdownMenuItem<String>(value: c['id'], child: Text(c['name'] ?? ''))).toList(),
                    onChanged: _onCasteChanged,
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                  _dropdown(
                    label: 'Sub-Caste', icon: Icons.account_tree_rounded,
                    value: _selectedSubCaste,
                    items: _filteredSubCastes.map((s) => DropdownMenuItem<String>(value: s['id'], child: Text(s['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedSubCaste = v),
                  ),
                  const SizedBox(height: 12),
                  _dropdown(
                    label: 'Family Value', icon: Icons.volunteer_activism_rounded,
                    value: _selectedFamilyValue,
                    items: _familyValues.map((f) => DropdownMenuItem<String>(value: f['id'], child: Text(f['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedFamilyValue = v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _dropdown(
                          label: 'Manglik', icon: Icons.star_border_rounded,
                          value: _selectedManglik,
                          items: const [
                            DropdownMenuItem<String>(value: 'true', child: Text('Yes')),
                            DropdownMenuItem<String>(value: 'false', child: Text('No')),
                          ],
                          onChanged: (v) => setState(() => _selectedManglik = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dropdown(
                          label: 'Intercaste', icon: Icons.diversity_1_rounded,
                          value: _selectedIntercasteAccepted,
                          items: const [
                            DropdownMenuItem<String>(value: 'true', child: Text('Accepted')),
                            DropdownMenuItem<String>(value: 'false', child: Text('Not Accepted')),
                          ],
                          onChanged: (v) => setState(() => _selectedIntercasteAccepted = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Physical Characteristics',
                icon: Icons.monitor_weight_rounded,
                children: [
                  _dropdown(
                    label: 'Height', icon: Icons.height_rounded,
                    value: _selectedHeight,
                    items: _heights.map((h) => DropdownMenuItem<String>(value: h['id'], child: Text(h['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedHeight = v),
                  ),
                  const SizedBox(height: 12),
                  _input(controller: _weightController, label: 'Weight (kg)', icon: Icons.scale_rounded, isNumber: true),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _dropdown(
                          label: 'Blood Group', icon: Icons.bloodtype_rounded,
                          value: _selectedBloodGroup,
                          items: _bloodGroups.map((b) => DropdownMenuItem<String>(value: b['id'], child: Text(b['name'] ?? ''))).toList(),
                          onChanged: (v) => setState(() => _selectedBloodGroup = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dropdown(
                          label: 'Complexion', icon: Icons.face_rounded,
                          value: _selectedComplexion,
                          items: _complexions.map((c) => DropdownMenuItem<String>(value: c['id'], child: Text(c['name'] ?? ''))).toList(),
                          onChanged: (v) => setState(() => _selectedComplexion = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Health status',
                icon: Icons.health_and_safety_rounded,
                children: [
                  _dropdown(
                    label: 'Physical Disability', icon: Icons.accessible_rounded,
                    value: _selectedPhysicalDisability,
                    items: const [
                      DropdownMenuItem<String>(value: 'false', child: Text('No')),
                      DropdownMenuItem<String>(value: 'true', child: Text('Yes')),
                    ],
                    onChanged: (v) => setState(() => _selectedPhysicalDisability = v),
                  ),
                  if (_selectedPhysicalDisability == 'true') ...[
                    const SizedBox(height: 12),
                    _input(controller: _disabilityDetailsController, label: 'Disability Details', icon: Icons.description_rounded),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: Text('Education & Location', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: _currentStep == 2 ? 14 : 12, color: _currentStep == 2 ? AppColors.primary(context) : AppColors.textSecondary(context))),
        content: Form(
          key: _formKeys[2],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Career & Academics',
                icon: Icons.school_rounded,
                children: [
                  _dropdown(
                    label: 'Education Level', icon: Icons.school_rounded,
                    value: _selectedEducation,
                    items: _educations.map((e) => DropdownMenuItem<String>(value: e['id'], child: Text(e['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedEducation = v),
                  ),
                  const SizedBox(height: 12),
                  _input(controller: _occupationTypeController, label: 'Occupation/Designation', icon: Icons.work_outline_rounded),
                  const SizedBox(height: 12),
                  _input(controller: _occupationDetailsController, label: 'Occupation Details/Company', icon: Icons.business_rounded),
                  const SizedBox(height: 12),
                  _input(controller: _annualIncomeController, label: 'Annual Income', icon: Icons.currency_rupee_rounded, isNumber: true),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Current Location',
                icon: Icons.location_on_rounded,
                children: [
                  _dropdown(
                    label: 'State', icon: Icons.map_rounded,
                    value: _selectedState,
                    items: _states.map((s) => DropdownMenuItem<String>(value: s['id'], child: Text(s['name'] ?? ''))).toList(),
                    onChanged: (v) => _onStateChanged(v),
                  ),
                  if (_isLoadingStates) const Padding(padding: EdgeInsets.only(top: 8), child: LinearProgressIndicator()),
                  const SizedBox(height: 12),
                  _dropdown(
                    label: 'District', icon: Icons.location_city_rounded,
                    value: _selectedCity,
                    items: _cities.map((c) => DropdownMenuItem<String>(value: c['id'], child: Text(c['name'] ?? ''))).toList(),
                    onChanged: (v) => setState(() => _selectedCity = v),
                  ),
                  if (_isLoadingCities) const Padding(padding: EdgeInsets.only(top: 8), child: LinearProgressIndicator()),
                  const SizedBox(height: 12),
                  _input(controller: _addressDetailsController, label: 'Full Location Details', icon: Icons.home_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep >= 3,
        title: Text('Family & Finish', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: _currentStep == 3 ? 14 : 12, color: _currentStep == 3 ? AppColors.primary(context) : AppColors.textSecondary(context))),
        content: Form(
          key: _formKeys[3],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Parents Status',
                icon: Icons.family_restroom_rounded,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _dropdown(
                          label: 'Father Alive', icon: Icons.man_rounded,
                          value: _selectedFatherAlive,
                          items: const [
                            DropdownMenuItem<String>(value: 'true', child: Text('Yes')),
                            DropdownMenuItem<String>(value: 'false', child: Text('No')),
                          ],
                          onChanged: (v) => setState(() => _selectedFatherAlive = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dropdown(
                          label: 'Mother Alive', icon: Icons.woman_rounded,
                          value: _selectedMotherAlive,
                          items: const [
                            DropdownMenuItem<String>(value: 'true', child: Text('Yes')),
                            DropdownMenuItem<String>(value: 'false', child: Text('No')),
                          ],
                          onChanged: (v) => setState(() => _selectedMotherAlive = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _input(controller: _parentsOccupationController, label: 'Parents Occupation', icon: Icons.group_work_outlined),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Siblings Information',
                icon: Icons.groups_rounded,
                children: [
                  Row(
                    children: [
                      Expanded(child: _input(controller: _noOfBrothersController, label: 'Brothers', icon: Icons.boy_rounded, isNumber: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _input(controller: _marriedBrothersController, label: 'Married', icon: Icons.check_circle_outline_rounded, isNumber: true)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _input(controller: _noOfSistersController, label: 'Sisters', icon: Icons.girl_rounded, isNumber: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _input(controller: _marriedSistersController, label: 'Married', icon: Icons.check_circle_outline_rounded, isNumber: true)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Partner Expectations',
                icon: Icons.favorite_rounded,
                children: [
                  _dropdown(
                    label: 'Expect Partner Manglik?', icon: Icons.stars_rounded,
                    value: _selectedPartnerManglik,
                    items: const [
                      DropdownMenuItem<String>(value: 'false', child: Text('Not Mandatory')),
                      DropdownMenuItem<String>(value: 'true', child: Text('Yes, Required')),
                    ],
                    onChanged: (v) => setState(() => _selectedPartnerManglik = v),
                  ),
                  const SizedBox(height: 12),
                  _dropdown(
                    label: 'Intercaste Accepted?', icon: Icons.diversity_3_rounded,
                    value: _selectedPartnerIntercaste,
                    items: const [
                      DropdownMenuItem<String>(value: 'false', child: Text('Not Accepted')),
                      DropdownMenuItem<String>(value: 'true', child: Text('Accepted')),
                    ],
                    onChanged: (v) => setState(() => _selectedPartnerIntercaste = v),
                  ),
                  const SizedBox(height: 12),
                  _input(controller: _expectedEducationController, label: 'Min. Education Expected', icon: Icons.school_outlined),
                  const SizedBox(height: 12),
                  _input(controller: _expectedIncomeController, label: 'Expected Annual Income', icon: Icons.currency_rupee_rounded, isNumber: true),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Additional Family Info',
                icon: Icons.info_outline_rounded,
                children: [
                  _input(controller: _propertyDetailsController, label: 'Property Details', icon: Icons.house_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep >= 4,
        title: Text('Uploads & Finish', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: _currentStep == 4 ? 14 : 12, color: _currentStep == 4 ? AppColors.primary(context) : AppColors.textSecondary(context))),
        content: Form(
          key: _formKeys[4],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Official Identity',
                icon: Icons.badge_rounded,
                children: [
                  GestureDetector(
                    onTap: _pickIdProof,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      child: _idProofImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(_idProofImage!.path, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_rounded, color: Colors.grey, size: 24),
                                const SizedBox(height: 4),
                                Text('Upload ID Proof', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Photo Gallery',
                icon: Icons.collections_rounded,
                children: [
                  GestureDetector(
                    onTap: _pickGalleryImages,
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_rounded, color: AppColors.primary(context), size: 20),
                            const SizedBox(height: 4),
                            Text('Add Gallery Photos (${_galleryImages.length})', style: GoogleFonts.inter(color: AppColors.primary(context), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_galleryImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _galleryImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(image: NetworkImage(_galleryImages[index].path), fit: BoxFit.cover),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () => setState(() => _galleryImages.removeAt(index)),
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              _buildSectionCard(
                title: 'Payment Details',
                icon: Icons.payments_rounded,
                children: [
                  _dropdown(
                    label: 'Payment Method',
                    icon: Icons.payment,
                    value: _selectedPaymentMethod,
                    items: _paymentMethods.map((p) => DropdownMenuItem<String>(value: p['id'], child: Text(p['name'] ?? ''))).toList(),
                    onChanged: (val) => setState(() => _selectedPaymentMethod = val),
                    isRequired: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'Member Profile & Package',
                icon: Icons.verified_user_rounded,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary(context).withValues(alpha: 0.1), width: 1.5),
                      ),
                      child: _profileImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(_profileImage!.path, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_rounded, size: 28, color: AppColors.primary(context)),
                                const SizedBox(height: 8),
                                Text('Profile Photo *', style: GoogleFonts.inter(color: AppColors.primary(context), fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _dropdown(
                    label: 'Membership Package', icon: Icons.workspace_premium_rounded,
                    value: _selectedPackage,
                    items: _packages.map((p) => DropdownMenuItem<String>(value: p['id'], child: Text('${p['name']} (₹${p['price']})'))).toList(),
                    onChanged: (v) => setState(() => _selectedPackage = v),
                    isRequired: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary(context)),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary(context),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.primary(context), width: 3)),
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary(context),
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 4) {
        setState(() => _currentStep += 1);
      } else {
        _submit();
      }
    } else {
      _showSnack('Please complete required fields', isError: true);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
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
          'Fill Biodata',
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryColor(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoadingDropdowns
          ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
          : Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.bluePrimary,
                ),
              ),
              child: Stepper(
                type: StepperType.vertical,
                physics: const BouncingScrollPhysics(),
                currentStep: _currentStep,
                onStepContinue: _nextStep,
                onStepCancel: _prevStep,
                onStepTapped: (step) {
                  if (step < _currentStep) {
                    setState(() => _currentStep = step);
                  } else if (_formKeys[_currentStep].currentState!.validate()) {
                    setState(() => _currentStep = step);
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.bluePrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: _isSaving
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text(_currentStep == 3 ? 'SUBMIT BIODATA' : 'CONTINUE', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        if (_currentStep > 0) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isSaving ? null : details.onStepCancel,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey,
                                side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text('BACK', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                steps: _buildSteps(),
              ),
            ),
    );
  }
}
// Sanket
