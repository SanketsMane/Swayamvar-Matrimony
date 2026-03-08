import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../core/constants.dart';
import '../services/biodata_service.dart';

class FillBiodataScreen extends StatefulWidget {
  const FillBiodataScreen({super.key});

  @override
  State<FillBiodataScreen> createState() => _FillBiodataScreenState();
}

class _FillBiodataScreenState extends State<FillBiodataScreen> {
  final _biodataService = BiodataService();
  final _formKeys = List.generate(8, (_) => GlobalKey<FormState>());
  int _currentStep = 0;
  bool _isLoadingDropdowns = true;
  bool _isSaving = false;

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  Uint8List? _profileImageBytes;

  // Controllers
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  
  final _weightController = TextEditingController();
  final _disabilityDetailsController = TextEditingController(); // Just in case details are asked for Physical Disability
  
  final _noOfBrothersController = TextEditingController();
  final _marriedBrothersController = TextEditingController();
  final _noOfSistersController = TextEditingController();
  final _marriedSistersController = TextEditingController();
  final _parentsOccupationController = TextEditingController();
  final _propertyDetailsController = TextEditingController();
  final _educationDetailController = TextEditingController();

  
  

  final _occupationDetailsController = TextEditingController();
  
  final _phoneController = TextEditingController();

  final _mobile2Controller = TextEditingController();
  
  final _govIdNumberController = TextEditingController();
  final _addressDetailsController = TextEditingController();

  // Dropdown Lists
  List<Map<String, String>>? _genders = [];
  List<Map<String, String>>? _maritalStatuses = [];
  List<Map<String, String>>? _religions = [];
  List<Map<String, String>>? _occupationTypes = [];
  List<Map<String, String>>? _incomeSlabs = [];
  List<Map<String, dynamic>>? _allCastes = [];
  List<Map<String, dynamic>>? _filteredCastes = [];
  List<Map<String, String>>? _packages = [];
  List<Map<String, String>>? _onBehalves = [];




  List<Map<String, String>>? _heights = [];

  List<Map<String, String>>? _bloodGroups = [];
  List<Map<String, String>>? _complexions = [];
  List<Map<String, String>>? _educations = [];
  List<Map<String, String>>? _states = [];
  List<Map<String, String>>? _districts = [];


  // Selections
  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedReligion;
  String? _selectedCaste;
  String? _selectedOccupationType;
  String? _selectedIncome;
  String? _selectedPackage;
  String? _selectedOnBehalf;
  String? _selectedHeight;


  String? _selectedBloodGroup;
  String? _selectedComplexion;
  String? _selectedEducation;
  String? _selectedGovIdType;
  String? _selectedState;
  String? _selectedDistrict;
  DateTime? _selectedDob;

  // Yes/No Bools (Stored as String to easily bind to dropdowns)
  String? _selectedPhysicalDisability = 'No';
  String? _selectedManglik = 'No';
  String? _selectedIntercasteAccepted = 'No';
  String? _selectedFatherAlive = 'Yes';
  String? _selectedMotherAlive = 'Yes';

  @override
  void initState() {
    super.initState();
    print('Sanket: FillBiodataScreen v2.1 (Web Safe) loaded. kIsWeb: $kIsWeb');
    _fetchDropdowns();
  }


  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _weightController.dispose();
    _disabilityDetailsController.dispose();
    _noOfBrothersController.dispose();
    _marriedBrothersController.dispose();
    _noOfSistersController.dispose();
    _marriedSistersController.dispose();
    _parentsOccupationController.dispose();
    _propertyDetailsController.dispose();
    _educationDetailController.dispose();
    _occupationDetailsController.dispose();

    _phoneController.dispose();


