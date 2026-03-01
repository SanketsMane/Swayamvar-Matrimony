import 'dart:async';

import 'package:active_matrimonial_flutter_app/app_config.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/add_on/addon_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/app_info/app_info_middleware.dart';
import 'package:active_matrimonial_flutter_app/redux/libs/feature/feature_check_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:info_getter/info_getter.dart';
import 'package:active_matrimonial_flutter_app/config/app_router.dart';
import 'package:active_matrimonial_flutter_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/shared_pref.dart';

late SharedPreferences prefs;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _appVersion = 'Loading version...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Initialize core services
    await SharedPref().init();
    await AuthService().init();

    // 2. Fetch app version (Keep existing logic)
    _fetchAppVersion();

    // 3. Dispatch redux actions (Keep existing logic if needed for background data)
    store.dispatch(featureCheckMiddleware());
    store.dispatch(appInfoMiddleware());
    store.dispatch(addonCheckMiddleware());

    // 4. Smart Routing Decision
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Artificial delay for splash branding (max 2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isLoggedIn = AuthService().isLoggedIn;
    final isOnboardingCompleted = SharedPref().isView;

    if (isLoggedIn) {
      // User is logged in -> Go to Dashboard
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    } else {
      if (isOnboardingCompleted) {
        // User has seen onboarding -> Go to Login
        Navigator.pushReplacementNamed(context, AppRouter.login);
      } else {
        // First time user -> Go to Onboarding
        Navigator.pushReplacementNamed(context, AppRouter.onboarding);
      }
    }
  }

  Future<void> _fetchAppVersion() async {
    String? version;
    if (kIsWeb) {
      version = '1.0.0';
    } else {
      version = await InfoGetter.getAppVersion();
    }

    if (mounted) {
      setState(() {
        _appVersion = version ?? 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder:
          (_, state) => Scaffold(
            body: Stack(
              children: [
                // 1. Full Screen Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/splash_bg.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                // 2. Dark Overlay for Text Readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Central Content (Logo & Text)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Automated Animation for Logo (Scale + Fade)
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/logo/app_logo.png',
                          height: 250,
                          width: 250,
                        ),
                      ),

                      // Logo Only
                    ],
                  ),
                ),

                // 4. Footer info
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'v $_appVersion',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        AppConfig.copyright_text,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
