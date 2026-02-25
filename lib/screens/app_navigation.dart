
import 'dart:ui';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/connectivity_helper.dart';
import 'package:active_matrimonial_flutter_app/helpers/get_context.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/common/common_states_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/profile_dropdown_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/account/account.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/signin.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_list.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/explore/explore.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/home/home.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/home_without_login.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import '../helpers/push_notification_service.dart';
import '../helpers/shared_pref.dart';
import '../main.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemHelper.context = context;
    _initializeApp();
    Future.delayed(const Duration(milliseconds: 1), () async {
      await PushNotificationService().initNotifications();
    });
  }

  void _initializeApp() {
    ConnectivityHelper().abortIfNotConnected(context, _onConnectivityChange);
    final profileDropdownData =
        store.state.manageProfileCombineState?.profiledropdownResponseData;
    if (profileDropdownData?.result != true) {
      store.dispatch(profiledropdownMiddleware());
    }

    if (store.state.commonState?.countries?.isEmpty ?? true) {
      store.dispatch(commonStateCountryMiddleware());
    }
  }

  void _onConnectivityChange(value) {
    ConnectivityHelper().abortIfNotConnected(context, _onConnectivityChange);
  }

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: Container(
          height: 64,
          decoration: BoxDecoration(
            color: MyTheme.white,
            border: Border(
              top: BorderSide(color: MyTheme.border, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: MyTheme.primary,
            unselectedItemColor: MyTheme.text_secondary,
            selectedLabelStyle: Styles.caption.copyWith(color: MyTheme.primary, fontSize: 10),
            unselectedLabelStyle: Styles.caption.copyWith(fontSize: 10),
            onTap: onTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 0 ? Icons.explore : Icons.explore_outlined),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 1 ? Icons.favorite : Icons.favorite_border),
                label: 'Matches',
              ),
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 2 ? Icons.chat_bubble : Icons.chat_bubble_outline),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 3 ? Icons.person : Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _handleWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
    return true;
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return SharedPref().isLoggedIn ? Home() : const HomeWithoutLogin();
    } else if (_currentIndex == 1) {
      return Explore();
    } else if (_currentIndex == 2) {
      return SharedPref().isLoggedIn
          ? ChatList(backButtonAppearance: false)
          : Login();
    } else if (_currentIndex == 3) {
      return SharedPref().isLoggedIn ? const Account() : Login();
    }
    return const SizedBox.shrink();
  }
}
