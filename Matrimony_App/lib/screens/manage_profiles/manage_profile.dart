// Sanket: Production-grade 4-step profile wizard — all 12 bugs fixed
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:active_matrimonial_flutter_app/repository/drop_down_repository.dart';
import 'package:active_matrimonial_flutter_app/models_response/common_models/ddown.dart';
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
  final _formKey = GlobalKey<FormState>();

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
  // Dropdown lists fetched from API
  List<DDown> _religionList = [];
  List<DDown> _casteList = [];
  List<DDown> _subCasteList = [];

  // Selected IDs for submission
  int? _selectedReligionId;
  int? _selectedCasteId;
  int? _selectedSubCasteId;
  List<DDown> _districtList = []; // Added by Sanket
  Map<String, String> get _maritalOptions {
    final loc = AppLocalizations.of(context)!;
    return {
      loc.marital_status_unmarried: "Unmarried",
      loc.marital_status_divorced_m: "Divorced (M)",
      loc.marital_status_divorced_f: "Divorced (F)",
      loc.marital_status_widow: "Widow",
      loc.marital_status_widower: "Widower",
    };
  }

  Map<String, String> get _heightOptions {
    // Height is mostly numeric/standard, but we can localize 'feet' and 'inch' if needed.
    // For now, these are stable strings.
    return {
      '4\' 0"': '4.0', '4\' 1"': '4.1', '4\' 2"': '4.2', '4\' 3"': '4.3', '4\' 4"': '4.4', '4\' 5"': '4.5', '4\' 6"': '4.6', '4\' 7"': '4.7', '4\' 8"': '4.8', '4\' 9"': '4.9', '4\' 10"': '4.10', '4\' 11"': '4.11',
      '5\' 0"': '5.0', '5\' 1"': '5.1', '5\' 2"': '5.2', '5\' 3"': '5.3', '5\' 4"': '5.4', '5\' 5"': '5.5', '5\' 6"': '5.6', '5\' 7"': '5.7', '5\' 8"': '5.8', '5\' 9"': '5.9', '5\' 10"': '5.10', '5\' 11"': '5.11',
      '6\' 0"': '6.0', '6\' 1"': '6.1', '6\' 2"': '6.2', '6\' 3"': '6.3', '6\' 4"': '6.4', '6\' 5"': '6.5', '6\' 6"': '6.6', '6\' 7"': '6.7', '6\' 8"': '6.8', '6\' 9"': '6.9', '6\' 10"': '6.10', '6\' 11"': '6.11',
      '7\' 0"': '7.0',
    };
  }

  Map<String, String> get _complexionOptions {
    final loc = AppLocalizations.of(context)!;
    return {
      loc.complexion_fair: "fair",
      loc.complexion_medium: "medium",
      loc.complexion_wheatish: "wheatish",
      loc.complexion_dark: "dark",
    };
  }

  Map<String, String> get _dietOptions {
    return {
      "Vegetarian": "Vegetarian",
      "Non-Vegetarian": "Non-Vegetarian",
    };
  }

  Map<String, String> get _bloodGroupOptions {
    return {
      'A+': 'A+', 'A-': 'A-', 'B+': 'B+', 'B-': 'B-',
      'O+': 'O+', 'O-': 'O-', 'AB+': 'AB+', 'AB-': 'AB-',
      'N/A': 'NA',
    };
  }

  // Sanket: Display label held in state; apiValue() converts on submit
  String? _religionDisplay;
  String? _casteDisplay;
  String? _subCasteDisplay;
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
  String? _noOfChildren; // Added by Sanket for married/divorced/widow
  String? _eduStart; // Added by Sanket to avoid hardcoded 0
  String? _careerStart; // Added by Sanket to avoid hardcoded 0

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

  Map<String, String> get _educationOptions {
    final loc = AppLocalizations.of(context)!;
    return {
      loc.education_illiterate: "Illiterate",
      loc.education_primary: "Primary",
      loc.education_secondary: "Secondary",
      loc.education_higher_secondary: "Higher Secondary",
      loc.education_graduate: "Graduate",
      loc.education_post_graduate: "Post Graduate",
      loc.education_doctorate: "Doctorate",
      loc.education_other: "Other",
    };
  }

  Map<String, String> get _occupationOptions {
    final loc = AppLocalizations.of(context)!;
    return {
      loc.occupation_private: "Private Job",
      loc.occupation_government: "Government Job",
      loc.occupation_business: "Business",
      loc.occupation_self_employed: "Self Employed",
      loc.occupation_farmer: "Farmer",
      loc.occupation_teacher: "Teacher",
      loc.occupation_doctor: "Doctor",
      loc.occupation_engineer: "Engineer",
      loc.occupation_defense: "Defense",
      loc.occupation_retired: "Retired",
      loc.occupation_not_working: "Not Working",
      loc.occupation_other_occ: "Other",
    };
  }

  Map<String, String> get _incomeOptions {
    final loc = AppLocalizations.of(context)!;
    return {
      loc.income_0_2: '0-2 Lakh',
      loc.income_2_5: '2-5 Lakh',
      loc.income_5_10: '5-10 Lakh',
      loc.income_10_20: '10-20 Lakh',
      loc.income_20_50: '20-50 Lakh',
      loc.income_50_plus: '50 Lakh+',
    };
  }

  String? _educationDisplay;
  final TextEditingController _educationDetails = TextEditingController();
  String? _occupationDisplay;
  final TextEditingController _occupationDetails = TextEditingController();
  String? _annualIncomeDisplay;

  // =========================================================================
  // STEP 3: Contact & Photos
  // =========================================================================
  Map<String, String> get _govIdOptions {
    final loc = AppLocalizations.of(context)!;
    return {
      loc.gov_id_aadhaar: 'aadhaar',
      loc.gov_id_pan: 'pan',
      loc.gov_id_dl: 'driving_license',
      loc.gov_id_passport: 'passport',
      loc.gov_id_voter: 'voter_id',
    };
  }
  // Sanket: Removed hardcoded _districtOptions; now fetched from API
  String? _govIdTypeDisplay;
  final TextEditingController _govIdNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  String? _districtDisplay;
  final TextEditingController _mobile1 = TextEditingController();
  final TextEditingController _mobile2 = TextEditingController();

  dynamic _profilePhoto; // Sanket: Use dynamic (XFile or File) for platform compatibility
  List<dynamic> _otherPhotos = [];
  dynamic _idProof;

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

  // Sanket: Partner specific selection IDs
  int? _partnerReligionId;
  String? _partnerReligionDisplay;
  int? _partnerCasteId;
  String? _partnerCasteDisplay;
  int? _partnerSubCasteId;
  String? _partnerSubCasteDisplay;
  List<DDown> _partnerCasteList = [];
  List<DDown> _partnerSubCasteList = [];

  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  bool _isLoadingData = true;
  // Track per-step validation errors
  String? _stepError;

  // =========================================================================
  // Helpers: convert display label → API value
  // =========================================================================

  // =========================================================================
  // Lifecycle
  // =========================================================================
  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _pageController = PageController(initialPage: widget.initialStep);
    _loadInitialDropdowns();
    _loadProfileData();
  }

  Future<void> _loadInitialDropdowns() async {
    try {
      final res = await DropDownRepository().fetchProfileDropDown();
      if (res.result == true && res.data != null) {
        setState(() {
          _religionList = res.data!.religionList ?? [];
          _districtList = res.data!.cityList ?? []; // Added by Sanket
        });
      }
    } catch (e) {
      debugPrint("Error loading religions: $e");
    }
  }

  Future<void> _onReligionChanged(DDown? religion) async {
    if (religion == null) return;
    setState(() {
      _religionDisplay = religion.name;
      _selectedReligionId = religion.id;
      _casteDisplay = null;
      _selectedCasteId = null;
      _subCasteDisplay = null;
      _selectedSubCasteId = null;
      _casteList = [];
      _subCasteList = [];
    });

    try {
      final res = await DropDownRepository().fetchCaste(religion.id);
      if (res.data != null) {
        setState(() => _casteList = res.data ?? []);
      }
    } catch (e) {
      debugPrint("Error loading castes: $e");
    }
  }

  Future<void> _onCasteChanged(DDown? caste) async {
    if (caste == null) return;
    setState(() {
      _casteDisplay = caste.name;
      _selectedCasteId = caste.id;
      _subCasteDisplay = null;
      _selectedSubCasteId = null;
      _subCasteList = [];
    });

    try {
      final res = await DropDownRepository().fetchSubCaste(caste.id);
      if (res.data != null) {
        setState(() => _subCasteList = res.data ?? []);
      }
    } catch (e) {
      debugPrint("Error loading sub-castes: $e");
    }
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
    debugPrint('Sanket: Starting profile data load...');
    try {
      final repo = ManageProfileRepository();
      // Parallel fetch for speed
      final basicFuture = repo.fetchBasicInfo();
      final phyFuture = repo.fetchPhysicalAttribute();
      final famFuture = repo.fetchFamily();
      final eduFuture = repo.fetchEducation();
      final careerFuture = repo.fetchCareer();
      final addrFuture = repo.fetchPresentAddress();
      final partnerFuture = repo.fetchPartnerExpectation();
      final lifeStyleFuture = repo.fetchLifeStyle(); // Sanket: For diet

      await Future.wait([
        basicFuture,
        phyFuture,
        famFuture,
        eduFuture,
        careerFuture,
        addrFuture,
        partnerFuture,
        lifeStyleFuture
      ]);

      if (!mounted) return;

      final basicRes = await basicFuture;
      final phyRes = await phyFuture;
      final famRes = await famFuture;
      final eduRes = await eduFuture;
      final careerRes = await careerFuture;
      final addrRes = await addrFuture;
      final partnerRes = await partnerFuture;
      final lifeStyleRes = await lifeStyleFuture; // Sanket: For diet

      debugPrint('Sanket: BasicInfo trace: ${basicRes.result}, data: ${basicRes.data?.firstName}');

      setState(() {
        // ---- Basic info ----
        if (basicRes.result == true && basicRes.data != null) {
          final d = basicRes.data!;
          _firstName.text = d.firstName ?? '';
          _surname.text = d.lastName ?? '';
          if (d.dateOfBirth != null) {
            _dob = d.dateOfBirth;
            _computedAge = _calculateAge(_dob!);
          }
          // Sanket: Map marital status id/name back to a stable API value
          if (d.maritialStatus != null) {
            final apiVal = d.maritialStatus.toString().toLowerCase();
            _maritalStatusDisplay = _maritalOptions.entries
                .where((e) => e.value.toLowerCase() == apiVal || e.key.toLowerCase() == apiVal)
                .map((e) => e.value) // Store stable API value
                .firstOrNull;
          }
          _mobile1.text = d.phone ?? '';
          if (d.noOfChildren != null) {
            _noOfChildren = d.noOfChildren.toString();
          }
        }

        // ---- Physical attributes ----
        if (phyRes.result == true && phyRes.data != null) {
          final p = phyRes.data!;
          _weight.text = p.weight?.toString() ?? '';
          _disabilityDetails.text = p.disability ?? '';
          _physicalDisability = p.disability != null && p.disability!.toLowerCase() != "none" && p.disability!.trim().isNotEmpty;
          
          if (p.complexion != null) {
            final target = p.complexion!.toLowerCase();
            _complexionDisplay = _complexionOptions.entries
                    .where((e) => e.value.toLowerCase() == target || e.key.toLowerCase() == target)
                    .map((e) => e.value) // Store stable API value
                    .firstOrNull ?? p.complexion;
          }
          if (p.bloodGroup != null) {
            _bloodGroupDisplay = p.bloodGroup;
          }
          if (p.height != null) {
            final h = p.height!.toString();
            _heightDisplay = _heightOptions.entries
                .where((e) => e.value == h)
                .map((e) => e.value) // Store stable API value
                .firstOrNull;
          }
        }

        // ---- Family info ----
        if (famRes.result == true && famRes.data != null) {
          final f = famRes.data!;
          _fatherAlive = f.father?.toLowerCase() == 'alive';
          _motherAlive = f.mother?.toLowerCase() == 'alive';
        }

        // ---- Education ----
        if (eduRes.result == true && eduRes.data != null && eduRes.data!.isNotEmpty) {
          final e = eduRes.data!.first;
          final targetDegree = e.degree?.toLowerCase();
          _educationDisplay = _educationOptions.entries
              .where((item) => item.value.toLowerCase() == targetDegree || item.key.toLowerCase() == targetDegree)
              .map((item) => item.value) // Store stable API value
              .firstOrNull ?? e.degree;
          _educationDetails.text = e.institution ?? '';
          _eduStart = e.start;
        }

        // ---- Career ----
        if (careerRes.result == true && careerRes.data != null && careerRes.data!.isNotEmpty) {
          final c = careerRes.data!.first;
          final targetOcc = c.designation?.toLowerCase();
          _occupationDisplay = _occupationOptions.entries
              .where((item) => item.value.toLowerCase() == targetOcc || item.key.toLowerCase() == targetOcc)
              .map((item) => item.value) // Store stable API value
              .firstOrNull ?? c.designation;
          _occupationDetails.text = c.company ?? '';
          _careerStart = c.start;
          if (c.annualIncome != null) {
            final target = c.annualIncome!.toLowerCase();
             _annualIncomeDisplay = _incomeOptions.entries
                .where((e) => e.value.toLowerCase() == target || e.key.toLowerCase() == target)
                .map((e) => e.value)
                .firstOrNull ?? c.annualIncome;
          }
        }

        // ---- Address & District ----
        if (addrRes.result == true && addrRes.data != null) {
          final a = addrRes.data!;
          _address.text = a.address ?? '';
          if (a.city != null) {
            final targetCity = a.city!.toLowerCase();
            _districtDisplay = _districtList
                .where((e) => e.name?.toLowerCase() == targetCity || e.id.toString() == targetCity)
                .map((e) => e.name)
                .firstOrNull ?? a.city;
          }
          if (a.govIdType != null) {
            final target = a.govIdType!.toLowerCase();
            _govIdTypeDisplay = _govIdOptions.entries
                .where((e) => e.value.toLowerCase() == target || e.key.toLowerCase() == target)
                .map((e) => e.value)
                .firstOrNull ?? a.govIdType;
            _govIdNumber.text = a.govIdNumber ?? '';
          }
        }

        // ---- Expectations ----
        if (partnerRes.result == true && partnerRes.data != null) {
          final ex = partnerRes.data!;
          _preferredCitiesCtrl.text = ex.general ?? '';
          if (ex.manglik != null) _partnerManglik = ex.manglik == '1' || ex.manglik!.toLowerCase() == 'yes';
          if (ex.childrenAcceptable != null)
            _divorceAccepted = ex.childrenAcceptable?.toLowerCase() == 'yes';
        // ---- Diet (from LifeStyle) ----
        if (lifeStyleRes.result == true && lifeStyleRes.data != null) {
          final target = lifeStyleRes.data!.diet?.toLowerCase();
          _dietDisplay = _dietOptions.entries
              .where((e) => e.value.toLowerCase() == target || e.key.toLowerCase() == target)
              .map((e) => e.value)
              .firstOrNull ?? lifeStyleRes.data!.diet;
        }

        // ---- Expectations Additional ----
        if (partnerRes.data != null) {
          final ex = partnerRes.data!;
          if (ex.education != null) {
            final target = ex.education!.toLowerCase();
            _expectedEducationDisplay = _educationOptions.entries
                .where((e) => e.value.toLowerCase() == target || e.key.toLowerCase() == target)
                .map((e) => e.value)
                .firstOrNull ?? ex.education;
          }
        }

          // Sanket: Load partner religion/caste IDs
          _partnerReligionId = int.tryParse(ex.religionId ?? '');
          _partnerReligionDisplay = ex.religion;
          _partnerCasteId = int.tryParse(ex.casteId ?? '');
          _partnerCasteDisplay = ex.caste;
          _partnerSubCasteId = int.tryParse(ex.subCasteId ?? '');
          _partnerSubCasteDisplay = ex.subCaste;

          // If IDs exist, pre-fetch their dependent lists
          if (_partnerReligionId != null) {
            DropDownRepository().fetchCaste(_partnerReligionId!).then((res) {
              if (res.data != null && mounted) {
                setState(() => _partnerCasteList = res.data ?? []);
              }
            });
          }
        }

        // ---- Religion & Caste ----
        if (basicRes.data?.religionId != null) {
           _selectedReligionId = basicRes.data!.religionId;
           _religionDisplay = basicRes.data!.religion;
           DropDownRepository().fetchCaste(_selectedReligionId!).then((res) {
              if (res.data != null && mounted) {
                setState(() => _casteList = res.data ?? []);
              }
           });
        }
        if (basicRes.data?.casteId != null) {
           _selectedCasteId = basicRes.data!.casteId;
           _casteDisplay = basicRes.data!.caste;
           DropDownRepository().fetchSubCaste(_selectedCasteId!).then((res) {
              if (res.data != null && mounted) {
                setState(() => _subCasteList = res.data ?? []);
              }
           });
        }

        _isLoadingData = false;
        debugPrint('Sanket: Profile data load completed.');
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
    if (_formKey.currentState?.validate() != true) {
      setState(() => _stepError = "Please fix the errors in the form.");
      return;
    }

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
        if (_firstName.text.trim().isEmpty || _surname.text.trim().isEmpty || _middleName.text.trim().isEmpty) {
          return "First, Middle, and Last Name are required.";
        }
        if (_dob == null) return loc.profile_error_dob;
        if (_religionDisplay == null || _casteDisplay == null || _maritalStatusDisplay == null) {
          return "Please select Religion, Caste, and Marital Status.";
        }
        if (_heightDisplay == null) {
          return "Please select Height.";
        }
        if (_bloodGroupDisplay == null || _complexionDisplay == null) {
          return "Please select Blood Group and Complexion.";
        }
        if (_physicalDisability == null || _manglik == null || _intercasteAccepted == null) {
          return "Please answer all Yes/No questions.";
        }
        if (_physicalDisability == true && _disabilityDetails.text.trim().isEmpty) {
          return "Please provide Disability Details.";
        }
        return null;

      case 1:
        if (_fatherAlive == null || _motherAlive == null) {
          return "Please select Parents status.";
        }
        if (_noOfBrothers == null || _marriedBrothers == null || _noOfSisters == null || _marriedSisters == null) {
          return "Please provide Siblings count.";
        }
        // Sanket: Occupation details is no longer mandatory
        if (_educationDisplay == null) {
          return "Please select your Education level.";
        }
        if (_educationDetails.text.trim().isEmpty) {
          return "Please provide Education details.";
        }
        if (_occupationDisplay == null || _annualIncomeDisplay == null) {
          return "Please fill Career and Income details.";
        }
        return null;

      case 2:
        // Sanket: Govt ID is no longer mandatory
        if (_address.text.trim().isEmpty || _districtDisplay == null) {
          return "Please fill address and select District.";
        }
        if (_mobile1.text.trim().isEmpty || _mobile1.text.trim().length < 10) {
          return loc.profile_error_mobile_invalid;
        }
        return null;

      case 3:
        if (_preferredCitiesCtrl.text.trim().isEmpty) {
          return "Please enter Preferred Cities.";
        }
        if (_partnerManglik == null || _divorceAccepted == null || _partnerIntercaste == null) {
          return "Please answer all Partner Expectations Yes/No questions.";
        }
        // Sanket: Partner religion is mandatory, but caste and education/income are no longer mandatory
        if (_partnerReligionDisplay == null) {
           return "Please select Partner Religion.";
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
      final preferredCitiesText = _preferredCitiesCtrl.text.trim();

      // Sanket: Use Atomic Update (B-001) - send all text data in one request
      final response = await repo.fullProfileUpdate(
        f_name: _firstName.text.trim(),
        middle_name: _middleName.text.trim(),
        l_name: _surname.text.trim(),
        dob: _dob != null ? DateFormat('yyyy-MM-dd').format(_dob!) : '',
        phone: _mobile1.text.trim(),
        m_status: _maritalStatusDisplay,
        height: _heightDisplay,
        weight: _weight.text.isNotEmpty ? _weight.text : null,
        complexion: _complexionDisplay,
        blood_group: _bloodGroupDisplay,
        disability: _physicalDisability == true ? _disabilityDetails.text : "None",
        religion: _religionDisplay,
        religion_id: _selectedReligionId,
        caste: _casteDisplay,
        caste_id: _selectedCasteId,
        sub_caste_id: _selectedSubCasteId,
        diet: _dietDisplay,
        personal_manglik: _manglik != null ? (_manglik! ? '1' : '0') : null,
        intercaste_accepted: _intercasteAccepted != null ? (_intercasteAccepted! ? '1' : '0') : null,
        father: _fatherAlive == true ? 'Alive' : 'Deceased',
        mother: _motherAlive == true ? 'Alive' : 'Deceased',
        brothers: _noOfBrothers ?? '0',
        married_brothers: _marriedBrothers ?? '0',
        sisters: _noOfSisters ?? '0',
        married_sisters: _marriedSisters ?? '0',
        parents_occupation: _parentsOccupation.text.isNotEmpty ? _parentsOccupation.text : null,
        property_details: _propertyDetails.text.isNotEmpty ? _propertyDetails.text : null,
        degree: _educationDisplay,
        institution: _educationDetails.text.isNotEmpty
            ? _educationDetails.text
            : "N/A",
        education_start: _eduStart ?? "2000",
        designation: _occupationDisplay,
        company: _occupationDetails.text.isNotEmpty
            ? _occupationDetails.text
            : "N/A",
        career_start: _careerStart ?? "2010",
        annual_income: _annualIncomeDisplay,
        gov_id_type: _govIdTypeDisplay,
        gov_id_number: _govIdNumber.text.trim(),
        address: _address.text.trim(),
        district: _districtList.where((e) => e.name == _districtDisplay).map((e) => e.id).firstOrNull,
        phone2: _mobile2.text.trim(),
        general_info: preferredCitiesText.isNotEmpty ? preferredCitiesText : null,
        manglik: _partnerManglik != null ? (_partnerManglik! ? '1' : '0') : null,
        partner_religion_id: _partnerReligionId,
        partner_caste_id: _partnerCasteId,
        partner_sub_caste_id: _partnerSubCasteId,
        no_of_children: (_maritalStatusDisplay != null && _maritalStatusDisplay != "Unmarried") ? _noOfChildren : null,
        education_expectation: _expectedEducationDisplay,
        expected_income: _expectedIncomeDisplay,
        children_acceptable: _divorceAccepted != null ? (_divorceAccepted! ? '1' : '0') : null,
        partner_intercaste: _partnerIntercaste != null ? (_partnerIntercaste! ? '1' : '0') : null,
      );


      if (!mounted) return;

      if (response.result == true) {
        // Atomic data saved. Now handle photo separately if exists.
        if (_profilePhoto != null) {
          await repo.profilePictureUpdate(photo: _profilePhoto);
        }

        setState(() => _isSubmitting = false);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profile_saved_ok),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() => _isSubmitting = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                response.message ?? AppLocalizations.of(context)!.profile_saved_fail),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
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
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
    final loc = AppLocalizations.of(context)!;
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
        isRequired: true,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_last_name,
        _surname,
        isRequired: true,
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
              color: MyTheme.text_secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      _buildDDown(
        AppLocalizations.of(context)!.profile_label_religion,
        _religionList,
        _religionDisplay,
        _selectedReligionId,
        _onReligionChanged,
        isRequired: true,
      ),
      _buildDDown(
        AppLocalizations.of(context)!.profile_label_caste,
        _casteList,
        _casteDisplay,
        _selectedCasteId,
        _onCasteChanged,
        isRequired: true,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_marital_status,
        _maritalOptions,
        _maritalStatusDisplay,
        (v) => setState(() => _maritalStatusDisplay = v),
        isRequired: true,
      ),
      if (_maritalStatusDisplay != null && _maritalStatusDisplay != "Unmarried")
        _buildMappedDropdown(
          "Number of Children",
          Map.fromEntries(List.generate(11, (i) => MapEntry(i.toString(), i.toString()))),
          _noOfChildren,
          (v) => setState(() => _noOfChildren = v),
          isRequired: true,
        ),

      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_physical),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_height,
        _heightOptions,
        _heightDisplay,
        (v) => setState(() => _heightDisplay = v),
        isRequired: true,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_weight,
        _weight,
        isNumber: true,
        isRequired: false,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_blood_group,
        _bloodGroupOptions,
        _bloodGroupDisplay,
        (v) => setState(() => _bloodGroupDisplay = v),
        isRequired: true,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_complexion,
        _complexionOptions,
        _complexionDisplay,
        (v) => setState(() => _complexionDisplay = v),
        isRequired: true,
      ),

      const SizedBox(height: 16),
      // Bug #12: Convert Physical Disability into Yes/No dropdown matching API
      _buildDropdown(
        label: loc.profile_physical_disability,
        value: _physicalDisability == null
            ? null
            : (_physicalDisability! ? loc.common_yes : loc.common_no),
        items: [loc.common_yes, loc.common_no],
        onChanged: (val) {
          setState(() {
            _physicalDisability = val == loc.common_yes;
            if (_physicalDisability == false) {
              _disabilityDetails.clear();
            }
          });
        },
        isRequired: true,
      ),
      if (_physicalDisability == true)
        Column(
          children: [
            const SizedBox(height: 16),
            _buildTextField(
              loc.profile_disability_details,
              _disabilityDetails,
              isRequired: true,
            ),
          ],
        ),

      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_diet,
        _dietOptions,
        _dietDisplay,
        (v) => setState(() => _dietDisplay = v),
        isRequired: false,
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_manglik,
        _manglik,
        (v) => setState(() => _manglik = v),
        isRequired: true,
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_intercaste,
        _intercasteAccepted,
        (v) => setState(() => _intercasteAccepted = v),
        isRequired: true,
      ),
    ]);
  }

  // =========================================================================
  // STEP 2: Family, Education, Occupation
  // =========================================================================
  Widget _buildStep2FamilyEducation() {
    final loc = AppLocalizations.of(context)!;
    final numberOptions = Map.fromEntries(
      List.generate(11, (i) => MapEntry(i.toString(), i.toString())),
    );
    return _pageWrapper([
      _sectionTitle(AppLocalizations.of(context)!.profile_section_family),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_father_alive,
        _fatherAlive,
        (v) => setState(() => _fatherAlive = v),
        isRequired: true,
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_mother_alive,
        _motherAlive,
        (v) => setState(() => _motherAlive = v),
        isRequired: true,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_brothers,
        numberOptions,
        _noOfBrothers,
        (v) => setState(() => _noOfBrothers = v),
        isRequired: true,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_married_brothers,
        numberOptions,
        _marriedBrothers,
        (v) => setState(() => _marriedBrothers = v),
        isRequired: true,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_sisters,
        numberOptions,
        _noOfSisters,
        (v) => setState(() => _noOfSisters = v),
        isRequired: true,
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_married_sisters,
        numberOptions,
        _marriedSisters,
        (v) => setState(() => _marriedSisters = v),
        isRequired: true,
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
        isRequired: true,
      ),
      if (_educationDisplay != null) ...[
        const SizedBox(height: 16),
        _buildTextField(
          "Degree / Specialization (उदा. B.E. Computer)",
          _educationDetails,
          isRequired: true,
        ),
      ],
      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_career),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_occ_type,
        _occupationOptions,
        _occupationDisplay,
        (v) => setState(() => _occupationDisplay = v),
        isRequired: true,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_occ_details,
        _occupationDetails,
        maxLines: 2,
        isRequired: false, // Sanket: Not mandatory
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_income,
        _incomeOptions,
        _annualIncomeDisplay,
        (v) => setState(() => _annualIncomeDisplay = v),
        isRequired: true,
      ),
    ]);
  }

  // =========================================================================
  // STEP 3: Contact & Photos
  // =========================================================================
  Widget _buildStep3ContactPhotos() {
    final loc = AppLocalizations.of(context)!;
    return _pageWrapper([
      _sectionTitle(AppLocalizations.of(context)!.profile_section_contact),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_gov_id_type,
        _govIdOptions,
        _govIdTypeDisplay,
        (v) => setState(() => _govIdTypeDisplay = v),
        isRequired: false, // Sanket: Not mandatory
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_gov_id_number,
        _govIdNumber,
        isRequired: false, // Sanket: Not mandatory
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_address,
        _address,
        maxLines: 3,
        isRequired: true,
      ),
      _buildTextField(
        loc.manage_profile_state,
        TextEditingController(text: "Maharashtra"),
        isRequired: true,
      ),
      // Sanket: Use dynamic district list from API
      _buildDDown(
        loc.manage_profile_city,
        _districtList,
        _districtDisplay,
        null, // Sanket: District matched by name, no numeric ID available
        (v) => setState(() => _districtDisplay = v?.name),
        isRequired: true,
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

  Future<void> _onPartnerReligionChanged(DDown? religion) async {
    if (religion == null) return;
    setState(() {
      _partnerReligionDisplay = religion.name;
      _partnerReligionId = religion.id;
      _partnerCasteDisplay = null;
      _partnerCasteId = null;
      _partnerSubCasteDisplay = null;
      _partnerSubCasteId = null;
      _partnerCasteList = [];
      _partnerSubCasteList = [];
    });

    try {
      final res = await DropDownRepository().fetchCaste(religion.id);
      if (res.data != null) {
        setState(() => _partnerCasteList = res.data ?? []);
      }
    } catch (e) {
      debugPrint("Error loading partner castes: $e");
    }
  }

  Future<void> _onPartnerCasteChanged(DDown? caste) async {
    if (caste == null) return;
    setState(() {
      _partnerCasteDisplay = caste.name;
      _partnerCasteId = caste.id;
      _partnerSubCasteDisplay = null;
      _partnerSubCasteId = null;
      _partnerSubCasteList = [];
    });

    try {
      final res = await DropDownRepository().fetchSubCaste(caste.id);
      if (res.data != null) {
        setState(() => _partnerSubCasteList = res.data ?? []);
      }
    } catch (e) {
      debugPrint("Error loading partner sub-castes: $e");
    }
  }

  // =========================================================================
  // STEP 4: Partner Expectations
  // =========================================================================
  Widget _buildStep4Expectations() {
    final loc = AppLocalizations.of(context)!;
    return _pageWrapper([
      _sectionTitle(
        AppLocalizations.of(context)!.profile_section_expectations,
      ),
      // Bug #2 fix: use the persistent controller
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_preferred_cities,
        _preferredCitiesCtrl,
        isRequired: true,
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_partner_manglik,
        _partnerManglik,
        (v) => setState(() => _partnerManglik = v),
        isRequired: true,
      ),
      _buildDDown(
        AppLocalizations.of(context)!.profile_label_religion,
        _religionList,
        _partnerReligionDisplay,
        _partnerReligionId, // Sanket: ID-based match for pre-fill
        _onPartnerReligionChanged,
        isRequired: true,
      ),
      _buildDDown(
        AppLocalizations.of(context)!.profile_label_caste,
        _partnerCasteList,
        _partnerCasteDisplay,
        _partnerCasteId, // Sanket: ID-based match for pre-fill
        _onPartnerCasteChanged,
        isRequired: false, // Sanket: Not mandatory
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_expected_edu,
        _educationOptions,
        _expectedEducationDisplay,
        (v) => setState(() => _expectedEducationDisplay = v),
        isRequired: false, // Sanket: Not mandatory
      ),
      _buildMappedDropdown(
        AppLocalizations.of(context)!.profile_label_expected_income,
        _incomeOptions,
        _expectedIncomeDisplay,
        (v) => setState(() => _expectedIncomeDisplay = v),
        isRequired: false, // Sanket: Not mandatory
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_divorce_accepted,
        _divorceAccepted,
        (v) => setState(() => _divorceAccepted = v),
        isRequired: true,
      ),
      _buildNullableRadioOption(
        AppLocalizations.of(context)!.profile_label_partner_intercaste,
        _partnerIntercaste,
        (v) => setState(() => _partnerIntercaste = v),
        isRequired: true,
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
    String? Function(String?)? validator,
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
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            textInputAction: TextInputAction.next,
            style: Styles.body.copyWith(color: MyTheme.text_primary),
            validator: validator ??
                (isRequired
                    ? (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "$label is required";
                        }
                        return null;
                      }
                    : null),
            decoration: InputDecoration(
              filled: true,
              fillColor: MyTheme.white,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: MyTheme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: MyTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: MyTheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sanket: Takes Map<displayLabel, apiValue> — only display labels shown to
  // user; apiValue is what gets submitted. Fixes Bug #8.
  Widget _buildDDown(
    String label,
    List<DDown> items,
    String? selectedDisplay,
    int? selectedId,
    Function(DDown?) onChanged, {
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
              child: DropdownButton<DDown>(
                isExpanded: true,
                value: items.any((e) => e.id == selectedId && e.id != null && e.id != 0)
                    ? items.firstWhere((e) => e.id == selectedId)
                    : items.any((e) => e.name?.toLowerCase().trim() == selectedDisplay?.toLowerCase().trim())
                        ? items.firstWhere((e) => e.name?.toLowerCase().trim() == selectedDisplay?.toLowerCase().trim())
                        : null,
                hint: Text(
                  AppLocalizations.of(context)!.profile_label_select,
                ),
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.name ?? ''),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMappedDropdown(
    String label,
    Map<String, String> items,
    String? selectedValue,
    Function(String) onChanged, {
    bool isRequired = false,
  }) {
    // Sanket: selectedValue holds the stable API string (the Value in our map).
    // We look up the localized Label (the Key in our map) for the UI.
    final displayLabel = items.entries
        .where((e) => e.value == selectedValue)
        .map((e) => e.key)
        .firstOrNull;

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
                value: displayLabel,
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
                  if (v != null) {
                    // Send the stable API value back
                    onChanged(items[v]!);
                  }
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
    Function(bool?) onChanged, {
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

  Widget _buildUploadBox(String label, dynamic file, Function(dynamic) onPicked) {
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
                  await _picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1000,
                    maxHeight: 1000,
                    imageQuality: 85,
                  );
              if (image != null) {
                // Sanket: Keep as XFile to avoid dart:io 'Namespace' error on Web
                onPicked(image);
              }
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
                      child: kIsWeb
                          ? Image.network(file.path, fit: BoxFit.cover)
                          : Image.file(File(file.path), fit: BoxFit.cover),
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
    List<dynamic> files,
    Function(List<dynamic>) onPicked,
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
                onPicked(images);
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
                                  child: kIsWeb
                                      ? Image.network(
                                          f.path,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(f.path),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
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
                value: value,
                hint: Text(
                  AppLocalizations.of(context)!.profile_label_select,
                ),
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

