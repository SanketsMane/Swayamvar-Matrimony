// Sanket: Public Profile screen — premium 2026 layout
import 'package:active_matrimonial_flutter_app/components/my_images.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/member_info/member_info.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest/express_interest_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/shortlist/add_shortlist_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/public_profile_middleware.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../others/report_dialog.dart';

class UserPublicProfile extends StatefulWidget {
  final int userId;

  const UserPublicProfile({super.key, required this.userId});

  @override
  State<UserPublicProfile> createState() => _UserPublicProfileState();
}

class _UserPublicProfileState extends State<UserPublicProfile> {
  final TextEditingController _reportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    // Sanket: Approval status does NOT gate app access — any registered user can view profiles.
    store.dispatch(Reset.publicProfile);
    store.dispatch(publicProfileMiddleware(userId: widget.userId));
    store.dispatch(Reset.memberInfo);
    store.dispatch(memberInfoMiddleware(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        if (state.publicProfileState!.isFetching! ||
            state.memberInfoState!.isFetching!) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: MyTheme.primary),
            ),
          );
        }

        final profile = state.publicProfileState!;
        final compatibility = "${profile.profilematch ?? 92}% Match";

        return Scaffold(
          backgroundColor: MyTheme.background,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // 1. Hero Image Section (420px)
                    _buildHeroSection(context, state, compatibility),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // 1. Basic Information
                          _buildBasicInfoSection(context, profile),
                          const SizedBox(height: 16),

                          // 2. Physical Details
                          _buildPhysicalDetailsSection(context, profile),
                          const SizedBox(height: 16),

                          // 3. Family Details
                          _buildFamilyDetailsSection(context, profile),
                          const SizedBox(height: 16),

                          // 4. Education & Career
                          _buildEducationCareerSection(context, profile),
                          const SizedBox(height: 16),

                          // 5. Lifestyle & Spiritual
                          _buildLifestyleSpiritualSection(context, profile),
                          const SizedBox(height: 16),

                          // 6. Contact & Location
                          _buildContactLocationSection(context, profile),
                          const SizedBox(height: 16),

                          // 7. Partner Expectations
                          _buildPartnerExpectationsSection(context, profile),
                          const SizedBox(height: 16),

                          // 8. Photo Gallery
                          _buildGallerySection(context, state),

                          const SizedBox(height: 160), // Space for sticky bars
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Sticky Action Buttons (Floating above Bottom Nav)
              _buildFloatingActions(context, state),

              // Sticky Bottom Navigation
              _buildBottomNav(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 64 + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: MyTheme.white,
          border: Border(top: BorderSide(color: MyTheme.border, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.explore_outlined, "मुख्य पान", false),
            _navItem(Icons.favorite_border, "शोधा", false),
            _navItem(Icons.chat_bubble_outline, "चॅट", false),
            _navItem(Icons.person_outline, "प्रोफाइल", false),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? MyTheme.primary : MyTheme.text_secondary,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? MyTheme.primary : MyTheme.text_secondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _circleActionBtn(
    IconData icon,
    VoidCallback onTap, {
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? MyTheme.text_primary, size: 20),
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    AppState state,
    String compatibility,
  ) {
    final basic = state.publicProfileState!.basic;

    return Stack(
      children: [
        // 420px Height Image
        Container(
          height: 420,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: MyImages.normalImage(basic?.photo, fit: BoxFit.cover),
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.2, 0.6, 1.0],
              ),
            ),
          ),
        ),

        // Back Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          child: _circleActionBtn(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.pop(context),
          ),
        ),

        // Shortlist (Heart) icon top-right
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 16,
          child: Row(
            children: [
              _circleActionBtn(
                (state.memberInfoState?.memberInfo?.shortlistStatus ?? 0) == 1
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                () => store.dispatch(addShortlistMiddleware(userId: widget.userId)),
                iconColor:
                    (state.memberInfoState?.memberInfo?.shortlistStatus ?? 0) == 1
                        ? MyTheme.primary
                        : MyTheme.text_primary,
              ),
              const SizedBox(width: 10),
              _circleActionBtn(
                Icons.more_vert_rounded,
                () {
                  showDialog(
                    context: context,
                    builder: (context) => ReportDialog(userId: widget.userId),
                  );
                },
              ),
            ],
          ),
        ),

        // Verified Badge overlay
        if (basic?.approved == 1)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: MyTheme.success.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    "पडताळणी केलेले",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Name, Age, Location & Compatibility Bottom Overlay
        Positioned(
          bottom: 24,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${basic?.firstName ?? ''} ${basic?.middleName ?? ''} ${basic?.lastName ?? ''}, ${basic?.age ?? ''}",
                style: Styles.profileName.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${state.publicProfileState!.presentAddress?.city ?? ''}, ${state.publicProfileState!.permanentAddress?.state ?? ''}",
                    style: Styles.body.copyWith(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Sanket: Removed Compatibility Match % overlay as requested
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // SECTION 1: Basic Information
  // =========================================================================
  Widget _buildBasicInfoSection(BuildContext context, dynamic profile) {
    final basic = profile.basic;
    if (basic == null) return const SizedBox.shrink();

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Basic Information"),
          const SizedBox(height: 8),
          _detailRow("First Name", basic.firstName),
          _detailRow("Middle Name", basic.middleName),
          _detailRow("Surname", basic.lastName),
          _detailRow("Date of Birth", basic.dateOfBirth != null ? DateFormat('dd-MM-yyyy').format(basic.dateOfBirth!) : null),
          _detailRow("Age", basic.age?.toString()),
          _detailRow("Religion", basic.religion),
          _detailRow("Caste", basic.caste),
          _detailRow("Sub-Caste", profile.spiritual?.subCaste),
          _detailRow("Marital Status", basic.maritialStatus),
          if (basic.maritialStatus != "Unmarried")
            _detailRow("Number of Children", basic.noOfChildren?.toString()),
          // Sanket: About Me is Step 1 Introduction
          if (basic.about != null && basic.about!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About Me", style: Styles.body.copyWith(fontWeight: FontWeight.bold, color: MyTheme.text_secondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(basic.about!, style: Styles.body.copyWith(color: MyTheme.text_primary, fontSize: 14, height: 1.5)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 2: Physical Details
  // =========================================================================
  Widget _buildPhysicalDetailsSection(BuildContext context, dynamic profile) {
    final physical = profile.physical;
    final basic = profile.basic; // Fallback for basic-info-mapped fields
    
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Physical Details"),
          const SizedBox(height: 8),
          _detailRow("Height", physical?.height?.toString() ?? basic?.height),
          _detailRow("Weight", physical?.weight?.toString() ?? basic?.weight),
          _detailRow("Blood Group", physical?.bloodGroup ?? basic?.bloodGroup),
          _detailRow("Complexion", physical?.complexion ?? basic?.complexion),
          _detailRow("Physical Disability", (physical?.physicalDisability == true || basic?.disability == 1) ? "Yes" : "No"),
          if (physical?.physicalDisability == true || basic?.disability == 1)
            _detailRow("Disability Details", physical?.disability ?? "N/A"),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 3: Family Details
  // =========================================================================
  Widget _buildFamilyDetailsSection(BuildContext context, dynamic profile) {
    final family = profile.family;
    if (family == null) return const SizedBox.shrink();

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Family Details"),
          const SizedBox(height: 8),
          _detailRow("Father Alive", family.father),
          _detailRow("Mother Alive", family.mother),
          _detailRow("Total Brothers", family.sibling?.toString().split(',').firstOrNull),
          _detailRow("Total Sisters", family.sibling?.toString().split(',').lastOrNull),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 4: Education & Career
  // =========================================================================
  Widget _buildEducationCareerSection(BuildContext context, dynamic profile) {
    final edu = profile.education is List && profile.education.isNotEmpty ? profile.education.first : null;
    final car = profile.career is List && profile.career.isNotEmpty ? profile.career.first : null;
    final basic = profile.basic;

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Education & Career"),
          const SizedBox(height: 8),
          _detailRow("Highest Education Level", edu?.degree),
          _detailRow("Education Details", edu?.institution),
          _detailRow("Occupation Type", car?.designation),
          _detailRow("Occupation Details", car?.company),
          _detailRow("Annual Income", car?.income ?? basic?.annualIncome),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 5: Lifestyle & Spiritual
  // =========================================================================
  Widget _buildLifestyleSpiritualSection(BuildContext context, dynamic profile) {
    final life = profile.lifeStyle;
    final spiritual = profile.spiritual;
    final basic = profile.basic;

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Lifestyle & Spiritual"),
          const SizedBox(height: 8),
          _detailRow("Diet", life?.diet ?? basic?.diet),
          _detailRow("Manglik Status", (spiritual?.manglik == 1 || basic?.manglik == 1) ? "Yes" : "No"),
          _detailRow("Intercaste Accepted", (spiritual?.intercasteAccepted == 1) ? "Yes" : "No"),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 6: Contact & Location
  // =========================================================================
  Widget _buildContactLocationSection(BuildContext context, dynamic profile) {
    final addr = profile.permanentAddress;
    final contact = profile.contactDetails;
    final basic = profile.basic;

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Contact & Location"),
          const SizedBox(height: 8),
          _detailRow("Permanent Address", addr?.postalCode),
          _detailRow("District", addr?.city),
          _detailRow("Mobile Number 1", contact?.phone ?? basic?.phone),
          _detailRow("Mobile Number 2", basic?.phone),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 7: Partner Expectations
  // =========================================================================
  Widget _buildPartnerExpectationsSection(BuildContext context, dynamic profile) {
    final partner = profile.partnerExpectation;
    if (partner == null) return const SizedBox.shrink();

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Partner Expectations"),
          const SizedBox(height: 8),
          _detailRow("Partner Religion", partner.religion),
          _detailRow("Partner Caste", partner.caste),
          _detailRow("Partner Sub-Caste", partner.subCaste),
          _detailRow("Minimum Expected Education", partner.expectedEducation),
          _detailRow("Minimum Expected Income", partner.expectedIncome),
          _detailRow("Preferred Cities", partner.general),
          _detailRow("Divorce Accepted", (partner.divorceAccepted == 1) ? "Yes" : "No"),
          _detailRow("Partner Manglik", (partner.partnerManglik == 1) ? "Yes" : "No"),
          _detailRow("Partner Intercaste Accepted", (partner.partnerIntercaste == 1) ? "Yes" : "No"),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context, AppState state) {
    final images = state.publicProfileState?.photogallery ?? [];
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l.pub_profile_gallery),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.isNotEmpty ? images.length : 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                decoration: BoxDecoration(
                  color: MyTheme.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      images.length > index
                          ? MyImages.normalImage(images[index].imagePath)
                          : Container(
                            color: MyTheme.border,
                            child: const Icon(
                              Icons.image,
                              color: MyTheme.text_secondary,
                            ),
                          ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActions(BuildContext context, AppState state) {
    return Positioned(
      bottom: 84 + MediaQuery.of(context).padding.bottom, // Above bottom nav
      left: 16,
      right: 16,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionPill(Icons.close_rounded, "नको", Colors.grey[400]!, () {}),
            _actionPill(
              Icons.star_border_rounded,
              "शॉर्टलिस्ट",
              Colors.orangeAccent,
              () {
                store.dispatch(addShortlistMiddleware(userId: widget.userId));
              },
            ),
            _actionPill(Icons.favorite_rounded, "आवडले", MyTheme.primary, () {
              store.dispatch(expressInterestMiddleware(userId: widget.userId));
            }, isPrimary: true),
            _actionPill(
              Icons.chat_bubble_outline_rounded,
              "चॅट",
              Colors.blueAccent,
              () {
                OneContext().push(
                  MaterialPageRoute(
                    builder:
                        (context) => Chat(
                          userId: widget.userId,
                          name: state.publicProfileState!.basic?.firstName,
                          picture: state.publicProfileState!.basic?.photo,
                          age: state.publicProfileState!.basic?.age?.toString(),
                          isVerified:
                              state.publicProfileState!.basic?.approved == 1,
                          phone: state.publicProfileState!.basic?.phone,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionPill(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: isPrimary ? color.withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: Styles.h2.copyWith(fontSize: 18, color: MyTheme.text_primary),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    if (value == null || value.toString().isEmpty || value.toString().toLowerCase() == 'null' || value.toString() == '0' || value.toString() == 'N/A') {
      return const SizedBox.shrink(); // Hide empty fields (Rule #2)
    }

    String safeValue = value.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Styles.regular_gull_grey_12.copyWith(fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              safeValue,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Styles.bold_arsenic_12.copyWith(
                fontSize: 14,
                color: MyTheme.text_primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
