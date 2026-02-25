// Sanket: Public Profile screen — premium 2026 layout
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/components/my_images.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/member_info/member_info.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/ignore/add_ignore_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/interest/express_interest_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/shortlist/add_shortlist_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/public_profile_middleware.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

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
    if (!store.state.userVerifyState!.isApprove!) {
      OneContext().pop();
      store.dispatch(ShowMessageAction(msg: "Please verify your account", color: MyTheme.failure));
    } else {
      store.dispatch(Reset.publicProfile);
      store.dispatch(publicProfileMiddleware(userId: widget.userId));
      store.dispatch(Reset.memberInfo);
      store.dispatch(memberInfoMiddleware(userId: widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        if (state.publicProfileState!.isFetching! || state.memberInfoState!.isFetching!) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: MyTheme.primary)));
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
                          _buildBasicInfoCard(profile),
                          const SizedBox(height: 16),
                          
                          // 3. About Section
                          _buildAboutSection(profile),
                          const SizedBox(height: 16),
                          
                          // 4. Personal Details
                          _buildPersonalDetails(profile),
                          const SizedBox(height: 16),
                          
                          // 5. Professional Details
                          _buildProfessionalDetails(profile),
                          const SizedBox(height: 16),
                          
                          // 6. Family Details
                          _buildFamilyDetails(profile),
                          const SizedBox(height: 16),
                          
                          // 7. Gallery Section
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
            _navItem(Icons.explore_outlined, "Discover", false),
            _navItem(Icons.favorite_border, "Matches", false),
            _navItem(Icons.chat_bubble_outline, "Inbox", false),
            _navItem(Icons.person_outline, "Profile", false),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? MyTheme.primary : MyTheme.text_secondary, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? MyTheme.primary : MyTheme.text_secondary, fontSize: 10)),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, AppState state, String compatibility) {
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
          child: _circleActionBtn(Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
        ),
        
        // Shortlist (Heart) icon top-right
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 16,
          child: _circleActionBtn(
            state.memberInfoState!.memberInfo!.shortlistStatus == 1 
                ? Icons.favorite_rounded 
                : Icons.favorite_border_rounded,
            () => store.dispatch(addShortlistMiddleware(userId: widget.userId)),
            iconColor: state.memberInfoState!.memberInfo!.shortlistStatus == 1 ? MyTheme.primary : MyTheme.text_primary,
          ),
        ),
        
        // Verified Badge overlay
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
                Text("Verified", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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
                "${basic?.firsName ?? ''} | ${state.publicProfileState!.basic?.age ?? ''}",
                style: Styles.bold_white_14.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "Thane, Maharashtra", // Mock location for design
                    style: Styles.regular_white_12.copyWith(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: MyTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  compatibility,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleActionBtn(IconData icon, VoidCallback onTap, {Color? iconColor}) {
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

  Widget _buildBasicInfoCard(dynamic profile) {
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Basic Information"),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3.5,
            children: [
              _infoTile("Religion", profile.spiritual?.religionId ?? "Brahmin"),
              _infoTile("Height", "${profile.physical?.height ?? '5.5'}'"),
              _infoTile("Marital Status", profile.basic?.maritialStatus ?? "Never Married"),
              _infoTile("Tongue", profile.basic?.mothereTongue ?? "Marathi"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(dynamic profile) {
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("About"),
          const SizedBox(height: 12),
          Text(
            profile.introduction?.introduction ?? "I am looking for a life partner who values family and tradition. I enjoy travel and exploring new cultures.",
            style: Styles.regular_gull_grey_12.copyWith(fontSize: 14, height: 1.5, color: MyTheme.text_primary),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetails(dynamic profile) {
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Personal Details"),
          const SizedBox(height: 8),
          _detailRow("Age", "${profile.basic?.age ?? '28'} Years"),
          _detailRow("Religion", profile.spiritual?.religionId ?? "-"),
          _detailRow("Caste", profile.spiritual?.casteId ?? "-"),
          _detailRow("Mother Tongue", profile.basic?.mothereTongue ?? "-"),
          _detailRow("Education", profile.education?.degree ?? "Bachelor of Engineering"),
          _detailRow("Location", "Thane, Maharashtra"),
        ],
      ),
    );
  }

  Widget _buildProfessionalDetails(dynamic profile) {
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Professional Details"),
          const SizedBox(height: 8),
          _detailRow("Occupation", profile.career?.designation ?? "Software Engineer"),
          _detailRow("Company", profile.career?.company ?? "TCS"),
          _detailRow("Income", profile.career?.income ?? "8-10 LPA"),
          _detailRow("Work Location", "Pune / Remote"),
        ],
      ),
    );
  }

  Widget _buildFamilyDetails(dynamic profile) {
    return _profileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Family Details"),
          const SizedBox(height: 8),
          _detailRow("Father Occupation", profile.family?.father ?? "Retired Government Service"),
          _detailRow("Mother Occupation", profile.family?.mother ?? "Homemaker"),
          _detailRow("Siblings", profile.family?.sibling ?? "1 Brother"),
          _detailRow("Family Type", "Nuclear / Middle Class"),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context, AppState state) {
    final images = state.publicProfileState?.photogallery ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Gallery"),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length > 0 ? images.length : 3,
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
                  child: images.length > index 
                      ? MyImages.normalImage(images[index].image)
                      : Container(color: MyTheme.border, child: const Icon(Icons.image, color: MyTheme.text_secondary)),
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
            _actionPill(Icons.close_rounded, "Pass", Colors.grey[400]!, () {}),
            _actionPill(Icons.star_border_rounded, "Shortlist", Colors.orangeAccent, () {
              store.dispatch(addShortlistMiddleware(userId: widget.userId));
            }),
            _actionPill(Icons.favorite_rounded, "Interest", MyTheme.primary, () {
               store.dispatch(expressInterestMiddleware(userId: widget.userId));
            }, isPrimary: true),
            _actionPill(Icons.chat_bubble_outline_rounded, "Chat", Colors.blueAccent, () {
               OneContext().push(MaterialPageRoute(builder: (context) => Chat(
                 userId: widget.userId,
                 name: state.publicProfileState!.basic?.firsName,
                 picture: state.publicProfileState!.basic?.photo,
               )));
            }),
          ],
        ),
      ),
    );
  }

  Widget _actionPill(IconData icon, String label, Color color, VoidCallback onTap, {bool isPrimary = false}) {
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
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
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
      style: Styles.bold_arsenic_16.copyWith(fontSize: 17, color: MyTheme.text_primary),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Styles.regular_gull_grey_12.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: Styles.bold_arsenic_12.copyWith(fontSize: 14)),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Styles.regular_gull_grey_12.copyWith(fontSize: 14)),
          Text(value, style: Styles.bold_arsenic_12.copyWith(fontSize: 14, color: MyTheme.text_primary)),
        ],
      ),
    );
  }
}