    _mobile2Controller.dispose();
    _govIdNumberController.dispose();
    _addressDetailsController.dispose();
    super.dispose();



  }

  List<Map<String, String>> _toStringList(List<dynamic>? raw) {
    if (raw == null || raw.isEmpty) return [];
    return raw.where((item) => item != null).map<Map<String, String>>((item) => {
      'id': item['id']?.toString() ?? '',
      'name': (item['name'] ?? '').toString(),
    }).toList();
  }



  Future<void> _fetchDropdowns() async {
    final response = await _biodataService.getDropdowns();
    if (response['result'] == true && mounted) {
      final Map<String, dynamic> data = (response['data'] as Map<String, dynamic>?) ?? {};


      final allCastes = (data['castes'] as List<dynamic>? ?? []).map<Map<String, dynamic>>((c) => {
        'id': c['id'].toString(),
        'name': (c['name'] ?? '').toString(),
        'religion_id': c['religion_id']?.toString() ?? '',
      }).toList();

      setState(() {
        _genders = _toStringList(data['genders'] ?? []);
        _maritalStatuses = _toStringList(data['marital_statuses'] ?? []);
        _religions = _toStringList(data['religions'] ?? []);
        _educations = _toStringList(data['educations'] ?? []); 
        _heights = _toStringList(data['heights'] ?? []);       
        _bloodGroups = _toStringList(data['blood_groups'] ?? []);
        final bGroups = _bloodGroups!;
        if (!bGroups.any((b) => b['name'] == 'NA')) {
          bGroups.add({'id': 'NA', 'name': 'NA'});
        }



        _occupationTypes = _toStringList(data['occupation_types'] ?? []);
        _incomeSlabs = _toStringList(data['income_slabs'] ?? []);
        _complexions = _toStringList(data['complexions'] ?? []);
        _packages = _toStringList(data['packages'] ?? []);
        _onBehalves = _toStringList(data['on_behalves'] ?? []);

        _allCastes = allCastes;
        _filteredCastes = allCastes;

        _allCastes = allCastes;
        _filteredCastes = allCastes;




        _heights = (_heights?.isNotEmpty ?? false) ? _heights : [

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

        final apiEducations = _toStringList(data['educations'] ?? []);
        final fallbackEducations = [
           {'id': '10th Std', 'name': '10th Std'},
           {'id': '12th Std', 'name': '12th Std'},
           {'id': 'Diploma', 'name': 'Diploma'},
           {'id': 'Graduate', 'name': 'Graduate'},
           {'id': 'Post Graduate', 'name': 'Post Graduate'},
           {'id': 'Doctorate', 'name': 'Doctorate'},
           {'id': 'Professional', 'name': 'Professional'},
        ];



        // Sanket: Merge API educations with fallback to ensure full list
        final Set<String> seenNames = {};
        final List<Map<String, String>> mergedEducations = [];

        for (var e in apiEducations) {
          final name = e['name']?.toString().toLowerCase() ?? '';
          if (name.isNotEmpty && !seenNames.contains(name)) {
            seenNames.add(name);
            mergedEducations.add(e);
          }
        }
        for (var e in fallbackEducations) {
          final name = e['name']?.toString().toLowerCase() ?? '';
          if (name.isNotEmpty && !seenNames.contains(name)) {
            seenNames.add(name);
            mergedEducations.add(e);
          }
        }
        _educations = mergedEducations;

        if (_genders?.isNotEmpty ?? false) _selectedGender = _genders?[0]['id'];

        _isLoadingDropdowns = false;
      });

      // Sanket: Apply Matrimony standard hardcoded fallbacks to ALL lists if they are still empty
      _applyFallbacks();

      // Fetch India (101) states by default
      await _fetchStates('101');
    } else if (mounted) {
      setState(() {
        _isLoadingDropdowns = false;
        _applyFallbacks();
      });
    }
  }



  void _applyFallbacks() {
    setState(() {
      if ((_bloodGroups ?? []).isEmpty) {
        _bloodGroups = [
          {'id': 'A+', 'name': 'A+'}, {'id': 'A-', 'name': 'A-'},
          {'id': 'B+', 'name': 'B+'}, {'id': 'B-', 'name': 'B-'},
          {'id': 'AB+', 'name': 'AB+'}, {'id': 'AB-', 'name': 'AB-'},
          {'id': 'O+', 'name': 'O+'}, {'id': 'O-', 'name': 'O-'},
          {'id': 'NA', 'name': 'NA'},
        ];
      }
      if ((_occupationTypes ?? []).isEmpty) {
        _occupationTypes = [
          {'id': 'Government', 'name': 'Government'},
          {'id': 'Private Sector', 'name': 'Private Sector'},
          {'id': 'Business / Self Employed', 'name': 'Business / Self Employed'},
          {'id': 'Professional', 'name': 'Professional'},
          {'id': 'Not Working', 'name': 'Not Working'},
        ];
      }
      if ((_incomeSlabs ?? []).isEmpty) {
        _incomeSlabs = [
          {'id': 'Below 2 Lakhs', 'name': 'Below 2 Lakhs'},
          {'id': '2 Lakhs - 5 Lakhs', 'name': '2 Lakhs - 5 Lakhs'},
          {'id': '5 Lakhs - 10 Lakhs', 'name': '5 Lakhs - 10 Lakhs'},
          {'id': '10 Lakhs - 15 Lakhs', 'name': '10 Lakhs - 15 Lakhs'},
          {'id': '15 Lakhs - 25 Lakhs', 'name': '15 Lakhs - 25 Lakhs'},
          {'id': 'Above 25 Lakhs', 'name': 'Above 25 Lakhs'},
        ];
      }

      // Sanket: Handle Package Fallback
      if ((_packages ?? []).isEmpty) {
        _packages = [{'id': '1', 'name': 'Free Package'}];
      }
      
      if (_selectedPackage == null && (_packages ?? []).isNotEmpty) {
        _selectedPackage = _packages!.first['id'];
      }

      // Sanket: Handle On Behalf Fallback
      if ((_onBehalves ?? []).isEmpty) {
        _onBehalves = [{'id': '1', 'name': 'Self'}];
      }
      if (_selectedOnBehalf == null && (_onBehalves ?? []).isNotEmpty) {
        _selectedOnBehalf = _onBehalves!.first['id'];
      }
    });
  }

  void _onReligionChanged(String? value) {
    setState(() {
      _selectedReligion = value;
      _selectedCaste = null;
      _filteredCastes = value == null
          ? (_allCastes ?? [])
          : (_allCastes ?? []).where((c) => c['religion_id'] == value).toList();
    });
  }

  Future<void> _fetchStates(String countryId) async {
    final response = await _biodataService.getStates(countryId);
    if (response['result'] == true && mounted) {
      setState(() {
        _states = _toStringList(response['data'] ?? []);
        // Set Maharashtra (22) as default if available
        if (_selectedState == null && (_states?.isNotEmpty ?? false)) {
          final sList = _states!;
          final maharashtra = sList.firstWhere((s) => s['id'] == '22', orElse: () => sList[0]);
          _selectedState = maharashtra['id'];
          _onStateChanged(_selectedState);
        }



      });
    }
  }

  Future<void> _onStateChanged(String? value) async {
    setState(() {
      _selectedState = value;
      _selectedDistrict = null;
      _districts = [];
    });
    if (value == null) return;
    
    final response = await _biodataService.getCities(value);
    if (response['result'] == true && mounted) {
      setState(() {
        _districts = _toStringList(response['data'] ?? []);
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
          ),
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
      final bytes = await image.readAsBytes();
      setState(() {
        _profileImage = image;
        _profileImageBytes = bytes;
      });
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
    if (!_formKeys[7].currentState!.validate()) return;
    
    if (_selectedReligion == null) { _showSnack('Religion is mandatory', isError: true); return; }
    if (_selectedCaste == null) { _showSnack('Caste is mandatory', isError: true); return; }
    if (_selectedDob == null) { _showSnack('Date of Birth is mandatory', isError: true); return; }
    
    if (_profileImageBytes == null) {
      _showSnack('Profile Photo is mandatory', isError: true);
      return;
    }
    
    final phone = _phoneController.text.trim();
    final mobile2 = _mobile2Controller.text.trim();

    if (phone.length != 10) {
      _showSnack('Mobile Number must be exactly 10 digits', isError: true);
      return;
    }

    if (mobile2.isNotEmpty && mobile2.length != 10) {
      _showSnack('Mobile Number 2 must be exactly 10 digits', isError: true);
      return;
    }


    setState(() => _isSaving = true);

    final data = {
      // 1. Personal
      'first_name': _firstNameController.text.trim(),
      'middle_name': _middleNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'gender': _selectedGender ?? 'Male',
      'on_behalf': '1', // Default to Self/Myself [Sanket]
      'date_of_birth': '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}',
      'religion': _selectedReligion ?? '',
      'caste': _selectedCaste ?? '',
      'on_behalf': _selectedOnBehalf ?? '1',
      'marital_status': _selectedMaritalStatus ?? '',
      'package': _selectedPackage ?? '',

      // 2. Physical
      'height': _selectedHeight ?? '',
      'weight': _weightController.text.trim(),
      'blood_group': _selectedBloodGroup ?? '',
      'complexion': _selectedComplexion ?? '',
      'physical_disability': _selectedPhysicalDisability ?? 'No',
      'manglik': _selectedManglik ?? 'No',
      'intercaste_accepted': _selectedIntercasteAccepted ?? 'No',

      // 3. Family
      'father_alive': _selectedFatherAlive ?? 'Yes',
      'mother_alive': _selectedMotherAlive ?? 'Yes',
      'no_of_brothers': _noOfBrothersController.text.trim().isEmpty ? '0' : _noOfBrothersController.text.trim(),
      'married_brothers': _marriedBrothersController.text.trim().isEmpty ? '0' : _marriedBrothersController.text.trim(),
      'no_of_sisters': _noOfSistersController.text.trim().isEmpty ? '0' : _noOfSistersController.text.trim(),
      'married_sisters': _marriedSistersController.text.trim().isEmpty ? '0' : _marriedSistersController.text.trim(),
      'parents_occupation': _parentsOccupationController.text.trim(),
      'property_details': _propertyDetailsController.text.trim(),

      // 4. Education
      'education_level': _selectedEducation ?? '',
      'education_detail': _educationDetailController.text.trim(),



      // 5. Career
      'occupation_type': _selectedOccupationType ?? '',
      'occupation_details': _occupationDetailsController.text.trim(),
      'annual_income': _selectedIncome ?? '',


      // 6. Contact
      'phone': _phoneController.text.trim(),
      'mobile2': _mobile2Controller.text.trim(),

      // 7. Address
      'gov_id_type': _selectedGovIdType ?? '',
      'gov_id_number': _govIdNumberController.text.trim(),
      'address': _addressDetailsController.text.trim(),
      'state': _selectedState ?? '',
      'district': _selectedDistrict ?? '', // Using city for district representation internally 
    };

    http.MultipartFile? imageFile;
    if (_profileImage != null && _profileImageBytes != null) {
      // Sanket: Fix for Flutter Web support - fromPath is IO only
      if (kIsWeb) {
        imageFile = http.MultipartFile.fromBytes(
          'photo',
          _profileImageBytes!,
          filename: _profileImage!.name,
        );
      } else {
        imageFile = await http.MultipartFile.fromPath('photo', _profileImage!.path);
      }
    }

    final response = await _biodataService.submitBiodata(
      data, 
      image: imageFile, 
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
            Text('Candidate has been automatically linked to your Telecaller Profile.', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 20),
            _infoRow('Matrimony ID', matrimonyId, Icons.badge_rounded),
            const SizedBox(height: 12),
            _infoRow('Temporary Password', password, Icons.lock_open_rounded),

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
              child: Text('Return to Dashboard', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
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
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
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
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: items.where((i) => i.value == value).isNotEmpty ? value : null,
        dropdownColor: AppColors.surface(context),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 16),
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
        items: items.isEmpty
            ? [DropdownMenuItem(value: '', child: Text('No options', style: GoogleFonts.inter(color: Colors.grey, fontSize: 13)))]
            : items.map((item) {
                return DropdownMenuItem<String>(
                  value: item.value,
                  child: Text(
                    item.child is Text ? (item.child as Text).data! : '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                );
              }).toList(),
        onChanged: items.isEmpty ? null : onChanged,
        validator: isRequired ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
      ),
    );
  }

  // --- 8 Steps Builder ---
  List<Step> _buildSteps() {
    return [
      _stepSection(0, '1. Personal Info', _step1Personal()),
      _stepSection(1, '2. Physical Info', _step2Physical()),
      _stepSection(2, '3. Family Info', _step3Family()),
      _stepSection(3, '4. Education', _step4Education()),
      _stepSection(4, '5. Career', _step5Career()),
      _stepSection(5, '6. Contact Info', _step6Contact()),
      _stepSection(6, '7. Address Info', _step7Address()),
      _stepSection(7, '8. Photo Upload *', _step8Photo()),
    ];
  }

  Step _stepSection(int index, String title, Widget content) {
    return Step(
      isActive: _currentStep >= index,
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          fontSize: _currentStep == index ? 14 : 12,
          color: _currentStep == index ? AppColors.primary(context) : AppColors.textSecondary(context),
        ),
      ),
      content: Form(
        key: _formKeys[index],
        child: content,
      ),
    );
  }

  Widget _step1Personal() {
    return Column(
      children: [
        _input(controller: _firstNameController, label: 'First Name *', icon: Icons.person, isRequired: true),
        const SizedBox(height: 12),
        _input(controller: _middleNameController, label: 'Middle Name *', icon: Icons.person_outline, isRequired: true),
        const SizedBox(height: 12),
        _input(controller: _lastNameController, label: 'Last Name *', icon: Icons.person_outline, isRequired: true),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickDob,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.background(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 16),
                const SizedBox(width: 12),
                Text(
                  _selectedDob == null ? 'Date of Birth *' : '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}',
                  style: GoogleFonts.inter(
                    color: _selectedDob == null ? Colors.grey : AppColors.textPrimary(context),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Gender *', icon: Icons.male,
          value: _selectedGender,
          items: (_genders ?? []).map((g) => DropdownMenuItem<String>(value: g['id'], child: Text(g['name'] ?? ''))).toList(),


          onChanged: (v) => setState(() => _selectedGender = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Religion *', icon: Icons.temple_hindu,
          value: _selectedReligion,
          items: (_religions ?? []).map((r) => DropdownMenuItem<String>(value: r['id'], child: Text(r['name'] ?? ''))).toList(),


          onChanged: _onReligionChanged,
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Caste *', icon: Icons.group_work,
          value: _selectedCaste,
          items: (_filteredCastes ?? []).map((c) => DropdownMenuItem<String>(value: c['id'], child: Text(c['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedCaste = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'On Behalf *', icon: Icons.person_search_rounded,
          value: _selectedOnBehalf,
          items: (_onBehalves ?? []).map((o) => DropdownMenuItem<String>(value: o['id'], child: Text(o['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedOnBehalf = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Marital Status *', icon: Icons.favorite_border,
          value: _selectedMaritalStatus,
          items: (_maritalStatuses ?? []).map((m) => DropdownMenuItem<String>(value: m['id'], child: Text(m['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedMaritalStatus = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Account Package *', icon: Icons.card_membership_rounded,
          value: _selectedPackage,
          items: (_packages ?? []).map((p) => DropdownMenuItem<String>(value: p['id'], child: Text(p['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedPackage = v),
          isRequired: true,
        ),
      ],
    );
  }

  Widget _step2Physical() {
    return Column(
      children: [
        _dropdown(
          label: 'Height *', icon: Icons.height,
          value: _selectedHeight,
          items: (_heights ?? []).map((h) => DropdownMenuItem<String>(value: h['id'], child: Text(h['name'] ?? ''))).toList(),

          onChanged: (v) => setState(() => _selectedHeight = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _input(controller: _weightController, label: 'Weight (kg)', icon: Icons.scale_rounded, isNumber: true),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Blood Group *', icon: Icons.bloodtype,
          value: _selectedBloodGroup,
          items: (_bloodGroups ?? []).map((b) => DropdownMenuItem<String>(value: b['id'], child: Text(b['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedBloodGroup = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Complexion *', icon: Icons.face,
          value: _selectedComplexion,
          items: (_complexions ?? []).map((c) => DropdownMenuItem<String>(value: c['id'], child: Text(c['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedComplexion = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Physical Disability *', icon: Icons.accessible,
          value: _selectedPhysicalDisability,
          items: const [
            DropdownMenuItem<String>(value: 'No', child: Text('No')),
            DropdownMenuItem<String>(value: 'Yes', child: Text('Yes')),
          ],
          onChanged: (v) => setState(() => _selectedPhysicalDisability = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Manglik *', icon: Icons.star_border,
          value: _selectedManglik,
          items: const [
            DropdownMenuItem<String>(value: 'No', child: Text('No')),
            DropdownMenuItem<String>(value: 'Yes', child: Text('Yes')),
          ],
          onChanged: (v) => setState(() => _selectedManglik = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Intercaste Marriage Accepted *', icon: Icons.diversity_1,
          value: _selectedIntercasteAccepted,
          items: const [
            DropdownMenuItem<String>(value: 'No', child: Text('No')),
            DropdownMenuItem<String>(value: 'Yes', child: Text('Yes')),
          ],
          onChanged: (v) => setState(() => _selectedIntercasteAccepted = v),
          isRequired: true,
        ),
      ],
    );
  }

  Widget _step3Family() {
    return Column(
      children: [
        _dropdown(
          label: 'Is Father Alive? *', icon: Icons.man,
          value: _selectedFatherAlive,
          items: const [
            DropdownMenuItem<String>(value: 'Yes', child: Text('Yes')),
            DropdownMenuItem<String>(value: 'No', child: Text('No')),
          ],
          onChanged: (v) => setState(() => _selectedFatherAlive = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Is Mother Alive? *', icon: Icons.woman,
          value: _selectedMotherAlive,
          items: const [
            DropdownMenuItem<String>(value: 'Yes', child: Text('Yes')),
            DropdownMenuItem<String>(value: 'No', child: Text('No')),
          ],
          onChanged: (v) => setState(() => _selectedMotherAlive = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _input(controller: _noOfBrothersController, label: 'No. of Brothers *', icon: Icons.boy, isNumber: true, isRequired: true)),
            const SizedBox(width: 8),
            Expanded(child: _input(controller: _marriedBrothersController, label: 'Married Brothers', icon: Icons.check_circle_outline, isNumber: true)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _input(controller: _noOfSistersController, label: 'No. of Sisters *', icon: Icons.girl, isNumber: true, isRequired: true)),
            const SizedBox(width: 8),
            Expanded(child: _input(controller: _marriedSistersController, label: 'Married Sisters', icon: Icons.check_circle_outline, isNumber: true)),
          ],
        ),
        const SizedBox(height: 12),
        _input(controller: _parentsOccupationController, label: 'Parents Occupation', icon: Icons.work_outline),
        const SizedBox(height: 12),
        _input(controller: _propertyDetailsController, label: 'Property Details', icon: Icons.home),
      ],
    );
  }

  Widget _step4Education() {
    return Column(
      children: [
        _dropdown(
          label: 'Education Level *', icon: Icons.school,
          value: _selectedEducation,
          items: (_educations ?? []).map((e) => DropdownMenuItem<String>(value: e['id'], child: Text(e['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedEducation = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _input(controller: _educationDetailController, label: 'Degree / Specialization', icon: Icons.workspace_premium_outlined),
      ],
    );
  }

  Widget _step5Career() {
    return Column(
      children: [
        _dropdown(
          label: 'Occupation Type *', icon: Icons.business_center,
          value: _selectedOccupationType,
          items: (_occupationTypes ?? []).map((o) => DropdownMenuItem<String>(value: o['id'], child: Text(o['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedOccupationType = v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _input(controller: _occupationDetailsController, label: 'Occupation Details/Company', icon: Icons.business),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Annual Income *', icon: Icons.currency_rupee,
          value: _selectedIncome,
          items: (_incomeSlabs ?? []).map((s) => DropdownMenuItem<String>(value: s['id'], child: Text(s['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedIncome = v),
          isRequired: true,
        ),
      ],
    );
  }

  Widget _step6Contact() {
    return Column(
      children: [
        _input(controller: _phoneController, label: 'Mobile Number 1 *', icon: Icons.phone, isNumber: true, isRequired: true),
        const SizedBox(height: 12),
        _input(controller: _mobile2Controller, label: 'Mobile Number 2 (Optional)', icon: Icons.phone_android, isNumber: true),
      ],
    );
  }

  Widget _step7Address() {
    return Column(
      children: [
        _dropdown(
          label: 'Government ID Type', icon: Icons.badge,
          value: _selectedGovIdType,
          items: const [
            DropdownMenuItem<String>(value: 'Aadhar Card', child: Text('Aadhar Card')),
            DropdownMenuItem<String>(value: 'PAN Card', child: Text('PAN Card')),
            DropdownMenuItem<String>(value: 'Voter ID', child: Text('Voter ID')),
            DropdownMenuItem<String>(value: 'Driving License', child: Text('Driving License')),
            DropdownMenuItem<String>(value: 'Passport', child: Text('Passport')),
          ],
          onChanged: (v) => setState(() => _selectedGovIdType = v),
          isRequired: false,
        ),
        const SizedBox(height: 12),
        _input(controller: _govIdNumberController, label: 'Government ID Number', icon: Icons.numbers),
        const SizedBox(height: 12),
        _input(controller: _addressDetailsController, label: 'Full Address *', icon: Icons.home, isRequired: true),
        const SizedBox(height: 12),
        _dropdown(
          label: 'State *', icon: Icons.map,
          value: _selectedState,
          items: (_states ?? []).map((s) => DropdownMenuItem<String>(value: s['id'], child: Text(s['name'] ?? ''))).toList(),
          onChanged: (v) => _onStateChanged(v),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'District *', icon: Icons.location_city,
          value: _selectedDistrict,
          items: (_districts ?? []).map((c) => DropdownMenuItem<String>(value: c['id'], child: Text(c['name'] ?? ''))).toList(),
          onChanged: (v) => setState(() => _selectedDistrict = v),
          isRequired: true,
        ),
      ],
    );
  }

  Widget _step8Photo() {
    return Column(
      children: [
        const Text('Profile Photo (Mandatory)', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary(context).withOpacity(0.1), width: 1.5),
            ),
            child: _profileImageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(_profileImageBytes!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_rounded, size: 28, color: AppColors.primary(context)),
                      const SizedBox(height: 8),
                      Text('Select Profile Photo', style: GoogleFonts.inter(color: AppColors.primary(context), fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }


  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      // Sanket: Manual validation for DOB in step 0
      if (_currentStep == 0 && _selectedDob == null) {
        _showSnack('Date of Birth is mandatory', isError: true);
        return;
      }
      
      if (_currentStep < 7) {
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
                     // Can safely go back
                    setState(() => _currentStep = step);
                  } else {
                    // Force them to fill up to the step they clicked sequentially
                    bool canGoToStep = true;
                    for (int i = 0; i < step; ++i) {
                       if (!_formKeys[i].currentState!.validate()) {
                          canGoToStep = false;
                          setState(() => _currentStep = i);
                          _showSnack('Please complete Step ${i+1} first', isError: true);
                          break;
                       }
                       // Sanket: Check DOB if jumping past Step 1
                       if (i == 0 && _selectedDob == null) {
                          canGoToStep = false;
                          setState(() => _currentStep = 0);
                          _showSnack('Date of Birth is mandatory', isError: true);
                          break;
                       }
                    }

                    if (canGoToStep) {
                       setState(() => _currentStep = step);
                    }
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
                                : Text(_currentStep == 7 ? 'CREATE BIODATA' : 'CONTINUE', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        if (_currentStep > 0) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isSaving ? null : details.onStepCancel,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey,
                                side: BorderSide(color: Colors.grey.withOpacity(0.2)),
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
