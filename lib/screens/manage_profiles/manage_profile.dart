import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/helpers/main_helpers.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:active_matrimonial_flutter_app/repository/manage_profile_repository.dart';

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

  // ==== STEP 1: Basic & Physical ====
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  DateTime? _dob;
  int? _computedAge;
  String? _religion;
  String? _caste;
  String? _maritalStatus;

  String? _height;
  final TextEditingController _weight = TextEditingController();
  String? _bloodGroup;
  String? _complexion;
  bool _physicalDisability = false;
  final TextEditingController _disabilityDetails = TextEditingController();
  String? _diet;
  bool _manglik = false;
  bool _intercasteAccepted = false;

  // ==== STEP 2: Family, Education, Occupation ====
  bool _fatherAlive = true;
  bool _motherAlive = true;
  String? _noOfBrothers;
  String? _marriedBrothers;
  String? _noOfSisters;
  String? _marriedSisters;
  final TextEditingController _parentsOccupation = TextEditingController();
  final TextEditingController _propertyDetails = TextEditingController();

  String? _educationLevel;

  String? _occupationType;
  final TextEditingController _occupationDetails = TextEditingController();
  String? _annualIncome;

  // ==== STEP 3: Contact & Photos ====
  String? _govIdType;
  final TextEditingController _govIdNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  String? _city;
  final TextEditingController _mobile1 = TextEditingController();
  final TextEditingController _mobile2 = TextEditingController();

  File? _profilePhoto;
  List<File> _otherPhotos = [];
  File? _idProof;

  // ==== STEP 4: Partner Expectations ====
  List<String> _preferredCities = [];
  bool _partnerManglik = false;
  String? _expectedEducation;
  String? _expectedIncome;
  bool _divorceAccepted = false;
  bool _partnerIntercaste = false;

  final ImagePicker _picker = ImagePicker();

  void _nextStep() {
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
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool _isSubmitting = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _pageController = PageController(initialPage: widget.initialStep);
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final repo = ManageProfileRepository();
      var basicRes = await repo.fetchBasicInfo();
      var phyRes = await repo.fetchPhysicalAttribute();
      var conRes = await repo.fetchContact();

      if (mounted) {
        setState(() {
          if (basicRes.result == true && basicRes.data != null) {
            _firstName.text = basicRes.data!.firsName ?? '';
            _surname.text = basicRes.data!.lastName ?? '';
            if (basicRes.data!.dateOfBirth != null) {
              try {
                _dob = basicRes.data!.dateOfBirth;
                if (_dob != null) {
                  _computedAge = DateTime.now().year - _dob!.year;
                }
              } catch (e) {}
            }
          }

          if (phyRes.result == true && phyRes.data != null) {
            _weight.text = phyRes.data!.weight?.toString() ?? '';
            _disabilityDetails.text = phyRes.data!.disability ?? '';
          }

          if (conRes.result == true &&
              conRes.data != null &&
              conRes.data!.email != null) {
            // Contact get response API doesn't hold phone, only email
          }

          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingData = false);
      debugPrint("Error loading profile data: ${e.toString()}");
    }
  }

  void _submitForm() async {
    setState(() => _isSubmitting = true);

    var baseUrl = "${AppConfig.BASE_URL}/member/profile-wizard/update";
    var accessToken = getToken;

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken",
    });

    // Step 1
    if (_firstName.text.isNotEmpty)
      request.fields['first_name'] = _firstName.text;
    if (_middleName.text.isNotEmpty)
      request.fields['middle_name'] = _middleName.text;
    if (_surname.text.isNotEmpty) request.fields['surname'] = _surname.text;
    if (_dob != null)
      request.fields['dob'] = DateFormat('yyyy-MM-dd').format(_dob!);
    if (_religion != null) request.fields['religion'] = _religion!;
    if (_caste != null) request.fields['caste'] = _caste!;
    if (_maritalStatus != null)
      request.fields['marital_status'] = _maritalStatus!;
    if (_height != null)
      request.fields['height'] = _height!.replaceAll(" ft", "");
    if (_weight.text.isNotEmpty) request.fields['weight'] = _weight.text;
    if (_bloodGroup != null) request.fields['blood_group'] = _bloodGroup!;
    if (_complexion != null) request.fields['complexion'] = _complexion!;
    request.fields['physical_disability'] = _physicalDisability ? "1" : "0";
    if (_disabilityDetails.text.isNotEmpty)
      request.fields['disability_details'] = _disabilityDetails.text;
    if (_diet != null) request.fields['diet'] = _diet!;
    request.fields['manglik'] = _manglik ? "1" : "0";
    request.fields['intercaste_accepted'] = _intercasteAccepted ? "1" : "0";

    // Step 2
    request.fields['father_alive'] = _fatherAlive ? "1" : "0";
    request.fields['mother_alive'] = _motherAlive ? "1" : "0";
    if (_noOfBrothers != null)
      request.fields['no_of_brothers'] = _noOfBrothers!;
    if (_marriedBrothers != null)
      request.fields['married_brothers'] = _marriedBrothers!;
    if (_noOfSisters != null) request.fields['no_of_sisters'] = _noOfSisters!;
    if (_marriedSisters != null)
      request.fields['married_sisters'] = _marriedSisters!;
    if (_parentsOccupation.text.isNotEmpty)
      request.fields['parents_occupation'] = _parentsOccupation.text;
    if (_propertyDetails.text.isNotEmpty)
      request.fields['property_details'] = _propertyDetails.text;
    if (_educationLevel != null)
      request.fields['education_level'] = _educationLevel!;
    if (_occupationType != null)
      request.fields['occupation_type'] = _occupationType!;
    if (_occupationDetails.text.isNotEmpty)
      request.fields['occupation_details'] = _occupationDetails.text;
    if (_annualIncome != null) request.fields['annual_income'] = _annualIncome!;

    // Step 3
    if (_govIdType != null) request.fields['gov_id_type'] = _govIdType!;
    if (_govIdNumber.text.isNotEmpty)
      request.fields['gov_id_number'] = _govIdNumber.text;
    if (_address.text.isNotEmpty) request.fields['address'] = _address.text;
    if (_city != null) request.fields['city'] = _city!;
    if (_mobile1.text.isNotEmpty) request.fields['mobile1'] = _mobile1.text;
    if (_mobile2.text.isNotEmpty) request.fields['mobile2'] = _mobile2.text;

    // Step 4
    if (_expectedEducation != null)
      request.fields['expected_education'] = _expectedEducation!;
    if (_expectedIncome != null)
      request.fields['expected_income'] = _expectedIncome!;
    request.fields['partner_manglik'] = _partnerManglik ? "1" : "0";
    request.fields['divorce_accepted'] = _divorceAccepted ? "1" : "0";
    request.fields['partner_intercaste'] = _partnerIntercaste ? "1" : "0";

    // Files
    if (_profilePhoto != null && !kIsWeb) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_photo', _profilePhoto!.path),
      );
    }
    if (_idProof != null && !kIsWeb) {
      request.files.add(
        await http.MultipartFile.fromPath('id_proof', _idProof!.path),
      );
    }

    if (_otherPhotos.isNotEmpty && !kIsWeb) {
      for (var file in _otherPhotos) {
        request.files.add(
          await http.MultipartFile.fromPath('other_photos[]', file.path),
        );
      }
    }

    try {
      var response = await request.send();
      setState(() => _isSubmitting = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profile_saved_ok),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profile_saved_fail),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.profile_save_error),
        ),
      );
    }
  }

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
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (idx) => setState(() => _currentStep = idx),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        16,
        16,
        16,
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
              child:
                  _isSubmitting
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
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_middle_name,
        _middleName,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_last_name,
        _surname,
      ),
      _buildDatePicker(AppLocalizations.of(context)!.profile_label_dob, _dob, (
        date,
      ) {
        setState(() {
          _dob = date;
          _computedAge = DateTime.now().year - date.year;
        });
      }),
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
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_religion,
        _religion,
        ["हिंदू", "मुस्लिम", "ख्रिश्चन", "शीख", "जैन", "बौद्ध"],
        (v) => setState(() => _religion = v),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_caste,
        _caste,
        ["मराठा", "ब्राह्मण", "कुणबी", "धनगर", "माळी", "चांभार", "महार"],
        (v) => setState(() => _caste = v),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_marital_status,
        _maritalStatus,
        ["अविवाहित", "घटस्फोटित पुरुष", "घटस्फोटित महिला", "विधवा", "विधुर"],
        (v) => setState(() => _maritalStatus = v),
      ),

      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_physical),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_height,
        _height,
        [
          "4.5 ft",
          "5.0 ft",
          "5.2 ft",
          "5.5 ft",
          "5.8 ft",
          "6.0 ft",
          "6.2 ft",
          "6.5 ft",
        ],
        (v) => setState(() => _height = v),
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_weight,
        _weight,
        isNumber: true,
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_blood_group,
        _bloodGroup,
        ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
        (v) => setState(() => _bloodGroup = v),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_complexion,
        _complexion,
        ["Fair", "Medium", "Wheatish", "Dark"],
        (v) => setState(() => _complexion = v),
      ),

      _buildRadioOption(
        AppLocalizations.of(context)!.profile_label_disability,
        _physicalDisability,
        (v) => setState(() => _physicalDisability = v!),
      ),
      if (_physicalDisability)
        _buildTextField(
          AppLocalizations.of(context)!.profile_label_disability_details,
          _disabilityDetails,
        ),

      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_diet,
        _diet,
        ["Veg", "Non Veg"],
        (v) => setState(() => _diet = v),
      ),
      _buildRadioOption(
        AppLocalizations.of(context)!.profile_label_manglik,
        _manglik,
        (v) => setState(() => _manglik = v!),
      ),
      _buildRadioOption(
        AppLocalizations.of(context)!.profile_label_intercaste,
        _intercasteAccepted,
        (v) => setState(() => _intercasteAccepted = v!),
      ),
    ]);
  }

  // =========================================================================
  // STEP 2: Family, Education, Occupation
  // =========================================================================
  Widget _buildStep2FamilyEducation() {
    List<String> numberOptions = List.generate(11, (i) => i.toString());
    return _pageWrapper([
      _sectionTitle(AppLocalizations.of(context)!.profile_section_family),
      _buildRadioOption(
        AppLocalizations.of(context)!.profile_label_father_alive,
        _fatherAlive,
        (v) => setState(() => _fatherAlive = v!),
      ),
      _buildRadioOption(
        AppLocalizations.of(context)!.profile_label_mother_alive,
        _motherAlive,
        (v) => setState(() => _motherAlive = v!),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_brothers,
        _noOfBrothers,
        numberOptions,
        (v) => setState(() => _noOfBrothers = v),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_married_brothers,
        _marriedBrothers,
        numberOptions,
        (v) => setState(() => _marriedBrothers = v),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_sisters,
        _noOfSisters,
        numberOptions,
        (v) => setState(() => _noOfSisters = v),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_married_sisters,
        _marriedSisters,
        numberOptions,
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
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_education_level,
        _educationLevel,
        ["१०वी", "१२वी", "ITI", "डिप्लोमा", "पदवीधर", "पदव्युत्तर", "PhD"],
        (v) => setState(() => _educationLevel = v),
      ),

      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_career),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_occ_type,
        _occupationType,
        ["विद्यार्थी", "खाजगी नोकरी", "सरकारी नोकरी", "व्यवसाय", "शेतकरी"],
        (v) => setState(() => _occupationType = v),
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_occ_details,
        _occupationDetails,
        maxLines: 2,
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_income,
        _annualIncome,
        ["०–२ लाख", "२–५ लाख", "५–१० लाख", "१०+ लाख"],
        (v) => setState(() => _annualIncome = v),
      ),
    ]);
  }

  // =========================================================================
  // STEP 3: Contact & Photos
  // =========================================================================
  Widget _buildStep3ContactPhotos() {
    return _pageWrapper([
      _sectionTitle(AppLocalizations.of(context)!.profile_section_contact),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_gov_id_type,
        _govIdType,
        ["Aadhaar", "PAN", "Driving License", "Passport", "Voter ID"],
        (v) => setState(() => _govIdType = v),
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
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_city,
        _city,
        ["Pune", "Mumbai", "Nagpur", "Nashik", "Aurangabad", "Solapur"],
        (v) => setState(() => _city = v),
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_mobile1,
        _mobile1,
        isNumber: true,
      ),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_mobile2,
        _mobile2,
        isNumber: true,
      ),

      const SizedBox(height: 16),
      _sectionTitle(AppLocalizations.of(context)!.profile_section_photos),
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
      // Handle Multiple photos ideally with a grid, but for UI mockup:
      _buildMultiUploadBox(
        AppLocalizations.of(context)!.profile_label_other_photos,
        _otherPhotos,
        (files) => setState(() => _otherPhotos = files),
      ),
    ]);
  }

  // =========================================================================
  // STEP 4: Partner Expectations
  // =========================================================================
  Widget _buildStep4Expectations() {
    return _pageWrapper([
      _sectionTitle(AppLocalizations.of(context)!.profile_section_expectations),
      _buildTextField(
        AppLocalizations.of(context)!.profile_label_preferred_cities,
        TextEditingController(text: _preferredCities.join(", ")),
      ),
      _buildRadioOption(
        AppLocalizations.of(context)!.profile_label_partner_manglik,
        _partnerManglik,
        (v) => setState(() => _partnerManglik = v!),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_expected_edu,
        _expectedEducation,
        ["10th", "12th", "Diploma", "Graduate", "Post Graduate", "PhD"],
        (v) => setState(() => _expectedEducation = v),
      ),
      _buildDropdown(
        AppLocalizations.of(context)!.profile_label_expected_income,
        _expectedIncome,
        ["0–2 Lakh", "2–5 Lakh", "5–10 Lakh", "10+ Lakh"],
        (v) => setState(() => _expectedIncome = v),
      ),
      _buildRadioOption(
        AppLocalizations.of(context)!.profile_label_divorce_accepted,
        _divorceAccepted,
        (v) => setState(() => _divorceAccepted = v!),
      ),
      _buildRadioOption(
        AppLocalizations.of(context)!.profile_label_partner_intercaste,
        _partnerIntercaste,
        (v) => setState(() => _partnerIntercaste = v!),
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
  }) {
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

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String) onChanged,
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
                hint: Text(AppLocalizations.of(context)!.profile_label_select),
                items:
                    items
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
    Function(DateTime) onPicked,
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
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime(1995),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
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
                      color:
                          date != null
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

  Widget _buildRadioOption(
    String label,
    bool value,
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
              final XFile? image = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) onPicked(File(image.path));
            },
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyTheme.solitude,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: MyTheme.border,
                  style: BorderStyle.solid,
                ),
              ),
              child:
                  file != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            kIsWeb
                                ? Image.network(file.path, fit: BoxFit.cover)
                                : Image.file(file, fit: BoxFit.cover),
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
                            AppLocalizations.of(
                              context,
                            )!.profile_label_upload_tap,
                            style: const TextStyle(
                              color: MyTheme.text_secondary,
                            ),
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
              if (images.isNotEmpty)
                onPicked(images.map((e) => File(e.path)).toList());
            },
            child: Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyTheme.solitude,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: MyTheme.border,
                  style: BorderStyle.solid,
                ),
              ),
              child:
                  files.isNotEmpty
                      ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              files
                                  .map(
                                    (f) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child:
                                            kIsWeb
                                                ? Image.network(
                                                  f.path,
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                )
                                                : Image.file(
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
                            AppLocalizations.of(
                              context,
                            )!.profile_label_upload_multi_tap,
                            style: const TextStyle(
                              color: MyTheme.text_secondary,
                            ),
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
