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
import 'package:active_matrimonial_flutter_app/models_response/public_profile_response.dart';
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
                          // 2. Basic Info Card
                          _buildBasicInfoCard(context, profile),
                          const SizedBox(height: 16),

                          // 3. About Section
                          _buildAboutSection(context, profile),
                          const SizedBox(height: 16),

                          // 4. Personal Details
                          _buildPersonalDetails(context, profile),
                          const SizedBox(height: 16),

                          // 5. Professional Details
                          _buildProfessionalDetails(context, profile),
                          const SizedBox(height: 16),

                          // 6. Physical Attributes (NEW)
                          _buildPhysicalAttributes(context, profile),
                          const SizedBox(height: 16),

                          // 7. Spiritual & Social (NEW)
                          _buildSpiritualBackground(context, profile),
                          const SizedBox(height: 16),

                          // 8. Lifestyle (NEW)
                          _buildLifestyle(context, profile),
                          const SizedBox(height: 16),

                          // 9. Family Details
                          _buildFamilyDetails(context, profile),
                          const SizedBox(height: 16),

                          // 10. Partner Expectations (NEW)
                          _buildPartnerExpectations(context, profile),
                          const SizedBox(height: 16),

                          // 11. Gallery Section
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
                "${basic?.firsName ?? ''}, ${state.publicProfileState!.basic?.age ?? ''}",
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
                    "ठाणे, महाराष्ट्र", // Localized mock
                    style: Styles.body.copyWith(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: MyTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$compatibility जुळते",
                  style: Styles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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

  Widget _buildBasicInfoCard(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_basic_info),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3.5,
            children: [
              _infoTile(
                l.pub_profile_religion,
                profile.spiritual?.religionId ?? "-",
              ),
              _infoTile(
                l.pub_profile_height,
                "${profile.physical?.height ?? '-'}'",
              ),
              _infoTile(
                l.pub_profile_marital_status,
                profile.basic?.maritialStatus ?? "-",
              ),
              _infoTile(
                l.pub_profile_mother_tongue,
                profile.motherTongue?.name ?? "-",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_about),
          const SizedBox(height: 12),
          Text(
            profile.introduction?.introduction ?? "-",
            style: Styles.regular_gull_grey_12.copyWith(
              fontSize: 14,
              height: 1.5,
              color: MyTheme.text_primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetails(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_personal),
          const SizedBox(height: 8),
          _detailRow(
            l.pub_profile_age,
            "${profile.basic?.age ?? '-'} ${l.pub_profile_age_years}",
          ),
          _detailRow(
            l.pub_profile_religion,
            profile.spiritual?.religionId ?? "-",
          ),
          _detailRow(l.pub_profile_caste, profile.spiritual?.casteId ?? "-"),
          _detailRow(
            l.pub_profile_mother_tongue,
            profile.motherTongue?.name ?? "-",
          ),
          _detailRow(
            l.pub_profile_education,
            (profile.education is List && profile.education.isNotEmpty)
                ? profile.education.first.degree
                : "-",
          ),
          _detailRow(
            l.pub_profile_location,
            profile.presentAddress?.city ?? "-",
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalDetails(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_professional),
          const SizedBox(height: 8),
          _detailRow(
            l.pub_profile_designation,
            (profile.career is List && profile.career.isNotEmpty)
                ? profile.career.first.designation
                : "-",
          ),
          _detailRow(
            l.pub_profile_company,
            (profile.career is List && profile.career.isNotEmpty)
                ? profile.career.first.company
                : "-",
          ),
          _detailRow(
            l.pub_profile_income,
            (profile.career is List && profile.career.isNotEmpty)
                ? profile.career.first.income
                : "-",
          ),
        ],
      ),
    );
  }

  // Sanket: Physical Attributes Card (NEW)
  Widget _buildPhysicalAttributes(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    final PhysicalAttributes? physical =
        profile.physical is PhysicalAttributes ? profile.physical : null;

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_physical),
          const SizedBox(height: 8),
          _detailRow(l.pub_profile_height, "${physical?.height ?? '-'}"),
          _detailRow(l.pub_profile_weight, "${physical?.weight ?? '-'} kg"),
          _detailRow(l.pub_profile_blood_group, physical?.bloodGroup ?? "-"),
          _detailRow(l.pub_profile_complexion, physical?.complexion ?? "-"),
          _detailRow(
            l.pub_profile_disability,
            (physical?.physicalDisability ?? false)
                ? l.profile_yes
                : l.profile_no,
          ),
        ],
      ),
    );
  }

  // Sanket: Spiritual & Social Card (NEW)
  Widget _buildSpiritualBackground(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    final SpiritualBackgrounds? spiritual =
        profile.spiritual is SpiritualBackgrounds ? profile.spiritual : null;

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_spiritual),
          const SizedBox(height: 8),
          _detailRow(l.pub_profile_religion, spiritual?.religionId ?? "-"),
          _detailRow(l.pub_profile_caste, spiritual?.casteId ?? "-"),
          _detailRow(
            l.pub_profile_manglik,
            (spiritual?.manglik ?? false) ? l.profile_yes : l.profile_no,
          ),
          _detailRow(
            l.pub_profile_intercaste,
            (spiritual?.intercasteAccepted ?? false)
                ? l.profile_yes
                : l.profile_no,
          ),
        ],
      ),
    );
  }

  // Sanket: Lifestyle Card (NEW)
  Widget _buildLifestyle(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_lifestyle),
          const SizedBox(height: 8),
          _detailRow(l.pub_profile_diet, profile.lifeStyle?.diet ?? "-"),
          _detailRow(l.pub_profile_drink, profile.lifeStyle?.drink ?? "-"),
          _detailRow(l.pub_profile_smoke, profile.lifeStyle?.smoke ?? "-"),
        ],
      ),
    );
  }

  Widget _buildFamilyDetails(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_family),
          const SizedBox(height: 8),
          _detailRow(l.pub_profile_father, profile.family?.father ?? "-"),
          _detailRow(l.pub_profile_mother, profile.family?.mother ?? "-"),
          _detailRow(l.pub_profile_brothers, profile.family?.sibling ?? "-"),
        ],
      ),
    );
  }

  // Sanket: Partner Expectations Card (NEW)
  Widget _buildPartnerExpectations(BuildContext context, dynamic profile) {
    final l = AppLocalizations.of(context)!;
    final PartnerExpectation? partner =
        profile.partnerExpectation is PartnerExpectation
            ? profile.partnerExpectation
            : null;

    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l.pub_profile_partner_exp),
          const SizedBox(height: 8),
          _detailRow(l.pub_profile_pref_edu, partner?.expectedEducation ?? "-"),
          _detailRow(l.pub_profile_pref_income, partner?.expectedIncome ?? "-"),
          _detailRow(l.pub_profile_pref_cities, partner?.preferredCity ?? "-"),
          _detailRow(
            l.pub_profile_pref_divorce,
            (partner?.divorceAccepted ?? false) ? l.profile_yes : l.profile_no,
          ),
          _detailRow(
            l.pub_profile_manglik,
            (partner?.partnerManglik ?? false) ? l.profile_yes : l.profile_no,
          ),
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
                          name: state.publicProfileState!.basic?.firsName,
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

  Widget _infoTile(String label, dynamic value) {
    String safeValue = (value == null || value.toString().isEmpty || value.toString() == 'null') ? "-" : value.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Styles.regular_gull_grey_12.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(safeValue, style: Styles.bold_arsenic_12.copyWith(fontSize: 14)),
      ],
    );
  }

  Widget _detailRow(String label, dynamic value) {
    String safeValue = (value == null || value.toString().isEmpty || value.toString() == 'null') ? "-" : value.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Sanket: Handle multi-line overflow
        children: [
          Text(
            label,
            style: Styles.regular_gull_grey_12.copyWith(fontSize: 14),
          ),
          const SizedBox(width: 8), // Gap
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
