// Sanket: Updated Filter screen — premium 2026 design system
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/caste_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/city_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/state_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/search_screens/search_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/search_screens/show_basic_search.dart';
import 'package:active_matrimonial_flutter_app/screens/search_screens/search_action.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({super.key});

  @override
  State<AdvancedSearch> createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  // Selection States
  RangeValues _ageRange = const RangeValues(21, 40);
  RangeValues _heightRange = const RangeValues(5.0, 6.2);
  
  List<String> _selectedQuickFilters = [];
  dynamic _religion_id;
  dynamic _marital_status_value;
  dynamic _country_value;
  dynamic _state_value;
  dynamic _city_value;
  dynamic _caste_value;
  dynamic _education_value;
  dynamic _income_value;
  
  bool _isManglik = false;
  bool _isIntercaste = false;
  bool _isDisabled = false;
  bool _hasPhoto = false;
  bool _recentlyJoined = false;

  @override
  void initState() {
    super.initState();
    final searchState = store.state.basicSearchState!;
    _ageRange = RangeValues(searchState.minAge ?? 21, searchState.maxAge ?? 40);
    _heightRange = RangeValues(searchState.minHeight ?? 5.0, searchState.maxHeight ?? 6.2);
    _selectedQuickFilters = List.from(searchState.quickFilters ?? []);
    
    // Map state to local variables (Fallback to SharedPrefs if app restarted)
    _religion_id = searchState.religion_value ?? SharedPref().advReligionId;
    _caste_value = searchState.caste_value ?? SharedPref().advCasteId;
    _marital_status_value = searchState.marital_status_value ?? SharedPref().advMaritalStatus;
    _country_value = searchState.country_value ?? SharedPref().advCountryId;
    _state_value = searchState.state_value ?? SharedPref().advStateId;
    _city_value = searchState.city_value ?? SharedPref().advCityId;
    _education_value = searchState.education;
    _income_value = searchState.income;
    _isManglik = searchState.isManglik ?? false;
    _isIntercaste = searchState.isIntercaste ?? false;
    _isDisabled = searchState.isDisabled ?? false;
    _hasPhoto = searchState.hasPhoto ?? false;
    _recentlyJoined = searchState.recentlyJoined ?? false;

    // Trigger dependent data fetching
    if (_religion_id != null && _religion_id is int) {
      store.dispatch(casteMiddleware(_religion_id));
    }
    if (_country_value != null && _country_value is int) {
      store.dispatch(stateMiddleware(_country_value, state: AppStates.advancedSearch));
    }
    if (_state_value != null && _state_value is int) {
      store.dispatch(cityMiddleware(_state_value, AppStates.advancedSearch));
    }
  }

  // Helper to resolve display name from ID
  String? _getNameById(List<dynamic>? list, dynamic id) {
    if (list == null || id == null) return null;
    return list.firstWhereOrNull((e) => e.id == id)?.name;
  }


  void _handleReset() {
    setState(() {
      _ageRange = const RangeValues(21, 40);
      _heightRange = const RangeValues(5.0, 6.2);
      _selectedQuickFilters = [];
      _religion_id = null;
      _marital_status_value = null;
      _country_value = null;
      _state_value = null;
      _city_value = null;
      _caste_value = null;
      _education_value = null;
      _income_value = null;
      _isManglik = false;
      _isIntercaste = false;
      _isDisabled = false;
      _hasPhoto = false;
      _recentlyJoined = false;
    });
    store.dispatch(SearchClearFiltersAction());
    
    // Clear persisted filters
    SharedPref().advReligionId = null;
    SharedPref().advCasteId = null;
    SharedPref().advMaritalStatus = null;
    SharedPref().advCountryId = null;
    SharedPref().advStateId = null;
    SharedPref().advCityId = null;
  }

  void _handleApply(AppState state) {
    store.dispatch(SearchSaveAdvancedFiltersAction(
      minAge: _ageRange.start,
      maxAge: _ageRange.end,
      religion: _religion_id,
      caste: _caste_value,
      maritalStatus: _marital_status_value,
      country: _country_value,
      state: _state_value,
      city: _city_value,
      quickFilters: _selectedQuickFilters,
      education: _education_value,
      income: _income_value,
      isManglik: _isManglik,
      isIntercaste: _isIntercaste,
      isDisabled: _isDisabled,
      hasPhoto: _hasPhoto,
      recentlyJoined: _recentlyJoined,
    ));

    // Save to SharedPreferences for app restart persistence
    SharedPref().advReligionId = _religion_id;
    SharedPref().advCasteId = _caste_value;
    SharedPref().advMaritalStatus = _marital_status_value;
    SharedPref().advCountryId = _country_value;
    SharedPref().advStateId = _state_value;
    SharedPref().advCityId = _city_value;

    store.dispatch(Reset.search);
    store.dispatch(
      searchMiddleware(
        age: _ageRange.start.round().toString(),
        to: _ageRange.end.round().toString(),
        religion: _religion_id,
        maritalStatus: _marital_status_value,
        caste: _caste_value,
        country: _country_value,
        state: _state_value,
        city: _city_value,
        minHeight: _heightRange.start.toString(),
        maxHeight: _heightRange.end.toString(),
        education: _education_value,
        income: _income_value,
        manglik: _isManglik ? 1 : 0,
        intercaste: _isIntercaste ? 1 : 0,
        disability: _isDisabled ? 1 : 0,
        withPhoto: _hasPhoto ? 1 : 0,
        recentlyJoined: _recentlyJoined ? 1 : 0,
        memberType: _selectedQuickFilters.contains("Premium Members") ? 1 : 2,
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.common_success_msg ?? "Filters applied successfully"),
        backgroundColor: MyTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return Scaffold(
          backgroundColor: MyTheme.background,
          appBar: _buildHeader(context),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSectionHeader("मूळ माहिती (Basic Info)"),
                    _buildBasicFilters(context, state),
                    const SizedBox(height: 16),
                    
                    _buildSectionHeader("श्रेणी (Ranges)"),
                    _buildAgeRange(context),
                    const SizedBox(height: 16),
                    _buildHeightRange(context),
                    const SizedBox(height: 16),
                    
                    _buildSectionHeader("शिक्षण आणि उत्पन्न (Education & Income)"),
                    _buildEduIncomeSection(context),
                    const SizedBox(height: 16),
                    
                    _buildSectionHeader("इतर निवडी (Other Preferences)"),
                    _buildCheckboxSection(context),
                    const SizedBox(height: 100), // Space for sticky button
                  ],
                ),
              ),
              _buildStickyApplyButton(context, state),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: MyTheme.text_primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "फिल्टर्स (शोध)", 
        style: Styles.h2.copyWith(color: MyTheme.text_primary, fontSize: 18)
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _handleReset,
          child: Text(
            "रिसेट करा", 
            style: Styles.body.copyWith(color: MyTheme.primary, fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Container(width: 4, height: 16, decoration: BoxDecoration(color: MyTheme.primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(title, style: Styles.body.copyWith(color: MyTheme.text_primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBasicFilters(BuildContext context, AppState state) {
    final manageData = state.manageProfileCombineState?.profiledropdownResponseData?.data;
    return _filterCard(
      child: Column(
        children: [
          // Marital Status
          _dropdownInput(
            context,
            AppLocalizations.of(context)!.filter_marital_status, 
            _marital_status_value, [
              "Never Married", "Divorced", "Widow / Widower", "Separated"
            ], 
            (val) => setState(() => _marital_status_value = val)
          ),
          const SizedBox(height: 12),
          
          // Religion
          _dropdownWithId(
            context,
            AppLocalizations.of(context)!.filter_religion, 
            _religion_id, 
            manageData?.religionList ?? [], 
            (id) {
              setState(() {
                _religion_id = id;
                _caste_value = null;
              });
              store.dispatch(casteMiddleware(id));
            }
          ),
          const SizedBox(height: 12),

          // Caste
          _dropdownWithId(
            context,
            AppLocalizations.of(context)!.filter_caste, 
            _caste_value, 
            state.basicSearchState?.casteResponse?.data ?? [], 
            (id) => setState(() => _caste_value = id)
          ),
          const SizedBox(height: 12),

          // Country (added for flow)
          _dropdownWithId(
            context,
            AppLocalizations.of(context)!.advanced_search_screen_country, 
            _country_value, 
            state.commonState?.countries ?? [], 
            (id) {
              setState(() {
                _country_value = id;
                _state_value = null;
                _city_value = null;
              });
              store.dispatch(stateMiddleware(id, state: AppStates.advancedSearch));
            }
          ),
          const SizedBox(height: 12),

          // State
          _dropdownWithId(
            context,
            AppLocalizations.of(context)!.advanced_search_screen_state, 
            _state_value, 
            state.basicSearchState?.stateResponse?.data ?? [], 
            (id) {
              setState(() {
                _state_value = id;
                _city_value = null;
              });
              store.dispatch(cityMiddleware(id, AppStates.advancedSearch));
            }
          ),
          const SizedBox(height: 12),

          // City
          _dropdownWithId(
            context,
            AppLocalizations.of(context)!.filter_city, 
            _city_value, 
            state.basicSearchState?.cityResponse?.data ?? [], 
            (id) => setState(() => _city_value = id)
          ),
        ],
      ),
    );
  }

  Widget _buildAgeRange(BuildContext context) {
    return _filterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.filter_age_range, style: Styles.body.copyWith(fontWeight: FontWeight.w600)),
              Text("${_ageRange.start.round()} - ${_ageRange.end.round()} वर्षे", style: Styles.body.copyWith(color: MyTheme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 60,
            activeColor: MyTheme.primary,
            inactiveColor: MyTheme.solitude,
            onChanged: (val) => setState(() => _ageRange = val),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightRange(BuildContext context) {
    return _filterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("उंचीची श्रेणी", style: Styles.body.copyWith(fontWeight: FontWeight.w600)),
              Text("${_heightRange.start.toStringAsFixed(1)} - ${_heightRange.end.toStringAsFixed(1)} फूट", style: Styles.body.copyWith(color: MyTheme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          RangeSlider(
            values: _heightRange,
            min: 4.0,
            max: 7.5,
            divisions: 35,
            activeColor: MyTheme.primary,
            inactiveColor: MyTheme.solitude,
            onChanged: (val) => setState(() => _heightRange = val),
          ),
        ],
      ),
    );
  }

  Widget _buildEduIncomeSection(BuildContext context) {
    return _filterCard(
      child: Column(
        children: [
          _dropdownInput(
            context,
            AppLocalizations.of(context)!.filter_education, 
            _education_value, [
              "१०वी", "१२वी", "ITI", "डिप्लोमा", "पदवीधर", "पदव्युत्तर", "PhD"
            ], 
            (val) => setState(() => _education_value = val)
          ),
          const SizedBox(height: 12),
          _dropdownInput(
            context,
            AppLocalizations.of(context)!.filter_income, 
            _income_value, [
              "० – २ लाख", "२ – ५ लाख", "५ – १० लाख", "१०+ लाख"
            ], 
            (val) => setState(() => _income_value = val)
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxSection(BuildContext context) {
    return _filterCard(
      child: Column(
        children: [
          _checkboxRow(AppLocalizations.of(context)!.filter_manglik, _isManglik, (val) => setState(() => _isManglik = val!)),
          const Divider(height: 24),
          _checkboxRow(AppLocalizations.of(context)!.filter_intercaste, _isIntercaste, (val) => setState(() => _isIntercaste = val!)),
          const Divider(height: 24),
          _checkboxRow(AppLocalizations.of(context)!.filter_disability, _isDisabled, (val) => setState(() => _isDisabled = val!)),
          const Divider(height: 24),
          _checkboxRow("प्रोफाइल फोटो आवश्यक (Must have Photo)", _hasPhoto, (val) => setState(() => _hasPhoto = val!)),
          const Divider(height: 24),
          _checkboxRow("अलीकडेच सामील झालेले (Recently Joined)", _recentlyJoined, (val) => setState(() => _recentlyJoined = val!)),
        ],
      ),
    );
  }

  Widget _checkboxRow(String title, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(title, style: Styles.body.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: MyTheme.primary,
        ),
      ],
    );
  }

  Widget _buildStickyApplyButton(BuildContext context, AppState state) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyTheme.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: ElevatedButton(
          onPressed: () => _handleApply(state),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyTheme.primary,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            AppLocalizations.of(context)!.filter_apply, 
            style: Styles.buttonText.copyWith(color: Colors.white, fontSize: 16)
          ),
        ),
      ),
    );
  }

  Widget _filterCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _dropdownWithId(BuildContext context, String label, dynamic selectedId, List<dynamic> items, Function(dynamic) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Styles.caption.copyWith(fontSize: 12, color: MyTheme.text_secondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: MyTheme.solitude, borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              isExpanded: true,
              value: (items.any((e) => e.id == selectedId)) ? selectedId : null,
              hint: Text("निवडा", style: Styles.body.copyWith(fontSize: 14, color: MyTheme.text_secondary)),
              items: items.map((item) {
                return DropdownMenuItem<dynamic>(
                  value: item.id, 
                  child: Text(item.name ?? "", style: Styles.body.copyWith(fontSize: 14))
                );
              }).toList(),
              onChanged: (val) { if (val != null) onChanged(val); },
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownInput(BuildContext context, String label, dynamic value, List<String> items, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: MyTheme.text_secondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: MyTheme.solitude, borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: (items.contains(value)) ? value : null,
              hint: Text(AppLocalizations.of(context)!.filter_select ?? "Select"),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item, style: Styles.body.copyWith(fontSize: 14)));
              }).toList(),
              onChanged: (val) { if (val != null) onChanged(val); },
            ),
          ),
        ),
      ],
    );
  }
}
