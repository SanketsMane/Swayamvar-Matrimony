import 'dart:io';

import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/components/container_with_icon.dart';
import 'package:active_matrimonial_flutter_app/components/custom_popup.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/shared_pref.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/explore/explore_middleware.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/components/my_images.dart';

class HomeWithoutLogin extends StatefulWidget {
  const HomeWithoutLogin({super.key});

  @override
  State<HomeWithoutLogin> createState() => _HomeWithoutLoginState();
}

class _HomeWithoutLoginState extends State<HomeWithoutLogin> {
  final PageController controller = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  int current_page = 0;

  void goNextPage() {
    if (current_page <
        (store.state.exploreState!.premiumMemberList!.length - 1)) {
      controller.animateToPage(
        current_page + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void goPrevPage() {
    if (current_page > 0) {
      controller.animateToPage(
        current_page - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) => [store.dispatch(fetchPremiumMembersAction())],
      builder:
          (_, state) => WillPopScope(
            onWillPop: () async {
              final shouldPop =
                  (await OneContext().showDialog<bool>(
                    builder:
                        (BuildContext context) =>
                            exit_dialog(context, screenSize),
                  )) ??
                  false;
              return shouldPop;
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: buildAppBar(context, screenSize) as PreferredSizeWidget?,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                    vertical: screenSize.height * 0.01,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.01),
                      Expanded(
                        child:
                            state.exploreState!.isFetchingPremiumMembers!
                                ? CommonWidget.circularIndicator
                                : state
                                    .exploreState!
                                    .premiumMemberList!
                                    .isNotEmpty
                                ? PageView.builder(
                                  controller: controller,
                                  itemCount:
                                      state
                                          .exploreState!
                                          .premiumMemberList!
                                          .length,
                                  itemBuilder: (listViewContext, index) {
                                    var members =
                                        state.exploreState!.premiumMemberList!;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.width * 0.01,
                                      ),
                                      child: Stack(
                                        children: [
                                          image_container(members, index),
                                          transparent_black_shade_over(),
                                          user_info_box_with(
                                            context,
                                            members,
                                            index,
                                            state,
                                            screenSize,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  onPageChanged: (index) {
                                    setState(() => current_page = index);
                                    SharedPref().showDialog = false;
                                  },
                                )
                                : CommonWidget.noData,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget user_info_box_with(
    BuildContext context,
    var members,
    int index,
    AppState state,
    Size screenSize,
  ) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            name_icon_row(members, index, screenSize),
            SizedBox(height: screenSize.height * 0.005),
            member_id_row(context, members, index, screenSize),
            SizedBox(height: screenSize.height * 0.005),
            btn_and_age_country_row(members, index, context, screenSize),
            SizedBox(height: screenSize.height * 0.02),
            buildPageNavigatorWithSubscribeLoveFollow(
              context,
              members[index],
              state,
              screenSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget exit_dialog(BuildContext context, Size screenSize) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.exit,
        style: Styles.bold_arsenic_14.copyWith(
          fontSize: screenSize.width * 0.04,
        ),
      ),
      content: Text("Are you sure you want to exit?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'No',
            style: Styles.regular_arsenic_14.copyWith(
              fontSize: screenSize.width * 0.035,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (kIsWeb) {
              Navigator.pop(context, false);
            } else {
              Platform.isAndroid ? SystemNavigator.pop() : exit(0);
            }
          },
          child: Text(
            'Yes',
            style: Styles.regular_arsenic_14.copyWith(
              fontSize: screenSize.width * 0.035,
            ),
          ),
        ),
      ],
    );
  }

  Widget btn_and_age_country_row(
    var members,
    int index,
    BuildContext context,
    Size screenSize,
  ) {
    double responsiveFontSize = screenSize.width * 0.035;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ImageIcon(
                    AssetImage('assets/icon/icon_person.png'),
                    size: responsiveFontSize,
                    color: MyTheme.white,
                  ),
                  SizedBox(width: screenSize.width * 0.015),
                  Text(
                    '${members[index].age ?? ''} yrs, ${members[index].height ?? ''} ft',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveFontSize,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.005),
              Row(
                children: [
                  ImageIcon(
                    AssetImage('assets/icon/icon_location.png'),
                    size: responsiveFontSize,
                    color: MyTheme.white,
                  ),
                  SizedBox(width: screenSize.width * 0.015),
                  Flexible(
                    child: Text(
                      members[index].country ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveFontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => CustomPopUp(context).loginDialog(context),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            side: const BorderSide(color: Colors.white),
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.04,
              vertical: screenSize.height * 0.01,
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.home_screen_full_profile,
            style: TextStyle(
              color: MyTheme.white,
              fontSize: responsiveFontSize * 0.9,
            ),
          ),
        ),
      ],
    );
  }

  Widget member_id_row(
    BuildContext context,
    var members,
    int index,
    Size screenSize,
  ) {
    return Row(
      children: [
        Text(
          "${AppLocalizations.of(context)!.common_screen_member_id} ",
          style: TextStyle(
            color: MyTheme.white,
            fontSize: screenSize.width * 0.035,
          ),
        ),
        Text(
          members[index].code ?? '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.035,
          ), // Responsive font
        ),
      ],
    );
  }

  Widget name_icon_row(var members, int index, Size screenSize) {
    return Row(
      children: [
        Flexible(
          child: Text(
            members[index].name ?? '',
            style: Styles.bold_white_16.copyWith(
              fontSize: screenSize.width * 0.05,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: screenSize.width * 0.02),
        if (members[index].membership == 2)
          ImageIcon(
            const AssetImage('assets/icon/icon_premium.png'),
            size: screenSize.width * 0.05, // Proportional size
            color: MyTheme.icon_premium_color,
          ),
      ],
    );
  }

  Widget image_container(var members, int index) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: SizedBox.expand(
          child: MyImages.normalImage(
            members[index].photo,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget transparent_black_shade_over() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.4, 1],
            colors: [Colors.transparent, Colors.black],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context, Size screenSize) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo/appbar_logo.png',
                  fit: BoxFit.contain,
                  height: screenSize.height * 0.04,
                ), // Proportional size
                SizedBox(width: screenSize.width * 0.02),
                Text(
                  AppConfig.app_name,
                  style: Styles.bold_app_accent_16.copyWith(
                    fontSize: screenSize.width * 0.045,
                  ),
                ), // Responsive font
              ],
            ),
            Row(
              children: [
                CommonWidget.social_button(
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: "icon_bell.png",
                  onpressed: () => CustomPopUp(context).loginDialog(context),
                ),
                SizedBox(width: screenSize.width * 0.02),
                CommonWidget.social_button(
                  gradient: Styles.buildLinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: "icon_search.png",
                  onpressed: () => CustomPopUp(context).loginDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPageNavigatorWithSubscribeLoveFollow(
    BuildContext context,
    dynamic user,
    AppState state,
    Size screenSize,
  ) {
    // Proportional button sizes
    double mainButtonSize = screenSize.width * 0.12;
    double navButtonSize = screenSize.width * 0.11;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ContainerWithIcon(
          onpressed: goPrevPage,
          icon: 'icon_left.png',
          width: navButtonSize,
          height: navButtonSize,
          radius: navButtonSize / 2,
          opacity: 0.1,
          color: Colors.white,
        ),
        Row(
          children: [
            _buildActionButton(context, 'icon_ignore.png', mainButtonSize),
            SizedBox(width: screenSize.width * 0.04),
            _buildActionButton(context, 'icon_love.png', mainButtonSize),
            SizedBox(width: screenSize.width * 0.04),
            _buildActionButton(context, 'icon_subscribe.png', mainButtonSize),
          ],
        ),
        ContainerWithIcon(
          onpressed: goNextPage,
          icon: 'icon_right.png',
          width: navButtonSize,
          height: navButtonSize,
          radius: navButtonSize / 2,
          opacity: 0.1,
          color: Colors.white,
        ),
      ],
    );
  }

  // Helper widget to avoid repetition for action buttons
  Widget _buildActionButton(BuildContext context, String icon, double size) {
    return ContainerWithIcon(
      onpressed: () => CustomPopUp(context).loginDialog(context),
      icon: icon,
      width: size,
      height: size,
      radius: size / 2,
      gradient: Styles.buildLinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
