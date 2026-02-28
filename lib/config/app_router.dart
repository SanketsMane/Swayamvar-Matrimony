import 'package:active_matrimonial_flutter_app/screens/app_navigation.dart';
import 'package:active_matrimonial_flutter_app/screens/auth/signin/phone_login.dart';
import 'package:active_matrimonial_flutter_app/screens/startup_pages/landing_page/landing_page.dart';
import 'package:active_matrimonial_flutter_app/screens/startup_pages/on_boarding_pages.dart';
import 'package:active_matrimonial_flutter_app/screens/startup_pages/splash_screen.dart';
import 'package:active_matrimonial_flutter_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingPages());

      case landing:
        return MaterialPageRoute(builder: (_) => const LandingPage());

      case login:
        return MaterialPageRoute(builder: (_) => const PhoneLogin());

      case dashboard:
        // Protected Route Guard
        if (!AuthService().isLoggedIn) {
          return MaterialPageRoute(builder: (_) => const PhoneLogin());
        }
        return MaterialPageRoute(builder: (_) => const AppNavigation());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }

  // Navigation Helpers
  static void pushReplace(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  static void push(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  static void pushRemoveUntil(BuildContext context, String routeName) {
    Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}
