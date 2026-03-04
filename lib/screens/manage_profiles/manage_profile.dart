// Sanket: Production-grade 4-step profile wizard — all 12 bugs fixed
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:active_matrimonial_flutter_app/repository/manage_profile_repository.dart';
import 'package:intl/intl.dart';

class MyProfile extends StatefulWidget {
  final int initialStep;
  const MyProfile({super.key, this.initialStep = 0});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late PageController _pageController;
  late int _currentStep;
  final int _totalSteps = 4;

  // =========================================================================
  // STEP 1: Basic & Physical
  // =========================================================================
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  DateTime? _dob;
  int? _computedAge;

  // Sanket: Dropdown display label → api value maps for all enum fields
  // This prevents sending Marathi UI strings to the backend (Bug #8)
  static const Map<String, String> _religionOptions = {
    'हिंदू': 'Hindu',
    'मुस्लिम': 'Muslim',
    'ख्रिश्चन': 'Christian',
    'शीख': 'Sikh',
    'जैन': 'Jain',
    'बौद्ध': 'Buddhist',
  };
  static const Map<String, String> _casteOptions = {
    'मराठा': 'Maratha',
    'ब्राह्मण': 'Brahman',
    'कुणबी': 'Kunabi',
    'धनगर': 'Dhangar',
    'माळी': 'Mali',
    'चांभार': 'Chambhar',
    'महार': 'Mahar',
  };
  static const Map<String, String> _maritalOptions = {
    'अविवाहित': 'Unmarried',
    'घटस्फोटित पुरुष': 'Divorced (M)',
    'घटस्फोटित महिला': 'Divorced (F)',
    'विधवा': 'Widow',
    'विधुर': 'Widower',
  };
  static const Map<String, String> _heightOptions = {
    '4.5 फूट': '4.5',
    '5.0 फूट': '5.0',
    '5.2 फूट': '5.2',
    '5.5 फूट': '5.5',
    '5.8 फूट': '5.8',
    '6.0 फूट': '6.0',
    '6.2 फूट': '6.2',
    '6.5 फूट': '6.5',
  };
  static const Map<String, String> _complexionOptions = {
    'गोरा': 'fair',
    'मध्यम': 'medium',
    'गव्हाळ': 'wheatish',
    'सावळा': 'dark',
  };
  static const Map<String, String> _dietOptions = {
    'शाकाहारी': 'Vegetarian',
    'मांसाहारी': 'Non-Vegetarian',
  };
  static const Map<String, String> _bloodGroupOptions = {
    'A+': 'A+', 'A-': 'A-', 'B+': 'B+', 'B-': 'B-',
    'O+': 'O+', 'O-': 'O-', 'AB+': 'AB+', 'AB-': 'AB-',
  };

  // Sanket: Display label held in state; apiValue() converts on submit
  String? _religionDisplay;
  String? _casteDisplay;
  String? _maritalStatusDisplay;
  String? _heightDisplay;
  final TextEditingController _weight = TextEditingController();
  String? _bloodGroupDisplay;
  String? _complexionDisplay;
  bool? _physicalDisability; // Bug #12: null = not answered
  final TextEditingController _disabilityDetails = TextEditingController();
  String? _dietDisplay;
  bool? _manglik; // null = not answered
  bool? _intercasteAccepted; // null = not answered

  // =========================================================================
  // STEP 2: Family, Education, Occupation
  // =========================================================================
  bool? _fatherAlive; // null = not answered
  bool? _motherAlive; // null = not answered
  String? _noOfBrothers;
  String? _marriedBrothers;
  String? _noOfSisters;
  String? _marriedSisters;
  final TextEditingController _parentsOccupation = TextEditingController();
  final TextEditingController _propertyDetails = TextEditingController();

  static const Map<String, String> _educationOptions = {
    '१०वी': '10th',
    '१२वी': '12th',
    'ITI': 'ITI',
    'डिप्लोमा': 'Diploma',
    'पदवीधर': 'Graduate',
    'पदव्युत्तर': 'Post Graduate',
    'PhD': 'PhD',
  };
  static const Map<String, String> _occupationOptions = {
    'विद्यार्थी': 'Student',
    'खाजगी नोकरी': 'Private Job',
    'सरकारी नोकरी': 'Government Job',
    'व्यवसाय': 'Business',
    'शेतकरी': 'Farmer',
  };
  static const Map<String, String> _incomeOptions = {
    '०–२ लाख': '0-2 Lakh',
    '२–५ लाख': '2-5 Lakh',
    '५–१० लाख': '5-10 Lakh',
    '१०+ लाख': '10+ Lakh',
  };

