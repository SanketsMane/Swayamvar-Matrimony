import 'dart:io';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'verify_action.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        // Sanket: Removed logic that instantly pops if verificationInfo is true
        // allow user to see their status
      },
      builder: (_, state) {
        final v = state.userVerifyState!;
        
        // Define colors and icons based on status
        Color statusColor = MyTheme.app_accent_color;
        IconData statusIcon = Icons.info_outline;
        String statusText = "Pending Review";
        
        if (v.verificationStatus == 'approved') {
          statusColor = Colors.green;
          statusIcon = Icons.check_circle;
          statusText = "Approved";
        } else if (v.verificationStatus == 'rejected') {
          statusColor = Colors.red;
          statusIcon = Icons.cancel;
          statusText = "Rejected";
        } else if (v.verificationStatus == 'query') {
          statusColor = Colors.orange;
          statusIcon = Icons.help_outline;
          statusText = "Action Required";
        }

        return Scaffold(
          backgroundColor: MyTheme.background,
          appBar: _buildHeader(context, l),
          body: Column(
            children: [
              // Sanket: Status Banner
              if (v.verificationInfo == true || v.verificationStatus != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  color: statusColor.withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Sanket: Admin Message Banner
              if (v.adminMessage != null && v.adminMessage!.isNotEmpty && (v.verificationStatus == 'rejected' || v.verificationStatus == 'query'))
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: MyTheme.border)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Message from Admin:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyTheme.text_primary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        v.adminMessage!,
                        style: TextStyle(color: MyTheme.text_secondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),

              if (v.verificationStatus != 'approved' && v.verificationStatus != 'pending') ...[
                _buildProgressStepper(l),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    children: [
                      _buildStep1(state, l),
                      _buildStep2(state, l),
                      _buildStep3(state, l),
                    ],
                  ),
                ),
                _buildBottomNav(context, state, l),
              ] else if (v.verificationStatus == 'approved') ...[
                 Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified, size: 80, color: Colors.green),
                          SizedBox(height: 16),
                          Text(
                            "Your profile is fully verified!",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "You are now visible to other members.",
                            style: TextStyle(color: MyTheme.text_secondary),
                          ),
                        ],
                      ),
                    ),
                  )
              ] else if (v.verificationStatus == 'pending' || v.verificationInfo == true) ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty, size: 80, color: MyTheme.app_accent_color),
                          SizedBox(height: 16),
                          Text(
                            "Verification in Progress",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Our team is reviewing your documents.",
                            style: TextStyle(color: MyTheme.text_secondary),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context, AppLocalizations l) {
    return AppBar(
      backgroundColor: MyTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: MyTheme.text_primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        l.verify_title,
        style: const TextStyle(
          color: MyTheme.text_primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressStepper(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: MyTheme.white,
      child: Row(
        children: [
          _stepIndicator(1, l.verify_step_id, _currentPage >= 0),
          _stepLine(_currentPage >= 1),
          _stepIndicator(2, l.verify_step_selfie, _currentPage >= 1),
          _stepLine(_currentPage >= 2),
          _stepIndicator(3, l.verify_step_review, _currentPage >= 2),
        ],
      ),
    );
  }

  Widget _stepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: isActive ? MyTheme.primary : MyTheme.solitude,
            shape: BoxShape.circle,
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: MyTheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child:
                isActive && _currentPage > step - 1
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                      "$step",
                      style: TextStyle(
                        color: isActive ? Colors.white : MyTheme.text_secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? MyTheme.text_primary : MyTheme.text_secondary,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
        color: isActive ? MyTheme.primary : MyTheme.solitude,
      ),
    );
  }

  Widget _buildStep1(AppState state, AppLocalizations l) {
    final v = state.userVerifyState!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.verify_step_1_title),
          const SizedBox(height: 16),
          _buildGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.verify_select_id_type,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: v.idType,
                  decoration: _inputDecoration(),
                  items:
                      ["Aadhaar", "PAN Card", "Passport", "Voter ID"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (val) => store.dispatch(SetVerifyIdType(payload: val!)),
                ),
                const SizedBox(height: 20),
                Text(
                  l.verify_enter_id_number,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: v.idNumber,
                  decoration: _inputDecoration(hint: l.verify_id_hint),
                  onChanged:
                      (val) => store.dispatch(SetVerifyIdNumber(payload: val)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(l.verify_upload_id),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildUploadBox(
                  l.verify_front_side,
                  v.idFront,
                  'front',
                  l,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildUploadBox(l.verify_back_side, v.idBack, 'back', l),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(AppState state, AppLocalizations l) {
    final v = state.userVerifyState!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _sectionTitle(l.verify_step_2_title),
          const SizedBox(height: 16),
          _buildGlassCard(
            child: Column(
              children: [
                const Icon(Icons.face, size: 80, color: MyTheme.primary),
                const SizedBox(height: 16),
                Text(
                  l.verify_selfie_desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.verify_selfie_instruction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MyTheme.text_secondary,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => store.dispatch(pickVerifyImage('selfie')),
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: MyTheme.solitude,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: MyTheme.primary, width: 2),
                    ),
                    child:
                        v.selfie == null
                            ? const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: MyTheme.primary,
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(v.selfie!, fit: BoxFit.cover),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(AppState state, AppLocalizations l) {
    final v = state.userVerifyState!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.verify_step_3_title),
          const SizedBox(height: 16),
          _buildGlassCard(
            child: Column(
              children: [
                _reviewRow(l.verify_id_type_label, v.idType),
                _divider(),
                _reviewRow(l.verify_id_number_label, v.idNumber),
                _divider(),
                _reviewRow(
                  l.verify_documents_label,
                  v.idFront != null && v.selfie != null
                      ? l.verify_attached
                      : l.verify_missing,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l.verify_review_desc,
            style: const TextStyle(fontSize: 12, color: MyTheme.text_secondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(
    String label,
    File? file,
    String type,
    AppLocalizations l,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => store.dispatch(pickVerifyImage(type)),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MyTheme.border),
            ),
            child:
                file == null
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_a_photo_outlined,
                          color: MyTheme.primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.verify_upload,
                          style: const TextStyle(
                            fontSize: 10,
                            color: MyTheme.primary,
                          ),
                        ),
                      ],
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(file, fit: BoxFit.cover),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(
    BuildContext context,
    AppState state,
    AppLocalizations l,
  ) {
    final v = state.userVerifyState!;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).padding.bottom,
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
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevPage,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l.verify_back),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: !v.isSubmitting ? Styles.primaryGradient : null,
                borderRadius: BorderRadius.circular(12),
                color: !v.isSubmitting ? null : MyTheme.primary.withOpacity(0.5),
                boxShadow: !v.isSubmitting ? [
                  BoxShadow(
                    color: MyTheme.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: ElevatedButton(
                onPressed:
                    v.isSubmitting
                        ? null
                        : () {
                          if (_currentPage < 2) {
                            _nextPage();
                          } else {
                            store.dispatch(submitVerifyFormAction(context));
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child:
                    v.isSubmitting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          _currentPage == 2
                              ? l.verify_submit_for_review
                              : l.verify_next,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: MyTheme.text_primary,
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: MyTheme.solitude,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: MyTheme.text_secondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: MyTheme.solitude, height: 24);
  }
}
