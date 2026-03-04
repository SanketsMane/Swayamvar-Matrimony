import 'package:active_matrimonial_flutter_app/helpers/connectivity_helper.dart';
import 'package:active_matrimonial_flutter_app/helpers/get_context.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/common/common_states_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/drop_down/profile_dropdown_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/account/account.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/phone_login.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_list.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/explore/explore.dart';
import 'package:active_matrimonial_flutter_app/screens/home_pages/home/home.dart';
import 'package:flutter/material.dart';

import '../helpers/push_notification_service.dart';
import '../helpers/push_notification_service.dart';
import '../redux/store.dart';
import '../widgets/custom_bottom_navbar.dart';

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
        body: Stack(
          children: [
            // Main Content with bottom padding to avoid overlap
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: _buildBody(),
            ),

            // Floating Custom Navbar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: onTapped,
              ),
            ),
          ],
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
      return Home();
    } else if (_currentIndex == 1) {
      return Explore();
    } else if (_currentIndex == 2) {
      return ChatList(backButtonAppearance: false);
    } else if (_currentIndex == 3) {
      return const Account();
    }
    return const SizedBox.shrink();
  }
}