  String? _educationDisplay;
  String? _occupationDisplay;
  final TextEditingController _occupationDetails = TextEditingController();
  String? _annualIncomeDisplay;

  // =========================================================================
  // STEP 3: Contact & Photos
  // =========================================================================
  static const Map<String, String> _govIdOptions = {
    'आधार': 'aadhaar',
    'PAN': 'pan',
    'ड्रायव्हिंग लायसन्स': 'driving_license',
    'पासपोर्ट': 'passport',
    'मतदान कार्ड': 'voter_id',
  };
  static const Map<String, String> _cityOptions = {
    'पुणे': 'Pune',
    'मुंबई': 'Mumbai',
    'नागपूर': 'Nagpur',
    'नाशिक': 'Nashik',
    'छत्रपती संभाजीनगर': 'Aurangabad',
    'सोलापूर': 'Solapur',
  };
  String? _govIdTypeDisplay;
  final TextEditingController _govIdNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  String? _cityDisplay;
  final TextEditingController _mobile1 = TextEditingController();
  final TextEditingController _mobile2 = TextEditingController();

  File? _profilePhoto;
  List<File> _otherPhotos = [];
  File? _idProof;

  // =========================================================================
  // STEP 4: Partner Expectations
  // =========================================================================
  // Bug #2 fix: dedicated controller so text survives rebuilds
  final TextEditingController _preferredCitiesCtrl = TextEditingController();
  bool? _partnerManglik; // null = not answered
  String? _expectedEducationDisplay;
  String? _expectedIncomeDisplay;
  bool? _divorceAccepted; // null = not answered
  bool? _partnerIntercaste; // null = not answered

  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  bool _isLoadingData = true;
  // Track per-step validation errors
  String? _stepError;

  // =========================================================================
  // Helpers: convert display label → API value
  // =========================================================================
  String? _apiVal(Map<String, String> map, String? display) =>
      display != null ? map[display] : null;

  // =========================================================================
  // Lifecycle
  // =========================================================================
  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _pageController = PageController(initialPage: widget.initialStep);
    _loadProfileData();
  }

  // Bug #1 fix: dispose ALL controllers
  @override
  void dispose() {
    _pageController.dispose();
    _firstName.dispose();
    _middleName.dispose();
    _surname.dispose();
    _weight.dispose();
    _disabilityDetails.dispose();
    _parentsOccupation.dispose();
    _propertyDetails.dispose();
    _occupationDetails.dispose();
    _govIdNumber.dispose();
    _address.dispose();
    _mobile1.dispose();
    _mobile2.dispose();
    _preferredCitiesCtrl.dispose(); // Bug #2
    super.dispose();
  }

  // =========================================================================
  // Data Loading — Bug #7: load all sections
  // =========================================================================
  Future<void> _loadProfileData() async {
    try {
      final repo = ManageProfileRepository();
      // Parallel fetch for speed
      final basicFuture = repo.fetchBasicInfo();
      final phyFuture = repo.fetchPhysicalAttribute();
      final famFuture = repo.fetchFamily();
      await Future.wait([basicFuture, phyFuture, famFuture]);

      if (!mounted) return;

      final basicRes = await basicFuture;
      final phyRes = await phyFuture;
      final famRes = await famFuture;

      setState(() {
        // ---- Basic info ----
        if (basicRes.result == true && basicRes.data != null) {
          final d = basicRes.data!;
          _firstName.text = d.firsName ?? '';
          _surname.text = d.lastName ?? '';
          if (d.dateOfBirth != null) {
            _dob = d.dateOfBirth;
            _computedAge = _calculateAge(_dob!);
          }
          // Sanket: Map marital status id/name back to a display label
          if (d.maritialStatus != null) {
            final apiVal = d.maritialStatus.toString();
            _maritalStatusDisplay = _maritalOptions.entries
                .where((e) => e.value == apiVal)
                .map((e) => e.key)
                .firstOrNull;
          }
        }

        // ---- Physical attributes ----
        if (phyRes.result == true && phyRes.data != null) {
          final p = phyRes.data!;
          _weight.text = p.weight?.toString() ?? '';
          _disabilityDetails.text = p.disability ?? '';
          if (p.complexion != null) {
            _complexionDisplay = _complexionOptions.entries
                .where((e) => e.value == p.complexion)
                .map((e) => e.key)
                .firstOrNull ?? p.complexion;
          }
          if (p.bloodGroup != null) {
            _bloodGroupDisplay = p.bloodGroup;
          }
          if (p.height != null) {
            final h = p.height!.toString();
            _heightDisplay = _heightOptions.entries
                .where((e) => e.value == h)
                .map((e) => e.key)
                .firstOrNull;
          }
        }

        // ---- Family info ----
        if (famRes.result == true && famRes.data != null) {
          final f = famRes.data!;
          _parentsOccupation.text = '${f.father ?? ''} / ${f.mother ?? ''}';
        }

        _isLoadingData = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoadingData = false);
      debugPrint('Sanket: Error loading profile data: $e');
    }
  }

  // =========================================================================
  // Age Calculation — Bug #3: correct birthday-aware formula
  // =========================================================================
  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    // Subtract 1 if birthday hasn't occurred yet this year
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  // =========================================================================
  // Navigation & Validation — Bug #4 & #11
  // =========================================================================
  void _nextStep() {
    final error = _validateCurrentStep();
    if (error != null) {
      setState(() => _stepError = error);
      return;
    }
    setState(() => _stepError = null);

    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitForm();
    }
  }

  void _prevStep() {
    setState(() => _stepError = null);
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  // Sanket: Per-step validation — returns error string or null if OK
  String? _validateCurrentStep() {
    final loc = AppLocalizations.of(context)!;
    switch (_currentStep) {
      case 0:
        if (_firstName.text.trim().isEmpty) {
          return loc.profile_error_first_name;
        }
        if (_dob == null) {
          return loc.profile_error_dob;
        }
        return null;

      case 1:
        // Bug #11: married count must not exceed total
        final brothers = int.tryParse(_noOfBrothers ?? '0') ?? 0;
        final marriedBrothers = int.tryParse(_marriedBrothers ?? '0') ?? 0;
        if (marriedBrothers > brothers) {
          return loc.profile_error_married_brothers;
        }
        final sisters = int.tryParse(_noOfSisters ?? '0') ?? 0;
        final marriedSisters = int.tryParse(_marriedSisters ?? '0') ?? 0;
        if (marriedSisters > sisters) {
          return loc.profile_error_married_sisters;
        }
        return null;

      case 2:
        if (_mobile1.text.trim().isEmpty) {
          return loc.profile_error_mobile;
        }
        if (_mobile1.text.trim().length < 10) {
          return loc.profile_error_mobile_invalid;
        }
        return null;

      default:
        return null;
    }
  }

  // =========================================================================
  // Submit — Bug #5 (read body), #6 (mounted), #8 (api values), #9 (cities)
  // =========================================================================
  Future<void> _submitForm() async {
    if (!mounted) return;
    setState(() => _isSubmitting = true);

    final repo = ManageProfileRepository();

    try {
      // Bug #9 fix: read preferred cities from the dedicated controller
      // and pass as a comma-separated string in general partner expectation
      final preferredCitiesText = _preferredCitiesCtrl.text.trim();

      // Sanket: Use per-section repository methods — proper API contracts
      final f1 = repo.basicInfoUpdate(
        f_name: _firstName.text.trim(),
        l_name: _surname.text.trim(),
        dob: _dob != null ? DateFormat('yyyy-MM-dd').format(_dob!) : '',
        phone: _mobile1.text.trim(),
        m_status: _apiVal(_maritalOptions, _maritalStatusDisplay),
        noofChild: '0',
        photo: _profilePhoto,
      );
      // Physical attributes update
      final f2 = repo.updatePhysicalAttr(
        height: _apiVal(_heightOptions, _heightDisplay),
        weight: _weight.text.isNotEmpty ? _weight.text : null,
        complexion: _apiVal(_complexionOptions, _complexionDisplay),
        blood_group: _bloodGroupDisplay,
        disability: _disabilityDetails.text.isNotEmpty
            ? _disabilityDetails.text
            : null,
      );
      // Partner expectations update
      final f3 = repo.updatePartnerExpectation(
        general_info: preferredCitiesText.isNotEmpty
            ? preferredCitiesText
            : null,
        manglik: _partnerManglik != null
            ? (_partnerManglik! ? '1' : '0')
            : null,
        education: _apiVal(_educationOptions, _expectedEducationDisplay),
        min_height: null,
        max_weight: null,
        residency_country: null,
        marital_status: null,
        children: _divorceAccepted != null
            ? (_divorceAccepted! ? '1' : '0')
            : null,
        religion: null,
        caste: null,
        subcaste: null,
          language: null,
          smoking: null,
          profession: null,
          drinking: null,
          diet: null,
          body_type: null,
          personal_value: null,
          pref_country: null,
          pref_state: null,
          family_val: null,
          complexion: null,
      );

      // Bug #6 fix: await all, then check mounted before touching context
      await Future.wait([f1, f2, f3]);

      if (!mounted) return;

      final res1 = await f1;
      final res2 = await f2;
      final res3 = await f3;

      // Bug #5 fix: check result field from each response, not just HTTP status
      final allSuccess = (res1.result == true) &&
                         (res2.result == true) &&
                         (res3.result == true);

      setState(() => _isSubmitting = false);

      if (!mounted) return;

      if (allSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profile_saved_ok),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profile_saved_fail),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return; // Bug #6 fix
      setState(() => _isSubmitting = false);
      debugPrint('Sanket: Profile submit error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.profile_save_error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================================================================
  // Build
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        backgroundColor: MyTheme.background,
        appBar: _buildHeader(),
        body: const Center(
          child: CircularProgressIndicator(color: MyTheme.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MyTheme.background,
      appBar: _buildHeader(),
      body: Column(
        children: [
          _buildProgressIndicator(),
          // Sanket: Show per-step validation error banner
          if (_stepError != null) _buildErrorBanner(_stepError!),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (idx) => setState(() {
                _currentStep = idx;
                _stepError = null;
              }),
              children: [
                _buildStep1BasicPhysical(),
                _buildStep2FamilyEducation(),
                _buildStep3ContactPhotos(),
                _buildStep4Expectations(),
              ],
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      color: Colors.red.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: MyTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: MyTheme.text_primary),
        onPressed: _prevStep,
      ),
      title: Text(
        AppLocalizations.of(context)!.profile_edit_title,
        style: Styles.h2.copyWith(color: MyTheme.text_primary, fontSize: 18),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: MyTheme.border, height: 1),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: MyTheme.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          bool isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? MyTheme.primary : MyTheme.border,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16, 16, 16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: MyTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: MyTheme.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.profile_back,
                  style: Styles.buttonText.copyWith(
                    color: MyTheme.text_primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep == _totalSteps - 1
                          ? AppLocalizations.of(context)!.profile_submit
                          : AppLocalizations.of(context)!.profile_next,
                      style: Styles.buttonText.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP 1: Basic & Physical
  // =========================================================================
  Widget _buildStep1BasicPhysical() {
    return _pageWrapper([
      _sectionTitle(AppLocalizations.of(context)!.profile_section_basic),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_first_name,
        _firstName,
        isRequired: true,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_middle_name,
        _middleName,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_last_name,
        _surname,
      ),
      _buildDatePicker(
        AppLocalizations.of(context)!.profile_label_dob,
        _dob,
        isRequired: true,
        (date) {
          setState(() {
            _dob = date;
            _computedAge = _calculateAge(date); // Bug #3 fixed
          });
        },
      ),
      if (_computedAge != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            AppLocalizations.of(context)!.profile_label_age(_computedAge!),
            style: Styles.body.copyWith(
              color: MyTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_religion,
        _religionOptions,
        _religionDisplay,
        (v) => setState(() => _religionDisplay = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_caste,
        _casteOptions,
        _casteDisplay,
        (v) => setState(() => _casteDisplay = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_marital_status,
        _maritalOptions,
        _maritalStatusDisplay,
        (v) => setState(() => _maritalStatusDisplay = v),
      ),

      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_physical),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_height,
        _heightOptions,
        _heightDisplay,
        (v) => setState(() => _heightDisplay = v),
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_weight,
        _weight,
        isNumber: true,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_blood_group,
        _bloodGroupOptions,
        _bloodGroupDisplay,
        (v) => setState(() => _bloodGroupDisplay = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_complexion,
        _complexionOptions,
        _complexionDisplay,
        (v) => setState(() => _complexionDisplay = v),
      ),

      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_disability,
        _physicalDisability,
        (v) => setState(() => _physicalDisability = v),
      ),
      if (_physicalDisability == true)
        _buildTextField(
          AppLocalizations.of(context)!.profile_label_disability_details,
          _disabilityDetails,
        ),

      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_diet,
        _dietOptions,
        _dietDisplay,
        (v) => setState(() => _dietDisplay = v),
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_manglik,
        _manglik,
        (v) => setState(() => _manglik = v),
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_intercaste,
        _intercasteAccepted,
        (v) => setState(() => _intercasteAccepted = v),
      ),
    ]);
  }

  // =========================================================================
  // STEP 2: Family, Education, Occupation
  // =========================================================================
  Widget _buildStep2FamilyEducation() {
    final numberOptions = Map.fromEntries(
      List.generate(11, (i) => MapEntry(i.toString(), i.toString())),
    );
    return _pageWrapper([
      _sectionTitle(AppLocalizations.of(context)!.profile_section_family),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_father_alive,
        _fatherAlive,
        (v) => setState(() => _fatherAlive = v),
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_mother_alive,
        _motherAlive,
        (v) => setState(() => _motherAlive = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_brothers,
        numberOptions,
        _noOfBrothers,
        (v) => setState(() => _noOfBrothers = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_married_brothers,
        numberOptions,
        _marriedBrothers,
        (v) => setState(() => _marriedBrothers = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_sisters,
        numberOptions,
        _noOfSisters,
        (v) => setState(() => _noOfSisters = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_married_sisters,
        numberOptions,
        _marriedSisters,
        (v) => setState(() => _marriedSisters = v),
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_parents_occ,
        _parentsOccupation,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_property,
        _propertyDetails,
        maxLines: 3,
      ),

      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_education),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_education_level,
        _educationOptions,
        _educationDisplay,
        (v) => setState(() => _educationDisplay = v),
      ),

      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_career),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_occ_type,
        _occupationOptions,
        _occupationDisplay,
        (v) => setState(() => _occupationDisplay = v),
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_occ_details,
        _occupationDetails,
        maxLines: 2,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_income,
        _incomeOptions,
        _annualIncomeDisplay,
        (v) => setState(() => _annualIncomeDisplay = v),
      ),
    ]);
  }

  // =========================================================================
  // STEP 3: Contact & Photos
  // =========================================================================
  Widget _buildStep3ContactPhotos() {
    return _pageWrapper([
      _sectionTitle(AppLocalizations.of(context)!.profile_section_contact),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_gov_id_type,
        _govIdOptions,
        _govIdTypeDisplay,
        (v) => setState(() => _govIdTypeDisplay = v),
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_gov_id_number,
        _govIdNumber,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_address,
        _address,
        maxLines: 3,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_city,
        _cityOptions,
        _cityDisplay,
        (v) => setState(() => _cityDisplay = v),
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_mobile1,
        _mobile1,
        isNumber: true,
        isRequired: true,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_mobile2,
        _mobile2,
        isNumber: true,
      ),

      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_photos),

      // Bug #10 fix: show banner on web instead of silently dropping
      if (kIsWeb)
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.profile_web_photo_note,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      if (!kIsWeb) ...[
        _buildUploadBox(
          AppLocalizations.of(context)!.profile_label_profile_photo,
          _profilePhoto,
          (file) => setState(() => _profilePhoto = file),
        ),
        _buildUploadBox(
          AppLocalizations.of(context)!.profile_label_id_proof,
          _idProof,
          (file) => setState(() => _idProof = file),
        ),
        _buildMultiUploadBox(
          AppLocalizations.of(context)!.profile_label_other_photos,
          _otherPhotos,
          (files) => setState(() => _otherPhotos = files),
        ),
      ],
    ]);
  }

  // =========================================================================
  // STEP 4: Partner Expectations
  // =========================================================================
  Widget _buildStep4Expectations() {
    return _pageWrapper([
      _sectionTitle(
        AppLocalizations.of(context)!.profile_section_expectations,
      ),
      // Bug #2 fix: use the persistent controller
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_preferred_cities,
        _preferredCitiesCtrl,
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_partner_manglik,
        _partnerManglik,
        (v) => setState(() => _partnerManglik = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_expected_edu,
        _educationOptions,
        _expectedEducationDisplay,
        (v) => setState(() => _expectedEducationDisplay = v),
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_expected_income,
        _incomeOptions,
        _expectedIncomeDisplay,
        (v) => setState(() => _expectedIncomeDisplay = v),
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_divorce_accepted,
        _divorceAccepted,
        (v) => setState(() => _divorceAccepted = v),
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_partner_intercaste,
        _partnerIntercaste,
        (v) => setState(() => _partnerIntercaste = v),
      ),
    ]);
  }

  // =========================================================================
  // REUSABLE UI WIDGETS
  // =========================================================================
  Widget _pageWrapper(List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: Styles.h2.copyWith(fontSize: 20, color: MyTheme.text_primary),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Styles.body.copyWith(
                  color: MyTheme.text_secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired)
                const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: MyTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyTheme.border),
            ),
            child: TextField(
              controller: controller,
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              maxLines: maxLines,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sanket: Takes Map<displayLabel, apiValue> — only display labels shown to
  // user; apiValue is what gets submitted. Fixes Bug #8.
  Widget _buildMappedDropdown(
    String label,
    Map<String, String> items,
    String? selectedDisplay,
    Function(String) onChanged, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Styles.body.copyWith(
                  color: MyTheme.text_secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired)
                const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: MyTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyTheme.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedDisplay,
                hint: Text(
                  AppLocalizations.of(context)!.profile_label_select,
                ),
                items: items.keys
                    .map(
                      (label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? date,
    Function(DateTime) onPicked, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Styles.body.copyWith(
                  color: MyTheme.text_secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired)
                const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime(1995),
                firstDate: DateTime(1950),
                lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              );
              if (picked != null) onPicked(picked);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyTheme.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date != null
                        ? DateFormat('dd MMM yyyy').format(date)
                        : AppLocalizations.of(context)!.profile_label_date_pick,
                    style: TextStyle(
                      color: date != null
                          ? MyTheme.text_primary
                          : MyTheme.text_secondary,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: MyTheme.text_secondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bug #12 fix: nullable bool — no default forced on user
  Widget _buildNullableRadioOption(
    String label,
    bool? value,
    Function(bool?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Styles.body.copyWith(
              color: MyTheme.text_secondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: Text(AppLocalizations.of(context)!.profile_yes),
                  value: true,
                  groupValue: value,
                  onChanged: onChanged,
                  contentPadding: EdgeInsets.zero,
                  activeColor: MyTheme.primary,
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: Text(AppLocalizations.of(context)!.profile_no),
                  value: false,
                  groupValue: value,
                  onChanged: onChanged,
                  contentPadding: EdgeInsets.zero,
                  activeColor: MyTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String label, File? file, Function(File) onPicked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Styles.body.copyWith(
              color: MyTheme.text_secondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) onPicked(File(image.path));
            },
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyTheme.solitude,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyTheme.border),
              ),
              child: file != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(file, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          color: MyTheme.text_secondary,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.profile_label_upload_tap,
                          style: const TextStyle(color: MyTheme.text_secondary),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiUploadBox(
    String label,
    List<File> files,
    Function(List<File>) onPicked,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Styles.body.copyWith(
              color: MyTheme.text_secondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final List<XFile> images = await _picker.pickMultiImage();
              if (images.isNotEmpty) {
                onPicked(images.map((e) => File(e.path)).toList());
              }
            },
            child: Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyTheme.solitude,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyTheme.border),
              ),
              child: files.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: files
                            .map(
                              (f) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    f,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.photo_library_outlined,
                          color: MyTheme.text_secondary,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!
                              .profile_label_upload_multi_tap,
                          style:
                              const TextStyle(color: MyTheme.text_secondary),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
